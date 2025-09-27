/**
 * Complete compression engine that orchestrates the entire compression process (Deno version)
 */
import { ImageProcessor } from './ImageProcessor.ts';
import { buildNESPalette } from '../utils/nespalette.ts';
import { defineCompressionProfiles, expandAllProfiles, type ExpandedCompressionProfile } from '../compression/profiles.ts';
import { COMMANDS } from './constants.ts';
import { RepeatBitsCommand } from '../commands/RepeatBitsCommand.ts';
import { PlotBitsCommand } from '../commands/PlotBitsCommand.ts';
import { RepeatCommand } from '../commands/RepeatCommand.ts';
import type { CommandResult } from '../commands/RepeatBitsCommand.ts';

export class CompressionEngine {
    private nesPalette;
    private imageProcessor;
    private COMPRESSION_PROFILES;
    private repeatBitsCommand;
    private plotBitsCommand;
    private repeatCommand;
    private lastDebugCommands: string[] = [];

    constructor() {
        this.nesPalette = buildNESPalette();
        this.imageProcessor = new ImageProcessor(this.nesPalette);

        // Expand base profiles into all concrete variants
        const baseProfiles = defineCompressionProfiles();
        this.COMPRESSION_PROFILES = expandAllProfiles(baseProfiles);

        // Command implementations
        this.repeatBitsCommand = new RepeatBitsCommand();
        this.plotBitsCommand = new PlotBitsCommand();
        this.repeatCommand = new RepeatCommand();
    }

    /**
     * Main compression method - orchestrates the entire pipeline
     */
    async processImage(filePath: string, profileName?: string): Promise<Uint8Array> {
        // STEP 1: IMAGE PREPARATION
        const pngData = await this.imageProcessor.loadPNG(filePath);
        const originalHasTransparency = this.imageProcessor.hasTransparency(pngData);
        const paddingInfo = this.imageProcessor.validateAndPadImage(pngData);
        const processedImageData = this.imageProcessor.processTransparency(paddingInfo.imageData, originalHasTransparency);

        // STEP 1.5: SPRITE BOUNDS DETECTION
        const spriteBounds = this.imageProcessor.detectSpriteBounds(processedImageData);

        // STEP 2: TILE EXTRACTION (16x16 for palette analysis)
        const tiles16x16 = this.imageProcessor.extractTiles16x16(processedImageData, paddingInfo.padOffsets);

        // STEP 3: PALETTE ANALYSIS
        const paletteAnalysis = this.imageProcessor.analyzePalettes(tiles16x16, this.nesPalette);

        // STEP 4: CHR TILE CONVERSION (8x8 for final output)
        const chrTiles = this.imageProcessor.convertToChrTiles(processedImageData, spriteBounds, paletteAnalysis);

        // Convert CHR tiles to bit stream
        const bitStream = this.chrTilesToBitStream(chrTiles);

        // STEP 5: COMPRESSION PROFILE TESTING
        let bestProfile: ExpandedCompressionProfile | undefined;
        let bestOutputBytes: Uint8Array | undefined;
        let bestDebugCommands: string[] | undefined;

        if (profileName) {
            // Use specific profile if requested
            const selectedProfile = this.COMPRESSION_PROFILES.find(p => p.name === profileName);
            if (!selectedProfile) {
                throw new Error(`Profile not found: ${profileName}`);
            }

            const compressedBits = this.compressBitStream(bitStream, selectedProfile);
            bestProfile = selectedProfile;
            bestOutputBytes = this.bitsToBytes(compressedBits, selectedProfile, spriteBounds, paletteAnalysis);
            bestDebugCommands = [...this.lastDebugCommands];
        } else {
            // Test all profiles and find the best one
            let bestSize = Infinity;
            console.log(`🔍 Testing ${this.COMPRESSION_PROFILES.length} profile variants...`);

            for (const profile of this.COMPRESSION_PROFILES) {
                try {
                    const compressedBits = this.compressBitStream(bitStream, profile);
                    const outputBytes = this.bitsToBytes(compressedBits, profile, spriteBounds, paletteAnalysis);

                    if (outputBytes.length < bestSize) {
                        bestSize = outputBytes.length;
                        bestProfile = profile;
                        bestOutputBytes = outputBytes;
                        bestDebugCommands = [...this.lastDebugCommands];
                    }

                    const compressionRatio = ((bitStream.length / 8 - outputBytes.length) / (bitStream.length / 8) * 100).toFixed(1);
                    console.log(`   ${profile.name}: ${outputBytes.length} bytes (${compressionRatio}% compression)`);
                } catch (error) {
                    console.log(`   ${profile.name}: FAILED - ${error instanceof Error ? error.message : String(error)}`);
                }
            }

            if (!bestProfile || !bestOutputBytes || !bestDebugCommands) {
                throw new Error('No profile succeeded in compressing the data');
            }

            console.log(`🏆 Best profile: ${bestProfile.name}`);
        }

        // Restore debug commands from best profile
        this.lastDebugCommands = bestDebugCommands;

        // STEP 6: FINAL OUTPUT GENERATION
        const originalSizeBytes = bitStream.length / 8; // Convert bits to bytes
        const compressionRatio = ((originalSizeBytes - bestOutputBytes.length) / originalSizeBytes * 100).toFixed(1);

        console.log(`✅ Processed MASSIVE file: ${filePath} -> (${compressionRatio}% compression)`);

        // Write debug output file
        await this.writeDebugOutput(filePath, {
            profileName: bestProfile.name,
            totalSize: bestOutputBytes.length,
            compressionRatio: compressionRatio,
            originalSizeBytes: originalSizeBytes,
            debugCommands: this.lastDebugCommands,
            bitStream: bitStream,
            imageWidth: processedImageData.width,
            imageHeight: processedImageData.height,
            spriteBounds: spriteBounds
        });

        return bestOutputBytes;
    }

    /**
     * Convert CHR tiles to a bit stream using proper NES CHR plane format
     */
    private chrTilesToBitStream(chrTiles: any[]): number[] {
        const bits: number[] = [];

        // Process each tile and convert to CHR plane format
        for (const tile of chrTiles) {
            const pixels = tile.pixels; // Array of 64 pixel values (8x8 tile)

            // Generate plane 0 (low bits) - 8 bytes, one per row
            for (let row = 0; row < 8; row++) {
                let planeByte = 0;
                for (let col = 0; col < 8; col++) {
                    const pixelIndex = row * 8 + col;
                    const pixelValue = pixels[pixelIndex] || 0;
                    const lowBit = pixelValue & 1; // Extract bit 0
                    planeByte |= (lowBit << (7 - col)); // Place bit in correct position
                }
                // Convert byte to 8 individual bits for the bit stream
                for (let bit = 7; bit >= 0; bit--) {
                    bits.push((planeByte >> bit) & 1);
                }
            }

            // Generate plane 1 (high bits) - 8 bytes, one per row
            for (let row = 0; row < 8; row++) {
                let planeByte = 0;
                for (let col = 0; col < 8; col++) {
                    const pixelIndex = row * 8 + col;
                    const pixelValue = pixels[pixelIndex] || 0;
                    const highBit = (pixelValue >> 1) & 1; // Extract bit 1
                    planeByte |= (highBit << (7 - col)); // Place bit in correct position
                }
                // Convert byte to 8 individual bits for the bit stream
                for (let bit = 7; bit >= 0; bit--) {
                    bits.push((planeByte >> bit) & 1);
                }
            }
        }

        return bits;
    }

    /**
     * Compress a bit stream using the selected profile
     */
    private compressBitStream(bits: number[], profile: any): number[] {
        const allCommandBits: number[] = [];
        const debugCommands: string[] = [];

        // Create command-to-index mapping for this profile
        const commandToIndex = new Map<number, number>();
        for (let i = 0; i < profile.commands.length; i++) {
            commandToIndex.set(profile.commands[i], i);
        }

        let bitIndex = 0;
        while (bitIndex < bits.length) {
            const remainingBits = bits.length - bitIndex;

            // Try all available commands and evaluate their efficiency
            const commandOptions: any[] = [];

            // Try REPEAT_BITS if available
            if (commandToIndex.has(COMMANDS.REPEAT_BITS)) {
                const result = this.tryRepeatBits(bitIndex, remainingBits, bits, profile.commandBitWidth);
                if (result.viable) {
                    commandOptions.push({
                        ...result,
                        commandType: COMMANDS.REPEAT_BITS,
                        ratio: result.bitsUsed / result.imageBitsProduced
                    });
                }
            }

            // Try all PLOT_BITS variants if available
            for (const plotBitsCommand of [COMMANDS.PLOT_BITS_4, COMMANDS.PLOT_BITS_8, COMMANDS.PLOT_BITS_12]) {
                if (commandToIndex.has(plotBitsCommand)) {
                    const result = this.tryPlotBits(bitIndex, remainingBits, bits, profile.commandBitWidth, plotBitsCommand);
                    if (result.viable) {
                        commandOptions.push({
                            ...result,
                            commandType: plotBitsCommand,
                            ratio: result.bitsUsed / result.imageBitsProduced
                        });
                    }
                }
            }

            // Try REPEAT_COMMAND if available
            if (commandToIndex.has(COMMANDS.REPEAT_COMMAND)) {
                const result = this.tryRepeatCommand(bitIndex, remainingBits, bits, profile.commandBitWidth, commandToIndex);
                if (result.viable) {
                    commandOptions.push({
                        ...result,
                        commandType: COMMANDS.REPEAT_COMMAND,
                        ratio: result.bitsUsed / result.imageBitsProduced
                    });
                }
            }

            if (commandOptions.length === 0) {
                throw new Error(`No viable commands at bit position ${bitIndex}, ${remainingBits} bits remaining`);
            }

            // Sort by: ratio (ascending), then imageBitsProduced (descending), then command order
            commandOptions.sort((a, b) => {
                if (a.ratio !== b.ratio) return a.ratio - b.ratio;
                if (a.imageBitsProduced !== b.imageBitsProduced) return b.imageBitsProduced - a.imageBitsProduced;
                return a.commandType - b.commandType;
            });

            const selectedCommand = commandOptions[0];

            // Execute the selected command
            const commandId = commandToIndex.get(selectedCommand.commandType);
            this.addCommandToBitQueue(allCommandBits, commandId!, profile.commandBitWidth);

            if (selectedCommand.commandType === COMMANDS.REPEAT_BITS) {
                allCommandBits.push(selectedCommand.commandData.bitValue);
                const count = selectedCommand.commandData.runLength - 2;
                for (let bit = 2; bit >= 0; bit--) {
                    allCommandBits.push((count >> bit) & 1);
                }
            } else if ([COMMANDS.PLOT_BITS_4, COMMANDS.PLOT_BITS_8, COMMANDS.PLOT_BITS_12].includes(selectedCommand.commandType)) {
                // Handle all PLOT_BITS variants in original sequential order
                for (let i = 0; i < selectedCommand.commandData.pattern.length; i++) {
                    allCommandBits.push(parseInt(selectedCommand.commandData.pattern[i]));
                }
            } else if (selectedCommand.commandType === COMMANDS.REPEAT_COMMAND) {
                const count = selectedCommand.commandData.repeatCount - 2;
                for (let bit = 2; bit >= 0; bit--) {
                    allCommandBits.push((count >> bit) & 1);
                }

                // Add the following command's bits
                const followingCommandId = commandToIndex.get(selectedCommand.commandData.followingCommandType);
                this.addCommandToBitQueue(allCommandBits, followingCommandId!, profile.commandBitWidth);

                if (selectedCommand.commandData.followingCommandType === COMMANDS.REPEAT_BITS) {
                    allCommandBits.push(selectedCommand.commandData.followingCommandData.bitValue);
                    const followingCount = selectedCommand.commandData.followingCommandData.runLength - 2;
                    for (let bit = 2; bit >= 0; bit--) {
                        allCommandBits.push((followingCount >> bit) & 1);
                    }
                }
            }

            // Create debug string with bit range format like original MJS
            const endBit = bitIndex + selectedCommand.imageBitsProduced - 1;
            debugCommands.push(`[${String(bitIndex).padStart(5, '0')}-${String(endBit).padStart(5, '0')}] ${selectedCommand.debugInfo}`);
            bitIndex += selectedCommand.imageBitsProduced;
        }

        // Save debug commands for later output
        this.lastDebugCommands = debugCommands;

        return allCommandBits;
    }

    /**
     * Add command bits to the queue in sequential order (MSB-first for multi-bit commands)
     */
    private addCommandToBitQueue(bitQueue: number[], commandId: number, commandBitWidth: number): void {
        for (let bit = commandBitWidth - 1; bit >= 0; bit--) {
            bitQueue.push((commandId >> bit) & 1);
        }
    }

    /**
     * Convert bit stream to byte array
     */
    private bitsToBytes(bits: number[], profile: ExpandedCompressionProfile, spriteBounds: any, paletteAnalysis: any): Uint8Array {
        // Convert compressed bits to bytes using LSB-first (right-to-left) ordering to match ASM header format
        const pixelData = new Uint8Array(Math.ceil(bits.length / 8));
        for (let i = 0; i < bits.length; i++) {
            const byteIndex = Math.floor(i / 8);
            const bitIndex = i % 8;
            if (bits[i]) {
                pixelData[byteIndex] |= (1 << bitIndex);  // LSB-first: bit 0 goes to position 0
            }
        }

        // Generate command header
        const commandHeader = this.generateCommandHeader(profile, spriteBounds);

        // Generate palette assignments (32 bytes - 128 tiles, 4 per byte, 2 bits each)
        const paletteAssignments = this.packPaletteAssignments(paletteAnalysis.assignments);

        // Serialize palette data (13 bytes - count + 4 palettes × 3 colors)
        const paletteData = this.serializePalettes(paletteAnalysis.palettes);

        // Combine all data: header + palette assignments + palette data + compressed pixel data
        const totalLength = commandHeader.length + paletteAssignments.length + paletteData.length + pixelData.length;
        const result = new Uint8Array(totalLength);

        let offset = 0;
        result.set(commandHeader, offset);
        offset += commandHeader.length;
        result.set(paletteAssignments, offset);
        offset += paletteAssignments.length;
        result.set(paletteData, offset);
        offset += paletteData.length;
        result.set(pixelData, offset);

        return result;
    }

    /**
     * Generate command header for profile with clipping info
     */
    private generateCommandHeader(profile: ExpandedCompressionProfile, spriteBounds: any): Uint8Array {
        const header: number[] = [];

        // First byte: 00xxyyyy format
        // xx = command bit width (0-3 representing 1-4 bits)
        // yyyy = number of commands in header (0-15)
        const bitWidthEncoded = profile.commandBitWidth - 1; // 1→0, 2→1, 3→2, 4→3
        const numCommands = profile.commands.length;
        const firstByte = (bitWidthEncoded << 4) | numCommands; // 00xxyyyy
        header.push(firstByte);

        // Extract clipping info from sprite bounds
        // NOTE: Clip values represent how many 8x8 tiles to remove from each edge
        const fullTilesWide = 256 / 8; // 32 tiles
        const fullTilesHigh = 128 / 8;  // 16 tiles
        const contentLeft = spriteBounds.boundingBox.x;
        const contentRight = spriteBounds.boundingBox.x + spriteBounds.boundingBox.width;
        const contentTop = spriteBounds.boundingBox.y;
        const contentBottom = spriteBounds.boundingBox.y + spriteBounds.boundingBox.height;

        const clipInfo = {
            leftClip: Math.floor(contentLeft / 8),   // How many tiles to clip from left
            rightClip: Math.floor((256 - contentRight) / 8),  // How many tiles to clip from right
            topClip: Math.floor(contentTop / 8),     // How many tiles to clip from top
            bottomClip: Math.floor((128 - contentBottom) / 8)  // How many tiles to clip from bottom
        };

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

        return new Uint8Array(header);
    }

    /**
     * Pack palette assignments into bytes (4 assignments per byte, 2 bits each)
     */
    private packPaletteAssignments(assignments: number[]): Uint8Array {
        const bytes: number[] = [];

        for (let i = 0; i < assignments.length; i += 4) {
            let byte = 0;

            // Pack 4 tile assignments into 1 byte
            for (let j = 0; j < 4 && (i + j) < assignments.length; j++) {
                const assignment = assignments[i + j] & 0x3; // Ensure 2-bit value
                byte |= (assignment << (6 - j * 2)); // Place in correct bit position
            }

            bytes.push(byte);
        }

        return new Uint8Array(bytes);
    }

    /**
     * Serialize palettes to bytes (13 bytes total)
     */
    private serializePalettes(palettes: any[]): Uint8Array {
        const bytes: number[] = [];

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

        return new Uint8Array(bytes);
    }

    /**
     * Delegate methods to command implementations
     */
    tryRepeatBits(bitPosition: number, remainingBits: number, bits: number[], commandBitWidth: number): CommandResult {
        return this.repeatBitsCommand.tryRepeatBits(bitPosition, remainingBits, bits, commandBitWidth);
    }

    tryPlotBits(bitPosition: number, remainingBits: number, bits: number[], commandBitWidth: number, commandType?: number): CommandResult {
        return this.plotBitsCommand.tryPlotBits(bitPosition, remainingBits, bits, commandBitWidth, commandType);
    }

    tryRepeatCommand(bitPosition: number, remainingBits: number, bits: number[], commandBitWidth: number, commandToIndex: Map<number, number>): CommandResult {
        return this.repeatCommand.tryRepeatCommand(bitPosition, remainingBits, bits, commandBitWidth, commandToIndex, this);
    }

    /**
     * Write human-readable debug output showing the compression commands
     */
    private async writeDebugOutput(originalFilePath: string, compressionResult: any): Promise<void> {
        try {
            // Generate output file path
            const debugPath = originalFilePath.replace('.massive.png', '.massive.txt');

            // Analyze commands used
            const commandCounts = new Map<string, number>();
            if (this.lastDebugCommands && this.lastDebugCommands.length > 0) {
                for (const command of this.lastDebugCommands) {
                    const parts = command.split(' ');
                    const commandType = parts[1]; // Extract main command type (e.g., "PLOT_BITS_12", "REPEAT_BITS", "REPEAT_COMMAND")
                    commandCounts.set(commandType, (commandCounts.get(commandType) || 0) + 1);

                    // Handle nested commands in REPEAT_COMMAND (e.g., "REPEAT_COMMAND 3x PLOT_BITS_4")
                    if (commandType === 'REPEAT_COMMAND' && parts.length >= 4) {
                        const nestedCommand = parts[3]; // Extract nested command type (e.g., "PLOT_BITS_4")
                        commandCounts.set(nestedCommand, (commandCounts.get(nestedCommand) || 0) + 1);
                    }
                }
            }

            // Build debug content
            const lines: string[] = [];
            lines.push(`// Massive Compression Debug Output`);
            lines.push(`// Original: ${originalFilePath}`);
            lines.push(`// Profile: ${compressionResult.profileName}`);
            lines.push(`// Total size: ${compressionResult.totalSize} bytes`);
            lines.push(`// Original size: ${compressionResult.originalSizeBytes.toFixed(1)} bytes`);
            lines.push(`// Compression ratio: ${compressionResult.compressionRatio}%`);
            lines.push(`// Commands: ${this.lastDebugCommands ? this.lastDebugCommands.length : 0}`);

            // Add command breakdown
            if (commandCounts.size > 0) {
                const commandBreakdown = Array.from(commandCounts.entries())
                    .sort((a, b) => b[1] - a[1]) // Sort by count descending
                    .map(([cmd, count]) => `${cmd}(${count})`)
                    .join(', ');
                lines.push(`// Command types: ${commandBreakdown}`);
            }

            lines.push('');

            // Add clipping information and ASCII bit representation
            if (compressionResult.bitStream && compressionResult.imageWidth && compressionResult.imageHeight && compressionResult.spriteBounds) {
                // Calculate clipping values
                const contentLeft = compressionResult.spriteBounds.boundingBox.x;
                const contentRight = compressionResult.spriteBounds.boundingBox.x + compressionResult.spriteBounds.boundingBox.width;
                const contentTop = compressionResult.spriteBounds.boundingBox.y;
                const contentBottom = compressionResult.spriteBounds.boundingBox.y + compressionResult.spriteBounds.boundingBox.height;

                const clipInfo = {
                    leftClip: Math.floor(contentLeft / 8),
                    rightClip: Math.floor((256 - contentRight) / 8),
                    topClip: Math.floor(contentTop / 8),
                    bottomClip: Math.floor((128 - contentBottom) / 8)
                };

                lines.push(`// Clipping: Left=${clipInfo.leftClip}, Right=${clipInfo.rightClip}, Top=${clipInfo.topClip}, Bottom=${clipInfo.bottomClip} (tiles to remove from each edge)`);
                lines.push(`// Hex Byte Representation (${compressionResult.bitStream.length} bits total)`);
                lines.push(`// Image: ${compressionResult.imageWidth}x${compressionResult.imageHeight}, Clipped area: ${compressionResult.spriteBounds.boundingBox.width}x${compressionResult.spriteBounds.boundingBox.height}`);
                lines.push('');

                // Convert bit stream to hex bytes
                const hexBytes: string[] = [];
                for (let i = 0; i < compressionResult.bitStream.length; i += 8) {
                    let byte = 0;
                    for (let j = 0; j < 8 && (i + j) < compressionResult.bitStream.length; j++) {
                        if (compressionResult.bitStream[i + j]) {
                            byte |= (1 << (7 - j));
                        }
                    }
                    hexBytes.push(`$${byte.toString(16).padStart(2, '0').toUpperCase()}`);
                }

                // Output hex bytes with spaces between them, 16 bytes per line
                for (let i = 0; i < hexBytes.length; i += 16) {
                    const lineBytes = hexBytes.slice(i, i + 16);
                    lines.push(lineBytes.join(' '));
                }
                lines.push('');

                // Add separate plane visualizations (commented out for file size)
                // lines.push('// Plane 1 (High Bit):');
                // const plane1Bits = [];
                // const plane2Bits = [];

                // // Separate the interleaved bit stream back into individual planes
                // for (let i = 0; i < compressionResult.bitStream.length; i += 2) {
                //     plane1Bits.push(compressionResult.bitStream[i] || 0);     // High bit
                //     plane2Bits.push(compressionResult.bitStream[i + 1] || 0); // Low bit
                // }

                // // Generate Plane 1 visualization (high bits)
                // const pixelsPerRow = clippedWidth;
                // for (let row = 0; row < clippedHeight; row++) {
                //     const startPixel = row * pixelsPerRow;
                //     const endPixel = Math.min(startPixel + pixelsPerRow, plane1Bits.length);

                //     let rowString = '';
                //     for (let pixel = startPixel; pixel < endPixel; pixel++) {
                //         rowString += plane1Bits[pixel];
                //     }

                //     // Add padding if needed
                //     while (rowString.length < pixelsPerRow) {
                //         rowString += '0';
                //     }

                //     lines.push(rowString);
                // }

                // lines.push('');
                // lines.push('// Plane 2 (Low Bit):');

                // // Generate Plane 2 visualization (low bits)
                // for (let row = 0; row < clippedHeight; row++) {
                //     const startPixel = row * pixelsPerRow;
                //     const endPixel = Math.min(startPixel + pixelsPerRow, plane2Bits.length);

                //     let rowString = '';
                //     for (let pixel = startPixel; pixel < endPixel; pixel++) {
                //         rowString += plane2Bits[pixel];
                //     }

                //     // Add padding if needed
                //     while (rowString.length < pixelsPerRow) {
                //         rowString += '0';
                //     }

                //     lines.push(rowString);
                // }

                // lines.push('');
                lines.push('// Command Analysis:');
            }

            if (this.lastDebugCommands && this.lastDebugCommands.length > 0) {
                this.lastDebugCommands.forEach((command) => {
                    lines.push(command);
                });
            } else {
                lines.push('// No debug commands available');
            }

            // Write to file
            await Deno.writeTextFile(debugPath, lines.join('\n'));

        } catch (error) {
            console.warn(`   ⚠️  Failed to write debug output: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
}