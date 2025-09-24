/**
 * REPEAT_BITS command implementation
 */

export class RepeatBitsCommand {
    /**
     * Try to use REPEAT_BITS command at current position
     * @param {number} bitPosition - Current position in bit stream
     * @param {number} remainingBits - Number of bits remaining from this position
     * @param {number[]} bits - Full bit array
     * @param {number} commandBitWidth - Width of command ID in bits
     * @returns {Object} - {viable, bitsUsed, imageBitsProduced, debugInfo, commandData}
     */
    tryRepeatBits(bitPosition, remainingBits, bits, commandBitWidth) {
        // Check if we have enough bits for the command structure
        const minBitsNeeded = commandBitWidth + 1 + 3; // command + bit_value + 3-bit count
        if (remainingBits < minBitsNeeded) {
            return { viable: false, bitsUsed: 0, imageBitsProduced: 0, debugInfo: 'Insufficient bits for command structure' };
        }

        // Find run of identical bits starting at current position
        const currentBit = bits[bitPosition];
        let runLength = 1;
        while (bitPosition + runLength < bits.length &&
               bits[bitPosition + runLength] === currentBit &&
               runLength < 9) { // Max run length is 9 (111 + 2)
            runLength++;
        }

        // Need at least 2 identical bits to be viable
        if (runLength < 2) {
            return { viable: false, bitsUsed: 0, imageBitsProduced: 0, debugInfo: 'Run too short (< 2 bits)' };
        }

        // Check if we can encode this run length within remaining bits
        const imageBitsConsumed = Math.min(runLength, remainingBits);
        if (imageBitsConsumed < 2) {
            return { viable: false, bitsUsed: 0, imageBitsProduced: 0, debugInfo: 'Not enough remaining bits for viable run' };
        }

        // Calculate actual command cost
        const bitsUsed = commandBitWidth + 1 + 3; // command + bit_value + count

        return {
            viable: true,
            bitsUsed: bitsUsed,
            imageBitsProduced: imageBitsConsumed,
            debugInfo: `REPEAT_BITS ${currentBit}, ${imageBitsConsumed}`,
            commandData: {
                bitValue: currentBit,
                runLength: imageBitsConsumed
            }
        };
    }
}