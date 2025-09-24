/**
 * REPEAT_COMMAND Implementation - Extracted for easier debugging
 */

export class RepeatCommand {
    constructor(COMMAND_REPEAT_BITS, COMMAND_PLOT_BITS, COMMAND_REPEAT_COMMAND) {
        this.COMMAND_REPEAT_BITS = COMMAND_REPEAT_BITS;
        this.COMMAND_PLOT_BITS = COMMAND_PLOT_BITS;
        this.COMMAND_REPEAT_COMMAND = COMMAND_REPEAT_COMMAND;
    }

    /**
     * Try to use REPEAT_COMMAND at the given position
     * This is the method extracted from massive_compress.mjs with debug logging added
     */
    tryRepeatCommand(bitPosition, remainingBits, bits, commandBitWidth, commandToIndex, compressor) {
        // REPEAT_COMMAND structure: [command_bits][3_bit_repeat_count]
        const repeatCommandBits = commandBitWidth + 3;

        if (remainingBits < repeatCommandBits) {
            return {
                viable: false,
                bitsUsed: 0,
                imageBitsProduced: 0,
                debugInfo: 'Insufficient bits for REPEAT_COMMAND structure'
            };
        }

        console.log(`\n🔍 REPEAT_COMMAND evaluation at bit position ${bitPosition}`);
        console.log(`   Available bits: ${remainingBits}, needed: ${repeatCommandBits}`);

        const bestOptions = [];

        // Try repeating each available command (except REPEAT_COMMAND itself)
        for (const [commandType, commandIndex] of commandToIndex) {
            if (commandType === this.COMMAND_REPEAT_COMMAND) continue; // No self-repetition

            console.log(`\n   Testing command type: ${commandType}`);

            // PATTERN DISCOVERY PHASE: Find actual maximum viable repeat count
            let maxViableRepeats = 1;
            let currentPos = bitPosition;
            const bitsAfterRepeat = remainingBits - repeatCommandBits;

            // Get the first pattern to match against
            let firstPatternResult;
            if (commandType === this.COMMAND_REPEAT_BITS) {
                firstPatternResult = compressor.tryRepeatBits(bitPosition, bitsAfterRepeat, bits, commandBitWidth);
            } else if (commandType === this.COMMAND_PLOT_BITS) {
                firstPatternResult = compressor.tryPlotBits(bitPosition, bitsAfterRepeat, bits, commandBitWidth);
            }

            if (!firstPatternResult || !firstPatternResult.viable) {
                console.log(`   ❌ First pattern not viable for command ${commandType}`);
                continue; // Skip this command type
            }

            // Debug logging for PLOT_BITS specifically
            if (commandType === this.COMMAND_PLOT_BITS) {
                console.log(`   ✅ First PLOT_BITS pattern found: ${firstPatternResult.commandData.pattern}`);
                console.log(`   Bits consumed: ${firstPatternResult.bitsUsed}, image bits produced: ${firstPatternResult.imageBitsProduced}`);
            }

            currentPos += firstPatternResult.imageBitsProduced;

            // Test how many times this EXACT pattern can be applied consecutively
            while (maxViableRepeats < 9) { // Cap at maximum repeat count
                let testResult;

                if (commandType === this.COMMAND_REPEAT_BITS) {
                    testResult = compressor.tryRepeatBits(currentPos, bits.length - currentPos, bits, commandBitWidth);
                } else if (commandType === this.COMMAND_PLOT_BITS) {
                    testResult = compressor.tryPlotBits(currentPos, bits.length - currentPos, bits, commandBitWidth);
                }

                if (!testResult || !testResult.viable) {
                    console.log(`   🛑 No more patterns at position ${currentPos}`);
                    break;
                }

                // Check if this pattern matches the first pattern
                let patternsMatch = false;
                if (commandType === this.COMMAND_REPEAT_BITS) {
                    patternsMatch = (testResult.commandData.bitValue === firstPatternResult.commandData.bitValue &&
                                    testResult.commandData.runLength === firstPatternResult.commandData.runLength);
                } else if (commandType === this.COMMAND_PLOT_BITS) {
                    patternsMatch = (testResult.commandData.pattern === firstPatternResult.commandData.pattern);
                }

                if (!patternsMatch) {
                    if (commandType === this.COMMAND_PLOT_BITS) {
                        console.log(`   🔄 Pattern mismatch at position ${currentPos}: expected ${firstPatternResult.commandData.pattern}, got ${testResult.commandData.pattern}`);
                    }
                    break;
                }

                // Debug logging for pattern matching
                if (commandType === this.COMMAND_PLOT_BITS) {
                    console.log(`   ✅ Found matching pattern ${testResult.commandData.pattern} at position ${currentPos}`);
                }

                maxViableRepeats++;
                currentPos += testResult.imageBitsProduced;
            }

            // EFFICIENCY EVALUATION PHASE: Only try repeat counts that actually exist
            const maxRepeatCount = Math.min(maxViableRepeats, 9);

            console.log(`   📊 Pattern count: ${maxViableRepeats}, max repeat count: ${maxRepeatCount}`);

            // Only consider repeat counts if we found at least 2 patterns (need repetition to justify REPEAT_COMMAND)
            if (maxRepeatCount < 2) {
                console.log(`   ❌ SKIPPING: Not enough patterns for REPEAT_COMMAND (need >= 2, found ${maxRepeatCount})`);
                continue; // Skip this command type if no actual repetitions found
            }

            console.log(`   ✅ PROCEEDING: Enough patterns for REPEAT_COMMAND`);

            for (let repeatCount = 2; repeatCount <= maxRepeatCount; repeatCount++) {
                // Use the already calculated first pattern result
                const totalBitsUsed = repeatCommandBits + firstPatternResult.bitsUsed;
                const totalImageBitsProduced = firstPatternResult.imageBitsProduced * repeatCount;
                const efficiency = totalBitsUsed / totalImageBitsProduced;

                console.log(`     Option: ${repeatCount}x repeat, efficiency: ${efficiency.toFixed(4)}`);

                bestOptions.push({
                    viable: true,
                    bitsUsed: totalBitsUsed,
                    imageBitsProduced: totalImageBitsProduced,
                    efficiency: efficiency,
                    debugInfo: `REPEAT_COMMAND ${repeatCount}x ${firstPatternResult.debugInfo}`,
                    commandData: {
                        repeatCount: repeatCount,
                        followingCommand: commandType,
                        followingCommandData: firstPatternResult.commandData
                    }
                });
            }
        }

        // Return the most efficient option
        if (bestOptions.length > 0) {
            const best = bestOptions.reduce((best, current) =>
                current.efficiency < best.efficiency ? current : best
            );
            console.log(`🏆 Best option: ${best.debugInfo} (efficiency: ${best.efficiency.toFixed(4)})`);
            return best;
        } else {
            console.log(`❌ No viable REPEAT_COMMAND options found`);
            return {
                viable: false,
                bitsUsed: 0,
                imageBitsProduced: 0,
                debugInfo: 'No viable commands to repeat'
            };
        }
    }
}