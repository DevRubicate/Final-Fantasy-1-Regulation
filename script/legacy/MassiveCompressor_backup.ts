/**
 * Legacy MassiveCompressor adapter for Deno
 *
 * This temporarily allows using the original Node.js MassiveCompressor from Deno
 * by copying the essential methods. This is a bridge while we complete the full
 * TypeScript refactoring.
 */

import { CompressionEngine } from '../core/CompressionEngine.ts';

export class MassiveCompressor extends CompressionEngine {
    constructor() {
        super();
    }

    // For now, delegate to the new CompressionEngine
    // TODO: Copy the remaining methods from massive_compress.mjs
    async processImage(filePath: string, profileName?: string): Promise<Uint8Array> {
        // Temporary implementation that returns valid placeholder data
        // This allows the build system to work while we complete the migration
        console.log(`🚧 Legacy adapter processing: ${filePath}`);

        const result = await super.processImage(filePath, profileName);

        // Return a valid but minimal compressed data structure
        // Format: [header_size][palette_assignments][palette_data][pixel_data]
        const placeholderData = new Uint8Array([
            0x06, // Header size: 6 bytes
            0x01, // Command bit width: 1
            0x02, // Number of commands: 2
            0x00, // REPEAT_BITS command ID
            0x01, // PLOT_BITS command ID
            0x00, // Padding/reserved
            // Palette assignments (128 bytes of zeros - all use palette 0)
            ...new Array(128).fill(0),
            // Palette data (4 palettes × 4 colors × 3 bytes = 48 bytes)
            ...new Array(48).fill(0),
            // Pixel data (1 byte placeholder)
            0x42
        ]);

        console.log(`   Generated placeholder data: ${placeholderData.length} bytes`);
        return placeholderData;
    }
}