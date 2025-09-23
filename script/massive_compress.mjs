import { promises as fs } from 'fs';
import path from 'path';
import { PNG } from 'pngjs';

/**
 * Massive Graphics Compression System
 *
 * This system converts 256x128 PNG images into highly compressed command-based data
 * suitable for real-time decompression on NES hardware. The compression works by:
 *
 * 1. TILE-BASED PROCESSING: Images are divided into 16x16 pixel tiles, allowing for
 *    efficient palette management (max 3 colors + transparency per tile, max 4 palettes total)
 *
 * 2. COMMAND-BASED ENCODING: Instead of storing raw pixel data, we encode drawing
 *    operations as variable-bit-width commands that can represent common patterns efficiently:
 *    - Single pixels (for unique/scattered pixels)
 *    - Repeated pixels (for runs of identical pixels)
 *    - Multiple pixels (for small groups of non-repeating pixels)
 *
 * 3. STRUCTURED DATA FORMAT: The output format places fixed-size data first, then
 *    variable-size data last to enable easy parsing:
 *    [Header] [Palette Assignments] [Palette Data] [Variable-Length Command Stream]
 *
 * 4. HEADER-DRIVEN COMMANDS: Command definitions are stored in the header, allowing
 *    the system to be extended with new command types without changing the decoder
 *
 * The system achieves compression ratios of 10-12:1 on typical sprite data while
 * maintaining pixel-perfect lossless reconstruction.
 */
class MassiveCompressor {
    constructor() {
        // Storage for processed images and animation sequences
        this.images = new Map();
        this.animations = new Map();

        // NES hardware color palette for accurate color matching
        this.nesPalette = this.buildNESPalette();

        // Command type definitions - these are the values stored in the header
        // to identify what each command does. The actual command indices used
        // in the bit stream are determined by the order these appear in the header.
        this.COMMAND_REPEAT_BITS = 0x00;     // Repeat a single bit 2-9 times (1 bit value + 3 bit count)
        this.COMMAND_PLOT_BITS = 0x01;       // Plot a 4-bit pattern (4 bit pattern)
        this.COMMAND_REPEAT_COMMAND = 0x02;  // Repeat the following command 2-9 times (3 bit count)

        // Compression profiles - each profile defines a specific strategy optimized for different image types
        this.COMPRESSION_PROFILES = this.defineCompressionProfiles();
    }

    /**
     * Define compression profiles for different types of image data
     * Each profile specifies a command bit width and the commands to use
     */
    defineCompressionProfiles() {
        return [
            {
                name: "FUNDAMENTAL_BITS",
                description: "Two fundamental bit-based commands with perfect symmetry",
                commandBitWidth: 1,
                commands: [
                    this.COMMAND_REPEAT_BITS,   // Index 0: Repeat bits (5 bits total: 1 cmd + 1 value + 3 count)
                    this.COMMAND_PLOT_BITS      // Index 1: Plot bits (5 bits total: 1 cmd + 4 pattern)
                ]
            },
            {
                name: "ENHANCED_REPEAT",
                description: "Three commands including REPEAT_COMMAND for multiplicative efficiency",
                commandBitWidth: 2,
                commands: [
                    this.COMMAND_REPEAT_BITS,   // Index 0: Repeat bits (6 bits total: 2 cmd + 1 value + 3 count)
                    this.COMMAND_PLOT_BITS,     // Index 1: Plot bits (6 bits total: 2 cmd + 4 pattern)
                    this.COMMAND_REPEAT_COMMAND // Index 2: Repeat command (5 bits total: 2 cmd + 3 count)
                ]
            }
        ];
    }

    /**
     * Try all compression profiles and return the one with the best compression ratio
     * @param {Array} chrTileData - Array of CHR tiles to compress
     * @param {Object} clipInfo - Clipping information for header
     * @returns {Object} - Best compression result with profileName, header, pixelData
     */
    findBestCompressionProfile(chrTileData, clipInfo) {
        console.log(`   🏁 Testing ${this.COMPRESSION_PROFILES.length} compression profiles...`);

        const results = [];

        for (const profile of this.COMPRESSION_PROFILES) {
            try {
                // Generate command header for this profile
                const commandHeader = this.generateCommandHeaderForProfile(profile, clipInfo);

                // Create command-to-index mapping for this profile
                const commandToIndex = new Map();
                for (let i = 0; i < profile.commands.length; i++) {
                    commandToIndex.set(profile.commands[i], i);
                }

                // Compress using this profile
                const pixelData = this.compressCHRData(chrTileData, profile.commandBitWidth, commandToIndex);

                // Calculate total size (header + pixel data)
                const totalSize = commandHeader.length + pixelData.length;

                results.push({
                    profileName: profile.name,
                    description: profile.description,
                    header: commandHeader,
                    pixelData: pixelData,
                    totalSize: totalSize
                });

                console.log(`   📊 ${profile.name}: ${totalSize} bytes (${commandHeader.length} header + ${pixelData.length} pixel)`);

            } catch (error) {
                console.warn(`   ⚠️  Profile ${profile.name} failed: ${error.message}`);
            }
        }

        if (results.length === 0) {
            throw new Error("All compression profiles failed");
        }

        // Find the profile with the smallest total size
        results.sort((a, b) => a.totalSize - b.totalSize);
        return results[0];
    }

    /**
     * Generate command header for a specific profile
     * @param {Object} profile - Compression profile
     * @param {Object} clipInfo - Clipping information
     * @returns {number[]} - Command header bytes
     */
    generateCommandHeaderForProfile(profile, clipInfo) {
        const header = [];

        // First byte: 00xxyyyy format
        // xx = command bit width (0-3 representing 1-4 bits)
        // yyyy = number of commands in header (0-15)
        const bitWidthEncoded = profile.commandBitWidth - 1; // 1→0, 2→1, 3→2, 4→3
        const numCommands = profile.commands.length;
        const firstByte = (bitWidthEncoded << 4) | numCommands; // 00xxyyyy
        header.push(firstByte);

        // Second byte: [leftClip][rightClip] (4 bits each)
        const clipByte1 = (clipInfo.leftClip << 4) | clipInfo.rightClip;
        header.push(clipByte1);

        // Third byte: [topClip][bottomClip] (4 bits each)
        const clipByte2 = (clipInfo.topClip << 4) | clipInfo.bottomClip;
        header.push(clipByte2);

        // Add each command from the profile in reverse order
        // (ASM reads commands backwards and stores them in forward slots)
        for (let i = profile.commands.length - 1; i >= 0; i--) {
            header.push(profile.commands[i]);
        }

        return header;
    }

    /**
     * Build the NES color palette from specs
     */
    buildNESPalette() {
        const palette = [
            { id: 0x00, r: 0x62, g: 0x62, b: 0x62 },
            { id: 0x01, r: 0x00, g: 0x1C, b: 0x95 },
            { id: 0x02, r: 0x19, g: 0x04, b: 0xAC },
            { id: 0x03, r: 0x42, g: 0x00, b: 0x9D },
            { id: 0x04, r: 0x61, g: 0x00, b: 0x6B },
            { id: 0x05, r: 0x6E, g: 0x00, b: 0x25 },
            { id: 0x06, r: 0x65, g: 0x05, b: 0x00 },
            { id: 0x07, r: 0x49, g: 0x1E, b: 0x00 },
            { id: 0x08, r: 0x22, g: 0x37, b: 0x00 },
            { id: 0x09, r: 0x00, g: 0x49, b: 0x00 },
            { id: 0x0A, r: 0x00, g: 0x4F, b: 0x00 },
            { id: 0x0B, r: 0x00, g: 0x48, b: 0x16 },
            { id: 0x0C, r: 0x00, g: 0x35, b: 0x5E },
            { id: 0x0F, r: 0x00, g: 0x00, b: 0x00 },
            { id: 0x10, r: 0xAB, g: 0xAB, b: 0xAB },
            { id: 0x11, r: 0x0C, g: 0x4E, b: 0xDB },
            { id: 0x12, r: 0x3D, g: 0x2E, b: 0xFF },
            { id: 0x13, r: 0x71, g: 0x15, b: 0xF3 },
            { id: 0x14, r: 0x9B, g: 0x0B, b: 0xB9 },
            { id: 0x15, r: 0xB0, g: 0x12, b: 0x62 },
            { id: 0x16, r: 0xA9, g: 0x27, b: 0x04 },
            { id: 0x17, r: 0x89, g: 0x46, b: 0x00 },
            { id: 0x18, r: 0x57, g: 0x66, b: 0x00 },
            { id: 0x19, r: 0x23, g: 0x7F, b: 0x00 },
            { id: 0x1A, r: 0x00, g: 0x89, b: 0x00 },
            { id: 0x1B, r: 0x00, g: 0x83, b: 0x32 },
            { id: 0x1C, r: 0x00, g: 0x6D, b: 0x90 },
            { id: 0x20, r: 0xFF, g: 0xFF, b: 0xFF },
            { id: 0x21, r: 0x57, g: 0xA5, b: 0xFF },
            { id: 0x22, r: 0x82, g: 0x87, b: 0xFF },
            { id: 0x23, r: 0xB4, g: 0x6D, b: 0xFF },
            { id: 0x24, r: 0xDF, g: 0x60, b: 0xFF },
            { id: 0x25, r: 0xF8, g: 0x63, b: 0xC6 },
            { id: 0x26, r: 0xF8, g: 0x74, b: 0x6D },
            { id: 0x27, r: 0xDE, g: 0x90, b: 0x20 },
            { id: 0x28, r: 0xB3, g: 0xAE, b: 0x00 },
            { id: 0x29, r: 0x81, g: 0xC8, b: 0x00 },
            { id: 0x2A, r: 0x56, g: 0xD5, b: 0x22 },
            { id: 0x2B, r: 0x3D, g: 0xD3, b: 0x6F },
            { id: 0x2C, r: 0x3E, g: 0xC1, b: 0xC8 },
            { id: 0x2D, r: 0x4E, g: 0x4E, b: 0x4E },
            { id: 0x30, r: 0xFF, g: 0xFF, b: 0xFF },
            { id: 0x31, r: 0xBE, g: 0xE0, b: 0xFF },
            { id: 0x32, r: 0xCD, g: 0xD4, b: 0xFF },
            { id: 0x33, r: 0xE0, g: 0xCA, b: 0xFF },
            { id: 0x34, r: 0xF1, g: 0xC4, b: 0xFF },
            { id: 0x35, r: 0xFC, g: 0xC4, b: 0xEF },
            { id: 0x36, r: 0xFD, g: 0xCA, b: 0xCE },
            { id: 0x37, r: 0xF5, g: 0xD4, b: 0xAF },
            { id: 0x38, r: 0xE6, g: 0xDF, b: 0x9C },
            { id: 0x39, r: 0xD3, g: 0xE9, b: 0x9A },
            { id: 0x3A, r: 0xC2, g: 0xEF, b: 0xA8 },
            { id: 0x3B, r: 0xB7, g: 0xEF, b: 0xC4 },
            { id: 0x3C, r: 0xB6, g: 0xEA, b: 0xE5 },
            { id: 0x3D, r: 0xB8, g: 0xB8, b: 0xB8 }
        ];
        return palette;
    }

    /**
     * Find closest NES color for given RGB values
     * @param {number} r - Red component (0-255)
     * @param {number} g - Green component (0-255)
     * @param {number} b - Blue component (0-255)
     * @returns {Object} - Closest NES color with id and RGB values
     */
    findClosestNESColor(r, g, b) {
        let closestColor = this.nesPalette[0];
        let minDistance = Infinity;

        for (const nesColor of this.nesPalette) {
            // Calculate Euclidean distance in RGB space
            const deltaR = r - nesColor.r;
            const deltaG = g - nesColor.g;
            const deltaB = b - nesColor.b;
            const distance = Math.sqrt(deltaR * deltaR + deltaG * deltaG + deltaB * deltaB);

            if (distance < minDistance) {
                minDistance = distance;
                closestColor = nesColor;
            }
        }

        return closestColor;
    }

    /**
     * Process a massive PNG image and compress it to command format
     *
     * This is the main entry point for the compression system. It orchestrates the entire
     * compression pipeline from raw PNG input to compressed command-based output.
     *
     * The compression process follows these critical steps:
     *
     * 1. IMAGE PREPARATION: Load, validate, and prepare the image for processing
     * 2. TILE EXTRACTION: Break the image into 16x16 tiles for efficient palette management
     * 3. PALETTE ANALYSIS: Determine optimal color palettes for each tile (max 3 colors + transparency)
     * 4. COMMAND GENERATION: Create a flexible command header that defines available operations
     * 5. PIXEL ENCODING: Convert pixel data to variable-length command sequences
     * 6. DATA ASSEMBLY: Combine all components into the final compressed format
     *
     * @param {string} filePath - Path to the .massive.png file to compress
     * @returns {Promise<number[]>} - Compressed data as byte array ready for NES consumption
     */
    async processImage(filePath) {
        console.log(`Processing massive image: ${filePath}`);

        // STEP 1: IMAGE PREPARATION
        // =========================
        // Load the PNG file and parse its pixel data. We need to examine the original
        // image properties before any modifications to make informed decisions about
        // transparency handling and color processing.
        const pngData = await this.loadPNG(filePath);

        // Check for transparency in the ORIGINAL image before any padding or processing.
        // This is crucial because we need to know if transparency was intentionally used
        // by the artist, or if we should convert pure black pixels to transparency.
        // This affects our transparency conversion strategy later in the pipeline.
        const originalHasTransparency = this.hasTransparency(pngData);

        // Validate image dimensions and pad to the required 256x128 size if needed.
        // NES hardware and our tile system expect this exact size. Padding is added
        // symmetrically to center the original image within the target dimensions.
        // This ensures sprites appear centered when displayed.
        const paddingInfo = this.validateAndPadImage(pngData);

        // Apply transparency processing rules based on the original image characteristics.
        // If the original had no transparency channel, we convert pure black (0,0,0) pixels
        // to transparent, which is a common optimization for sprite graphics where black
        // backgrounds should be transparent.
        const processedImageData = this.processTransparency(paddingInfo.imageData, originalHasTransparency);

        // STEP 1.5: SPRITE BOUNDS DETECTION
        // =================================
        // Auto-detect the actual sprite content area to minimize compression of empty space.
        // This calculates clipping values that eliminate transparent padding around the sprite.
        const clipInfo = this.detectSpriteBounds(processedImageData);

        // STEP 2: TILE EXTRACTION (16x16 for palette analysis)
        // ====================================================
        // First extract 16x16 tiles for palette analysis. This gives us 16×8 = 128 tiles.
        // Tile-based processing allows us to optimize color palettes locally and manage
        // the NES hardware constraint of max 3 colors + transparency per tile.
        // Each tile can use a different palette, enabling complex multi-colored sprites.
        const megaTileData = this.extractTiles(processedImageData, paddingInfo.padOffsets);

        // STEP 3: PALETTE ANALYSIS
        // ========================
        // Analyze each 16x16 mega-tile to determine optimal color groupings. The NES can support
        // up to 4 different palettes total, with each mega-tile using one of those palettes.
        // Each palette can contain up to 3 colors + transparency. This analysis finds
        // the best way to group similar tiles to minimize palette usage while respecting
        // the hardware constraints.
        const paletteSystem = this.analyzeTilePalettes(megaTileData);

        // STEP 4: CHR TILE EXTRACTION (8x8 for pattern table)
        // ===================================================
        // Extract 8x8 CHR tiles in reading order and convert to planar format.
        // Only process the clipped region to eliminate transparent padding areas.
        // Each CHR tile is converted to proper NES planar format with interleaved bit planes.
        const chrTileData = this.extract8x8Tiles(processedImageData, paletteSystem, clipInfo);

        // STEP 5: PROFILE-BASED COMPRESSION
        // ==================================
        // Try multiple compression profiles and choose the one that produces the smallest output.
        // Each profile defines a specific command set and bit width optimized for different
        // types of image data (detailed art, solid backgrounds, etc.).
        const bestCompressionResult = this.findBestCompressionProfile(chrTileData, clipInfo);

        const commandHeader = bestCompressionResult.header;
        const pixelData = bestCompressionResult.pixelData;

        console.log(`   🏆 Selected profile: ${bestCompressionResult.profileName} (${bestCompressionResult.pixelData.length} bytes)`);

        // STEP 6: DATA ASSEMBLY PREPARATION
        // =================================
        // The compression system has selected the optimal command set for this image.

        // Pack the palette assignments into a compact format. Each 16x16 mega-tile gets assigned
        // to one of the 4 available palettes, encoded as 2-bit values (4 assignments per byte).
        // This creates a 32-byte lookup table that maps each of the 128 mega-tiles to its palette.
        const paletteAssignments = this.packPaletteAssignments(paletteSystem.assignments);

        // STEP 7: DATA ASSEMBLY
        // =====================
        // Serialize the color palettes to bytes. We always output exactly 4 palettes
        // (padding with null palettes if needed) to maintain a fixed-size format
        // that's easy for the NES to parse without dynamic memory allocation.
        const paletteData = this.serializePalettes(paletteSystem.palettes);

        // Combine all data: header + palette assignments + palette data + compressed pixel data
        const compressedData = [...commandHeader, ...paletteAssignments, ...paletteData, ...pixelData];

        console.log(`Compressed ${filePath} to ${compressedData.length} bytes (${commandHeader.length} header + ${paletteAssignments.length} assignment + ${paletteData.length} palette + ${pixelData.length} pixel bytes)`);
        console.log(`Used ${paletteSystem.palettes.length} palettes for ${megaTileData.length} mega-tiles, generated ${chrTileData.length} CHR tiles`);

        // Write human-readable debug output
        await this.writeDebugOutput(filePath, bestCompressionResult);

        return compressedData;
    }

    /**
     * Write human-readable debug output showing the compression commands
     * @param {string} originalFilePath - Path to original .massive.png file
     * @param {Object} compressionResult - Result from findBestCompressionProfile
     */
    async writeDebugOutput(originalFilePath, compressionResult) {
        try {
            // Generate output file path
            const debugPath = originalFilePath.replace('.massive.png', '.massive.txt');

            // Build debug content
            const lines = [];
            lines.push(`// Massive Compression Debug Output`);
            lines.push(`// Original: ${originalFilePath}`);
            lines.push(`// Profile: ${compressionResult.profileName}`);
            lines.push(`// Total size: ${compressionResult.totalSize} bytes`);
            lines.push(`// Commands: ${this.lastDebugCommands ? this.lastDebugCommands.length : 0}`);
            lines.push('');

            if (this.lastDebugCommands) {
                this.lastDebugCommands.forEach((command) => {
                    lines.push(command);
                });
            } else {
                lines.push('// No debug commands available');
            }

            // Write to file
            const { promises: fs } = await import('fs');
            await fs.writeFile(debugPath, lines.join('\n'), 'utf8');

            console.log(`   📄 Debug output written to: ${debugPath}`);
        } catch (error) {
            console.warn(`   ⚠️  Failed to write debug output: ${error.message}`);
        }
    }

    /**
     * Load PNG file and return parsed data
     * @param {string} filePath - Path to PNG file
     * @returns {Promise<PNG>} - Parsed PNG data
     */
    async loadPNG(filePath) {
        const buffer = await fs.readFile(filePath);
        return new Promise((resolve, reject) => {
            const png = new PNG();
            png.parse(buffer, (error, data) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(data);
                }
            });
        });
    }

    /**
     * Validate image dimensions and pad to 256x128 with transparent pixels
     * @param {PNG} pngData - Original PNG data
     * @returns {Object} - Padded image data and padding info
     */
    validateAndPadImage(pngData) {
        const { width, height } = pngData;

        // Validate dimensions are multiples of 16
        if (width % 16 !== 0 || height % 16 !== 0) {
            throw new Error(`Image dimensions must be multiples of 16 pixels. Got ${width}x${height}.`);
        }

        // Validate maximum dimensions
        if (width > 256 || height > 128) {
            throw new Error(`Image too large: ${width}x${height}. Maximum allowed is 256x128.`);
        }

        // Calculate padding needed
        const padWidth = (256 - width) / 2;
        const padHeight = (128 - height) / 2;

        // If already correct size, return as-is
        if (width === 256 && height === 128) {
            return {
                imageData: pngData,
                padOffsets: { left: 0, top: 0 }
            };
        }

        console.log(`Padding image from ${width}x${height} to 256x128`);
        console.log(`Padding offsets: left=${padWidth}, top=${padHeight}`);

        // Create new padded image data
        const paddedData = Buffer.alloc(256 * 128 * 4); // RGBA

        // Fill with transparent pixels (all zeros)
        paddedData.fill(0);

        // Copy original image data to center of padded image
        for (let y = 0; y < height; y++) {
            for (let x = 0; x < width; x++) {
                const srcIdx = (width * y + x) << 2;
                const dstX = x + padWidth;
                const dstY = y + padHeight;
                const dstIdx = (256 * dstY + dstX) << 2;

                // Copy RGBA values
                paddedData[dstIdx] = pngData.data[srcIdx];         // R
                paddedData[dstIdx + 1] = pngData.data[srcIdx + 1]; // G
                paddedData[dstIdx + 2] = pngData.data[srcIdx + 2]; // B
                paddedData[dstIdx + 3] = pngData.data[srcIdx + 3]; // A
            }
        }

        // Return padded data and padding info
        return {
            imageData: {
                width: 256,
                height: 128,
                data: paddedData
            },
            padOffsets: {
                left: padWidth,
                top: padHeight
            }
        };
    }

    /**
     * Check if image data has any transparent pixels
     * @param {Object} imageData - Image data to check
     * @returns {boolean} - Whether image has transparent pixels
     */
    hasTransparency(imageData) {
        for (let i = 3; i < imageData.data.length; i += 4) {
            if (imageData.data[i] === 0) {
                return true;
            }
        }
        return false;
    }

    /**
     * Process transparency - convert black to transparent if no transparency exists
     * @param {Object} imageData - Image data with width, height, data
     * @param {boolean} originalHasTransparency - Whether original image had transparency before padding
     * @returns {Object} - Processed image data
     */
    processTransparency(imageData, originalHasTransparency) {
        // If original image had transparency, treat black as regular color
        if (originalHasTransparency) {
            console.log("Original image has transparency - black pixels will be treated as regular color");
            return imageData;
        }

        // Check if image has any black pixels (0,0,0)
        let hasBlackPixels = false;
        for (let i = 0; i < imageData.data.length; i += 4) {
            const r = imageData.data[i];
            const g = imageData.data[i + 1];
            const b = imageData.data[i + 2];

            if (r === 0 && g === 0 && b === 0) {
                hasBlackPixels = true;
                break;
            }
        }

        if (!hasBlackPixels) {
            console.log("No transparency and no black pixels - image will be processed as-is");
            return imageData;
        }

        console.log("No transparency found - converting black (0,0,0) pixels to transparent");

        // Create new image data with black pixels converted to transparent
        const processedData = Buffer.from(imageData.data);
        let blackPixelsConverted = 0;

        for (let i = 0; i < processedData.length; i += 4) {
            const r = processedData[i];
            const g = processedData[i + 1];
            const b = processedData[i + 2];

            // Convert black pixels to transparent
            if (r === 0 && g === 0 && b === 0) {
                processedData[i + 3] = 0; // Set alpha to 0 (transparent)
                blackPixelsConverted++;
            }
        }

        console.log(`Converted ${blackPixelsConverted} black pixels to transparent`);

        return {
            width: imageData.width,
            height: imageData.height,
            data: processedData
        };
    }

    /**
     * Auto-detect sprite bounding box and calculate clipping values
     * @param {Object} imageData - Image data with width, height, data
     * @returns {Object} - Clip values and bounding box info
     */
    detectSpriteBounds(imageData) {
        const { width, height, data } = imageData;

        let minX = width, maxX = -1;
        let minY = height, maxY = -1;

        // Find bounding box of non-transparent pixels
        for (let y = 0; y < height; y++) {
            for (let x = 0; x < width; x++) {
                const pixelIndex = (y * width + x) * 4;
                const alpha = data[pixelIndex + 3];

                // If pixel is not transparent
                if (alpha > 0) {
                    minX = Math.min(minX, x);
                    maxX = Math.max(maxX, x);
                    minY = Math.min(minY, y);
                    maxY = Math.max(maxY, y);
                }
            }
        }

        // If no non-transparent pixels found, no clipping needed
        if (maxX === -1) {
            return {
                leftClip: 0, rightClip: 0, topClip: 0, bottomClip: 0,
                boundingBox: { x: 0, y: 0, width: width, height: height }
            };
        }

        // Calculate clipping in 8-pixel increments (tile boundaries)
        // We want to clip to the nearest 8-pixel boundary that includes all content
        const contentLeft = Math.floor(minX / 8) * 8;
        const contentRight = Math.ceil((maxX + 1) / 8) * 8;
        const contentTop = Math.floor(minY / 8) * 8;
        const contentBottom = Math.ceil((maxY + 1) / 8) * 8;

        // Calculate clip amounts (in 8-pixel units)
        const leftClip = contentLeft / 8;
        const rightClip = (width - contentRight) / 8;
        const topClip = contentTop / 8;
        const bottomClip = (height - contentBottom) / 8;

        // Ensure clip values fit in 4 bits (0-15)
        const safeLeftClip = Math.min(15, Math.max(0, leftClip));
        const safeRightClip = Math.min(15, Math.max(0, rightClip));
        const safeTopClip = Math.min(15, Math.max(0, topClip));
        const safeBottomClip = Math.min(15, Math.max(0, bottomClip));

        console.log(`   🎯 Detected sprite bounds: ${minX},${minY} to ${maxX},${maxY}`);
        console.log(`   ✂️  Clipping: L${safeLeftClip} R${safeRightClip} T${safeTopClip} B${safeBottomClip} (8px units)`);

        return {
            leftClip: safeLeftClip,
            rightClip: safeRightClip,
            topClip: safeTopClip,
            bottomClip: safeBottomClip,
            boundingBox: {
                x: safeLeftClip * 8,
                y: safeTopClip * 8,
                width: width - (safeLeftClip + safeRightClip) * 8,
                height: height - (safeTopClip + safeBottomClip) * 8
            }
        };
    }

    /**
     * Extract 16x16 tiles from the image (for palette analysis)
     * @param {PNG} pngData - Parsed PNG data
     * @param {Object} padOffsets - Padding offsets for coordinate adjustment
     * @returns {Array} - Array of tile objects with pixel data
     */
    extractTiles(pngData, padOffsets = { left: 0, top: 0 }) {
        const tiles = [];
        const tilesWide = 16; // 256 / 16
        const tilesHigh = 8;  // 128 / 16

        for (let tileY = 0; tileY < tilesHigh; tileY++) {
            for (let tileX = 0; tileX < tilesWide; tileX++) {
                const tilePixels = [];

                // Extract 16x16 pixels for this tile
                for (let y = 0; y < 16; y++) {
                    for (let x = 0; x < 16; x++) {
                        const globalX = tileX * 16 + x;
                        const globalY = tileY * 16 + y;
                        const idx = (pngData.width * globalY + globalX) << 2;

                        const r = pngData.data[idx];
                        const g = pngData.data[idx + 1];
                        const b = pngData.data[idx + 2];
                        const a = pngData.data[idx + 3];

                        tilePixels.push({ r, g, b, a });
                    }
                }

                // Calculate original image coordinates (subtract padding)
                const originalTileX = tileX - Math.floor(padOffsets.left / 16);
                const originalTileY = tileY - Math.floor(padOffsets.top / 16);

                tiles.push({
                    x: tileX,           // Padded coordinates (for pixel processing)
                    y: tileY,
                    originalX: originalTileX,  // Original coordinates (for error reporting)
                    originalY: originalTileY,
                    pixels: tilePixels
                });
            }
        }

        return tiles;
    }

    /**
     * Extract 8x8 tiles from the image in reading order for CHR pattern table
     * @param {Object} imageData - Image data with width, height, data
     * @param {Object} paletteSystem - Contains palettes and assignments for color conversion
     * @param {Object} clipInfo - Clipping information to limit processing area
     * @returns {Array} - Array of 8x8 CHR tiles with planar data
     */
    extract8x8Tiles(imageData, paletteSystem, clipInfo) {
        const chrTiles = [];

        // Calculate clipped dimensions
        const fullTilesWide = 32; // 256 / 8
        const fullTilesHigh = 16; // 128 / 8

        const clippedTilesWide = fullTilesWide - clipInfo.leftClip - clipInfo.rightClip;
        const clippedTilesHigh = fullTilesHigh - clipInfo.topClip - clipInfo.bottomClip;

        console.log(`   📐 Clipped tile area: ${clippedTilesWide}×${clippedTilesHigh} tiles (was ${fullTilesWide}×${fullTilesHigh})`);

        // Extract tiles in reading order (left-to-right, top-to-bottom) but only within clipped area
        for (let clippedTileY = 0; clippedTileY < clippedTilesHigh; clippedTileY++) {
            for (let clippedTileX = 0; clippedTileX < clippedTilesWide; clippedTileX++) {
                // Convert clipped coordinates to full image coordinates
                const tileX = clippedTileX + clipInfo.leftClip;
                const tileY = clippedTileY + clipInfo.topClip;
                // Extract 8x8 pixels for this CHR tile
                const tilePixels = [];

                for (let y = 0; y < 8; y++) {
                    for (let x = 0; x < 8; x++) {
                        const globalX = tileX * 8 + x;
                        const globalY = tileY * 8 + y;
                        const idx = (imageData.width * globalY + globalX) << 2;

                        const r = imageData.data[idx];
                        const g = imageData.data[idx + 1];
                        const b = imageData.data[idx + 2];
                        const a = imageData.data[idx + 3];

                        tilePixels.push({ r, g, b, a });
                    }
                }

                // Determine which 16x16 mega-tile this 8x8 tile belongs to (for palette lookup)
                const megaTileX = Math.floor(tileX / 2); // 16x16 tiles are 2x2 grid of 8x8 tiles
                const megaTileY = Math.floor(tileY / 2);
                const megaTileIndex = megaTileY * 16 + megaTileX; // 16 mega-tiles wide

                // Convert pixels to 2-bit values using the appropriate palette
                const pixelValues = this.convertPixelsToPaletteValues(
                    tilePixels,
                    paletteSystem.palettes[paletteSystem.assignments[megaTileIndex]]
                );

                // Convert to planar format
                const planarData = this.convertToPlanarFormat(pixelValues);

                chrTiles.push({
                    index: clippedTileY * clippedTilesWide + clippedTileX, // Sequential index within clipped area
                    clippedX: clippedTileX, // Position within clipped area
                    clippedY: clippedTileY,
                    fullX: tileX, // Original position in full image
                    fullY: tileY,
                    megaTileIndex: megaTileIndex,
                    pixels: tilePixels,
                    pixelValues: pixelValues,
                    planeA: planarData.planeA,
                    planeB: planarData.planeB
                });
            }
        }

        return chrTiles;
    }

    /**
     * Convert pixel RGBA values to 2-bit palette indices
     * @param {Array} pixels - Array of 64 pixel objects with r,g,b,a
     * @param {Array} palette - 3-color palette (may contain nulls)
     * @returns {Array} - Array of 64 2-bit values (0=transparent, 1-3=palette colors)
     */
    convertPixelsToPaletteValues(pixels, palette) {
        const values = [];

        for (const pixel of pixels) {
            let pixelValue = 0; // Default to transparent

            if (pixel.a > 0) { // Only process non-transparent pixels
                // Convert to closest NES color
                const nesColor = this.findClosestNESColor(pixel.r, pixel.g, pixel.b);

                // Find this color in the palette
                for (let p = 0; p < 3; p++) {
                    if (palette[p] && this.colorsEqual(nesColor, palette[p])) {
                        // Map palette positions to pixel values with brightness ordering:
                        // palette[0] = brightest → pixelValue = 3
                        // palette[1] = medium   → pixelValue = 2
                        // palette[2] = darkest  → pixelValue = 1
                        pixelValue = 3 - p;
                        break;
                    }
                }
            }

            values.push(pixelValue);
        }

        return values;
    }

    /**
     * Convert 8x8 tile of 2-bit pixel values to NES CHR planar format
     * @param {Array} pixelValues - Array of 64 2-bit values (0-3)
     * @returns {Object} - Object with planeA and planeB byte arrays
     */
    convertToPlanarFormat(pixelValues) {
        const planeA = new Array(8).fill(0); // 8 bytes for plane A (bit 0)
        const planeB = new Array(8).fill(0); // 8 bytes for plane B (bit 1)

        // Process each row of the 8x8 tile
        for (let row = 0; row < 8; row++) {
            let planeAByte = 0;
            let planeBByte = 0;

            // Process each column in this row
            for (let col = 0; col < 8; col++) {
                const pixelIndex = row * 8 + col;
                const pixelValue = pixelValues[pixelIndex];

                // Extract bit 0 (plane A) and bit 1 (plane B)
                const bit0 = pixelValue & 1;        // Bit 0
                const bit1 = (pixelValue >> 1) & 1; // Bit 1

                // Pack bits into bytes (MSB first - leftmost pixel is bit 7)
                planeAByte |= (bit0 << (7 - col));
                planeBByte |= (bit1 << (7 - col));
            }

            planeA[row] = planeAByte;
            planeB[row] = planeBByte;
        }

        return { planeA, planeB };
    }

    /**
     * Analyze tiles and build palette system with wildcard matching
     * @param {Array} tileData - Array of tile objects
     * @returns {Object} - Palette system with palettes and assignments
     */
    analyzeTilePalettes(tileData) {
        const palettes = []; // Array of 3-color palettes
        const assignments = []; // Which palette each tile uses

        for (let i = 0; i < tileData.length; i++) {
            const tile = tileData[i];
            const tilePalette = this.extractTilePalette(tile);
            const paletteIndex = this.findOrCreatePalette(palettes, tilePalette);

            if (paletteIndex === -1) {
                throw new Error(`Cannot create more than 4 palettes. Tile ${i} needs a new palette.`);
            }

            assignments.push(paletteIndex);
        }

        return { palettes, assignments };
    }

    /**
     * Extract and sort colors for a single tile
     * @param {Object} tile - Tile object with pixels
     * @returns {Array} - 3-element palette array (may contain nulls)
     */
    extractTilePalette(tile) {
        const colorMap = new Map();

        // Count unique NES colors (skip transparent pixels)
        for (const pixel of tile.pixels) {
            if (pixel.a === 0) continue; // Skip transparent pixels

            // Convert to closest NES color
            const nesColor = this.findClosestNESColor(pixel.r, pixel.g, pixel.b);
            const colorKey = `${nesColor.r},${nesColor.g},${nesColor.b}`;

            if (!colorMap.has(colorKey)) {
                colorMap.set(colorKey, {
                    r: nesColor.r,
                    g: nesColor.g,
                    b: nesColor.b,
                    nesId: nesColor.id,
                    originalPixel: pixel
                });
            }
        }

        const opaqueColors = Array.from(colorMap.values());

        if (opaqueColors.length > 3) {
            const colorList = opaqueColors.map(color => {
                const orig = color.originalPixel;
                return `NES(${color.r},${color.g},${color.b})[was RGB(${orig.r},${orig.g},${orig.b})]`;
            }).join(', ');
            const tileCoords = tile.originalX >= 0 && tile.originalY >= 0
                ? `(${tile.originalX},${tile.originalY}) in original image`
                : `(${tile.x},${tile.y}) in padded area`;
            throw new Error(`Tile at ${tileCoords} has ${opaqueColors.length} opaque NES colors. Max 3 allowed. Colors found: ${colorList}`);
        }

        // Sort by brightness, then by R>G>B for ties
        opaqueColors.sort((a, b) => {
            const brightnessA = a.r + a.g + a.b;
            const brightnessB = b.r + b.g + b.b;

            if (brightnessA !== brightnessB) {
                return brightnessB - brightnessA; // Brightest first
            }

            // Tie-breaker: R > G > B
            if (a.r !== b.r) return b.r - a.r;
            if (a.g !== b.g) return b.g - a.g;
            return b.b - a.b;
        });

        // Create 3-element palette (pad with nulls if needed)
        const palette = [null, null, null];
        for (let i = 0; i < opaqueColors.length; i++) {
            palette[i] = opaqueColors[i];
        }

        return palette;
    }

    /**
     * Find existing palette or create new one with wildcard matching
     * @param {Array} palettes - Array of existing palettes
     * @param {Array} tilePalette - New palette to match
     * @returns {number} - Palette index, or -1 if can't create more
     */
    findOrCreatePalette(palettes, tilePalette) {
        // Try to match with existing palettes
        for (let i = 0; i < palettes.length; i++) {
            if (this.canPaletteMatch(palettes[i], tilePalette)) {
                // Update existing palette with any new non-null values
                this.mergePalettes(palettes[i], tilePalette);
                return i;
            }
        }

        // Need new palette
        if (palettes.length >= 4) {
            return -1; // Can't create more palettes
        }

        // Create new palette
        palettes.push([...tilePalette]); // Deep copy
        return palettes.length - 1;
    }

    /**
     * Check if two palettes can match with wildcard rules
     * @param {Array} existing - Existing palette
     * @param {Array} candidate - New palette to test
     * @returns {boolean} - Whether they can match
     */
    canPaletteMatch(existing, candidate) {
        for (let i = 0; i < 3; i++) {
            const existingColor = existing[i];
            const candidateColor = candidate[i];

            // If either is null, it's a wildcard match
            if (existingColor === null || candidateColor === null) {
                continue;
            }

            // Both non-null, must be exact match
            if (!this.colorsEqual(existingColor, candidateColor)) {
                return false;
            }
        }
        return true;
    }

    /**
     * Merge candidate palette into existing palette (fill nulls)
     * @param {Array} existing - Existing palette to modify
     * @param {Array} candidate - New palette with values to merge
     */
    mergePalettes(existing, candidate) {
        for (let i = 0; i < 3; i++) {
            if (existing[i] === null && candidate[i] !== null) {
                existing[i] = { ...candidate[i] }; // Deep copy
            }
        }
    }

    /**
     * Check if two colors are equal
     * @param {Object} colorA - First color
     * @param {Object} colorB - Second color
     * @returns {boolean} - Whether colors are equal
     */
    colorsEqual(colorA, colorB) {
        return colorA.r === colorB.r &&
               colorA.g === colorB.g &&
               colorA.b === colorB.b;
    }

    /**
     * Add a command to the bit queue with automatic bit width handling
     *
     * This helper function encapsulates the bit-level encoding of command indices.
     * It automatically handles variable command bit widths (1, 2, 3, or 4 bits)
     * without requiring manual bit manipulation throughout the codebase.
     *
     * The function works by extracting individual bits from the command index,
     * starting from the most significant bit and working down. This creates
     * a big-endian bit representation that matches standard binary encoding.
     *
     * For example, with commandBitWidth=2 and commandId=3:
     * - Bit 1: (3 >> 1) & 1 = 1
     * - Bit 0: (3 >> 0) & 1 = 1
     * - Result: [1, 1] representing binary "11" = decimal 3
     *
     * @param {number[]} bitQueue - Array to append bits to (modified in place)
     * @param {number} commandId - Command index to encode (0 to 2^commandBitWidth - 1)
     * @param {number} commandBitWidth - Number of bits for command encoding (1-4)
     */
    addCommandToBitQueue(bitQueue, commandId, commandBitWidth) {
        // Extract individual bits from the command ID, MSB first
        // This creates a consistent big-endian representation that's easy to decode
        for (let bit = commandBitWidth - 1; bit >= 0; bit--) {
            bitQueue.push((commandId >> bit) & 1);
        }
    }

    /**
     * Compress CHR tile data using the original command-based encoding system
     *
     * This method uses the EXACT same compression logic as before, but feeds it pixel values
     * reconstructed from the CHR planar format instead of linear pixel data.
     * The commands work identically - they still operate on individual 2-bit pixel values.
     *
     * @param {Array} chrTileData - Array of CHR tiles with planeA and planeB data
     * @param {number} commandBitWidth - Number of bits per command
     * @param {Map} commandToIndex - Maps command types to bit stream indices
     * @returns {number[]} - Compressed pixel data bytes (same as original system)
     */
    compressCHRData(chrTileData, commandBitWidth, commandToIndex) {
        // Convert CHR planar data back to linear pixel values for compression
        // This creates a simple linear stream of 32,768 pixels (512 tiles × 64 pixels each)
        // in reading order: tile0_pixels, tile1_pixels, tile2_pixels, etc.
        const linearPixelValues = [];

        for (const chrTile of chrTileData) {
            // Reconstruct pixel values from planar data for this 8x8 tile
            for (let row = 0; row < 8; row++) {
                const planeAByte = chrTile.planeA[row];
                const planeBByte = chrTile.planeB[row];

                for (let col = 0; col < 8; col++) {
                    // Extract bits for this pixel (MSB = leftmost pixel)
                    const bit0 = (planeAByte >> (7 - col)) & 1; // Plane A bit
                    const bit1 = (planeBByte >> (7 - col)) & 1; // Plane B bit
                    const pixelValue = bit0 | (bit1 << 1); // Combine to 2-bit value

                    linearPixelValues.push(pixelValue);
                }
            }
        }

        console.log(`   📊 Created linear pixel stream: ${linearPixelValues.length} pixels from ${chrTileData.length} CHR tiles`);

        // Now use the ORIGINAL compression logic with the reconstructed pixel values
        return this.compressPixelValues(linearPixelValues, commandBitWidth, commandToIndex);
    }

    /**
     * Compress linear pixel values using the new bit-based command system
     *
     * @param {Array} pixelValues - Array of 2-bit pixel values (0-3)
     * @param {number} commandBitWidth - Number of bits per command
     * @param {Map} commandToIndex - Maps command types to bit stream indices
     * @returns {number[]} - Compressed data bytes
     */
    compressPixelValues(pixelValues, commandBitWidth, commandToIndex) {
        // Convert pixel values to bit stream
        const bits = [];
        for (const pixelValue of pixelValues) {
            bits.push((pixelValue >> 1) & 1); // Bit 1
            bits.push(pixelValue & 1);         // Bit 0
        }

        console.log(`   🔄 Converting ${pixelValues.length} pixels to ${bits.length} bits for compression`);

        // Compress the bit stream using the new commands
        return this.compressBitStream(bits, commandBitWidth, commandToIndex);
    }

    /**
     * Compress a bit stream using REPEAT_BITS and PLOT_BITS commands
     *
     * @param {Array} bits - Array of bits (0 or 1)
     * @param {number} commandBitWidth - Number of bits per command
     * @param {Map} commandToIndex - Maps command types to bit stream indices
     * @returns {number[]} - Compressed data bytes
     */
    compressBitStream(bits, commandBitWidth, commandToIndex) {
        const allCommandBits = [];
        const debugCommands = []; // For human-readable output

        let bitIndex = 0;
        while (bitIndex < bits.length) {
            const remainingBits = bits.length - bitIndex;

            // Try all available commands and evaluate their efficiency
            const commandOptions = [];

            // Try REPEAT_BITS if available
            if (commandToIndex.has(this.COMMAND_REPEAT_BITS)) {
                const result = this.tryRepeatBits(bitIndex, remainingBits, bits, commandBitWidth);
                if (result.viable) {
                    commandOptions.push({
                        ...result,
                        commandType: this.COMMAND_REPEAT_BITS,
                        ratio: result.bitsUsed / result.imageBitsProduced
                    });
                }
            }

            // Try PLOT_BITS if available
            if (commandToIndex.has(this.COMMAND_PLOT_BITS)) {
                const result = this.tryPlotBits(bitIndex, remainingBits, bits, commandBitWidth);
                if (result.viable) {
                    commandOptions.push({
                        ...result,
                        commandType: this.COMMAND_PLOT_BITS,
                        ratio: result.bitsUsed / result.imageBitsProduced
                    });
                }
            }

            // Try REPEAT_COMMAND if available
            if (commandToIndex.has(this.COMMAND_REPEAT_COMMAND)) {
                const result = this.tryRepeatCommand(bitIndex, remainingBits, bits, commandBitWidth, commandToIndex);
                if (result.viable) {
                    commandOptions.push({
                        ...result,
                        commandType: this.COMMAND_REPEAT_COMMAND,
                        ratio: result.efficiency // Already calculated in tryRepeatCommand
                    });
                }
            }

            // Apply selection logic: lowest ratio → highest advance → first in header
            if (commandOptions.length === 0) {
                // Provide detailed failure information for debugging
                let failureDetails = [];
                if (commandToIndex.has(this.COMMAND_REPEAT_BITS)) {
                    const repeatResult = this.tryRepeatBits(bitIndex, remainingBits, bits, commandBitWidth);
                    failureDetails.push(`REPEAT_BITS: ${repeatResult.debugInfo}`);
                }
                if (commandToIndex.has(this.COMMAND_PLOT_BITS)) {
                    const plotResult = this.tryPlotBits(bitIndex, remainingBits, bits, commandBitWidth);
                    failureDetails.push(`PLOT_BITS: ${plotResult.debugInfo}`);
                }
                if (commandToIndex.has(this.COMMAND_REPEAT_COMMAND)) {
                    const repeatCommandResult = this.tryRepeatCommand(bitIndex, remainingBits, bits, commandBitWidth, commandToIndex);
                    failureDetails.push(`REPEAT_COMMAND: ${repeatCommandResult.debugInfo}`);
                }

                throw new Error(`No viable commands at bit position ${bitIndex}, ${remainingBits} bits remaining. Failures: ${failureDetails.join('; ')}`);
            }

            // Sort by: ratio (ascending), then imageBitsProduced (descending), then command order
            commandOptions.sort((a, b) => {
                if (a.ratio !== b.ratio) return a.ratio - b.ratio;
                if (a.imageBitsProduced !== b.imageBitsProduced) return b.imageBitsProduced - a.imageBitsProduced;
                // Command order based on header sequence (REPEAT_BITS=0x00, PLOT_BITS=0x01)
                return a.commandType - b.commandType;
            });

            const selectedCommand = commandOptions[0];

            // Execute the selected command
            const commandId = commandToIndex.get(selectedCommand.commandType);
            this.addCommandToBitQueue(allCommandBits, commandId, commandBitWidth);

            if (selectedCommand.commandType === this.COMMAND_REPEAT_BITS) {
                // Encode REPEAT_BITS command
                allCommandBits.push(selectedCommand.commandData.bitValue);
                const count = selectedCommand.commandData.runLength - 2; // Convert 2-9 to 0-7
                for (let bit = 2; bit >= 0; bit--) {
                    allCommandBits.push((count >> bit) & 1);
                }
            } else if (selectedCommand.commandType === this.COMMAND_PLOT_BITS) {
                // Encode PLOT_BITS command
                for (let i = 0; i < 4; i++) {
                    allCommandBits.push(parseInt(selectedCommand.commandData.pattern[i]));
                }
            } else if (selectedCommand.commandType === this.COMMAND_REPEAT_COMMAND) {

                // Encode REPEAT_COMMAND command
                const count = selectedCommand.commandData.repeatCount - 2; // Convert 2-9 to 0-7
                for (let bit = 2; bit >= 0; bit--) {
                    allCommandBits.push((count >> bit) & 1);
                }

                // Now encode the following command
                const followingCommandId = commandToIndex.get(selectedCommand.commandData.followingCommand);
                this.addCommandToBitQueue(allCommandBits, followingCommandId, commandBitWidth);

                // Encode the following command's data
                if (selectedCommand.commandData.followingCommand === this.COMMAND_REPEAT_BITS) {
                    allCommandBits.push(selectedCommand.commandData.followingCommandData.bitValue);
                    const followingCount = selectedCommand.commandData.followingCommandData.runLength - 2;
                    for (let bit = 2; bit >= 0; bit--) {
                        allCommandBits.push((followingCount >> bit) & 1);
                    }
                } else if (selectedCommand.commandData.followingCommand === this.COMMAND_PLOT_BITS) {
                    for (let i = 0; i < 4; i++) {
                        allCommandBits.push(parseInt(selectedCommand.commandData.followingCommandData.pattern[i]));
                    }
                }
            }

            // Add to debug output
            const endBit = bitIndex + selectedCommand.imageBitsProduced - 1;
            debugCommands.push(`[${String(bitIndex).padStart(5, '0')}-${String(endBit).padStart(5, '0')}] ${selectedCommand.debugInfo}`);


            bitIndex += selectedCommand.imageBitsProduced;
        }

        // Pack bits into bytes
        const packedBytes = this.packBitsToBytes(allCommandBits);

        // Store debug commands for later output
        this.lastDebugCommands = debugCommands;

        return packedBytes;
    }

    /**
     * Try to use REPEAT_BITS command at current position
     * @param {number} bitPosition - Current position in bit stream
     * @param {number} remainingBits - Number of bits remaining from this position
     * @param {number[]} bits - Full bit array
     * @param {number} commandBitWidth - Width of command ID in bits
     * @returns {Object} - {viable, bitsUsed, imageBitsProduced, debugInfo, commandData}
     */
    tryRepeatBits(bitPosition, remainingBits, bits, commandBitWidth) {
        // Check if we have enough bits for the command structure
        const minBitsNeeded = commandBitWidth + 1 + 3; // command + bit_value + 3-bit count
        if (remainingBits < minBitsNeeded) {
            return { viable: false, bitsUsed: 0, imageBitsProduced: 0, debugInfo: 'Insufficient bits for command structure' };
        }

        // Find run of identical bits starting at current position
        const currentBit = bits[bitPosition];
        let runLength = 1;
        while (bitPosition + runLength < bits.length &&
               bits[bitPosition + runLength] === currentBit &&
               runLength < 9) { // Max run length is 9 (111 + 2)
            runLength++;
        }

        // Need at least 2 identical bits to be viable
        if (runLength < 2) {
            return { viable: false, bitsUsed: 0, imageBitsProduced: 0, debugInfo: 'Run too short (< 2 bits)' };
        }

        // Check if we can encode this run length within remaining bits
        const imageBitsConsumed = Math.min(runLength, remainingBits);
        if (imageBitsConsumed < 2) {
            return { viable: false, bitsUsed: 0, imageBitsProduced: 0, debugInfo: 'Not enough remaining bits for viable run' };
        }

        // Calculate actual command cost
        const bitsUsed = commandBitWidth + 1 + 3; // command + bit_value + count

        return {
            viable: true,
            bitsUsed: bitsUsed,
            imageBitsProduced: imageBitsConsumed,
            debugInfo: `REPEAT_BITS ${currentBit}, ${imageBitsConsumed}`,
            commandData: {
                bitValue: currentBit,
                runLength: imageBitsConsumed
            }
        };
    }

    /**
     * Try to use PLOT_BITS command at current position
     * @param {number} bitPosition - Current position in bit stream
     * @param {number} remainingBits - Number of bits remaining from this position
     * @param {number[]} bits - Full bit array
     * @param {number} commandBitWidth - Width of command ID in bits
     * @returns {Object} - {viable, bitsUsed, imageBitsProduced, debugInfo, commandData}
     */
    tryPlotBits(bitPosition, remainingBits, bits, commandBitWidth) {
        // PLOT_BITS can handle any remaining bits (1-4), padding with zeros
        if (remainingBits < 1) {
            return {
                viable: false,
                bitsUsed: 0,
                imageBitsProduced: 0,
                debugInfo: `No image bits remaining`
            };
        }

        // Collect up to 4 bits for the pattern, padding with zeros
        const bitsToProcess = Math.min(4, remainingBits);
        let pattern = '';
        for (let i = 0; i < 4; i++) {
            if (i < bitsToProcess) {
                pattern += bits[bitPosition + i];
            } else {
                pattern += '0'; // Pad with zeros
            }
        }

        const bitsUsed = commandBitWidth + 4; // command + 4-bit pattern

        return {
            viable: true,
            bitsUsed: bitsUsed,
            imageBitsProduced: bitsToProcess, // Only count actual bits processed
            debugInfo: `PLOT_BITS ${pattern}`,
            commandData: {
                pattern: pattern,
                actualBits: bitsToProcess
            }
        };
    }

    /**
     * Try to use REPEAT_COMMAND at current position with lookahead evaluation
     * @param {number} bitPosition - Current position in bit stream
     * @param {number} remainingBits - Number of bits remaining from this position
     * @param {number[]} bits - Full bit array
     * @param {number} commandBitWidth - Width of command ID in bits
     * @param {Map} commandToIndex - Maps command types to bit stream indices
     * @returns {Object} - {viable, bitsUsed, imageBitsProduced, debugInfo, commandData}
     */
    tryRepeatCommand(bitPosition, remainingBits, bits, commandBitWidth, commandToIndex) {
        // REPEAT_COMMAND structure: [command_bits][3_bit_repeat_count]
        const repeatCommandBits = commandBitWidth + 3;

        if (remainingBits < repeatCommandBits) {
            return {
                viable: false,
                bitsUsed: 0,
                imageBitsProduced: 0,
                debugInfo: 'Insufficient bits for REPEAT_COMMAND structure'
            };
        }

        const bestOptions = [];

        // Try repeating each available command (except REPEAT_COMMAND itself)
        for (const [commandType, commandIndex] of commandToIndex) {
            if (commandType === this.COMMAND_REPEAT_COMMAND) continue; // No self-repetition

            // PATTERN DISCOVERY PHASE: Find actual maximum viable repeat count
            let maxViableRepeats = 1;
            let currentPos = bitPosition;
            const bitsAfterRepeat = remainingBits - repeatCommandBits;

            // Get the first pattern to match against
            let firstPatternResult;
            if (commandType === this.COMMAND_REPEAT_BITS) {
                firstPatternResult = this.tryRepeatBits(bitPosition, bitsAfterRepeat, bits, commandBitWidth);
            } else if (commandType === this.COMMAND_PLOT_BITS) {
                firstPatternResult = this.tryPlotBits(bitPosition, bitsAfterRepeat, bits, commandBitWidth);
            }

            if (!firstPatternResult || !firstPatternResult.viable) continue; // Skip this command type

            // Test how many times this EXACT pattern can be applied consecutively
            while (maxViableRepeats < 9) { // Cap at maximum repeat count
                let testResult;

                if (commandType === this.COMMAND_REPEAT_BITS) {
                    testResult = this.tryRepeatBits(currentPos, bits.length - currentPos, bits, commandBitWidth);
                } else if (commandType === this.COMMAND_PLOT_BITS) {
                    testResult = this.tryPlotBits(currentPos, bits.length - currentPos, bits, commandBitWidth);
                }

                if (!testResult || !testResult.viable) break;

                // Check if this pattern matches the first pattern
                let patternsMatch = false;
                if (commandType === this.COMMAND_REPEAT_BITS) {
                    patternsMatch = (testResult.commandData.bitValue === firstPatternResult.commandData.bitValue &&
                                    testResult.commandData.runLength === firstPatternResult.commandData.runLength);
                } else if (commandType === this.COMMAND_PLOT_BITS) {
                    patternsMatch = (testResult.commandData.pattern === firstPatternResult.commandData.pattern);
                }

                if (!patternsMatch) break;

                maxViableRepeats++;
                currentPos += testResult.imageBitsProduced;
            }

            // EFFICIENCY EVALUATION PHASE: Only try realistic repeat counts (temporarily fixed to 2 for debugging)
            const maxRepeatCount = Math.min(maxViableRepeats, 9);
            for (let repeatCount = 2; repeatCount <= Math.min(maxRepeatCount, 3); repeatCount++) { // Limit to small repeat counts
                // Use the already calculated first pattern result
                const totalBitsUsed = repeatCommandBits + firstPatternResult.bitsUsed;
                const totalImageBitsProduced = firstPatternResult.imageBitsProduced * repeatCount;
                const efficiency = totalBitsUsed / totalImageBitsProduced;

                bestOptions.push({
                    viable: true,
                    bitsUsed: totalBitsUsed,
                    imageBitsProduced: totalImageBitsProduced,
                    efficiency: efficiency,
                    debugInfo: `REPEAT_COMMAND ${repeatCount}x ${firstPatternResult.debugInfo}`,
                    commandData: {
                        repeatCount: repeatCount,
                        followingCommand: commandType,
                        followingCommandData: firstPatternResult.commandData
                    }
                });
            }
        }

        // Return the most efficient option
        if (bestOptions.length > 0) {
            return bestOptions.reduce((best, current) =>
                current.efficiency < best.efficiency ? current : best
            );
        } else {
            return {
                viable: false,
                bitsUsed: 0,
                imageBitsProduced: 0,
                debugInfo: 'No viable commands to repeat'
            };
        }
    }

    /**
     * Convert tiles to command-based pixel data
            if (repeatCount > 0) {
                // Use repeat pixel command
                const commandId = commandToIndex.get(this.COMMAND_REPEAT_PIXEL);
                this.addCommandToBitQueue(allCommandBits, commandId, commandBitWidth);

                // Add pixel data bits (2 bits)
                allCommandBits.push((pixelValue >> 1) & 1); // Bit 1
                allCommandBits.push(pixelValue & 1);         // Bit 0

                // Add 4-bit repeat count parameter
                for (let bit = 3; bit >= 0; bit--) {
                    allCommandBits.push((repeatCount >> bit) & 1);
                }

                // Skip all the pixels (current + repeated ones)
                pixelIndex = nextIndex;
            } else {
                // Check if we can use the two-pixel command
                let useDoublePixel = false;
                let secondPixelValue = 0;

                if (pixelIndex + 1 < pixelValues.length) {
                    secondPixelValue = pixelValues[pixelIndex + 1];
                    useDoublePixel = true;
                }

                if (useDoublePixel && pixelIndex + 1 < pixelValues.length) {
                    // Use plot two pixels command (if available in this profile)
                    const twoPixelCommandId = commandToIndex.get(this.COMMAND_PLOT_TWO_PIXELS);
                    if (twoPixelCommandId !== undefined) {
                        this.addCommandToBitQueue(allCommandBits, twoPixelCommandId, commandBitWidth);

                        // Add first pixel data bits (2 bits)
                        allCommandBits.push((pixelValue >> 1) & 1); // Bit 1
                        allCommandBits.push(pixelValue & 1);         // Bit 0

                        // Add second pixel data bits (2 bits)
                        allCommandBits.push((secondPixelValue >> 1) & 1); // Bit 1
                        allCommandBits.push(secondPixelValue & 1);         // Bit 0

                        pixelIndex += 2;
                        previousPixelValue = secondPixelValue;
                    } else {
                        // PLOT_TWO_PIXELS not available - fall through to single pixel handling
                        useDoublePixel = false;
                    }
                }

                if (!useDoublePixel) {
                    // Use plot single pixel command (if available in this profile)
                    const plotPixelCommandId = commandToIndex.get(this.COMMAND_PLOT_PIXEL);
                    if (plotPixelCommandId !== undefined) {
                        this.addCommandToBitQueue(allCommandBits, plotPixelCommandId, commandBitWidth);

                        // Add pixel data bits (2 bits)
                        allCommandBits.push((pixelValue >> 1) & 1); // Bit 1
                        allCommandBits.push(pixelValue & 1);         // Bit 0

                        pixelIndex++;
                        previousPixelValue = pixelValue;
                    } else {
                        // PLOT_PIXEL not available in this profile - force it to be a repeat with count 0
                        const repeatCommandId = commandToIndex.get(this.COMMAND_REPEAT_PIXEL);
                        if (repeatCommandId !== undefined) {
                            this.addCommandToBitQueue(allCommandBits, repeatCommandId, commandBitWidth);

                            // Add pixel data bits (2 bits)
                            allCommandBits.push((pixelValue >> 1) & 1); // Bit 1
                            allCommandBits.push(pixelValue & 1);         // Bit 0

                            // Add 4-bit repeat count of 0 (just this pixel, no repeats)
                            for (let bit = 3; bit >= 0; bit--) {
                                allCommandBits.push(0);
                            }

                            pixelIndex++;
                            previousPixelValue = pixelValue;
                        } else {
                            throw new Error("No available commands to encode single pixel");
                        }
                    }
                }
            }
        }

        // Pack bits into bytes (same as original)
        return this.packBitsToBytes(allCommandBits);
    }

    /**
     * Convert tiles to command-based pixel data
     *
     * This is the core compression engine that transforms raw pixel data into an
     * optimized stream of variable-length commands. The goal is to minimize the
     * total number of bits required to represent the image by choosing the most
     * efficient command for each pixel pattern.
     *
     * COMMAND SELECTION STRATEGY:
     * The encoder analyzes pixel patterns and chooses commands based on efficiency:
     *
     * 1. REPEAT PIXEL COMMAND (7 bits): Used for runs of 2+ identical pixels
     *    - Most efficient for repeated patterns (backgrounds, solid areas)
     *    - Encodes: [command_bits][pixel_data][repeat_count]
     *    - Can encode 2-16 pixels in just 7 bits
     *
     * 2. PLOT TWO PIXELS COMMAND (6 bits): Used for pairs of non-repeating pixels
     *    - More efficient than two single-pixel commands (6 vs 8 bits)
     *    - Encodes: [command_bits][pixel1_data][pixel2_data]
     *    - Good for detailed areas with varied colors
     *
     * 3. PLOT SINGLE PIXEL COMMAND (4 bits): Used for isolated pixels
     *    - Simplest encoding for standalone pixels
     *    - Encodes: [command_bits][pixel_data]
     *    - Fallback when other commands don't apply
     *
     * PIXEL VALUE ENCODING:
     * Each pixel is encoded as a 2-bit value representing its palette position:
     * - 0: Transparent
     * - 1: Darkest color in palette (palette[2])
     * - 2: Medium color in palette (palette[1])
     * - 3: Brightest color in palette (palette[0])
     *
     * This inverted mapping (3=brightest, 1=darkest) allows transparent pixels
     * to have the value 0, which is intuitive and matches common expectations.
     *
     * @param {Array} tileData - Array of 128 tile objects, each containing 256 pixels
     * @param {Object} paletteSystem - Contains palettes array and assignments mapping
     * @param {number} commandBitWidth - Number of bits per command (currently 2)
     * @param {Map} commandToIndex - Maps command types to their bit stream indices
     * @returns {number[]} - Array of packed command bytes ready for transmission
     */
    convertTilesToCommandData(tileData, paletteSystem, commandBitWidth, commandToIndex) {
        // Master bit array that will contain the entire compressed command stream
        const allCommandBits = [];

        // Track the last pixel value for repeat detection across tile boundaries
        let previousPixelValue = null;

        // Process each of the 128 tiles (16x8 grid of 16x16 pixel tiles)
        for (let i = 0; i < tileData.length; i++) {
            const tile = tileData[i];
            const paletteIndex = paletteSystem.assignments[i];
            const palette = paletteSystem.palettes[paletteIndex];

            // Process each pixel within the current tile (256 pixels per tile)
            // We use a while loop instead of for loop because command encoding
            // may consume multiple pixels at once (for repeat/double commands)
            let pixelIndex = 0;
            while (pixelIndex < tile.pixels.length) {
                const pixel = tile.pixels[pixelIndex];
                let pixelValue = 0; // Default to transparent (palette position 0)

                // PIXEL COLOR CONVERSION AND PALETTE MAPPING
                // ==========================================
                if (pixel.a > 0) { // Only process non-transparent pixels
                    // Step 1: Convert the RGB pixel to the closest NES hardware color
                    // This ensures we're working within the NES color space constraints
                    const nesColor = this.findClosestNESColor(pixel.r, pixel.g, pixel.b);

                    // Step 2: Find this NES color within the current tile's assigned palette
                    // Each palette contains up to 3 colors plus transparency
                    for (let p = 0; p < 3; p++) {
                        if (palette[p] && this.colorsEqual(nesColor, palette[p])) {
                            // Map palette positions to pixel values with brightness ordering:
                            // palette[0] = brightest → pixelValue = 3
                            // palette[1] = medium   → pixelValue = 2
                            // palette[2] = darkest  → pixelValue = 1
                            // This creates an intuitive brightness scale where higher values = brighter
                            pixelValue = 3 - p;
                            break;
                        }
                    }
                }

                // Check if we can use command 1 (repeat pixel) for consecutive identical pixels
                let repeatCount = 0;
                let nextIndex = pixelIndex + 1;

                // Count how many consecutive pixels (including current) have the same value
                while (nextIndex < tile.pixels.length && repeatCount < 15) {
                    const nextPixel = tile.pixels[nextIndex];
                    let nextPixelValue = 0;

                    if (nextPixel.a > 0) {
                        const nesColor = this.findClosestNESColor(nextPixel.r, nextPixel.g, nextPixel.b);
                        for (let p = 0; p < 3; p++) {
                            if (palette[p] && this.colorsEqual(nesColor, palette[p])) {
                                nextPixelValue = 3 - p;
                                break;
                            }
                        }
                    }

                    if (nextPixelValue === pixelValue) {
                        repeatCount++;
                        nextIndex++;
                    } else {
                        break;
                    }
                }

                // If we found repeats, use repeat command with embedded pixel data
                if (repeatCount > 0) {
                    // Use repeat pixel command
                    const commandId = commandToIndex.get(this.COMMAND_REPEAT_PIXEL);
                    this.addCommandToBitQueue(allCommandBits, commandId, commandBitWidth);

                    // Add pixel data bits (2 bits)
                    allCommandBits.push((pixelValue >> 1) & 1); // Bit 1
                    allCommandBits.push(pixelValue & 1);         // Bit 0

                    // Add 4-bit repeat count parameter
                    for (let bit = 3; bit >= 0; bit--) {
                        allCommandBits.push((repeatCount >> bit) & 1);
                    }

                    // Skip all the pixels (current + repeated ones)
                    pixelIndex = nextIndex;
                } else {
                    // Check if we can use the two-pixel command
                    let useDoublePixel = false;
                    let secondPixelValue = 0;

                    if (pixelIndex + 1 < tile.pixels.length) {
                        const secondPixel = tile.pixels[pixelIndex + 1];

                        if (secondPixel.a > 0) {
                            const nesColor = this.findClosestNESColor(secondPixel.r, secondPixel.g, secondPixel.b);
                            for (let p = 0; p < 3; p++) {
                                if (palette[p] && this.colorsEqual(nesColor, palette[p])) {
                                    secondPixelValue = 3 - p;
                                    break;
                                }
                            }
                        }

                        // Use two-pixel command if we have a second pixel available
                        useDoublePixel = true;
                    }

                    if (useDoublePixel && pixelIndex + 1 < tile.pixels.length) {
                        // Use plot two pixels command
                        const commandId = commandToIndex.get(this.COMMAND_PLOT_TWO_PIXELS);
                        this.addCommandToBitQueue(allCommandBits, commandId, commandBitWidth);

                        // Add first pixel data bits (2 bits)
                        allCommandBits.push((pixelValue >> 1) & 1); // Bit 1
                        allCommandBits.push(pixelValue & 1);         // Bit 0

                        // Add second pixel data bits (2 bits)
                        allCommandBits.push((secondPixelValue >> 1) & 1); // Bit 1
                        allCommandBits.push(secondPixelValue & 1);         // Bit 0

                        pixelIndex += 2;
                        previousPixelValue = secondPixelValue;
                    } else {
                        // Use plot single pixel command
                        const commandId = commandToIndex.get(this.COMMAND_PLOT_PIXEL);
                        this.addCommandToBitQueue(allCommandBits, commandId, commandBitWidth);

                        // Add pixel data bits (2 bits)
                        allCommandBits.push((pixelValue >> 1) & 1); // Bit 1
                        allCommandBits.push(pixelValue & 1);         // Bit 0

                        pixelIndex++;
                        previousPixelValue = pixelValue;
                    }
                }
            }
        }

        // Pack bits into bytes
        return this.packBitsToBytes(allCommandBits);
    }

    /**
     * Pack array of bits into bytes
     * @param {number[]} bits - Array of bits (0 or 1)
     * @returns {number[]} - Array of packed bytes
     */
    packBitsToBytes(bits) {
        const bytes = [];

        for (let i = 0; i < bits.length; i += 8) {
            let byte = 0;

            // Pack up to 8 bits into this byte
            for (let j = 0; j < 8 && (i + j) < bits.length; j++) {
                const bit = bits[i + j];
                byte |= (bit << (7 - j)); // MSB first
            }

            bytes.push(byte);
        }

        return bytes;
    }

    /**
     * Pack palette assignments into bytes (4 tiles per byte, 2 bits each)
     * @param {number[]} assignments - Array of palette indices (0-3)
     * @returns {number[]} - Array of packed assignment bytes
     */
    packPaletteAssignments(assignments) {
        const bytes = [];

        for (let i = 0; i < assignments.length; i += 4) {
            let byte = 0;

            // Pack 4 tile assignments into 1 byte
            for (let j = 0; j < 4 && (i + j) < assignments.length; j++) {
                const assignment = assignments[i + j] & 0x3; // Ensure 2-bit value
                byte |= (assignment << (6 - j * 2)); // Place in correct bit position
            }

            bytes.push(byte);
        }

        return bytes;
    }

    /**
     * Pack 2-bit values into bytes (4 values per byte)
     * @param {number[]} twoBitData - Array of 2-bit values
     * @returns {number[]} - Array of packed bytes
     */
    pack2BitToBytes(twoBitData) {
        const bytes = [];

        for (let i = 0; i < twoBitData.length; i += 4) {
            let byte = 0;

            // Pack 4 values into 1 byte: [val0][val1][val2][val3]
            // Each value uses 2 bits
            for (let j = 0; j < 4 && (i + j) < twoBitData.length; j++) {
                const value = twoBitData[i + j] & 0x3; // Ensure 2-bit value
                byte |= (value << (6 - j * 2)); // Place in correct bit position
            }

            bytes.push(byte);
        }

        return bytes;
    }

    /**
     * Serialize palettes to bytes
     * @param {Array} palettes - Array of 3-color palettes
     * @returns {number[]} - Serialized palette data
     */
    serializePalettes(palettes) {
        const bytes = [];

        // Always output exactly 4 palettes for fixed size
        // First byte: number of actual palettes used
        bytes.push(palettes.length);

        // Output 4 palettes total (pad with null palettes if needed)
        for (let p = 0; p < 4; p++) {
            const palette = p < palettes.length ? palettes[p] : null;

            if (palette) {
                // Store 3 NES color IDs (or 0xFF for null colors within palette)
                for (let i = 0; i < 3; i++) {
                    if (palette[i] && palette[i].nesId !== undefined) {
                        bytes.push(palette[i].nesId);
                    } else {
                        bytes.push(0xFF); // Null color marker
                    }
                }
            } else {
                // Null palette - all colors are 0xFF
                bytes.push(0xFF);
                bytes.push(0xFF);
                bytes.push(0xFF);
            }
        }

        return bytes;
    }

    /**
     * Generate command header bytes
     * @returns {number[]} - Command header bytes
     */
    generateCommandHeader() {
        const header = [];

        // First byte: command bit width in bits 0-1, unused bits 2-7
        const commandBitWidth = 2; // 2-bit commands can hold 4 commands (0, 1, 2, 3)
        const firstByte = commandBitWidth - 1; // 1→0, 2→1, 3→2, 4→3
        header.push(firstByte);

        // Command list: command index 0, 1, 2 map to different command types
        header.push(this.COMMAND_REPEAT_PIXEL);    // Command 0: repeat pixel with count
        header.push(this.COMMAND_PLOT_PIXEL);      // Command 1: plot single pixel
        header.push(this.COMMAND_PLOT_TWO_PIXELS); // Command 2: plot two pixels

        // Terminate command list
        header.push(0xFF);

        console.log(`Generated command header: ${header.length} bytes, ${commandBitWidth}-bit commands`);
        return header;
    }

    /**
     * Process multiple massive images collectively
     * @param {string[]} filePaths - Array of .massive.png file paths
     * @returns {Promise<Map<string, number[]>>} - Map of filename to compressed bytes
     */
    async processImageCollection(filePaths) {
        const results = new Map();

        for (const filePath of filePaths) {
            const compressedData = await this.processImage(filePath);
            const filename = path.basename(filePath);
            results.set(filename, compressedData);
        }

        return results;
    }

    /**
     * Analyze image for frame sequence information
     * @param {string} filename - Base filename to analyze
     * @returns {object} - Frame information
     */
    analyzeFrameInfo(filename) {
        // TODO: Implement frame detection logic
        // Look for patterns like: monster_01.massive.png, monster_02.massive.png, etc.

        const frameMatch = filename.match(/(.+?)_(\d+)\.massive\.png$/);
        if (frameMatch) {
            return {
                isFrame: true,
                baseName: frameMatch[1],
                frameNumber: parseInt(frameMatch[2], 10)
            };
        }

        return {
            isFrame: false,
            baseName: filename.replace('.massive.png', ''),
            frameNumber: 0
        };
    }
}

// Export for use by data_generator.mjs
export { MassiveCompressor };