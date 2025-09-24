/**
 * Main compression engine that orchestrates the entire compression process
 */
import { ImageProcessor } from './ImageProcessor.js';
import { buildNESPalette } from '../utils/nespalette.js';
import { defineCompressionProfiles } from '../compression/profiles.js';
import { RepeatBitsCommand } from '../commands/RepeatBitsCommand.js';
import { PlotBitsCommand } from '../commands/PlotBitsCommand.js';
import { RepeatCommand } from '../commands/RepeatCommand.js';

export class CompressionEngine {
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
    async processImage(filePath, profileName = null) {
        console.log(`Processing massive image: ${filePath}`);

        // STEP 1: IMAGE PREPARATION
        const pngData = await this.imageProcessor.loadPNG(filePath);
        const originalHasTransparency = this.imageProcessor.hasTransparency(pngData);
        const paddingInfo = this.imageProcessor.validateAndPadImage(pngData);
        const processedImageData = this.imageProcessor.processTransparency(paddingInfo.imageData, originalHasTransparency);

        // TODO: Implement remaining steps
        // STEP 1.5: SPRITE BOUNDS DETECTION
        // STEP 2: TILE EXTRACTION (16x16 for palette analysis)
        // STEP 3: PALETTE ANALYSIS
        // STEP 4: CHR TILE CONVERSION (8x8 for final output)
        // STEP 5: COMPRESSION PROFILE TESTING
        // STEP 6: FINAL OUTPUT GENERATION

        console.log('🚧 Compression engine partially implemented');
        return new Uint8Array([0]); // Placeholder
    }

    /**
     * Delegate methods to command implementations
     */
    tryRepeatBits(bitPosition, remainingBits, bits, commandBitWidth) {
        return this.repeatBitsCommand.tryRepeatBits(bitPosition, remainingBits, bits, commandBitWidth);
    }

    tryPlotBits(bitPosition, remainingBits, bits, commandBitWidth) {
        return this.plotBitsCommand.tryPlotBits(bitPosition, remainingBits, bits, commandBitWidth);
    }

    tryRepeatCommand(bitPosition, remainingBits, bits, commandBitWidth, commandToIndex) {
        return this.repeatCommand.tryRepeatCommand(bitPosition, remainingBits, bits, commandBitWidth, commandToIndex, this);
    }
}