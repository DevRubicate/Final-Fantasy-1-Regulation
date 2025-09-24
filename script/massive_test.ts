#!/usr/bin/env -S deno run --allow-read --allow-write

/**
 * Massive Graphics Compression Test Suite (Deno version)
 */

import { PNG } from "pngjs";
import { MassiveCompressor } from './legacy/MassiveCompressor.ts';
import * as path from "https://deno.land/std@0.208.0/path/mod.ts";

interface PixelComparison {
    x: number;
    y: number;
    expected: { r: number; g: number; b: number; a: number };
    actual: { r: number; g: number; b: number; a: number };
}

/**
 * Stateful decoder for command-based compressed data
 */
class MassiveDecoder {
    commandBitWidth = 1; // Default bit width
    commands: number[] = []; // Array of command definitions
    isInitialized = false;

    // Command definitions (should match compressor)
    COMMAND_REPEAT_BITS = 0x00;
    COMMAND_PLOT_BITS = 0x01;
    COMMAND_REPEAT_COMMAND = 0x02;

    constructor() {}

    /**
     * Test the REPEAT_COMMAND decoder with a handcrafted bit stream
     */
    testRepeatCommandDecoder(): boolean {
        console.log('🧪 Testing REPEAT_COMMAND decoder with handcrafted bit stream...');

        // Handcrafted bit stream: REPEAT_COMMAND 2x REPEAT_BITS 0, 3
        // [10][000][00][0][011] = "10000000011" (11 bits)
        // 10 = REPEAT_COMMAND (2-bit)
        // 000 = count 0 = repeat 2 times
        // 00 = REPEAT_BITS (2-bit)
        // 0 = bit value
        // 011 = count 3 = run length 5

        const inputBits = [1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1];
        console.log(`Input bits: ${inputBits.join('')} (${inputBits.length} bits)`);

        // Set up decoder state for 2-bit commands with REPEAT_COMMAND
        this.commandBitWidth = 2;
        this.commands = [this.COMMAND_REPEAT_BITS, this.COMMAND_PLOT_BITS, this.COMMAND_REPEAT_COMMAND];

        try {
            const result = this.decodeBitStreamFromArray(inputBits);
            const resultStr = result.join('');
            const expected = '0000000000'; // 10 zeros (5 zeros × 2 repetitions = 10)

            console.log(`Output bits: ${resultStr} (${result.length} bits)`);
            console.log(`Expected: ${expected} (${expected.length} bits)`);

            const passed = resultStr === expected;
            if (passed) {
                console.log('✅ Test PASSED');
            } else {
                console.log('❌ Test FAILED');
                console.log('🔍 Mismatch details:');
                for (let i = 0; i < Math.max(resultStr.length, expected.length); i++) {
                    const actual = resultStr[i] || '?';
                    const exp = expected[i] || '?';
                    if (actual !== exp) {
                        console.log(`   Position ${i}: expected ${exp}, got ${actual}`);
                        break; // Show first mismatch only
                    }
                }
            }

            return passed;
        } catch (error) {
            console.log('❌ Test FAILED with error:', error.message);
            return false;
        }
    }

    /**
     * Decode a bit stream from an array of bits (for testing)
     */
    decodeBitStreamFromArray(bits: number[]): number[] {
        const decodedBits: number[] = [];
        let bitIndex = 0;

        while (bitIndex < bits.length) {
            // Read command ID
            if (bitIndex + this.commandBitWidth > bits.length) break;

            let commandId = 0;
            for (let i = 0; i < this.commandBitWidth; i++) {
                commandId = (commandId << 1) | bits[bitIndex++];
            }

            console.log(`Read command ID: ${commandId} at bitIndex ${bitIndex - this.commandBitWidth}`);

            if (commandId < this.commands.length && this.commands[commandId] === this.COMMAND_REPEAT_BITS) {
                // REPEAT_BITS: 1 bit value + 3 bit count
                if (bitIndex + 4 > bits.length) break;

                const bitValue = bits[bitIndex++];
                let count = 0;
                for (let i = 0; i < 3; i++) {
                    count = (count << 1) | bits[bitIndex++];
                }
                const repetitions = count + 2;

                console.log(`REPEAT_BITS: value=${bitValue}, count=${repetitions}`);

                for (let i = 0; i < repetitions; i++) {
                    decodedBits.push(bitValue);
                }

            } else if (commandId < this.commands.length && this.commands[commandId] === this.COMMAND_PLOT_BITS) {
                // PLOT_BITS: 4 bit pattern
                if (bitIndex + 4 > bits.length) break;

                for (let i = 0; i < 4; i++) {
                    decodedBits.push(bits[bitIndex++]);
                }

            } else if (commandId < this.commands.length && this.commands[commandId] === this.COMMAND_REPEAT_COMMAND) {
                // REPEAT_COMMAND: 3 bit count + following command
                if (bitIndex + 3 > bits.length) break;

                let count = 0;
                for (let i = 0; i < 3; i++) {
                    count = (count << 1) | bits[bitIndex++];
                }
                const repetitions = count + 2;

                console.log(`REPEAT_COMMAND: repetitions=${repetitions}`);

                // Read the following command
                if (bitIndex + this.commandBitWidth > bits.length) break;
                let followingCommandId = 0;
                for (let i = 0; i < this.commandBitWidth; i++) {
                    followingCommandId = (followingCommandId << 1) | bits[bitIndex++];
                }

                console.log(`Following command ID: ${followingCommandId}`);

                // Read the following command's data once
                let followingCommandOutput: number[] = [];
                if (followingCommandId < this.commands.length && this.commands[followingCommandId] === this.COMMAND_REPEAT_BITS) {
                    if (bitIndex + 4 > bits.length) break;

                    const bitValue = bits[bitIndex++];
                    let followingCount = 0;
                    for (let i = 0; i < 3; i++) {
                        followingCount = (followingCount << 1) | bits[bitIndex++];
                    }
                    const followingRepetitions = followingCount + 2;

                    console.log(`Following REPEAT_BITS: value=${bitValue}, count=${followingRepetitions}`);

                    for (let i = 0; i < followingRepetitions; i++) {
                        followingCommandOutput.push(bitValue);
                    }
                } else {
                    console.log(`❌ Unsupported following command: ${followingCommandId}`);
                    break;
                }

                // Execute repetitions times
                for (let rep = 0; rep < repetitions; rep++) {
                    for (const bit of followingCommandOutput) {
                        decodedBits.push(bit);
                    }
                }

            } else {
                console.log(`❌ Unknown command ID: ${commandId}`);
                break;
            }
        }

        return decodedBits;
    }

    /**
     * Decompress data using the format from compression engine
     */
    decompressData(compressedData: Uint8Array): number[] {
        // The compression engine returns raw bits as bytes
        // Convert bytes back to bits
        const bits: number[] = [];
        for (let i = 0; i < compressedData.length; i++) {
            const byte = compressedData[i];
            for (let bit = 7; bit >= 0; bit--) {
                bits.push((byte >> bit) & 1);
            }
        }
        return bits;
    }

    /**
     * Extract pixel data from PNG for comparison
     */
    extractPixelsFromPNG(png: PNG): number[] {
        const pixels: number[] = [];

        // Convert PNG pixels to the same format as the compression pipeline
        for (let i = 0; i < png.data.length; i += 4) {
            const r = png.data[i];
            const g = png.data[i + 1];
            const b = png.data[i + 2];
            const a = png.data[i + 3];

            // Convert to palette index (same logic as createLinearPixelStream)
            if (a === 0) {
                pixels.push(0); // Transparent
            } else {
                pixels.push(1); // Non-transparent (simple mapping)
            }
        }

        // Convert pixels to bits (2 bits per pixel)
        const bits: number[] = [];
        for (const pixelValue of pixels) {
            bits.push((pixelValue >> 1) & 1); // Bit 1
            bits.push(pixelValue & 1);        // Bit 0
        }

        return bits;
    }

    /**
     * Compare original pixels with decompressed pixels
     */
    comparePixels(originalBits: number[], decompressedBits: number[]): boolean {
        if (originalBits.length !== decompressedBits.length) {
            console.log(`   🔍 Length mismatch: original=${originalBits.length}, decompressed=${decompressedBits.length}`);
            return false;
        }

        let mismatches = 0;
        for (let i = 0; i < originalBits.length; i++) {
            if (originalBits[i] !== decompressedBits[i]) {
                mismatches++;
                if (mismatches <= 5) { // Show first 5 mismatches
                    console.log(`   🔍 Bit mismatch at position ${i}: expected ${originalBits[i]}, got ${decompressedBits[i]}`);
                }
            }
        }

        if (mismatches > 0) {
            console.log(`   🔍 Total mismatches: ${mismatches}/${originalBits.length} bits`);
            return false;
        }

        return true;
    }
}

/**
 * Main test class for running compression/decompression tests
 */
class MassiveTest {
    async runAllTests(): Promise<void> {
        console.log('🧪 Starting Massive Compression Unit Tests');

        try {
            // Find all .massive.png files
            console.log('🔍 Searching for .massive.png files...');
            const massiveFiles = await this.findMassiveFiles();
            console.log(`📁 Search complete. Found files: ${JSON.stringify(massiveFiles)}`);
            console.log(`Found ${massiveFiles.length} massive images to test`);

            const results = {
                passed: 0,
                failed: 0,
                total: massiveFiles.length,
                failures: [] as string[]
            };

            // Test each file
            for (const file of massiveFiles) {
                console.log(`🔄 Testing: ${path.basename(file)}`);
                const success = await this.testSingleFile(file);

                if (success) {
                    results.passed++;
                    console.log(`✅ PASSED: ${path.basename(file)}`);
                } else {
                    results.failed++;
                    results.failures.push(path.basename(file));
                    console.log(`❌ FAILED: ${path.basename(file)}`);
                }
            }

            // Print summary
            this.printTestSummary(results);

        } catch (error) {
            console.error('💥 Test suite failed:', error);
            throw error;
        }
    }

    async findMassiveFiles(): Promise<string[]> {
        const files: string[] = [];

        try {
            await this.searchDirectory('data', files);
        } catch (error) {
            console.error('Error searching for files:', error);
        }

        return files.filter(f => f.endsWith('.massive.png'));
    }

    async searchDirectory(dir: string, files: string[]): Promise<void> {
        try {
            for await (const entry of Deno.readDir(dir)) {
                const fullPath = path.join(dir, entry.name);
                if (entry.isDirectory) {
                    await this.searchDirectory(fullPath, files);
                } else if (entry.isFile && entry.name.endsWith('.massive.png')) {
                    files.push(fullPath);
                }
            }
        } catch (error) {
            // Directory might not exist, that's ok
        }
    }

    async testSingleFile(filePath: string): Promise<boolean> {
        try {
            // Load original image
            const originalPng = await this.loadPNG(filePath);
            console.log(`   📥 Loaded original: ${originalPng.width}x${originalPng.height}`);

            // Compress the image
            const compressor = new MassiveCompressor();
            const compressedData = await compressor.processImage(filePath);
            console.log(`   🗜️  Compressed to: ${compressedData.length} bytes`);

            // Decompress and compare with original
            console.log(`   🔄 Decompressing for verification...`);
            const decoder = new MassiveDecoder();
            const decompressedBits = decoder.decompressData(compressedData);

            // Compare with original
            const originalPixels = this.extractPixelsFromPNG(originalPng);
            const isMatch = this.comparePixels(originalPixels, decompressedBits);

            if (isMatch) {
                console.log(`   ✅ Round-trip test PASSED - pixels match!`);
                return true;
            } else {
                console.log(`   ❌ Round-trip test FAILED - pixel mismatch!`);
                return false;
            }

        } catch (error) {
            console.error(`   ❌ Error testing ${filePath}:`, error);
            return false;
        }
    }

    async loadPNG(filePath: string): Promise<PNG> {
        const buffer = await Deno.readFile(filePath);
        return new Promise((resolve, reject) => {
            const png = new PNG();
            png.parse(buffer, (error, data) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(data);
                }
            });
        });
    }

    printTestSummary(results: { passed: number; failed: number; total: number; failures: string[] }): void {
        console.log('\n📊 Test Summary');
        console.log('================');
        console.log(`✅ Passed: ${results.passed}`);
        console.log(`❌ Failed: ${results.failed}`);
        console.log(`📊 Total: ${results.total}`);

        if (results.failures.length > 0) {
            console.log('\nFailed Tests:');
            for (const failure of results.failures) {
                console.log(`  ❌ ${failure}`);
            }
        }
    }
}

// CLI handling
if (import.meta.main) {
    console.log('🚀 Starting massive test script...');

    const decoder = new MassiveDecoder();
    const testPassed = decoder.testRepeatCommandDecoder();

    if (!testPassed) {
        console.log('❌ Specific test failed, stopping here.');
        Deno.exit(1);
    }

    console.log('✅ Specific test passed, running full tests...');

    try {
        const tester = new MassiveTest();
        await tester.runAllTests();
    } catch (error) {
        console.error('💥 Test script failed:', error);
    }
    console.log('🏁 Test script finished.');
}

// Export for use by other modules
export { MassiveDecoder, MassiveTest };