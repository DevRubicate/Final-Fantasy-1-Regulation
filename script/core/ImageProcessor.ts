/**
 * Complete Image processing utilities for the compression system (Deno version)
 */
import { PNG } from "pngjs";
import { FORMAT } from './constants.ts';
import type { NESColor } from '../utils/nespalette.ts';

export interface PaddingInfo {
    imageData: PNG;
    padOffsets: {
        left: number;
        right: number;
        top: number;
        bottom: number;
    };
}

export class ImageProcessor {
    constructor(private nesPalette: NESColor[]) {}

    /**
     * Load PNG file and return parsed data
     */
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

    /**
     * Check if image has transparency
     */
    hasTransparency(imageData: PNG): boolean {
        for (let i = 3; i < imageData.data.length; i += 4) {
            if (imageData.data[i] < 255) {
                return true;
            }
        }
        return false;
    }

    /**
     * Validate and pad image to required dimensions
     */
    validateAndPadImage(pngData: PNG): PaddingInfo {
        const targetWidth = FORMAT.IMAGE_WIDTH;
        const targetHeight = FORMAT.IMAGE_HEIGHT;

        if (pngData.width === targetWidth && pngData.height === targetHeight) {
            return { imageData: pngData, padOffsets: { left: 0, right: 0, top: 0, bottom: 0 } };
        }

        if (pngData.width > targetWidth || pngData.height > targetHeight) {
            throw new Error(`Image too large: ${pngData.width}x${pngData.height}, max: ${targetWidth}x${targetHeight}`);
        }

        // Calculate padding
        const padLeft = Math.floor((targetWidth - pngData.width) / 2);
        const padRight = targetWidth - pngData.width - padLeft;
        const padTop = Math.floor((targetHeight - pngData.height) / 2);
        const padBottom = targetHeight - pngData.height - padTop;


        // Create padded image
        const paddedData = new PNG({ width: targetWidth, height: targetHeight });

        for (let y = 0; y < targetHeight; y++) {
            for (let x = 0; x < targetWidth; x++) {
                const targetIdx = (y * targetWidth + x) * 4;

                if (x >= padLeft && x < targetWidth - padRight &&
                    y >= padTop && y < targetHeight - padBottom) {
                    // Inside original image bounds
                    const sourceX = x - padLeft;
                    const sourceY = y - padTop;
                    const sourceIdx = (sourceY * pngData.width + sourceX) * 4;

                    paddedData.data[targetIdx] = pngData.data[sourceIdx];
                    paddedData.data[targetIdx + 1] = pngData.data[sourceIdx + 1];
                    paddedData.data[targetIdx + 2] = pngData.data[sourceIdx + 2];
                    paddedData.data[targetIdx + 3] = pngData.data[sourceIdx + 3];
                } else {
                    // Padding area - transparent
                    paddedData.data[targetIdx] = 0;
                    paddedData.data[targetIdx + 1] = 0;
                    paddedData.data[targetIdx + 2] = 0;
                    paddedData.data[targetIdx + 3] = 0;
                }
            }
        }

        return {
            imageData: paddedData,
            padOffsets: { left: padLeft, right: padRight, top: padTop, bottom: padBottom }
        };
    }

    /**
     * Process transparency based on original image characteristics
     */
    processTransparency(imageData: PNG, originalHasTransparency: boolean): PNG {
        if (originalHasTransparency) {
            return imageData;
        }

        // Convert black pixels to transparent
        let convertedCount = 0;
        for (let i = 0; i < imageData.data.length; i += 4) {
            const r = imageData.data[i];
            const g = imageData.data[i + 1];
            const b = imageData.data[i + 2];
            const a = imageData.data[i + 3];

            if (r === 0 && g === 0 && b === 0 && a === 255) {
                imageData.data[i + 3] = 0; // Make transparent
                convertedCount++;
            }
        }


        return imageData;
    }

    /**
     * Detect sprite bounds and calculate clipping information
     */
    detectSpriteBounds(imageData: PNG) {
        const { width, height, data } = imageData;

        let minX = width, maxX = -1;
        let minY = height, maxY = -1;

        // Find bounding box of non-transparent pixels
        for (let y = 0; y < height; y++) {
            for (let x = 0; x < width; x++) {
                const pixelIndex = (y * width + x) * 4;
                const alpha = data[pixelIndex + 3];

                // If pixel is not transparent
                if (alpha > 0) {
                    minX = Math.min(minX, x);
                    maxX = Math.max(maxX, x);
                    minY = Math.min(minY, y);
                    maxY = Math.max(maxY, y);
                }
            }
        }

        // If no non-transparent pixels found, no clipping needed
        if (maxX === -1) {
            return {
                leftClip: 0, rightClip: 0, topClip: 0, bottomClip: 0,
                boundingBox: { x: 0, y: 0, width: width, height: height }
            };
        }

        // Calculate clipping in 8-pixel increments (tile boundaries)
        const contentLeft = Math.floor(minX / 8) * 8;
        const contentRight = Math.ceil((maxX + 1) / 8) * 8;
        const contentTop = Math.floor(minY / 8) * 8;
        const contentBottom = Math.ceil((maxY + 1) / 8) * 8;

        // Calculate clip amounts (in 8-pixel units)
        const leftClip = contentLeft / 8;
        const rightClip = (width - contentRight) / 8;
        const topClip = contentTop / 8;
        const bottomClip = (height - contentBottom) / 8;

        // Ensure clip values fit in 4 bits (0-15)
        const safeLeftClip = Math.min(15, Math.max(0, leftClip));
        const safeRightClip = Math.min(15, Math.max(0, rightClip));
        const safeTopClip = Math.min(15, Math.max(0, topClip));
        const safeBottomClip = Math.min(15, Math.max(0, bottomClip));


        return {
            leftClip: safeLeftClip,
            rightClip: safeRightClip,
            topClip: safeTopClip,
            bottomClip: safeBottomClip,
            boundingBox: {
                x: safeLeftClip * 8,
                y: safeTopClip * 8,
                width: width - (safeLeftClip + safeRightClip) * 8,
                height: height - (safeTopClip + safeBottomClip) * 8
            }
        };
    }

    /**
     * Extract 16x16 tiles from the image (for palette analysis)
     */
    extractTiles16x16(pngData: PNG, padOffsets = { left: 0, top: 0 }) {
        const tiles = [];
        const tilesWide = 16; // 256 / 16
        const tilesHigh = 8;  // 128 / 16

        for (let tileY = 0; tileY < tilesHigh; tileY++) {
            for (let tileX = 0; tileX < tilesWide; tileX++) {
                const tilePixels = [];

                // Extract 16x16 pixels for this tile
                for (let y = 0; y < 16; y++) {
                    for (let x = 0; x < 16; x++) {
                        const globalX = tileX * 16 + x;
                        const globalY = tileY * 16 + y;
                        const idx = (pngData.width * globalY + globalX) << 2;

                        const r = pngData.data[idx];
                        const g = pngData.data[idx + 1];
                        const b = pngData.data[idx + 2];
                        const a = pngData.data[idx + 3];

                        tilePixels.push({ r, g, b, a });
                    }
                }

                // Calculate original image coordinates (subtract padding)
                const originalTileX = tileX - Math.floor(padOffsets.left / 16);
                const originalTileY = tileY - Math.floor(padOffsets.top / 16);

                tiles.push({
                    x: tileX,
                    y: tileY,
                    originalX: originalTileX,
                    originalY: originalTileY,
                    pixels: tilePixels,
                    isEmpty: tilePixels.every(p => p.a === 0)
                });
            }
        }

        return tiles;
    }

    /**
     * Analyze palettes for tiles
     */
    analyzePalettes(tiles: any[], nesPalette: NESColor[]) {
        // Find unique colors across all tiles
        const colorSet = new Set<string>();
        const tileColors = new Map();

        for (const tile of tiles) {
            const colors = new Set<string>();
            for (const pixel of tile.pixels) {
                if (pixel.a > 0) { // Only non-transparent pixels
                    const colorKey = `${pixel.r},${pixel.g},${pixel.b}`;
                    colors.add(colorKey);
                    colorSet.add(colorKey);
                }
            }
            tileColors.set(tile, Array.from(colors));
        }

        const allColors = Array.from(colorSet);

        // Simple palette assignment - use palette 0 for all tiles
        const paletteAssignments = new Array(128).fill(0);
        const palettes = [allColors.slice(0, 3)]; // Take first 3 colors for palette 0

        return {
            assignments: paletteAssignments,
            palettes,
            tileColors
        };
    }

    /**
     * Convert to CHR tiles (8x8)
     */
    convertToChrTiles(processedImageData: PNG, clipInfo: any, paletteAnalysis: any) {
        const chrTiles = [];
        const clipLeft = clipInfo.leftClip * 8;
        const clipTop = clipInfo.topClip * 8;
        const clipWidth = processedImageData.width - (clipInfo.leftClip + clipInfo.rightClip) * 8;
        const clipHeight = processedImageData.height - (clipInfo.topClip + clipInfo.bottomClip) * 8;

        const tilesWide = Math.ceil(clipWidth / 8);
        const tilesHigh = Math.ceil(clipHeight / 8);


        for (let tileY = 0; tileY < tilesHigh; tileY++) {
            for (let tileX = 0; tileX < tilesWide; tileX++) {
                const tilePixels = [];

                // Extract 8x8 pixels for this CHR tile
                for (let y = 0; y < 8; y++) {
                    for (let x = 0; x < 8; x++) {
                        const globalX = clipLeft + tileX * 8 + x;
                        const globalY = clipTop + tileY * 8 + y;
                        const idx = (processedImageData.width * globalY + globalX) << 2;

                        if (globalX < processedImageData.width && globalY < processedImageData.height) {
                            const r = processedImageData.data[idx];
                            const g = processedImageData.data[idx + 1];
                            const b = processedImageData.data[idx + 2];
                            const a = processedImageData.data[idx + 3];

                            // Convert RGB to pattern index using palette analysis
                            let patternIndex = 0; // Default: transparent
                            if (a > 0) { // Non-transparent pixel
                                const colorKey = `${r},${g},${b}`;
                                const paletteColors = paletteAnalysis.palettes[0] || [];
                                const colorIndex = paletteColors.indexOf(colorKey);
                                if (colorIndex >= 0) {
                                    patternIndex = colorIndex + 1; // Map to 1, 2, 3
                                } else {
                                    patternIndex = 1; // Fallback for unmapped colors
                                }
                            }
                            tilePixels.push(patternIndex);
                        } else {
                            // Outside bounds - transparent
                            tilePixels.push(0);
                        }
                    }
                }

                chrTiles.push({
                    x: tileX,
                    y: tileY,
                    pixels: tilePixels // Now contains pattern indices (0-3) instead of RGBA
                });
            }
        }

        return chrTiles;
    }

    /**
     * Convert CHR tiles to linear pixel stream
     */
    createLinearPixelStream(chrTiles: any[]) {
        const pixels = [];
        for (const tile of chrTiles) {
            for (const patternIndex of tile.pixels) {
                // Pixels now contain pattern indices (0-3) directly from convertToChrTiles()
                pixels.push(patternIndex);
            }
        }
        return pixels;
    }
}