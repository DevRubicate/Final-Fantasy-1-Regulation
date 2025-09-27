#!/usr/bin/env -S deno run --allow-read --allow-write

/**
 * Main entry point for the Massive Graphics Compression System (Deno version)
 *
 * Usage: deno run --allow-read --allow-write script/compress.ts <image.png> <profile>
 * Example: deno run --allow-read --allow-write script/compress.ts data/chr/crab.massive.png STANDARD_A_v1
 *
 * Or use the task: deno task compress data/chr/crab.massive.png STANDARD_A_v1
 */

import { CompressionEngine } from './core/CompressionEngine.ts';

// CLI handling
if (import.meta.main) {
    const engine = new CompressionEngine();

    if (Deno.args.length < 1) {
        console.log('Usage: deno task compress <image.png> [profile]');
        console.log('Profiles: MINIMAL_A_v1-v9, MINIMAL_B_v1-v3, STANDARD_A_v1-v16');
        console.log('Example: deno task compress data/chr/crab.massive.png STANDARD_A_v3');
        console.log('If no profile specified, it will test all profiles and pick the best one.');
        Deno.exit(1);
    }

    const filePath = Deno.args[0];
    const profileName = Deno.args[1]; // Let it auto-select if no profile specified

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