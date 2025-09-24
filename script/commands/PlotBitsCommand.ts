/**
 * PLOT_BITS command implementation supporting multiple bit widths
 */
import { COMMANDS } from '../core/constants.ts';

export interface CommandResult {
    viable: boolean;
    bitsUsed: number;
    imageBitsProduced: number;
    debugInfo: string;
    commandData?: {
        bitValue?: number;
        runLength?: number;
        pattern?: string;
        actualBits?: number;
    };
}

export class PlotBitsCommand {
    /**
     * Try to use PLOT_BITS command at current position
     * Detects command type and uses appropriate bit width
     */
    tryPlotBits(bitPosition: number, remainingBits: number, bits: number[], commandBitWidth: number, commandType?: number): CommandResult {
        if (remainingBits < 1) {
            return {
                viable: false,
                bitsUsed: 0,
                imageBitsProduced: 0,
                debugInfo: `No image bits remaining`
            };
        }

        // Determine pattern bit width based on command type
        let patternBitWidth: number;
        let commandName: string;

        if (commandType === COMMANDS.PLOT_BITS_4 || commandType === undefined) {
            patternBitWidth = 4;
            commandName = 'PLOT_BITS_4';
        } else if (commandType === COMMANDS.PLOT_BITS_8) {
            patternBitWidth = 8;
            commandName = 'PLOT_BITS_8';
        } else if (commandType === COMMANDS.PLOT_BITS_12) {
            patternBitWidth = 12;
            commandName = 'PLOT_BITS_12';
        } else {
            // Fallback for legacy PLOT_BITS
            patternBitWidth = 4;
            commandName = 'PLOT_BITS';
        }

        // Collect up to patternBitWidth bits for the pattern, padding with zeros
        const bitsToProcess = Math.min(patternBitWidth, remainingBits);
        let pattern = '';
        for (let i = 0; i < patternBitWidth; i++) {
            if (i < bitsToProcess) {
                pattern += bits[bitPosition + i];
            } else {
                pattern += '0'; // Pad with zeros
            }
        }

        const bitsUsed = commandBitWidth + patternBitWidth; // command + pattern bits

        return {
            viable: true,
            bitsUsed: bitsUsed,
            imageBitsProduced: bitsToProcess, // Only count actual bits processed
            debugInfo: `${commandName} ${pattern}`,
            commandData: {
                pattern: pattern,
                actualBits: bitsToProcess
            }
        };
    }
}