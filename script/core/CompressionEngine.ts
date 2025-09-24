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
        let bestProfile: ExpandedCompressionProfile;
        let bestOutputBytes: Uint8Array;
        let bestDebugCommands: string[];

        if (profileName) {
            // Use specific profile if requested
            const selectedProfile = this.COMPRESSION_PROFILES.find(p => p.name === profileName);
            if (!selectedProfile) {
                throw new Error(`Profile not found: ${profileName}`);
            }

            const compressedBits = this.compressBitStream(bitStream, selectedProfile);
            bestProfile = selectedProfile;
            bestOutputBytes = this.bitsToBytes(compressedBits);
            bestDebugCommands = [...this.lastDebugCommands];
        } else {
            // Test all profiles and find the best one
            let bestSize = Infinity;
            console.log(`🔍 Testing ${this.COMPRESSION_PROFILES.length} profile variants...`);

            for (const profile of this.COMPRESSION_PROFILES) {
                try {
                    const compressedBits = this.compressBitStream(bitStream, profile);
                    const outputBytes = this.bitsToBytes(compressedBits);

                    if (outputBytes.length < bestSize) {
                        bestSize = outputBytes.length;
                        bestProfile = profile;
                        bestOutputBytes = outputBytes;
                        bestDebugCommands = [...this.lastDebugCommands];
                    }

                    const compressionRatio = ((bitStream.length / 8 - outputBytes.length) / (bitStream.length / 8) * 100).toFixed(1);
                    console.log(`   ${profile.name}: ${outputBytes.length} bytes (${compressionRatio}% compression)`);
                } catch (error) {
                    console.log(`   ${profile.name}: FAILED - ${error.message}`);
                }
            }

            if (!bestProfile!) {
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
     * Convert CHR tiles to a bit stream
     */
    private chrTilesToBitStream(chrTiles: any[]): number[] {
        // Create linear pixel stream from CHR tiles
        const pixels = this.imageProcessor.createLinearPixelStream(chrTiles);

        // Convert pixels to bits (2 bits per pixel)
        const bits: number[] = [];
        for (const pixelValue of pixels) {
            // Convert 2-bit pixel value to bit stream
            bits.push((pixelValue >> 1) & 1); // Bit 1
            bits.push(pixelValue & 1);        // Bit 0
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
                // Handle all PLOT_BITS variants
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
     * Add command bits to the queue
     */
    private addCommandToBitQueue(bitQueue: number[], commandId: number, commandBitWidth: number): void {
        for (let bit = commandBitWidth - 1; bit >= 0; bit--) {
            bitQueue.push((commandId >> bit) & 1);
        }
    }

    /**
     * Convert bit stream to byte array
     */
    private bitsToBytes(bits: number[]): Uint8Array {
        const bytes = new Uint8Array(Math.ceil(bits.length / 8));
        for (let i = 0; i < bits.length; i++) {
            const byteIndex = Math.floor(i / 8);
            const bitIndex = i % 8;
            if (bits[i]) {
                bytes[byteIndex] |= (1 << (7 - bitIndex));
            }
        }
        return bytes;
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
                    const commandType = command.split(' ')[1]; // Extract command type (e.g., "PLOT_BITS_12", "REPEAT_BITS")
                    commandCounts.set(commandType, (commandCounts.get(commandType) || 0) + 1);
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

            // Add ASCII bit representation
            if (compressionResult.bitStream && compressionResult.imageWidth && compressionResult.imageHeight && compressionResult.spriteBounds) {
                lines.push(`// ASCII Bit Representation (${compressionResult.bitStream.length} bits total)`);
                lines.push(`// Image: ${compressionResult.imageWidth}x${compressionResult.imageHeight}, Clipped area: ${compressionResult.spriteBounds.boundingBox.width}x${compressionResult.spriteBounds.boundingBox.height}`);
                lines.push('// 0=transparent, 1=bit set');
                lines.push('');

                // Calculate dimensions for the clipped area in bits
                const clippedWidth = compressionResult.spriteBounds.boundingBox.width;
                const clippedHeight = compressionResult.spriteBounds.boundingBox.height;
                const bitsPerPixel = 2; // Each pixel becomes 2 bits
                const totalBitsPerRow = clippedWidth * bitsPerPixel;

                // Generate ASCII representation row by row
                for (let row = 0; row < clippedHeight; row++) {
                    const startBit = row * totalBitsPerRow;
                    const endBit = Math.min(startBit + totalBitsPerRow, compressionResult.bitStream.length);

                    let rowString = '';
                    for (let bit = startBit; bit < endBit; bit++) {
                        rowString += compressionResult.bitStream[bit];
                    }

                    // Add padding if needed
                    while (rowString.length < totalBitsPerRow) {
                        rowString += '0';
                    }

                    lines.push(rowString);
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
            console.warn(`   ⚠️  Failed to write debug output: ${error.message}`);
        }
    }
}