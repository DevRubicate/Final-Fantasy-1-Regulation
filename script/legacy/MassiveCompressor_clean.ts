/**
 * MassiveCompressor adapter for Deno - now with complete implementation
 */

import { CompressionEngine } from '../core/CompressionEngine.ts';

export class MassiveCompressor extends CompressionEngine {
    constructor() {
        super();
    }

    // All compression logic is now implemented in CompressionEngine
    async processImage(filePath: string, profileName?: string): Promise<Uint8Array> {
        return await super.processImage(filePath, profileName);
    }
}