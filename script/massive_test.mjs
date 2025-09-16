import { promises as fs } from 'fs';
import path from 'path';
import { PNG } from 'pngjs';
import { MassiveCompressor } from './massive_compress.mjs';

/**
 * Stateful decoder for command-based compressed data
 * Maintains global state for command configuration across frame sequences
 */
class MassiveDecoder {
    constructor() {
        this.commandBitWidth = 1; // Default bit width
        this.commands = []; // Array of command definitions
        this.isInitialized = false;

        // Command definitions (should match compressor)
        this.COMMAND_PLOT_PIXEL = 0x00;
        this.COMMAND_REPEAT_PIXEL = 0x01;
        this.COMMAND_PLOT_TWO_PIXELS = 0x02;
    }

    /**
     * Parse header and update global state
     * @param {number[]} compressedBytes - Full compressed data
     * @returns {number} - Header size in bytes
     */
    parseAndSetHeader(compressedBytes) {
        if (compressedBytes.length < 3) {
            throw new Error('Compressed data too small for header');
        }

        // Parse first byte: command bit width in bits 0-1
        const firstByte = compressedBytes[0];
        this.commandBitWidth = (firstByte & 0x3) + 1; // Extract bits 0-1, add 1
        const unusedBits = firstByte >> 2; // Bits 2-7 (should be 0 for now)

        // Parse command list and update global state
        this.commands = [];
        let byteIndex = 1;

        while (byteIndex < compressedBytes.length) {
            const commandByte = compressedBytes[byteIndex];
            if (commandByte === 0xFF) {
                // Terminator found
                byteIndex++;
                break;
            }
            this.commands.push(commandByte);
            byteIndex++;
        }

        if (byteIndex >= compressedBytes.length && compressedBytes[byteIndex - 1] !== 0xFF) {
            throw new Error('Command header not properly terminated with 0xFF');
        }

        this.isInitialized = true;

        console.log(`   📋 Decoder state: ${this.commandBitWidth}-bit commands, ${this.commands.length} commands defined`);

        return byteIndex; // Header size
    }

    /**
     * Decode command-based pixel data using current state
     * @param {number[]} pixelBytes - Encoded pixel data bytes
     * @returns {number[]} - Array of 2-bit pixel values
     */
    decodePixelData(pixelBytes) {
        if (!this.isInitialized) {
            throw new Error('Decoder not initialized - must parse header first');
        }

        const bits = this.unpackBytesToBits(pixelBytes);
        const pixelValues = [];
        let lastPixelValue = 0; // Track last pixel for repeat command

        let bitIndex = 0;
        while (bitIndex < bits.length) {
            // Read command bits
            if (bitIndex + this.commandBitWidth > bits.length) break;

            let commandId = 0;
            for (let i = 0; i < this.commandBitWidth; i++) {
                commandId = (commandId << 1) | bits[bitIndex++];
            }

            // Process command based on global state
            if (commandId < this.commands.length && this.commands[commandId] === this.COMMAND_PLOT_PIXEL) {
                // Plot single pixel - read 2 more bits
                if (bitIndex + 2 > bits.length) break;

                let pixelValue = 0;
                pixelValue = (pixelValue << 1) | bits[bitIndex++]; // Bit 1
                pixelValue = (pixelValue << 1) | bits[bitIndex++]; // Bit 0

                pixelValues.push(pixelValue);
                lastPixelValue = pixelValue;
            } else if (commandId < this.commands.length && this.commands[commandId] === this.COMMAND_REPEAT_PIXEL) {
                // Plot pixel and repeat X times - read 2-bit pixel + 4-bit repeat count
                if (bitIndex + 6 > bits.length) break;

                // Read pixel data (2 bits)
                let pixelValue = 0;
                pixelValue = (pixelValue << 1) | bits[bitIndex++]; // Bit 1
                pixelValue = (pixelValue << 1) | bits[bitIndex++]; // Bit 0

                // Read repeat count (4 bits)
                let repeatCount = 0;
                for (let i = 0; i < 4; i++) {
                    repeatCount = (repeatCount << 1) | bits[bitIndex++];
                }

                // Plot the pixel once, then repeat it repeatCount additional times
                pixelValues.push(pixelValue);
                for (let i = 0; i < repeatCount; i++) {
                    pixelValues.push(pixelValue);
                }

                lastPixelValue = pixelValue;
            } else if (commandId < this.commands.length && this.commands[commandId] === this.COMMAND_PLOT_TWO_PIXELS) {
                // Plot two pixels - read 4 more bits
                if (bitIndex + 4 > bits.length) break;

                // Read first pixel (2 bits)
                let firstPixelValue = 0;
                firstPixelValue = (firstPixelValue << 1) | bits[bitIndex++]; // Bit 1
                firstPixelValue = (firstPixelValue << 1) | bits[bitIndex++]; // Bit 0

                // Read second pixel (2 bits)
                let secondPixelValue = 0;
                secondPixelValue = (secondPixelValue << 1) | bits[bitIndex++]; // Bit 1
                secondPixelValue = (secondPixelValue << 1) | bits[bitIndex++]; // Bit 0

                pixelValues.push(firstPixelValue);
                pixelValues.push(secondPixelValue);
                lastPixelValue = secondPixelValue;
            } else {
                throw new Error(`Unknown or unimplemented command ID: ${commandId} (available commands: ${this.commands.join(', ')})`);
            }
        }

        return pixelValues;
    }

    /**
     * Unpack bytes into individual bits
     * @param {number[]} bytes - Array of bytes
     * @returns {number[]} - Array of bits (0 or 1)
     */
    unpackBytesToBits(bytes) {
        const bits = [];

        for (const byte of bytes) {
            // Extract 8 bits from each byte (MSB first)
            for (let i = 7; i >= 0; i--) {
                bits.push((byte >> i) & 1);
            }
        }

        return bits;
    }

    /**
     * Reset decoder state (useful for testing multiple images)
     */
    reset() {
        this.commandBitWidth = 1;
        this.commands = [];
        this.isInitialized = false;
    }
}

/**
 * Unit test system for massive compression
 * Tests compression -> decompression -> comparison roundtrip
 */
class MassiveTest {
    constructor() {
        this.compressor = new MassiveCompressor();
        this.decoder = new MassiveDecoder();
        this.testResults = [];
    }

    /**
     * Run all tests on massive images
     */
    async runAllTests() {
        console.log('🧪 Starting Massive Compression Unit Tests\n');

        const massiveFiles = await this.findMassiveImages();
        console.log(`Found ${massiveFiles.length} massive images to test\n`);

        for (const filePath of massiveFiles) {
            try {
                await this.testRoundtrip(filePath);
            } catch (error) {
                this.testResults.push({
                    file: filePath,
                    passed: false,
                    error: error.message
                });
                console.log(`❌ FAILED: ${path.basename(filePath)} - ${error.message}\n`);
            }
        }

        this.printSummary();
    }

    /**
     * Find all .massive.png files
     */
    async findMassiveImages() {
        const massiveFiles = [];
        console.log('🔍 Searching for .massive.png files...');
        await this.searchDirectory('data/', massiveFiles);
        console.log(`📁 Search complete. Found files:`, massiveFiles);
        return massiveFiles;
    }

    async searchDirectory(directory, files) {
        try {
            const entries = await fs.readdir(directory, { withFileTypes: true });
            for (const entry of entries) {
                const entryPath = path.join(directory, entry.name);
                if (entry.isDirectory()) {
                    await this.searchDirectory(entryPath, files);
                } else if (entry.isFile() && entry.name.endsWith('.massive.png')) {
                    files.push(entryPath);
                }
            }
        } catch (err) {
            // Directory might not exist, ignore
        }
    }

    /**
     * Test compression -> decompression roundtrip for one file
     */
    async testRoundtrip(filePath) {
        const fileName = path.basename(filePath);
        console.log(`🔄 Testing: ${fileName}`);

        // Step 1: Load original image
        const originalImage = await this.loadPNG(filePath);
        console.log(`   📥 Loaded original: ${originalImage.width}x${originalImage.height}`);

        // Step 2: Process image the same way compression does (for fair comparison)
        const processedImage = await this.preprocessImageForComparison(originalImage);

        // Step 3: Compress
        const compressedBytes = await this.compressor.processImage(filePath);
        console.log(`   🗜️  Compressed to: ${compressedBytes.length} bytes`);

        // Step 4: Decompress
        const decompressedImage = await this.decompressImage(compressedBytes, originalImage.width, originalImage.height);
        console.log(`   📤 Decompressed to: ${decompressedImage.width}x${decompressedImage.height}`);

        // Step 5: Compare processed vs decompressed (fair comparison)
        const isIdentical = this.compareImages(processedImage, decompressedImage);

        if (isIdentical) {
            console.log(`   ✅ PASSED: Images are identical\n`);
            this.testResults.push({
                file: filePath,
                passed: true,
                originalSize: originalImage.width * originalImage.height * 4,
                compressedSize: compressedBytes.length,
                compressionRatio: ((originalImage.width * originalImage.height * 4) / compressedBytes.length).toFixed(2)
            });
        } else {
            throw new Error('Decompressed image does not match original');
        }
    }

    /**
     * Load PNG file
     */
    async loadPNG(filePath) {
        const buffer = await fs.readFile(filePath);
        return new Promise((resolve, reject) => {
            const png = new PNG();
            png.parse(buffer, (error, data) => {
                if (error) reject(error);
                else resolve(data);
            });
        });
    }

    /**
     * Decompress CHR bytes back into image data
     */
    async decompressImage(compressedBytes, originalWidth, originalHeight) {
        console.log(`   🔧 Decompressing ${compressedBytes.length} bytes to ${originalWidth}x${originalHeight} image`);

        let offset = 0;

        // Parse header
        const commandBitWidth = (compressedBytes[offset] & 0x3) + 1;
        offset++;

        // Skip command definitions until 0xFF terminator
        while (offset < compressedBytes.length && compressedBytes[offset] !== 0xFF) {
            offset++;
        }
        if (offset < compressedBytes.length) offset++; // Skip 0xFF terminator

        console.log(`   📋 Header parsed, ${commandBitWidth}-bit commands, CHR data starts at offset ${offset}`);

        // Parse palette assignments (32 bytes = 128 assignments, 4 per byte)
        const paletteAssignmentSize = 32;
        const paletteAssignmentBytes = compressedBytes.slice(offset, offset + paletteAssignmentSize);
        offset += paletteAssignmentSize;

        const paletteAssignments = this.unpack2BitData(paletteAssignmentBytes);
        console.log(`   🎨 Parsed ${paletteAssignments.length} palette assignments`);

        // Parse palette data (13 bytes = 1 count + 4 palettes × 3 colors)
        const paletteDataSize = 13;
        const paletteData = compressedBytes.slice(offset, offset + paletteDataSize);
        offset += paletteDataSize;

        const palettes = this.deserializePalettes(paletteData);
        console.log(`   🌈 Parsed ${palettes.length} palettes`);

        // Remaining data is compressed pixel data (using original command system)
        const pixelBytes = compressedBytes.slice(offset);
        console.log(`   📊 Pixel data: ${pixelBytes.length} bytes (compressed)`);

        // Reset decoder and parse header
        this.decoder.reset();
        this.decoder.parseAndSetHeader(compressedBytes);

        // Decode pixel data using the original command system
        const pixelValues = this.decoder.decodePixelData(pixelBytes);
        console.log(`   🔢 Decoded ${pixelValues.length} pixel values`);

        // Convert pixel values back to image
        return this.pixelValuesToImage(pixelValues, palettes, paletteAssignments, originalWidth, originalHeight);
    }

    /**
     * Convert linear pixel values back to RGBA image (using original method)
     * @param {Array} pixelValues - Array of 2-bit pixel values (0-3)
     * @param {Array} palettes - Color palettes
     * @param {Array} paletteAssignments - Palette assignments for each 16x16 mega-tile
     * @param {number} originalWidth - Original image width
     * @param {number} originalHeight - Original image height
     * @returns {Object} - Image data with width, height, data
     */
    pixelValuesToImage(pixelValues, palettes, paletteAssignments, originalWidth, originalHeight) {
        console.log(`   🖼️  Converting ${pixelValues.length} pixel values to ${originalWidth}x${originalHeight} image`);

        // Create 256x128 image buffer
        const imageData = Buffer.alloc(256 * 128 * 4); // RGBA
        imageData.fill(0); // Initialize to transparent

        const chrTilesWide = 32; // 256 / 8 (8x8 CHR tiles)
        const chrTilesHigh = 16;  // 128 / 8
        const expectedPixels = 256 * 128; // 32,768 pixels

        console.log(`   🔢 Processing ${Math.min(expectedPixels, pixelValues.length)} pixels in 8x8 tile order`);

        let pixelIndex = 0;

        // Process pixels in 8x8 tile order (matching compression input)
        for (let tileIndex = 0; tileIndex < chrTilesWide * chrTilesHigh; tileIndex++) {
            const tileX = tileIndex % chrTilesWide;
            const tileY = Math.floor(tileIndex / chrTilesWide);

            // Determine which 16x16 mega-tile this 8x8 tile belongs to (for palette lookup)
            const megaTileX = Math.floor(tileX / 2);
            const megaTileY = Math.floor(tileY / 2);
            const megaTileIndex = megaTileY * 16 + megaTileX; // 16 mega-tiles wide

            const paletteIndex = paletteAssignments[megaTileIndex];
            const palette = palettes[paletteIndex];

            if (!palette) {
                console.warn(`   ⚠️  Missing palette ${paletteIndex} for CHR tile ${tileIndex}, skipping`);
                pixelIndex += 64; // Skip this tile's pixels
                continue;
            }

            // Process 8x8 tile
            for (let y = 0; y < 8; y++) {
                for (let x = 0; x < 8; x++) {
                    if (pixelIndex >= pixelValues.length) break;

                    const pixelValue = pixelValues[pixelIndex];
                    const globalX = tileX * 8 + x;
                    const globalY = tileY * 8 + y;
                    const imageIdx = (globalY * 256 + globalX) * 4;

                    if (imageIdx >= imageData.length) {
                        pixelIndex++;
                        continue;
                    }

                    // Convert pixel value to RGBA
                    if (pixelValue === 0) {
                        // Transparent
                        imageData[imageIdx] = 0;     // R
                        imageData[imageIdx + 1] = 0; // G
                        imageData[imageIdx + 2] = 0; // B
                        imageData[imageIdx + 3] = 0; // A
                    } else {
                        // Get color from palette (inverted mapping: 1→darkest, 3→brightest)
                        const palettePos = 3 - pixelValue; // 1→2, 2→1, 3→0
                        const color = palette[palettePos];

                        if (color) {
                            imageData[imageIdx] = color.r;     // R
                            imageData[imageIdx + 1] = color.g; // G
                            imageData[imageIdx + 2] = color.b; // B
                            imageData[imageIdx + 3] = 255;     // A
                        } else {
                            // Fallback to magenta for debugging
                            imageData[imageIdx] = 255;     // R
                            imageData[imageIdx + 1] = 0;   // G
                            imageData[imageIdx + 2] = 255; // B
                            imageData[imageIdx + 3] = 255; // A
                        }
                    }

                    pixelIndex++;
                }
            }
        }

        // Extract original image area (remove padding)
        const padWidth = Math.floor((256 - originalWidth) / 2);
        const padHeight = Math.floor((128 - originalHeight) / 2);

        const originalImageData = Buffer.alloc(originalWidth * originalHeight * 4);

        for (let y = 0; y < originalHeight; y++) {
            for (let x = 0; x < originalWidth; x++) {
                const srcX = x + padWidth;
                const srcY = y + padHeight;

                if (srcX >= 0 && srcX < 256 && srcY >= 0 && srcY < 128) {
                    const srcIdx = (srcY * 256 + srcX) * 4;
                    const dstIdx = (y * originalWidth + x) * 4;

                    originalImageData[dstIdx] = imageData[srcIdx];         // R
                    originalImageData[dstIdx + 1] = imageData[srcIdx + 1]; // G
                    originalImageData[dstIdx + 2] = imageData[srcIdx + 2]; // B
                    originalImageData[dstIdx + 3] = imageData[srcIdx + 3]; // A
                }
            }
        }

        console.log(`   ✅ Pixel values to image conversion complete`);

        return {
            width: originalWidth,
            height: originalHeight,
            data: originalImageData
        };
    }

    /**
     * Convert CHR data back to RGBA image (UNUSED - kept for reference)
     * @param {number[]} chrData - Interleaved CHR bytes (PlaneA, PlaneB, PlaneA, PlaneB...)
     * @param {Array} palettes - Color palettes
     * @param {Array} paletteAssignments - Palette assignments for each 16x16 mega-tile
     * @param {number} originalWidth - Original image width
     * @param {number} originalHeight - Original image height
     * @returns {Object} - Image data with width, height, data
     */
    chrToImage(chrData, palettes, paletteAssignments, originalWidth, originalHeight) {
        console.log(`   🖼️  Converting CHR to image: ${chrData.length} bytes → ${originalWidth}x${originalHeight}`);

        // Create 256x128 image buffer
        const imageData = Buffer.alloc(256 * 128 * 4); // RGBA
        imageData.fill(0); // Initialize to transparent

        const chrTilesWide = 32; // 256 / 8 (8x8 CHR tiles)
        const chrTilesHigh = 16; // 128 / 8
        const expectedTiles = chrTilesWide * chrTilesHigh; // 512 tiles

        const availableTiles = Math.floor(chrData.length / 16);
        console.log(`   🔢 Processing ${Math.min(expectedTiles, availableTiles)} CHR tiles`);

        // Process each 8x8 CHR tile
        for (let tileIndex = 0; tileIndex < Math.min(expectedTiles, availableTiles); tileIndex++) {
            const tileX = tileIndex % chrTilesWide;
            const tileY = Math.floor(tileIndex / chrTilesWide);

            // Get CHR data for this tile (16 bytes = 8 bytes plane A + 8 bytes plane B)
            const chrOffset = tileIndex * 16;
            const planeA = chrData.slice(chrOffset, chrOffset + 8);
            const planeB = chrData.slice(chrOffset + 8, chrOffset + 16);

            // Determine which 16x16 mega-tile this 8x8 tile belongs to (for palette lookup)
            const megaTileX = Math.floor(tileX / 2); // 16x16 tiles are 2x2 grid of 8x8 tiles
            const megaTileY = Math.floor(tileY / 2);
            const megaTileIndex = megaTileY * 16 + megaTileX; // 16 mega-tiles wide

            if (megaTileIndex >= paletteAssignments.length) {
                console.warn(`   ⚠️  Mega-tile index ${megaTileIndex} out of range, using palette 0`);
                continue;
            }

            const paletteIndex = paletteAssignments[megaTileIndex];
            const palette = palettes[paletteIndex];

            if (!palette) {
                console.warn(`   ⚠️  Missing palette ${paletteIndex}, using fallback colors`);
                continue;
            }

            // Convert planar data back to pixels
            for (let row = 0; row < 8; row++) {
                const planeAByte = planeA[row] || 0;
                const planeBByte = planeB[row] || 0;

                for (let col = 0; col < 8; col++) {
                    // Extract bits for this pixel (MSB = leftmost pixel)
                    const bit0 = (planeAByte >> (7 - col)) & 1; // Plane A bit
                    const bit1 = (planeBByte >> (7 - col)) & 1; // Plane B bit
                    const pixelValue = bit0 | (bit1 << 1); // Combine to 2-bit value

                    // Calculate global image coordinates
                    const globalX = tileX * 8 + col;
                    const globalY = tileY * 8 + row;
                    const pixelIndex = (globalY * 256 + globalX) * 4;

                    if (pixelIndex >= imageData.length) continue;

                    // Convert pixel value to RGBA
                    if (pixelValue === 0) {
                        // Transparent
                        imageData[pixelIndex] = 0;     // R
                        imageData[pixelIndex + 1] = 0; // G
                        imageData[pixelIndex + 2] = 0; // B
                        imageData[pixelIndex + 3] = 0; // A
                    } else {
                        // Get color from palette (inverted mapping: 1→darkest, 3→brightest)
                        const palettePos = 3 - pixelValue; // 1→2, 2→1, 3→0
                        const color = palette[palettePos];

                        if (color) {
                            imageData[pixelIndex] = color.r;     // R
                            imageData[pixelIndex + 1] = color.g; // G
                            imageData[pixelIndex + 2] = color.b; // B
                            imageData[pixelIndex + 3] = 255;     // A
                        } else {
                            // Fallback to magenta for debugging
                            imageData[pixelIndex] = 255;     // R
                            imageData[pixelIndex + 1] = 0;   // G
                            imageData[pixelIndex + 2] = 255; // B
                            imageData[pixelIndex + 3] = 255; // A
                        }
                    }
                }
            }
        }

        // Extract original image area (remove padding)
        const padWidth = Math.floor((256 - originalWidth) / 2);
        const padHeight = Math.floor((128 - originalHeight) / 2);

        const originalImageData = Buffer.alloc(originalWidth * originalHeight * 4);

        for (let y = 0; y < originalHeight; y++) {
            for (let x = 0; x < originalWidth; x++) {
                const srcX = x + padWidth;
                const srcY = y + padHeight;

                if (srcX >= 0 && srcX < 256 && srcY >= 0 && srcY < 128) {
                    const srcIdx = (srcY * 256 + srcX) * 4;
                    const dstIdx = (y * originalWidth + x) * 4;

                    originalImageData[dstIdx] = imageData[srcIdx];         // R
                    originalImageData[dstIdx + 1] = imageData[srcIdx + 1]; // G
                    originalImageData[dstIdx + 2] = imageData[srcIdx + 2]; // B
                    originalImageData[dstIdx + 3] = imageData[srcIdx + 3]; // A
                }
            }
        }

        console.log(`   ✅ CHR to image conversion complete`);

        return {
            width: originalWidth,
            height: originalHeight,
            data: originalImageData
        };
    }

    /**
     * Unpack 2-bit data from bytes (4 values per byte)
     */
    unpack2BitData(bytes) {
        const values = [];
        for (const byte of bytes) {
            // Extract 4 2-bit values from each byte
            values.push((byte >> 6) & 0x3);  // Bits 7-6
            values.push((byte >> 4) & 0x3);  // Bits 5-4
            values.push((byte >> 2) & 0x3);  // Bits 3-2
            values.push(byte & 0x3);         // Bits 1-0
        }
        return values;
    }

    /**
     * Deserialize palette data from bytes
     */
    deserializePalettes(paletteBytes) {
        if (paletteBytes.length !== 13) {
            throw new Error(`Invalid palette data size. Expected 13 (fixed), got ${paletteBytes.length}`);
        }

        const paletteCount = paletteBytes[0];
        const palettes = [];
        let byteIndex = 1;

        // Always read 4 palettes (fixed format)
        for (let p = 0; p < 4; p++) {
            const palette = [];
            for (let c = 0; c < 3; c++) {
                const nesId = paletteBytes[byteIndex++];
                if (nesId === 0xFF) {
                    palette.push(null); // Null color
                } else {
                    // Find NES color by ID
                    const nesColor = this.nesPalette.find(color => color.id === nesId);
                    if (!nesColor) {
                        throw new Error(`Invalid NES color ID: ${nesId}`);
                    }
                    palette.push(nesColor);
                }
            }
            palettes.push(palette);
        }

        return palettes;
    }

    /**
     * Parse command header from compressed data
     * @param {number[]} compressedBytes - Full compressed data
     * @returns {Object} - Header information
     */
    parseCommandHeader(compressedBytes) {
        if (compressedBytes.length < 3) {
            throw new Error('Compressed data too small for header');
        }

        // Parse first byte: command bit width in bits 0-1
        const firstByte = compressedBytes[0];
        const commandBitWidth = (firstByte & 0x3) + 1; // Extract bits 0-1, add 1 (0→1, 1→2, 2→3, 3→4)
        const unusedBits = firstByte >> 2; // Bits 2-7 (should be 0 for now)

        // Parse command list
        const commands = [];
        let byteIndex = 1;

        while (byteIndex < compressedBytes.length) {
            const commandByte = compressedBytes[byteIndex];
            if (commandByte === 0xFF) {
                // Terminator found
                byteIndex++;
                break;
            }
            commands.push(commandByte);
            byteIndex++;
        }

        if (byteIndex >= compressedBytes.length && compressedBytes[byteIndex - 1] !== 0xFF) {
            throw new Error('Command header not properly terminated with 0xFF');
        }

        return {
            commandBitWidth,
            commands,
            headerSize: byteIndex,
            unusedBits
        };
    }

    /**
     * Get NES palette (should match the one in MassiveCompressor)
     */
    get nesPalette() {
        if (!this._nesPalette) {
            this._nesPalette = [
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
        }
        return this._nesPalette;
    }

    /**
     * Decode command-based pixel data
     * @param {number[]} pixelBytes - Encoded pixel data bytes
     * @param {Object} headerInfo - Command header information
     * @returns {number[]} - Array of 2-bit pixel values
     */
    decodeCommandData(pixelBytes, headerInfo) {
        const bits = this.unpackBytesToBits(pixelBytes);
        const pixelValues = [];
        const commandBitWidth = headerInfo.commandBitWidth;

        let bitIndex = 0;
        while (bitIndex < bits.length) {
            // Read command bits
            if (bitIndex + commandBitWidth > bits.length) break;

            let commandId = 0;
            for (let i = 0; i < commandBitWidth; i++) {
                commandId = (commandId << 1) | bits[bitIndex++];
            }

            // Process command
            if (commandId === 0) {
                // Command 0: "here is one pixel" - read 2 more bits
                if (bitIndex + 2 > bits.length) break;

                let pixelValue = 0;
                pixelValue = (pixelValue << 1) | bits[bitIndex++]; // Bit 1
                pixelValue = (pixelValue << 1) | bits[bitIndex++]; // Bit 0

                pixelValues.push(pixelValue);
            } else {
                throw new Error(`Unknown command ID: ${commandId}`);
            }
        }

        return pixelValues;
    }

    /**
     * Unpack bytes into individual bits
     * @param {number[]} bytes - Array of bytes
     * @returns {number[]} - Array of bits (0 or 1)
     */
    unpackBytesToBits(bytes) {
        const bits = [];

        for (const byte of bytes) {
            // Extract 8 bits from each byte (MSB first)
            for (let i = 7; i >= 0; i--) {
                bits.push((byte >> i) & 1);
            }
        }

        return bits;
    }

    /**
     * Preprocess image the same way the compressor does
     * This includes: padding, transparency conversion, and NES color conversion
     */
    async preprocessImageForComparison(originalImage) {
        // Step 1: Check transparency before padding
        const hasTransparency = this.hasTransparency(originalImage);

        // Step 2: Pad image
        const paddedImage = this.padImage(originalImage);

        // Step 3: Apply transparency conversion
        const transparencyProcessed = this.processTransparency(paddedImage, hasTransparency);

        // Step 4: Convert all colors to NES colors
        const nesProcessed = this.convertToNESColors(transparencyProcessed);

        // Step 5: Extract back to original size
        return this.extractOriginalSize(nesProcessed, originalImage.width, originalImage.height);
    }

    hasTransparency(imageData) {
        for (let i = 3; i < imageData.data.length; i += 4) {
            if (imageData.data[i] === 0) {
                return true;
            }
        }
        return false;
    }

    padImage(originalImage) {
        const { width, height } = originalImage;
        const padWidth = (256 - width) / 2;
        const padHeight = (128 - height) / 2;

        if (width === 256 && height === 128) {
            return originalImage;
        }

        const paddedData = Buffer.alloc(256 * 128 * 4);
        paddedData.fill(0);

        for (let y = 0; y < height; y++) {
            for (let x = 0; x < width; x++) {
                const srcIdx = (width * y + x) * 4;
                const dstX = x + padWidth;
                const dstY = y + padHeight;
                const dstIdx = (256 * dstY + dstX) * 4;

                paddedData[dstIdx] = originalImage.data[srcIdx];
                paddedData[dstIdx + 1] = originalImage.data[srcIdx + 1];
                paddedData[dstIdx + 2] = originalImage.data[srcIdx + 2];
                paddedData[dstIdx + 3] = originalImage.data[srcIdx + 3];
            }
        }

        return { width: 256, height: 128, data: paddedData };
    }

    processTransparency(imageData, originalHasTransparency) {
        if (originalHasTransparency) {
            return imageData;
        }

        const processedData = Buffer.from(imageData.data);

        for (let i = 0; i < processedData.length; i += 4) {
            const r = processedData[i];
            const g = processedData[i + 1];
            const b = processedData[i + 2];

            if (r === 0 && g === 0 && b === 0) {
                processedData[i + 3] = 0; // Set alpha to 0 (transparent)
            }
        }

        return { width: imageData.width, height: imageData.height, data: processedData };
    }

    convertToNESColors(imageData) {
        const processedData = Buffer.from(imageData.data);

        for (let i = 0; i < processedData.length; i += 4) {
            if (processedData[i + 3] === 0) continue; // Skip transparent pixels

            const r = processedData[i];
            const g = processedData[i + 1];
            const b = processedData[i + 2];

            const nesColor = this.findClosestNESColor(r, g, b);
            processedData[i] = nesColor.r;
            processedData[i + 1] = nesColor.g;
            processedData[i + 2] = nesColor.b;
        }

        return { width: imageData.width, height: imageData.height, data: processedData };
    }

    findClosestNESColor(r, g, b) {
        let closestColor = this.nesPalette[0];
        let minDistance = Infinity;

        for (const nesColor of this.nesPalette) {
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

    extractOriginalSize(paddedImage, originalWidth, originalHeight) {
        const padWidth = (256 - originalWidth) / 2;
        const padHeight = (128 - originalHeight) / 2;

        const originalData = Buffer.alloc(originalWidth * originalHeight * 4);

        for (let y = 0; y < originalHeight; y++) {
            for (let x = 0; x < originalWidth; x++) {
                const srcX = x + padWidth;
                const srcY = y + padHeight;
                const srcIdx = (256 * srcY + srcX) * 4;
                const dstIdx = (originalWidth * y + x) * 4;

                originalData[dstIdx] = paddedImage.data[srcIdx];
                originalData[dstIdx + 1] = paddedImage.data[srcIdx + 1];
                originalData[dstIdx + 2] = paddedImage.data[srcIdx + 2];
                originalData[dstIdx + 3] = paddedImage.data[srcIdx + 3];
            }
        }

        return { width: originalWidth, height: originalHeight, data: originalData };
    }

    /**
     * Compare two images for pixel-perfect equality
     */
    compareImages(imageA, imageB) {
        if (imageA.width !== imageB.width || imageA.height !== imageB.height) {
            console.log(`   ❌ Size mismatch: ${imageA.width}x${imageA.height} vs ${imageB.width}x${imageB.height}`);
            return false;
        }

        if (imageA.data.length !== imageB.data.length) {
            console.log(`   ❌ Data length mismatch: ${imageA.data.length} vs ${imageB.data.length}`);
            return false;
        }

        // Compare pixel by pixel - must be exactly identical for lossless compression
        for (let i = 0; i < imageA.data.length; i += 4) {
            const rA = imageA.data[i];
            const gA = imageA.data[i + 1];
            const bA = imageA.data[i + 2];
            const aA = imageA.data[i + 3];

            const rB = imageB.data[i];
            const gB = imageB.data[i + 1];
            const bB = imageB.data[i + 2];
            const aB = imageB.data[i + 3];

            // Check for exact pixel match
            if (rA !== rB || gA !== gB || bA !== bB || aA !== aB) {
                const pixelIndex = i / 4;
                const x = pixelIndex % imageA.width;
                const y = Math.floor(pixelIndex / imageA.width);
                console.log(`   ❌ Pixel mismatch at (${x},${y}): Expected RGBA(${rA},${gA},${bA},${aA}) vs Got RGBA(${rB},${gB},${bB},${aB})`);
                return false;
            }
        }

        return true;
    }

    /**
     * Print test summary
     */
    printSummary() {
        console.log('\n📊 Test Summary');
        console.log('================');

        const passed = this.testResults.filter(r => r.passed).length;
        const failed = this.testResults.filter(r => !r.passed).length;

        console.log(`✅ Passed: ${passed}`);
        console.log(`❌ Failed: ${failed}`);
        console.log(`📊 Total: ${this.testResults.length}\n`);

        if (passed > 0) {
            console.log('Compression Statistics:');
            const passedTests = this.testResults.filter(r => r.passed);
            const avgCompression = passedTests.reduce((sum, t) => sum + parseFloat(t.compressionRatio), 0) / passedTests.length;
            console.log(`Average compression ratio: ${avgCompression.toFixed(2)}:1`);

            passedTests.forEach(test => {
                const fileName = path.basename(test.file);
                console.log(`  ${fileName}: ${test.compressionRatio}:1 (${test.originalSize} → ${test.compressedSize} bytes)`);
            });
        }

        if (failed > 0) {
            console.log('\nFailed Tests:');
            this.testResults.filter(r => !r.passed).forEach(test => {
                console.log(`  ❌ ${path.basename(test.file)}: ${test.error}`);
            });
        }
    }
}

// Export for use by other modules
export { MassiveTest };

// Run tests directly
console.log('🚀 Starting massive test script...');
try {
    const tester = new MassiveTest();
    await tester.runAllTests();
} catch (error) {
    console.error('💥 Test script failed:', error);
}
console.log('🏁 Test script finished.');