#!/usr/bin/env node

/**
 * Main entry point for the Massive Graphics Compression System
 *
 * Usage: node compress.mjs <image.png> <profile>
 * Example: node compress.mjs data/chr/crab.massive.png ENHANCED_REPEAT
 */

import { CompressionEngine } from './core/CompressionEngine.js';

// CLI handling
if (import.meta.url === `file://${process.argv[1]}`) {
    const engine = new CompressionEngine();

    if (process.argv.length < 3) {
        console.log('Usage: node compress.mjs <image.png> <profile>');
        console.log('Profiles: FUNDAMENTAL_BITS, ENHANCED_REPEAT');
        console.log('Example: node compress.mjs data/chr/crab.massive.png ENHANCED_REPEAT');
        process.exit(1);
    }

    const filePath = process.argv[2];
    const profileName = process.argv[3] || 'ENHANCED_REPEAT';

    try {
        const result = await engine.processImage(filePath, profileName);
        console.log(`✅ Compression complete: ${result.length} bytes`);
    } catch (error) {
        console.error(`❌ Compression failed:`, error.message);
        process.exit(1);
    }
}

// Export for use by other modules
export { CompressionEngine };