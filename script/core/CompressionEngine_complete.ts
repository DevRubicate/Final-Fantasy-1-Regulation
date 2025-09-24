/**
 * Complete compression engine that orchestrates the entire compression process (Deno version)
 */
import { ImageProcessor } from './ImageProcessor.ts';
import { buildNESPalette } from '../utils/nespalette.ts';
import { defineCompressionProfiles } from '../compression/profiles.ts';
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

    constructor() {
        this.nesPalette = buildNESPalette();
        this.imageProcessor = new ImageProcessor(this.nesPalette);
        this.COMPRESSION_PROFILES = defineCompressionProfiles();

        // Command implementations
        this.repeatBitsCommand = new RepeatBitsCommand();
        this.plotBitsCommand = new PlotBitsCommand();
        this.repeatCommand = new RepeatCommand();
    }

    /**
     * Main compression method - orchestrates the entire pipeline
     */
    async processImage(filePath: string, profileName?: string): Promise<Uint8Array> {
        console.log(`Processing massive image: ${filePath}`);

        // STEP 1: IMAGE PREPARATION
        const pngData = await this.imageProcessor.loadPNG(filePath);
        const originalHasTransparency = this.imageProcessor.hasTransparency(pngData);
        const paddingInfo = this.imageProcessor.validateAndPadImage(pngData);
        const processedImageData = this.imageProcessor.processTransparency(paddingInfo.imageData, originalHasTransparency);

        console.log(`✅ Image processing complete: ${processedImageData.width}x${processedImageData.height}`);
        console.log(`   Original transparency: ${originalHasTransparency ? 'Yes' : 'No'}`);
        console.log(`   Padding: L${paddingInfo.padOffsets.left} R${paddingInfo.padOffsets.right} T${paddingInfo.padOffsets.top} B${paddingInfo.padOffsets.bottom}`);

        // STEP 1.5: SPRITE BOUNDS DETECTION
        const spriteBounds = this.imageProcessor.detectSpriteBounds(processedImageData);

        // STEP 2: TILE EXTRACTION (16x16 for palette analysis)
        const tiles16x16 = this.imageProcessor.extractTiles16x16(processedImageData, paddingInfo.padOffsets);

        // STEP 3: PALETTE ANALYSIS
        const paletteAnalysis = this.imageProcessor.analyzePalettes(tiles16x16, this.nesPalette);

        // STEP 4: CHR TILE CONVERSION (8x8 for final output)
        const chrTiles = this.imageProcessor.convertToChrTiles(processedImageData, spriteBounds, paletteAnalysis);

        // STEP 5: COMPRESSION PROFILE TESTING
        console.log(`📊 Available profiles: ${this.COMPRESSION_PROFILES.map(p => p.name).join(', ')}`);
        const selectedProfile = this.COMPRESSION_PROFILES.find(p => p.name === (profileName || 'ENHANCED_REPEAT'));
        if (!selectedProfile) {
            throw new Error(`Profile not found: ${profileName}`);
        }
        console.log(`🎯 Selected profile: ${selectedProfile.name}`);

        // Convert CHR tiles to bit stream
        const bitStream = this.chrTilesToBitStream(chrTiles);
        console.log(`🔢 Generated bit stream: ${bitStream.length} bits`);

        // Compress the bit stream
        const compressedBits = this.compressBitStream(bitStream, selectedProfile);
        console.log(`🗜️ Compressed to: ${compressedBits.length} bits`);

        // STEP 6: FINAL OUTPUT GENERATION
        const outputBytes = this.bitsToBytes(compressedBits);
        console.log(`✅ Compression complete: ${outputBytes.length} bytes`);

        return outputBytes;
    }

    /**
     * Convert CHR tiles to a bit stream
     */
    private chrTilesToBitStream(chrTiles: any[]): number[] {
        // Create linear pixel stream from CHR tiles
        const pixels = this.imageProcessor.createLinearPixelStream(chrTiles);
        console.log(`   📊 Created linear pixel stream: ${pixels.length} pixels from ${chrTiles.length} CHR tiles`);

        // Convert pixels to bits (2 bits per pixel)
        const bits: number[] = [];
        for (const pixelValue of pixels) {
            // Convert 2-bit pixel value to bit stream
            bits.push((pixelValue >> 1) & 1); // Bit 1
            bits.push(pixelValue & 1);        // Bit 0
        }

        console.log(`   🔄 Converting ${pixels.length} pixels to ${bits.length} bits for compression`);
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
            if (commandToIndex.has(0x00)) { // REPEAT_BITS
                const result = this.tryRepeatBits(bitIndex, remainingBits, bits, profile.commandBitWidth);
                if (result.viable) {
                    commandOptions.push({
                        ...result,
                        commandType: 0x00,
                        ratio: result.bitsUsed / result.imageBitsProduced
                    });
                }
            }

            // Try PLOT_BITS if available
            if (commandToIndex.has(0x01)) { // PLOT_BITS
                const result = this.tryPlotBits(bitIndex, remainingBits, bits, profile.commandBitWidth);
                if (result.viable) {
                    commandOptions.push({
                        ...result,
                        commandType: 0x01,
                        ratio: result.bitsUsed / result.imageBitsProduced
                    });
                }
            }

            // Try REPEAT_COMMAND if available
            if (commandToIndex.has(0x02)) { // REPEAT_COMMAND
                const result = this.tryRepeatCommand(bitIndex, remainingBits, bits, profile.commandBitWidth, commandToIndex);
                if (result.viable) {
                    commandOptions.push({
                        ...result,
                        commandType: 0x02,
                        ratio: result.efficiency
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

            if (selectedCommand.commandType === 0x00) { // REPEAT_BITS
                allCommandBits.push(selectedCommand.commandData.bitValue);
                const count = selectedCommand.commandData.runLength - 2;
                for (let bit = 2; bit >= 0; bit--) {
                    allCommandBits.push((count >> bit) & 1);
                }
            } else if (selectedCommand.commandType === 0x01) { // PLOT_BITS
                for (let i = 0; i < 4; i++) {
                    allCommandBits.push(parseInt(selectedCommand.commandData.pattern[i]));
                }
            } else if (selectedCommand.commandType === 0x02) { // REPEAT_COMMAND
                const count = selectedCommand.commandData.repeatCount - 2;
                for (let bit = 2; bit >= 0; bit--) {
                    allCommandBits.push((count >> bit) & 1);
                }

                // Add the following command's bits
                const followingCommandId = commandToIndex.get(selectedCommand.commandData.followingCommandType);
                this.addCommandToBitQueue(allCommandBits, followingCommandId!, profile.commandBitWidth);

                if (selectedCommand.commandData.followingCommandType === 0x00) { // Following REPEAT_BITS
                    allCommandBits.push(selectedCommand.commandData.followingCommandData.bitValue);
                    const followingCount = selectedCommand.commandData.followingCommandData.runLength - 2;
                    for (let bit = 2; bit >= 0; bit--) {
                        allCommandBits.push((followingCount >> bit) & 1);
                    }
                }
            }

            // Create debug string
            debugCommands.push(selectedCommand.debugString || `Command at ${bitIndex}`);
            bitIndex += selectedCommand.imageBitsProduced;
        }

        console.log(`   🗜️ Compressed using ${debugCommands.length} commands`);
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

    tryPlotBits(bitPosition: number, remainingBits: number, bits: number[], commandBitWidth: number): CommandResult {
        return this.plotBitsCommand.tryPlotBits(bitPosition, remainingBits, bits, commandBitWidth);
    }

    tryRepeatCommand(bitPosition: number, remainingBits: number, bits: number[], commandBitWidth: number, commandToIndex: Map<number, number>): CommandResult {
        return this.repeatCommand.tryRepeatCommand(bitPosition, remainingBits, bits, commandBitWidth, commandToIndex, this);
    }
}