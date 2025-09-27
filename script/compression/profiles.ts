/**
 * Compression profiles for different types of image data
 */
import { COMMANDS } from '../core/constants.ts';

export interface CompressionProfile {
    name: string;
    commandBitWidth?: number; // Optional - will be auto-calculated
    commands: (number | Array<number | null> | null)[];
}

export interface ExpandedCompressionProfile {
    name: string;
    description: string;
    commandBitWidth: number;
    commands: number[];
}

/**
 * Define compression profiles for different types of image data
 * Each profile specifies a command bit width and the commands to use
 */
/**
 * Calculate the minimum number of bits needed to represent command indices
 */
function calculateCommandBitWidth(commandCount: number): number {
    if (commandCount <= 1) return 1;
    return Math.ceil(Math.log2(commandCount));
}

/**
 * Generate all possible combinations from arrays in commands
 */
function generatePermutations(commands: (number | Array<number | null> | null)[]): number[][] {
    const permutations: number[][] = [];

    function generateRecursive(index: number, current: number[]): void {
        if (index >= commands.length) {
            permutations.push([...current]);
            return;
        }

        const command = commands[index];

        if (command === null) {
            // Skip this command (null means optional)
            generateRecursive(index + 1, current);
        } else if (Array.isArray(command)) {
            // Try each variant in the array, plus null if allowed
            const variants = [...command, null];
            for (const variant of variants) {
                if (variant !== null) {
                    // Check if this command is already in the current array
                    if (current.includes(variant)) {
                        // Skip this variant as it would create a duplicate
                        generateRecursive(index + 1, current);
                    } else {
                        generateRecursive(index + 1, [...current, variant]);
                    }
                } else {
                    generateRecursive(index + 1, current);
                }
            }
        } else {
            // Single command
            // Check if this command is already in the current array
            if (current.includes(command)) {
                // Skip this command as it would create a duplicate
                generateRecursive(index + 1, current);
            } else {
                generateRecursive(index + 1, [...current, command]);
            }
        }
    }

    generateRecursive(0, []);
    return permutations;
}

/**
 * Expand a single profile into multiple concrete profiles
 */
export function expandProfile(profile: CompressionProfile): ExpandedCompressionProfile[] {
    const commandPermutations = generatePermutations(profile.commands);
    const expanded: ExpandedCompressionProfile[] = [];

    for (let i = 0; i < commandPermutations.length; i++) {
        const commands = commandPermutations[i];
        const commandBitWidth = profile.commandBitWidth ?? calculateCommandBitWidth(commands.length);

        expanded.push({
            name: `${profile.name}_v${i + 1}`,
            description: `${profile.name} (variant ${i + 1}: ${commands.length} commands, ${commandBitWidth}-bit width)`,
            commandBitWidth,
            commands
        });
    }

    return expanded;
}

/**
 * Expand all profiles and return concrete profiles ready for compression
 */
export function expandAllProfiles(baseProfiles: CompressionProfile[]): ExpandedCompressionProfile[] {
    const allExpanded: ExpandedCompressionProfile[] = [];

    for (const profile of baseProfiles) {
        const expanded = expandProfile(profile);
        allExpanded.push(...expanded);
    }

    return allExpanded;
}

export function defineCompressionProfiles(): CompressionProfile[] {
    return [
        {
            name: "MINIMAL_A",
            commands: [
                [COMMANDS.PLOT_BITS_4, COMMANDS.PLOT_BITS_8, COMMANDS.PLOT_BITS_12],
                [COMMANDS.PLOT_BITS_4, COMMANDS.PLOT_BITS_8, COMMANDS.PLOT_BITS_12]
            ]
        },
        {
            name: "MINIMAL_B",
            commands: [
                COMMANDS.REPEAT_BITS,
                [COMMANDS.PLOT_BITS_4, COMMANDS.PLOT_BITS_8, COMMANDS.PLOT_BITS_12],
            ]
        },
        {
            name: "STANDARD_A",
            commands: [
                COMMANDS.REPEAT_BITS,
                //COMMANDS.REPEAT_COMMAND,
                [COMMANDS.PLOT_BITS_4, COMMANDS.PLOT_BITS_8, COMMANDS.PLOT_BITS_12],
                [COMMANDS.PLOT_BITS_4, COMMANDS.PLOT_BITS_8, COMMANDS.PLOT_BITS_12],
            ]
        }
    ];
}