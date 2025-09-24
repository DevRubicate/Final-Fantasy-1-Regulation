/**
 * PLOT_BITS command implementation
 */

export class PlotBitsCommand {
    /**
     * Try to use PLOT_BITS command at current position
     * @param {number} bitPosition - Current position in bit stream
     * @param {number} remainingBits - Number of bits remaining from this position
     * @param {number[]} bits - Full bit array
     * @param {number} commandBitWidth - Width of command ID in bits
     * @returns {Object} - {viable, bitsUsed, imageBitsProduced, debugInfo, commandData}
     */
    tryPlotBits(bitPosition, remainingBits, bits, commandBitWidth) {
        // PLOT_BITS can handle any remaining bits (1-4), padding with zeros
        if (remainingBits < 1) {
            return {
                viable: false,
                bitsUsed: 0,
                imageBitsProduced: 0,
                debugInfo: `No image bits remaining`
            };
        }

        // Collect up to 4 bits for the pattern, padding with zeros
        const bitsToProcess = Math.min(4, remainingBits);
        let pattern = '';
        for (let i = 0; i < 4; i++) {
            if (i < bitsToProcess) {
                pattern += bits[bitPosition + i];
            } else {
                pattern += '0'; // Pad with zeros
            }
        }

        const bitsUsed = commandBitWidth + 4; // command + 4-bit pattern

        return {
            viable: true,
            bitsUsed: bitsUsed,
            imageBitsProduced: bitsToProcess, // Only count actual bits processed
            debugInfo: `PLOT_BITS ${pattern}`,
            commandData: {
                pattern: pattern,
                actualBits: bitsToProcess
            }
        };
    }
}