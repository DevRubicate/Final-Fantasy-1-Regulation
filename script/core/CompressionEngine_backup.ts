/**
 * Main compression engine that orchestrates the entire compression process (Deno version)
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

        // TODO: Implement remaining steps
        // STEP 1.5: SPRITE BOUNDS DETECTION
        // STEP 2: TILE EXTRACTION (16x16 for palette analysis)
        // STEP 3: PALETTE ANALYSIS
        // STEP 4: CHR TILE CONVERSION (8x8 for final output)
        // STEP 5: COMPRESSION PROFILE TESTING
        // STEP 6: FINAL OUTPUT GENERATION

        console.log('🚧 Compression engine partially implemented');
        console.log(`📊 Available profiles: ${this.COMPRESSION_PROFILES.map(p => p.name).join(', ')}`);
        console.log(`🎯 Selected profile: ${profileName || 'ENHANCED_REPEAT'}`);

        return new Uint8Array([0x42]); // Placeholder - returns a single test byte
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