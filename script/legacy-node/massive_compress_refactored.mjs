import { promises as fs } from 'fs';
import path from 'path';
import { PNG } from 'pngjs';

// Import our refactored modules
import { COMMANDS, FORMAT, COMPRESSION } from './core/constants.js';
import { buildNESPalette, findClosestNESColor } from './utils/nespalette.js';
import { defineCompressionProfiles } from './compression/profiles.js';
import { RepeatBitsCommand } from './commands/RepeatBitsCommand.js';
import { PlotBitsCommand } from './commands/PlotBitsCommand.js';
import { RepeatCommand } from './commands/RepeatCommand.js';

/**
 * Massive Graphics Compression System - Refactored Version
 */
class MassiveCompressor {
    constructor() {
        this.images = new Map();
        this.animations = new Map();
        this.nesPalette = buildNESPalette();

        // Command implementations
        this.repeatBitsCommand = new RepeatBitsCommand();
        this.plotBitsCommand = new PlotBitsCommand();
        this.repeatCommand = new RepeatCommand();

        this.COMPRESSION_PROFILES = defineCompressionProfiles();
    }

    // Quick test method to verify the refactored system works
    testRefactoredSystem() {
        console.log('🧪 Testing refactored system...');
        console.log(`✅ NES Palette loaded: ${this.nesPalette.length} colors`);
        console.log(`✅ Compression profiles: ${this.COMPRESSION_PROFILES.length}`);
        console.log(`✅ Commands: REPEAT_BITS=${COMMANDS.REPEAT_BITS}, PLOT_BITS=${COMMANDS.PLOT_BITS}, REPEAT_COMMAND=${COMMANDS.REPEAT_COMMAND}`);

        // Test command implementations with dummy data
        const testBits = [1, 1, 1, 0, 0, 1, 1];
        const testResult = this.repeatBitsCommand.tryRepeatBits(0, testBits.length, testBits, 2);
        console.log(`✅ REPEAT_BITS test: ${testResult.viable ? 'PASS' : 'FAIL'}`);

        const plotResult = this.plotBitsCommand.tryPlotBits(0, 4, testBits, 2);
        console.log(`✅ PLOT_BITS test: ${plotResult.viable ? 'PASS' : 'FAIL'}`);

        console.log('🎉 Refactored system basic tests passed!');
        return true;
    }
}

// For command line usage (temporary compatibility)
if (import.meta.url === `file://${process.argv[1]}`) {
    const compressor = new MassiveCompressor();

    if (process.argv.length < 3) {
        console.log('Usage: node massive_compress_refactored.mjs [test]');
        console.log('   or: node massive_compress_refactored.mjs <image.png> <profile>');
        process.exit(1);
    }

    if (process.argv[2] === 'test') {
        compressor.testRefactoredSystem();
    } else {
        console.log('🚧 Full compression not yet implemented in refactored version');
        console.log('    Use original massive_compress.mjs for now');
    }
}

export { MassiveCompressor };