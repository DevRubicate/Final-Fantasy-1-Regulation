#!/usr/bin/env node

import { MassiveCompressor } from './script/legacy-node/massive_compress.mjs';

async function main() {
    const compressor = new MassiveCompressor();

    try {
        console.log("🧪 Testing legacy compression on crab image...");
        const result = await compressor.processImage('data/chr/crab.massive.png');
        console.log(`✅ Compression successful: ${result.length} bytes`);

        // Show first few bytes
        const preview = Array.from(result.slice(0, 20)).map(b => `0x${b.toString(16).padStart(2, '0')}`).join(' ');
        console.log(`📊 First 20 bytes: ${preview}`);

    } catch (error) {
        console.error("❌ Compression failed:", error.message);
    }
}

main();