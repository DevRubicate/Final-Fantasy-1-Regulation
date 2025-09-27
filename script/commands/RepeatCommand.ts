/**
 * REPEAT_COMMAND command implementation
 */
import { COMMANDS } from '../core/constants.ts';
import type { CompressionEngine } from '../core/CompressionEngine.ts';

export interface CommandResult {
    viable: boolean;
    bitsUsed: number;
    imageBitsProduced: number;
    debugInfo: string;
    commandData?: any;
}

export class RepeatCommand {
    private COMMAND_REPEAT_BITS = COMMANDS.REPEAT_BITS;
    private COMMAND_PLOT_BITS = COMMANDS.PLOT_BITS_4;
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

        // Must have enough bits for the repeat command itself + following command + data
        if (remainingBits < repeatCommandBits + commandBitWidth + 4) { // minimum following command size
            return {
                viable: false,
                bitsUsed: 0,
                imageBitsProduced: 0,
                debugInfo: `Not enough bits for REPEAT_COMMAND structure`
            };
        }

        const results = [];

        // Try REPEAT_COMMAND with REPEAT_BITS if available
        if (commandToIndex.has(this.COMMAND_REPEAT_BITS)) {
            const result = this.tryRepeatCommandWithFollowing(
                bitPosition, remainingBits, bits, commandBitWidth,
                this.COMMAND_REPEAT_BITS, compressor
            );
            if (result.viable) {
                results.push(result);
            }
        }

        // Try REPEAT_COMMAND with PLOT_BITS variants if available
        for (const plotBitsCommand of [COMMANDS.PLOT_BITS_4, COMMANDS.PLOT_BITS_8, COMMANDS.PLOT_BITS_12]) {
            if (commandToIndex.has(plotBitsCommand)) {
                const result = this.tryRepeatCommandWithFollowing(
                    bitPosition, remainingBits, bits, commandBitWidth,
                    plotBitsCommand, compressor
                );
                if (result.viable) {
                    results.push(result);
                }
            }
        }

        // Return the best result
        if (results.length === 0) {
            return {
                viable: false,
                bitsUsed: 0,
                imageBitsProduced: 0,
                debugInfo: `No viable following commands for REPEAT_COMMAND`
            };
        }

        // Sort by efficiency (lowest ratio = best)
        results.sort((a, b) => {
            const ratioA = a.bitsUsed / a.imageBitsProduced;
            const ratioB = b.bitsUsed / b.imageBitsProduced;
            return ratioA - ratioB;
        });

        return results[0];
    }

    private tryRepeatCommandWithFollowing(
        bitPosition: number,
        remainingBits: number,
        bits: number[],
        commandBitWidth: number,
        followingCommandType: number,
        compressor: CompressionEngine
    ): CommandResult {
        let bestResult: CommandResult = {
            viable: false,
            bitsUsed: 0,
            imageBitsProduced: 0,
            debugInfo: 'No repeating patterns found'
        };

        // Try different repeat counts (2-9)
        for (let repeatCount = 2; repeatCount <= 9; repeatCount++) {
            // Try the following command once to see how many bits it would produce
            let followingCommandResult: CommandResult;

            if (followingCommandType === this.COMMAND_REPEAT_BITS) {
                followingCommandResult = compressor.tryRepeatBits(bitPosition, remainingBits, bits, commandBitWidth);
            } else {
                // PLOT_BITS variants
                followingCommandResult = compressor.tryPlotBits(bitPosition, remainingBits, bits, commandBitWidth, followingCommandType);
            }

            if (!followingCommandResult.viable) {
                continue;
            }

            const patternLength = followingCommandResult.imageBitsProduced;
            const totalBitsNeeded = patternLength * repeatCount;

            if (bitPosition + totalBitsNeeded > bits.length) {
                continue; // Not enough bits for this repeat count
            }

            // Check if the pattern actually repeats
            let matches = true;
            for (let rep = 1; rep < repeatCount; rep++) {
                for (let i = 0; i < patternLength; i++) {
                    const originalBit = bits[bitPosition + i];
                    const repeatBit = bits[bitPosition + rep * patternLength + i];
                    if (originalBit !== repeatBit) {
                        matches = false;
                        break;
                    }
                }
                if (!matches) break;
            }

            if (matches) {
                const repeatCommandBits = commandBitWidth + 3; // REPEAT_COMMAND + 3-bit count
                const followingCommandBits = followingCommandResult.bitsUsed;
                const totalBitsUsed = repeatCommandBits + followingCommandBits;

                const efficiency = totalBitsUsed / totalBitsNeeded;

                if (efficiency < 1.0) { // Only if it actually compresses
                    const result: CommandResult = {
                        viable: true,
                        bitsUsed: totalBitsUsed,
                        imageBitsProduced: totalBitsNeeded,
                        debugInfo: `REPEAT_COMMAND ${repeatCount}x ${followingCommandResult.debugInfo}`,
                        commandData: {
                            repeatCount: repeatCount,
                            followingCommandType: followingCommandType,
                            followingCommandData: followingCommandResult.commandData
                        }
                    };

                    if (!bestResult.viable || efficiency < (bestResult.bitsUsed / bestResult.imageBitsProduced)) {
                        bestResult = result;
                    }
                }
            }
        }

        return bestResult;
    }
}