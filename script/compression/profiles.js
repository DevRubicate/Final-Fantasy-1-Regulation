/**
 * Compression profiles for different types of image data
 */
import { COMMANDS } from '../core/constants.js';

/**
 * Define compression profiles for different types of image data
 * Each profile specifies a command bit width and the commands to use
 */
export function defineCompressionProfiles() {
    return [
        {
            name: "FUNDAMENTAL_BITS",
            description: "Two fundamental bit-based commands with perfect symmetry",
            commandBitWidth: 1,
            commands: [
                COMMANDS.REPEAT_BITS,   // Index 0: Repeat bits (5 bits total: 1 cmd + 1 value + 3 count)
                COMMANDS.PLOT_BITS      // Index 1: Plot bits (5 bits total: 1 cmd + 4 pattern)
            ]
        },
        {
            name: "ENHANCED_REPEAT",
            description: "Three commands including REPEAT_COMMAND for multiplicative efficiency",
            commandBitWidth: 2,
            commands: [
                COMMANDS.REPEAT_BITS,   // Index 0: Repeat bits (6 bits total: 2 cmd + 1 value + 3 count)
                COMMANDS.PLOT_BITS,     // Index 1: Plot bits (6 bits total: 2 cmd + 4 pattern)
                COMMANDS.REPEAT_COMMAND // Index 2: Repeat command (5 bits total: 2 cmd + 3 count)
            ]
        }
    ];
}