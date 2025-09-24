/**
 * Core constants for the Massive Graphics Compression System
 */

// Command type definitions - these are the values stored in the header
export const COMMANDS = {
    REPEAT_BITS: 0x00,     // Repeat a single bit 2-9 times (1 bit value + 3 bit count)
    PLOT_BITS_4: 0x01,     // Plot a 4-bit pattern (4 bit pattern)
    PLOT_BITS_8: 0x02,     // Plot an 8-bit pattern (8 bit pattern)
    PLOT_BITS_12: 0x03,    // Plot a 12-bit pattern (12 bit pattern)
    REPEAT_COMMAND: 0x04   // Repeat the following command 2-9 times (3 bit count)
} as const;

// Legacy alias for backward compatibility
export const COMMANDS_LEGACY = {
    PLOT_BITS: COMMANDS.PLOT_BITS_4
} as const;

// File format constants
export const FORMAT = {
    MAX_PALETTES: 4,
    PALETTE_SIZE: 4,
    TILE_SIZE: 8,
    MEGA_TILE_SIZE: 16,
    IMAGE_WIDTH: 256,
    IMAGE_HEIGHT: 128
} as const;

// Compression constants
export const COMPRESSION = {
    MAX_REPEAT_COUNT: 9,
    MIN_REPEAT_COUNT: 2,
    COMMAND_BIT_WIDTHS: [1, 2] as const, // Supported command bit widths
    MAX_RUN_LENGTH: 9
} as const;