#!/usr/bin/env -S deno run --allow-read --allow-write

/**
 * Main entry point for the Massive Graphics Compression System (Deno version)
 *
 * Usage: deno run --allow-read --allow-write script/compress.ts <image.png> <profile>
 * Example: deno run --allow-read --allow-write script/compress.ts data/chr/crab.massive.png ENHANCED_REPEAT
 *
 * Or use the task: deno task compress data/chr/crab.massive.png ENHANCED_REPEAT
 */

import { CompressionEngine } from './core/CompressionEngine.ts';

// CLI handling
if (import.meta.main) {
    const engine = new CompressionEngine();

    if (Deno.args.length < 1) {
        console.log('Usage: deno task compress <image.png> <profile>');
        console.log('Profiles: FUNDAMENTAL_BITS, ENHANCED_REPEAT');
        console.log('Example: deno task compress data/chr/crab.massive.png ENHANCED_REPEAT');
        Deno.exit(1);
    }

    const filePath = Deno.args[0];
    const profileName = Deno.args[1] || 'ENHANCED_REPEAT';

    try {
        const result = await engine.processImage(filePath, profileName);
        console.log(`✅ Compression complete: ${result.length} bytes`);
    } catch (error) {
        console.error(`❌ Compression failed:`, error.message);
        Deno.exit(1);
    }
}

// Export for use by other modules
export { CompressionEngine };