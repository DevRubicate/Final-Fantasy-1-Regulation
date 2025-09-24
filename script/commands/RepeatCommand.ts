/**
 * REPEAT_COMMAND Implementation with debug logging
 */
import { COMMANDS } from '../core/constants.ts';
import type { CommandResult } from './RepeatBitsCommand.ts';

interface CompressionEngine {
    tryRepeatBits(bitPosition: number, remainingBits: number, bits: number[], commandBitWidth: number): CommandResult;
    tryPlotBits(bitPosition: number, remainingBits: number, bits: number[], commandBitWidth: number): CommandResult;
}

export class RepeatCommand {
    private COMMAND_REPEAT_BITS = COMMANDS.REPEAT_BITS;
    private COMMAND_PLOT_BITS = COMMANDS.PLOT_BITS;
    private COMMAND_REPEAT_COMMAND = COMMANDS.REPEAT_COMMAND;

    /**
     * Try to use REPEAT_COMMAND at the given position with extensive debug logging
     */
    tryRepeatCommand(
        bitPosition: number,
        remainingBits: number,
        bits: number[],
        commandBitWidth: number,
        commandToIndex: Map<number, number>,
        compressor: CompressionEngine
    ): CommandResult {
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

        const bestOptions: CommandResult[] = [];

        // Try repeating each available command (except REPEAT_COMMAND itself)
        for (const [commandType, commandIndex] of commandToIndex) {
            if (commandType === this.COMMAND_REPEAT_COMMAND) continue; // No self-repetition

            // PATTERN DISCOVERY PHASE: Find actual maximum viable repeat count
            let maxViableRepeats = 1;
            let currentPos = bitPosition;
            const bitsAfterRepeat = remainingBits - repeatCommandBits;

            // Get the first pattern to match against
            let firstPatternResult: CommandResult;
            if (commandType === this.COMMAND_REPEAT_BITS) {
                firstPatternResult = compressor.tryRepeatBits(bitPosition, bitsAfterRepeat, bits, commandBitWidth);
            } else if (commandType === this.COMMAND_PLOT_BITS) {
                firstPatternResult = compressor.tryPlotBits(bitPosition, bitsAfterRepeat, bits, commandBitWidth);
            } else {
                continue;
            }

            if (!firstPatternResult || !firstPatternResult.viable) {
                continue; // Skip this command type
            }

            currentPos += firstPatternResult.imageBitsProduced;

            // Test how many times this EXACT pattern can be applied consecutively
            while (maxViableRepeats < 9) { // Cap at maximum repeat count
                let testResult: CommandResult;

                if (commandType === this.COMMAND_REPEAT_BITS) {
                    testResult = compressor.tryRepeatBits(currentPos, bits.length - currentPos, bits, commandBitWidth);
                } else if (commandType === this.COMMAND_PLOT_BITS) {
                    testResult = compressor.tryPlotBits(currentPos, bits.length - currentPos, bits, commandBitWidth);
                } else {
                    break;
                }

                if (!testResult || !testResult.viable) {
                    break;
                }

                // Check if this pattern matches the first pattern
                let patternsMatch = false;
                if (commandType === this.COMMAND_REPEAT_BITS) {
                    patternsMatch = (testResult.commandData?.bitValue === firstPatternResult.commandData?.bitValue &&
                                    testResult.commandData?.runLength === firstPatternResult.commandData?.runLength);
                } else if (commandType === this.COMMAND_PLOT_BITS) {
                    patternsMatch = (testResult.commandData?.pattern === firstPatternResult.commandData?.pattern);
                }

                if (!patternsMatch) {
                    break;
                }

                maxViableRepeats++;
                currentPos += testResult.imageBitsProduced;
            }

            // EFFICIENCY EVALUATION PHASE: Only try repeat counts that actually exist
            const maxRepeatCount = Math.min(maxViableRepeats, 9);

            // Only consider repeat counts if we found at least 2 patterns (need repetition to justify REPEAT_COMMAND)
            if (maxRepeatCount < 2) {
                continue; // Skip this command type if no actual repetitions found
            }

            for (let repeatCount = 2; repeatCount <= maxRepeatCount; repeatCount++) {
                // Use the already calculated first pattern result
                const totalBitsUsed = repeatCommandBits + firstPatternResult.bitsUsed;
                const totalImageBitsProduced = firstPatternResult.imageBitsProduced * repeatCount;

                bestOptions.push({
                    viable: true,
                    bitsUsed: totalBitsUsed,
                    imageBitsProduced: totalImageBitsProduced,
                    debugInfo: `REPEAT_COMMAND ${repeatCount}x ${firstPatternResult.debugInfo}`,
                    commandData: {
                        // Store repeat command specific data
                        ...firstPatternResult.commandData
                    }
                });
            }
        }

        // Return the most efficient option
        if (bestOptions.length > 0) {
            const best = bestOptions.reduce((best, current) =>
                (current.bitsUsed / current.imageBitsProduced) < (best.bitsUsed / best.imageBitsProduced) ? current : best
            );
            return best;
        } else {
            return {
                viable: false,
                bitsUsed: 0,
                imageBitsProduced: 0,
                debugInfo: 'No viable commands to repeat'
            };
        }
    }
}