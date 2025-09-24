/**
 * Image processing utilities for the compression system (Deno version)
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

        console.log(`   📐 Padding ${pngData.width}x${pngData.height} to ${targetWidth}x${targetHeight} (L${padLeft} R${padRight} T${padTop} B${padBottom})`);

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
            console.log("Image already has transparency - preserving as-is");
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

        if (convertedCount > 0) {
            console.log(`Converted ${convertedCount} black pixels to transparent`);
        }

        return imageData;
    }

    // TODO: Extract more image processing methods from original file
    // - detectSpriteBounds
    // - extractTiles
    // - analyzeTilePalettes
    // - extract8x8Tiles
    // - convertPixelsToPaletteValues
    // - convertToPlanarFormat
    // - createLinearPixelStream
}