#!/usr/bin/env -S deno run --allow-read --allow-write --allow-run

/**
 * Data Generator for Final Fantasy 1 Regulation (Deno version)
 *
 * This tool processes PNG and JSON files to generate assembly data for the NES build
 */

import { MassiveCompressor } from './legacy/MassiveCompressor.ts';
import * as path from "https://deno.land/std@0.208.0/path/mod.ts";

interface OutputData {
    massive?: Array<{
        name: string;
        data: Uint8Array;
        originalPath: string;
    }>;
    sprites?: any[];
    backgrounds?: any[];
    json?: any[];
    chr?: any[];
    text?: any[];
    item?: any[];
    shop?: any[];
    tile?: any[];
    metasprite?: any[];
    metatile?: any[];
    map?: any[];
}

class Structure {
    pages: any[] = [];
    backupPages: any[] = [];

    constructor(pages: any[]) {
        this.pages = pages;
        this.backupPages = [];
    }

    clonePages(pages: any[]): any[] {
        const clonedPages = [];
        for (let i = 0; i < pages.length; ++i) {
            let nodeClone = null;
            let node = pages[i];
            do {
                const previousNodeClone = nodeClone;
                nodeClone = {
                    ...node
                };
                nodeClone.previous = previousNodeClone;
                if (previousNodeClone) {
                    previousNodeClone.next = nodeClone;
                } else {
                    clonedPages.push(nodeClone);
                }
            } while (node = node.next);
        }
        return clonedPages;
    }

    transaction(): void {
        this.backupPages.push(
            this.clonePages(this.pages)
        );
    }

    rollback(): void {
        if (this.backupPages.length === 0) {
            throw new Error('Structure.rollback: No transaction active');
        }
        this.pages = this.backupPages.pop()!;
    }

    commit(): void {
        this.backupPages.pop();
    }
}


class BinaryPackage {
    name: string;
    data: any[];

    constructor(name: string, data?: any[]) {
        this.name = name;
        this.data = data ?? [];
    }

    push(...input: any[]): void {
        for (let i = 0; i < input.length; ++i) {
            this.data[i] = this.data[i] ?? [];
            this.data[i].push(input[i]);
        }
    }

    getName(): string {
        return this.name;
    }

    getLength(): number {
        return this.data[0].length;
    }

    getPriority(): number {
        return this.getLength();
    }

    getOutput(): string {
        return this.data[0].map((a: any) => {
            if (typeof a === 'number') {
                return `$${a.toString(16).padStart(2, '0')}`;
            } else {
                return a;
            }
        }).join(', ');
    }

    split(start: number, end: number): BinaryPackage {
        const subData = [];
        for (let i = 0; i < this.data.length; ++i) {
            subData.push(this.data[i].slice(start, end));
        }
        return new BinaryPackage(this.getName(), subData);
    }

    childAllocations(): BinaryPackage[] {
        return this.data.slice(1).map((a: any, i: number) => new BinaryPackage(`${this.name}_SIBLING${i+2}`, [a]));
    }
}

class PointerPackage {
    name: string;
    data: any[];
    type: string;

    constructor(name: string, data?: any[], type: string = '<') {
        this.name = name;
        this.data = data ?? [];
        this.type = type;
    }

    push(input: any): void {
        this.data.push(input);
    }

    getName(): string {
        return `${this.name}_${this.type === '<' ? 'LO' : 'HI'}`;
    }

    getLength(): number {
        return this.data.length;
    }

    getPriority(): number {
        return this.getLength();
    }

    getOutput(): string {
        return this.data.map((a: any) => {
            if (a === 0) {
                return '0';
            }
            return `${this.type}${a.getName()}`;
        }).join(', ');
    }

    split(start: number, end: number): PointerPackage {
        return new PointerPackage(this.name, this.data.slice(start, end), this.type);
    }

    childAllocations(): any[] {
        if (this.type === '<') {
            return [new PointerPackage(this.name, this.data.slice(), '>')].concat(
                this.data.filter((a: any) => a !== 0)
            );
        } else {
            return [];
        }
    }
}

class PointerStructPackage {
    name: string;
    data: any[];

    constructor(name: string, data?: any[]) {
        this.name = name;
        this.data = data ?? [];
    }

    push(input: any): void {
        this.data.push(input);
    }

    getName(): string {
        return this.name;
    }

    getLength(): number {
        return this.data.length * 2;
    }

    getPriority(): number {
        return this.getLength() * 2;
    }

    getOutput(): string {
        return this.data.map((a: any) => {
            if (a === 0) {
                return '0, 0';
            }
            return `<${a.getName()}, >${a.getName()}`;
        }).join(', ');
    }

    split(start: number, end: number): PointerStructPackage {
        if (start >> 1 << 1 !== start || end >> 1 << 1 !== end) {
            throw new Error(`PointerStructPackage: Uneven split`);
        }
        return new PointerStructPackage(this.getName(), this.data.slice(start >> 1, end >> 1));
    }

    childAllocations(): any[] {
        return this.data.filter((a: any) => a !== 0);
    }
}

class Preprocessor {
    packer: Packer;
    constants: Map<string, any> = new Map();
    metatiles: Map<string, any> = new Map();

    constructor() {
        this.packer = new Packer();
    }

    processJson(jsonData: OutputData): any[] {
        const packer = this.packer;

        const ITEM: any[] = [];
        const METASPRITE: any[] = [];
        const TILE: any[] = [];

        if (jsonData.text) {
            for (let i = 0; i < jsonData.text.length; ++i) {
                const node = jsonData.text[i];
                packer.addStatic(this.compileText(`TEXT_${node.name}`, node.text));
            }
        }

        if (jsonData.item) {
            const itemName = new PointerPackage('LUT_ITEM_NAME');
            const itemDescription = new PointerPackage('LUT_ITEM_DESCRIPTION');
            const itemPrice = new BinaryPackage('LUT_ITEM_PRICE');
            const itemDataFirst = new BinaryPackage('LUT_ITEM_DATA_FIRST');

            // The zero entry
            itemPrice.push(0, 0, 0);
            itemName.push(0);
            itemDescription.push(0);
            itemDataFirst.push(0, 0, 0);

            for (let i = 0; i < jsonData.item.length; ++i) {
                const item = jsonData.item[i];
                const itemId = i + 1;

                ITEM.push({name: item.name, data: itemId});

                packer.addConst({name: `ITEM_${item.name}`, data: itemId});

                itemPrice.push(
                    item.price & 0xFF,
                    item.price >> 8 & 0xFF,
                    item.price >> 16 & 0xFF,
                );

                switch (item.type) {
                    case 'ITEM':
                        itemDataFirst.push(0, 0, 0);
                        break;
                    case 'EQUIP':
                        itemDataFirst.push(0, 0, 0);
                        break;
                    case 'SPELLBOOK':
                        itemDataFirst.push(item.level, 0, 0);
                        break;
                    case 'QUEST':
                        itemDataFirst.push(0, 0, 0);
                        break;
                    default: throw new Error(`item ${item.name} has invalid type: ${item.type}`);
                }

                // Add this item's text to the output
                const textData = this.compileText(`TEXT_ITEM_NAME_${item.name}`, item.text);
                itemName.push(textData);

                const descriptionData = this.compileText(`TEXT_ITEM_DESCRIPTION_${item.name}`, item.description);
                itemDescription.push(descriptionData);
            }
            packer.addReferenceTable(itemName);
            packer.addReferenceTable(itemDescription);

            packer.addStatic(itemPrice);
            packer.addStatic(itemDataFirst);
        }

        if (jsonData.shop) {
            const shops = [];
            for (let i = 0; i < jsonData.shop.length; ++i) {
                const node = jsonData.shop[i];
                const shopList = new BinaryPackage(node.name);
                for (let j = 0; j < node.list.length; ++j) {
                    const item = ITEM.find((a: any) => a.name === node.list[j]);
                    if (!item) {
                        throw new Error(`Cannot find item ${node.list[j].name}`);
                    }
                    shopList.push(
                        item.data & 0xFF,
                        item.data >> 8 & 0xFF
                    );
                }
                // Terminator
                shopList.push(0, 0);

                const shop = packer.addStatic(shopList);
                shops.push(shop);
            }
        }

        if (jsonData.tile) {
            const tiles = new PointerPackage('LUT_TILE_CHR');
            for (let i = 0; i < jsonData.tile.length; ++i) {
                const node = jsonData.tile[i];
                const chr = jsonData.chr?.find((a: any) => a.name === node.source);

                if (!chr) {
                    throw new Error(`Could not find ${node.source}`);
                }
                packer.addConst({name: node.name, data: i});
                tiles.push(new BinaryPackage(`TILECHR_${node.name}`, [chr.tile[node.index]]));
            }
            packer.addReferenceTable(tiles);
        }

        if (jsonData.metasprite) {
            const metaspritePalette = new PointerPackage('LUT_METASPRITE_PALETTE');
            const metaspriteCHR = new PointerPackage('LUT_METASPRITE_CHR');
            const metaspriteData = new PointerPackage('LUT_METASPRITE_FRAMES');
            for (let i = 0; i < jsonData.metasprite.length; ++i) {
                const metasprite = jsonData.metasprite[i];
                packer.addConst({name: metasprite.name, data: i});

                // Add this metasprite's palette to the output
                metaspritePalette.push(this.compileMetaspritePalette(`${metasprite.name}_PALETTE`, metasprite));

                // Add this metasprite's chr to the output
                metaspriteCHR.push(this.compileMetaspriteCHR(`${metasprite.name}_CHR`, metasprite));

                // Add this metasprite's frames to the output
                metaspriteData.push(this.compileMetasprite(`${metasprite.name}_FRAMES`, metasprite));
            }
            packer.addReferenceTable(metaspritePalette);
            packer.addReferenceTable(metaspriteCHR);
            packer.addReferenceTable(metaspriteData);
        }

        if (jsonData.metatile) {
            // Find all of the animation variations
            this.reorganizeMetatileAnimationVariations(jsonData.metatile);
        }

        if (jsonData.map) {
            const mapData = new PointerPackage('LUT_MAP_METATILES');
            for (let i = 0; i < jsonData.map.length; ++i) {
                const map = jsonData.map[i];
                packer.addConst({name: map.name, data: i});
                mapData.push(this.compileMapMetatiles(`${map.name}_METATILES`, map));
            }
            packer.addReferenceTable(mapData);
        }

        if (jsonData.massive) {
            for (let i = 0; i < jsonData.massive.length; ++i) {
                const massive = jsonData.massive[i];
                packer.addConst({name: massive.name, data: i});

                // Create a BinaryPackage with the compressed data
                const massiveData = new BinaryPackage(`${massive.name}_IMAGE`, [Array.from(massive.data)]);
                packer.addStatic(massiveData);
            }
        }

        return packer.build();
    }

    addConstant(name: string, value: any): void {
        this.constants.set(name, value);
    }

    getConstant(name: string): any {
        if (!this.constants.has(name)) {
            throw new Error(`getConstant: Undefined constant ${name}`);
        }
        return this.constants.get(name);
    }

    compileText(name: string, text: string): BinaryPackage {
        const dict: {[key: string]: number} = {
            ' ': 2,
            '0': 5,
            '1': 6,
            '2': 7,
            '3': 8,
            '4': 9,
            '5': 10,
            '6': 11,
            '7': 12,
            '8': 13,
            '9': 14,
            'A': 15,
            'B': 16,
            'C': 17,
            'D': 18,
            'E': 19,
            'F': 20,
            'G': 21,
            'H': 22,
            'I': 23,
            'J': 24,
            'K': 25,
            'L': 26,
            'M': 27,
            'N': 28,
            'O': 29,
            'P': 30,
            'Q': 31,
            'R': 32,
            'S': 33,
            'T': 34,
            'U': 35,
            'V': 36,
            'W': 37,
            'X': 38,
            'Y': 39,
            'Z': 40,
            'a': 41,
            'b': 42,
            'c': 43,
            'd': 44,
            'e': 45,
            'f': 46,
            'g': 47,
            'h': 48,
            'i': 49,
            'j': 50,
            'k': 51,
            'l': 52,
            'm': 53,
            'n': 54,
            'o': 55,
            'p': 56,
            'q': 57,
            'r': 58,
            's': 59,
            't': 60,
            'u': 61,
            'v': 62,
            'w': 63,
            'x': 64,
            'y': 65,
            'z': 66,
            ',': 67,
            '.': 68,
            '-': 69,
            '?': 70,
            '!': 71,
            '%': 72,
            '"': 73,
            '\'': 74,
            ':': 75,
            '/': 76,
            '\n': 127,
        };

        let mode = 'FREE';
        let commandString = '';

        const buffer = new BinaryPackage(name);
        for (let i = 0; i < text.length; ++i) {
            const char = text[i];

            if (mode === 'FREE') {
                if (char === '{') {
                    mode = 'COMMAND';
                } else {
                    const val = dict[char];
                    if (typeof val === 'undefined') {
                        throw new Error(`Invalid character "${char}" in text: "${text}"`);
                    }
                    buffer.push(val);
                }
            } else if (mode === 'COMMAND') {
                if (char === '}') {
                    this.translateCommand(commandString, buffer);
                    commandString = '';
                    mode = 'FREE';
                } else {
                    commandString += char;
                }
            }
        }

        buffer.push(0); // Terminator

        return buffer;
    }

    compileMetaspritePalette(name: string, input: any): BinaryPackage {
        const buffer = new BinaryPackage(name);
        for (let i = 0; i < input.palette.length; ++i) {
            let colors = 0;
            for (let j = 0; j < input.palette[i].length; ++j) {
                buffer.push(input.palette[i][j]);
                ++colors;
            }
            if (colors !== 3) {
                buffer.push(0xFF); // Palette terminator
            }
        }
        buffer.push(0xFF); // Full terminator
        return buffer;
    }

    compileMetaspriteCHR(name: string, input: any): BinaryPackage {
        const buffer = new BinaryPackage(name);
        for (let i = 0; i < input.chr.length; ++i) {
            const chr = input.chr[i];
            buffer.push(chr.size - 1);
            buffer.push(`<${chr.name}`);
            buffer.push(`>${chr.name}`);
        }
        buffer.push(0xFF);
        return buffer;
    }

    compileMetasprite(name: string, input: any): PointerStructPackage {
        const metaspriteFrame = new PointerStructPackage(`${name}_FRAMES`);

        for (let i = 0; i < input.frame.length; ++i) {
            const frameInput = input.frame[i];
            const frameBuffer = new BinaryPackage(`${input.name}_FRAME_${i}`);
            frameBuffer.push(frameInput.x);
            frameBuffer.push(frameInput.y);
            frameBuffer.push(frameInput.height - 1);
            frameBuffer.push(frameInput.width - 1);
            for (let j = 0; j < frameInput.tile.length; ++j) {
                const tile = frameInput.tile[j];
                frameBuffer.push(tile.index);
            }
            metaspriteFrame.push(frameBuffer);
        }

        return metaspriteFrame;
    }

    reorganizeMetatileAnimationVariations(input: any[]): void {
        const lutMetatileTopLeft = new BinaryPackage('LUT_METATILE_TOP_LEFT');
        const lutMetatileTopRight = new BinaryPackage('LUT_METATILE_TOP_RIGHT');
        const lutMetatileBottomLeft = new BinaryPackage('LUT_METATILE_BOTTOM_LEFT');
        const lutMetatileBottomRight = new BinaryPackage('LUT_METATILE_BOTTOM_RIGHT');
        const lutTileAnimations = new PointerPackage('LUT_TILE_ANIMATIONS');

        const variants = new Map();
        for (let i = 0; i < input.length; ++i) {
            const metatile = input[i];
            const corners = [];
            // Once for each corner
            for (let j = 0; j < 4; ++j) {

                // Create a frame progression of tiles for this corner
                const progression = [];
                for (let k = 0; k < metatile.frame.length; ++k) {
                    const frame = metatile.frame[k];
                    progression.push(frame[j]);
                }
                const progressionName = progression.join(' ');

                // Check if this frame progression of tiles already exist
                if (variants.has(progressionName)) {
                    const tileAnimationName = variants.get(progressionName);
                    corners.push(tileAnimationName);

                } else {
                    const index = variants.size;
                    const tileAnimationName = `TILE_ANIMATION_${index}`;
                    corners.push(tileAnimationName);
                    this.packer.addConst({name: tileAnimationName, data: index});
                    const buffer = new BinaryPackage(`TILE_ANIMATION_DATA_${index}`);
                    for (let k = 0; k < progression.length; ++k) {
                        buffer.push(`>${progression[k]}`); // High byte
                        buffer.push(`<${progression[k]}`); // Low byte
                    }
                    buffer.push(0xFF); // Terminator
                    lutTileAnimations.push(buffer);

                    variants.set(progressionName, tileAnimationName);
                }
            }

            // Now for the metatile itself
            this.packer.addConst({name: metatile.name, data: i});
            lutMetatileTopLeft.push(
                `<${corners[0]}`,
                `>${corners[0]}`
            );
            lutMetatileTopRight.push(
                `<${corners[1]}`,
                `>${corners[1]}`
            );
            lutMetatileBottomLeft.push(
                `<${corners[2]}`,
                `>${corners[2]}`
            );
            lutMetatileBottomRight.push(
                `<${corners[3]}`,
                `>${corners[3]}`
            );
        }

        this.packer.addReferenceTable(lutTileAnimations);  // This is just a test to see if the metatile animations are being loaded correctly
        this.packer.addReferenceTable(lutMetatileTopLeft);
        this.packer.addReferenceTable(lutMetatileTopRight);
        this.packer.addReferenceTable(lutMetatileBottomLeft);
        this.packer.addReferenceTable(lutMetatileBottomRight);
    }

    compileMapMetatiles(name: string, input: any): BinaryPackage {
        const buffer = new BinaryPackage(name);

        for (let i = 0; i < input.metatile.length; ++i) {
            const metatileName = input.metatile[i];
            buffer.push(`>${metatileName}`);
            buffer.push(`<${metatileName}`);
        }

        // Terminator
        buffer.push(255);

        return buffer;
    }

    translateCommand(commandString: string, buffer: BinaryPackage): void {
        const segment = commandString.split(' ');
        switch (segment[0]) {
            case 'SWORD': {
                buffer.push(77);
                break;
            }
            case 'HAMMER': {
                buffer.push(78);
                break;
            }
            case 'KNIFE': {
                buffer.push(79);
                break;
            }
            case 'AXE': {
                buffer.push(80);
                break;
            }
            case 'STAFF': {
                buffer.push(81);
                break;
            }
            case 'NUNCHUCK': {
                buffer.push(82);
                break;
            }
            case 'ARMOR': {
                buffer.push(83);
                break;
            }
            case 'SHIELD': {
                buffer.push(84);
                break;
            }
            case 'HELMET': {
                buffer.push(85);
                break;
            }
            case 'GAUNTLET': {
                buffer.push(86);
                break;
            }
            case 'BRACELET': {
                buffer.push(87);
                break;
            }
            case 'CLOTH': {
                buffer.push(88);
                break;
            }
            case 'POTION': {
                buffer.push(89);
                break;
            }
            case 'BYTE':
                buffer.push(128);
                buffer.push(this.getPositiveInteger(segment[1]));
                break;
            case 'WORD': {
                const value = this.getPositiveInteger(segment[1]);
                const byte1 = value & 0xFF;
                const byte2 = (value >> 8) & 0xFF;

                buffer.push(129);
                buffer.push(byte1);
                buffer.push(byte2);
                break;
            }
            case 'TRIBYTE': {
                const value = this.getPositiveInteger(segment[1]);
                const byte1 = value & 0xFF;
                const byte2 = (value >> 8) & 0xFF;
                const byte3 = (value >> 16) & 0xFF;
                buffer.push(130);
                buffer.push(byte1);
                buffer.push(byte2);
                buffer.push(byte3);
                break;
            }
            case 'READ8': {
                const lo = this.getFirstPart(segment[1]);
                const hi = this.getSecondPart(segment[1]);
                buffer.push(131);
                buffer.push(hi);
                buffer.push(lo);
                break;
            }
            case 'READ16': {
                const address = this.getPositiveInteger(segment[1]);
                const lo = address & 0xFF;
                const hi = (address >> 8) & 0xFF;
                buffer.push(132);
                buffer.push(hi);
                buffer.push(lo);
                break;
            }
            case 'READ24': {
                const address = this.getPositiveInteger(segment[1]);
                const lo = address & 0xFF;
                const hi = (address >> 8) & 0xFF;
                buffer.push(133);
                buffer.push(hi);
                buffer.push(lo);
                break;
            }
            case 'ADD':
                buffer.push(134);
                break;
            case 'SUB':
                buffer.push(135);
                break;
            case 'DIV':
                buffer.push(136);
                break;
            case 'MUL':
                buffer.push(137);
                break;
            case 'MAX':
                buffer.push(138);
                break;
            case 'MIN':
                buffer.push(139);
                break;
            case 'AND':
                buffer.push(140);
                break;
            case 'OR':
                buffer.push(141);
                break;
            case 'XOR':
                buffer.push(142);
                break;
            case 'HERO_LEVEL':
                buffer.push(143);
                break;
            case 'HERO_HP':
                buffer.push(144);
                break;
            case 'HERO_MAXHP':
                buffer.push(145);
                break;
            case 'HERO_SPELLCHARGE1':
                buffer.push(146);
                break;
            case 'HERO_SPELLCHARGE2':
                buffer.push(147);
                break;
            case 'HERO_SPELLCHARGE3':
                buffer.push(148);
                break;
            case 'HERO_SPELLCHARGE4':
                buffer.push(149);
                break;
            case 'HERO_SPELLCHARGE5':
                buffer.push(150);
                break;
            case 'HERO_SPELLCHARGE6':
                buffer.push(151);
                break;
            case 'HERO_SPELLCHARGE7':
                buffer.push(152);
                break;
            case 'HERO_SPELLCHARGE8':
                buffer.push(153);
                break;
            case 'HERO_MAXSPELLCHARGE1':
                buffer.push(154);
                break;
            case 'HERO_MAXSPELLCHARGE2':
                buffer.push(155);
                break;
            case 'HERO_MAXSPELLCHARGE3':
                buffer.push(156);
                break;
            case 'HERO_MAXSPELLCHARGE4':
                buffer.push(157);
                break;
            case 'HERO_MAXSPELLCHARGE5':
                buffer.push(158);
                break;
            case 'HERO_MAXSPELLCHARGE6':
                buffer.push(159);
                break;
            case 'HERO_MAXSPELLCHARGE7':
                buffer.push(160);
                break;
            case 'HERO_MAXSPELLCHARGE8':
                buffer.push(161);
                break;
            case 'ITEM_PRICE':
                buffer.push(162);
                break;
            case 'SUBSTRING': {
                const address = this.getPositiveInteger(segment[1]);
                const lo = address & 0xFF;
                const hi = (address >> 8) & 0xFF;
                buffer.push(128);
                buffer.push(hi);
                buffer.push(lo);
                break;
            }
            case 'DIGIT1':
                buffer.push(129);
                break;
            case 'DIGIT2L':
                buffer.push(130);
                break;
            case 'DIGIT2R':
                buffer.push(131);
                break;
            case 'DIGIT3L':
                buffer.push(132);
                break;
            case 'DIGIT3R':
                buffer.push(133);
                break;
            case 'DIGIT4L':
                buffer.push(134);
                break;
            case 'DIGIT4R':
                buffer.push(135);
                break;
            case 'DIGIT5L':
                buffer.push(136);
                break;
            case 'DIGIT5R':
                buffer.push(137);
                break;
            case 'DIGIT6L':
                buffer.push(138);
                break;
            case 'DIGIT6R':
                buffer.push(139);
                break;
            case 'DIGIT7L':
                buffer.push(140);
                break;
            case 'DIGIT7R':
                buffer.push(141);
                break;
            case 'DIGIT8L':
                buffer.push(142);
                break;
            case 'DIGIT8R':
                buffer.push(143);
                break;
            case 'SET_HERO':
                buffer.push(144);
                break;
            case 'HERO_NAME':
                buffer.push(145);
                break;
            case 'HERO_CLASS':
                buffer.push(146);
                break;
            case 'ITEM_NAME':
                buffer.push(147);
                break;
            case 'ITEM_DESCRIPTION':
                buffer.push(148);
                break;
            case 'ADDRESS': {
                const address = this.getPositiveInteger(segment[1]);
                const lo = address & 0xFF;
                const hi = (address >> 8) & 0xFF;
                const length = this.getPositiveInteger(segment[2]) + 1;
                buffer.push(251);
                buffer.push(255);
                buffer.push(hi);
                buffer.push(255);
                buffer.push(lo);
                buffer.push(255);
                buffer.push(length);
                break;
            }
            default:
                throw new Error(`Invalid command: ${segment[0]}`);
        }
    }

    getPositiveInteger(n: string): number {
        if (n.charAt(0) === '$') {
            return parseInt(n.substring(1), 16);
        } else if ((parseInt(n) >>> 0) === parseFloat(n)) {
            return parseFloat(n);
        } else {
            throw new Error(`Invalid input, must be positive integer, got "${n}" instead`);
        }
    }

    getFirstPart(n: string): any {
        if (n.charAt(0) === '@') {
            return `<${n.substring(1)}`;
        } else if (n.charAt(0) === '$') {
            return parseInt(n.substring(1), 16) & 0xFF;
        } else if ((parseInt(n) >>> 0) === parseFloat(n)) {
            return parseFloat(n) & 0xFF;
        } else {
            throw new Error(`getFirstPart: Invalid identifier. Must be positive integer, $hex, or @label. Got "${n}" instead`);
        }
    }

    getSecondPart(n: string): any {
        if (n.charAt(0) === '@') {
            return `>${n.substring(1)}`;
        } else if (n.charAt(0) === '$') {
            return (parseInt(n.substring(1), 16) >> 8) & 0xFF;
        } else if ((parseInt(n) >>> 0) === parseFloat(n)) {
            return (parseFloat(n) >> 8) & 0xFF;
        } else {
            throw new Error(`getSecondPart: Invalid identifier. Must be positive integer, $hex, or @label. Got "${n}" instead`);
        }
    }

    getThirdPart(n: string): any {
        if (n.charAt(0) === '@') {
            throw new Error(`getThirdPart: Cannot accept @label`);
        } else if (n.charAt(0) === '$') {
            return (parseInt(n.substring(1), 16) >> 16) & 0xFF;
        } else if ((parseInt(n) >>> 0) === parseFloat(n)) {
            return (parseFloat(n) >> 16) & 0xFF;
        } else {
            throw new Error(`getThirdPart: Invalid identifier. Must be positive integer, $hex, or @label. Got "${n}" instead`);
        }
    }

    translateLabel(input: any[]): string {
        let output = '';
        for (let i = 0; i < input.length; ++i) {
            const label = input[i];
            const address = label.value;
            output += `${label.name} := $${address.toString(16)}\n`;
        }
        return output;
    }
}

class Packer {
    structure: Structure;
    stuff: any[] = [];
    consts: any[] = [];

    constructor() {
        this.structure = new Structure([
            {address: 0, page: 0,  size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 1,  size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 2,  size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 3,  size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 4,  size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 5,  size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 6,  size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 7,  size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 8,  size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 9,  size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 10, size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 11, size: 0x2000, occupied: null, next: null, previous: null},
            {address: 0, page: 12, size: 0x2000, occupied: null, next: null, previous: null},
        ]);
    }

    addStatic(entry: any): void {
        this.stuff.push(entry);
    }

    addReferenceTable(entry: any): void {
        this.stuff.push(entry);
    }

    addConst(entry: any): void {
        this.consts.push(entry);
    }

    place(plan: any): boolean {
        const banned: any[] = [];
        // eslint-disable-next-line no-constant-condition
        outer: while (true) {
            this.structure.transaction();

            let success = true;
            const baseAllocation = this.allocate(plan, {}, banned);
            if (!baseAllocation) {
                this.structure.rollback();
                return false;
            }

            // success
            break;
        }
        this.structure.commit();

        return true;
    }

    allocate(thing: any, param: any = {}, banned: any[]): any {
        if (!thing) {
            throw new Error(`allocate: Provided thing is invalid: ${JSON.stringify(thing)}`);
        }

        const dataLength = thing.getLength();

        const sizes = [];
        for (let i = 0, len = Math.ceil(dataLength / 256); i < len; ++i) {
            sizes.push(
                i < len - 1 ? 256 : dataLength % 256
            );
        }
        const greedy = sizes.length > 1;

        let nodes = this.getFreeNodes();

        // remove cells that are too small
        nodes = nodes.filter((a: any) => a.size >= sizes[0]);

        // Remove cells that aren't on the right page
        if (typeof param.page !== 'undefined') {
            nodes = nodes.filter((a: any) => a.page === param.page);
        }

        nodes = nodes.filter((a: any) => !banned.find((b: any) => a.page === b.page && a.address === b.address));

        if (greedy) {
            nodes.sort(
                (a: any, b: any) => a.address === b.address ? b.page - a.page : a.address - b.address
            );
        } else {
            nodes.sort(
                (a: any, b: any) => a.address === b.address ? b.page - a.page : b.address - a.address
            );
        }

        outer: while (nodes.length > 0) {
            const currentNode = nodes.pop();
            const currentPage = currentNode.page;
            const currentAddress = currentNode.address;

            let pageIndex = 0;

            // Check if there are any available pages on the left
            const pagesToTheLeft = [];
            if (typeof param.page === 'undefined') {
                for (let j = currentPage - 1; j >= 0; --j) {

                    if (pageIndex >= sizes.length - 1) {
                        // There is only 1 segment left to allocate so we break here as the last segment should be put in
                        // the middle page.
                        break;
                    }

                    let leftNode = this.structure.pages[j];
                    while (
                        leftNode &&
                        leftNode.occupied &&
                        leftNode.address + leftNode.size <= currentAddress
                    ) {
                        leftNode = leftNode.next;
                    }
                    const wastedSize = currentAddress - leftNode.address;
                    if (leftNode.size - wastedSize >= sizes[pageIndex]) {
                        ++pageIndex;
                        pagesToTheLeft.push(leftNode);
                    } else {
                        break;
                    }
                }
            }

            // Increment pageIndex once for the middle page
            ++pageIndex;

            // Check if there are any available pages on the right
            const pagesToTheRight = [];
            for (let j = currentPage + 1; j < this.structure.pages.length; ++j) {
                let rightNode = this.structure.pages[j];

                while (
                    rightNode &&
                    rightNode.occupied &&
                    rightNode.address + rightNode.size <= currentAddress
                ) {
                    rightNode = rightNode.next;
                }
                const wastedSize = currentAddress - rightNode.address;
                if (rightNode.size - wastedSize >= sizes[pageIndex]) {
                    ++pageIndex;
                    pagesToTheRight.push(rightNode);
                } else {
                    break;
                }
            }

            // We incremented pageIndex once for each suitable node we found, so if our pageIndex was
            // incremented until it is equal to our sizes array, it means we have successfully found enough
            // cells to hold this complete allocation
            if (pageIndex === sizes.length) {
                this.structure.transaction();

                let pageCounter = 0;
                let offset = 0;

                // Allocates cells to the left of center
                for (let j = 0; j < pagesToTheLeft.length; ++j) {
                    const leftNode = pagesToTheLeft[j];
                    const subData = thing.split(
                        offset,
                        offset + sizes[pageCounter]
                    );
                    this.takeCell(
                        subData,
                        pageCounter === 0 ? `${thing.getName()}` : `${thing.getName()}_PART${pageCounter + 1}`,
                        `address ${leftNode.address} - ${leftNode.address + sizes[pageCounter]} (bytes ${offset} - ${offset + sizes[pageCounter]})`,
                        leftNode,
                        currentAddress,
                        sizes[pageCounter],
                        pageCounter !== 0,
                    );
                    offset += sizes[pageCounter];

                    // Now we allocate any child allocations from this subdata to the page that the subdata was
                    // allocated to.
                    const children = subData.childAllocations();
                    for (let k = 0; k < children.length; ++k) {
                        const success = this.allocate(children[k], {page: leftNode.page}, []);
                        if (!success) {
                            this.structure.rollback();
                            continue outer;
                        }
                    }

                    ++pageCounter;
                }

                // Allocate center cell
                const subData = thing.split(
                    offset,
                    offset + sizes[pageCounter]
                );
                this.takeCell(
                    subData,
                    pageCounter === 0 ? `${thing.getName()}` : `${thing.getName()}_EXTENDED`,
                    `address ${currentNode.address} - ${currentNode.address + sizes[pageCounter]} (bytes ${offset} - ${offset + sizes[pageCounter]})`,
                    currentNode,
                    currentAddress,
                    sizes[pageCounter],
                    pageCounter !== 0
                );
                offset += sizes[pageCounter];
                // Now we allocate any child allocations from this subdata to the page that the subdata was
                // allocated to.

                const children = subData.childAllocations();
                for (let k = 0; k < children.length; ++k) {
                    const success = this.allocate(children[k], {page: currentNode.page}, []);
                    if (!success) {
                        this.structure.rollback();
                        continue outer;
                    }
                }
                ++pageCounter;

                // Allocate cells to the right of center
                for (let j = 0; j < pagesToTheRight.length; ++j) {
                    const rightNode = pagesToTheRight[j];
                    const subData = thing.split(
                        offset,
                        offset + sizes[pageCounter]
                    );
                    this.takeCell(
                        subData,
                        `${thing.getName()}_EXTENDED`,
                        `address ${rightNode.address} - ${rightNode.address + sizes[pageCounter]} (bytes ${offset} - ${offset + sizes[pageCounter]})`,
                        rightNode,
                        currentAddress,
                        sizes[pageCounter],
                        true
                    );
                    offset += sizes[pageCounter];
                    // Now we allocate any child allocations from this subdata to the page that the subdata was
                    // allocated to.
                    const children = subData.childAllocations();
                    for (let k = 0; k < children.length; ++k) {
                        const success = this.allocate(children[k], {page: rightNode.page}, []);
                        if (!success) {
                            this.structure.rollback();
                            continue outer;
                        }
                    }
                    ++pageCounter;
                }

                this.structure.commit();
                return {
                    anchorNode: currentNode,
                    node: pagesToTheLeft[0] ?? currentNode,
                };
            }
        }
        return null;
    }

    takeCell(data: any, labelName: string, comment: string, cell: any, address: number, size: number, noExport: boolean = false): void {
        if (cell.address === address) {
            if (cell.size === size) {
                cell.occupied = data;
            } else if (cell.size > size) {
                const nextCell = {
                    address: cell.address + size,
                    page: cell.page,
                    size: cell.size - size,
                    occupied: null,
                    comment: null,
                    next: cell.next,
                    previous: cell
                };
                cell.occupied = data;
                cell.size = size;
                cell.noExport = noExport;
                if (cell.next) { cell.next.previous = nextCell; }
                cell.next = nextCell;
                cell.comment = comment;
            } else {
                throw new Error(`takeCell: Tried to allocate size ${size} into a cell that's size ${cell.size}. ${comment}`);
            }
        } else if (cell.address < address) {
            const wastedSize = address - cell.address;
            if (cell.size - wastedSize === size) {
                const previousCell = {
                    address: cell.address,
                    page: cell.page,
                    size: wastedSize,
                    occupied: null,
                    comment: null,
                    next: cell,
                    previous: cell.previous
                };
                cell.occupied = data;
                cell.size = size;
                cell.noExport = noExport;
                if (cell.previous) { cell.previous.next = previousCell; }
                cell.previous = previousCell;
                cell.comment = comment;
            } else if (cell.size > size) {
                const previousCell = {
                    address: cell.address,
                    page: cell.page,
                    size: wastedSize,
                    occupied: null,
                    comment: null,
                    next: cell,
                    previous: cell.previous
                };
                const nextCell = {
                    address: cell.address + size,
                    page: cell.page,
                    size: cell.size - wastedSize - size,
                    occupied: null,
                    comment: null,
                    next: cell.next,
                    previous: cell
                };
                cell.occupied = data;
                cell.size = size;
                cell.noExport = noExport;
                if (cell.previous) { cell.previous.next = previousCell; }
                cell.previous = previousCell;
                if (cell.next) { cell.next.previous = nextCell; }
                cell.next = nextCell;
                cell.comment = comment;
            } else {
                throw new Error('fatal');
            }
        } else {
            throw new Error(`takeCell: Cannot allocate at address ${address} inside cell that starts at address ${cell.address}`);
        }

        cell.name = labelName;
    }

    getFreeNodes(): any[] {
        const freeNodes = [];
        for (let i = 0; i < this.structure.pages.length; ++i) {
            let node = this.structure.pages[i];
            while (node) {
                if (!node.occupied) { freeNodes.push(node); }
                node = node.next;
            }
        }
        return freeNodes;
    }

    build(): any[] {
        this.stuff.sort((a: any, b: any) => b.getPriority() - a.getPriority());

        for (let i = 0; i < this.stuff.length; ++i) {
            const thing = this.stuff[i];
            const success = this.place(thing);
            if (!success) {
                throw new Error(`Could not allocate ${thing.getName()}`);
            }
        }

        const files = [];
        files.push({
            name: `data_consts.inc`,
            output: this.consts.map((a: any) => `${a.name} := ${a.data}`).join('\n')
        });

        for (let i = 0; i < this.structure.pages.length; ++i) {
            const file = {name: `data_${String(114+i).padStart(3, '0')}.asm`, output: ''};
            files.push(file);

            file.output += `.segment "DATA_${String(114+i).padStart(3, '0')}"\n\n`;
            file.output += `.include "src/global-import.inc"\n\n`;

            {
                const labelExports = [];
                let node = this.structure.pages[i];
                do {
                    if (node.occupied && !node.noExport) {
                        labelExports.push(node.name);
                    }
                } while (node = node.next);
                if (labelExports.length > 0) {
                    file.output += '.export ' + labelExports.join(', ') + '\n\n';
                }
            }

            let node = this.structure.pages[i];
            do {
                if (node.occupied) {
                    file.output += `; ${node.comment}\n`;
                    file.output += `${node.name}:\n`;
                    file.output += `.byte ${node.occupied.getOutput()}\n\n`;
                } else {
                    file.output += `; ${node.address} - ${node.address+node.size}\n`;
                    file.output += `.res ${node.size}\n\n`;
                }
            } while (node = node.next);
        }

        return files;
    }
}

class Main {
    static async main(): Promise<void> {
        console.log('🚀 Starting Deno data generator...');

        try {
            const output: OutputData = {};
            await this.processDirectory('data', output);

            // Generate assembly files using packer logic (matching original MJS)
            const preprocessor = new Preprocessor();
            const files = preprocessor.processJson(output);

            // Write the generated assembly files
            for (const file of files) {
                await Deno.writeTextFile(`src/data/${file.name}`, file.output);
                console.log(`✅ Generated assembly file: ${file.name}`);
            }

            console.log('📊 Processed data:');
            console.log(`   Massive files: ${output.massive?.length || 0}`);
            console.log(`   Sprites: ${output.sprites?.length || 0}`);
            console.log(`   Backgrounds: ${output.backgrounds?.length || 0}`);
            console.log(`   JSON files: ${output.json?.length || 0}`);

        } catch (error) {
            console.error('❌ Data generation failed:', error);
            Deno.exit(1);
        }
    }

    static async readMassivePNGFile(filePath: string, output: OutputData): Promise<void> {
        try {
            const compressor = new MassiveCompressor();
            const compressedData = await compressor.processImage(filePath);

            // Create a name from the file path for the output data
            const baseName = path.basename(filePath, '.massive.png').toUpperCase();
            const massiveName = `MASSIVE_${baseName}`;

            output.massive = output.massive ?? [];
            output.massive.push({
                name: massiveName,
                data: compressedData,
                originalPath: filePath
            });

        } catch (error) {
            console.error(`❌ Error processing massive PNG ${filePath}:`, error);
            throw error;
        }
    }

    static async readJsonFile(filePath: string, output: OutputData): Promise<void> {
        try {
            const content = await Deno.readTextFile(filePath);
            const jsonContent = JSON.parse(content);
            const keys = Object.keys(jsonContent);
            for (let i = 0; i < keys.length; ++i) {
                const key = keys[i];
                (output as any)[key] = (output as any)[key] ?? [];
                for (let j = 0; j < jsonContent[key].length; ++j) {
                    const thing = jsonContent[key][j];
                    if (!!(output as any)[key].find((a: any) => a.name === thing.name)) {
                        throw new Error(`The data ${thing.name} appears more than once`);
                    }
                    (output as any)[key].push(thing);
                }
            }

            console.log(`✅ Processed JSON: ${filePath}`);
        } catch (error) {
            console.error(`❌ Error processing JSON ${filePath}:`, error);
            throw error;
        }
    }

    static async readPNGFile(filePath: string, output: OutputData): Promise<void> {
        try {
            if (filePath.includes('.massive.png')) {
                await this.readMassivePNGFile(filePath, output);
            } else if (filePath.includes('.sprite.png')) {
                await this.runPNGToCHR([`--image=${filePath}`, `--output=${filePath}.chr`, `-H 16`]);
                await this.processCHRFile(`${filePath}.chr`, filePath, output);
            } else if (filePath.includes('.background.png')) {
                await this.runPNGToCHR([`--image=${filePath}`, `--output=${filePath}.chr`]);
                await this.processCHRFile(`${filePath}.chr`, filePath, output);
            } else {
                throw new Error(`Invalid "${filePath}", lacking .sprite.png, .background.png, or .massive.png naming`);
            }
        } catch (error) {
            console.error(`❌ Error processing PNG ${filePath}:`, error);
        }
    }

    // Recursive function to process all files in the directory
    static async processDirectory(directory: string, output: OutputData = {}): Promise<OutputData> {
        try {
            for await (const entry of Deno.readDir(directory)) {
                const entryPath = path.join(directory, entry.name);
                if (entry.isDirectory) {
                    await this.processDirectory(entryPath, output); // Recurse into subdirectories
                } else if (entry.isFile) {
                    if (entry.name.endsWith('.json')) {
                        await this.readJsonFile(entryPath, output); // Read JSON files
                    } else if (entry.name.endsWith('.png')) {
                        await this.readPNGFile(entryPath, output); // Read PNG files
                    }
                }
            }
            return output;
        } catch (err) {
            console.error(`❌ Error processing directory ${directory}:`, err);
            throw err;
        }
    }

    /**
     * Run PNG to CHR conversion using external tool
     */
    static async runPNGToCHR(options: string[]): Promise<void> {
        try {
            const command = new Deno.Command("script/pngtochr.exe", {
                args: options,
                stdout: "piped",
                stderr: "piped"
            });

            const { code, stderr } = await command.output();

            if (code !== 0) {
                const errorText = new TextDecoder().decode(stderr);
                throw new Error(`pngtochr failed: ${errorText}`);
            }
        } catch (error) {
            console.error(`❌ Error running pngtochr:`, error);
            throw error;
        }
    }

    /**
     * Run Donut tool to process CHR files
     */
    static async runDonut(inputFile: string, options: string[]): Promise<number[]> {
        try {
            const args = [...options, inputFile, '-'];
            const command = new Deno.Command("script/donut-nes.exe", {
                args: args,
                stdout: "piped",
                stderr: "piped"
            });

            const { code, stdout, stderr } = await command.output();

            if (code !== 0) {
                const errorText = new TextDecoder().decode(stderr);
                throw new Error(`donut failed: ${errorText}`);
            }

            return Array.from(stdout);
        } catch (error) {
            console.error(`❌ Error running donut:`, error);
            throw error;
        }
    }

    /**
     * Process CHR file and extract tile data
     */
    static async processCHRFile(chrFilePath: string, originalPath: string, output: OutputData): Promise<void> {
        try {
            const data = await this.runDonut(chrFilePath, ['-l']);

            const sizes = [];
            for (let i = data.length - 2; i >= 0; --i) {
                const value = data[i];
                if (value === 255) { break; }
                sizes.push(value);
            }
            sizes.reverse();

            const tileEntries = [];
            let entry = [];
            let size = 0;
            for (let i = 0; i < data.length; ++i) {
                const value = data[i];
                entry.push(value);
                ++size;
                if (sizes[0] === size) {
                    sizes.shift();
                    size = 0;
                    tileEntries.push(entry);
                    entry = [];
                }
            }

            output.chr = output.chr ?? [];
            output.chr.push({
                name: `${originalPath.split(path.sep).join('/')}.chr`,
                tile: tileEntries
            });

            console.log(`✅ Processed CHR file: ${originalPath} -> ${tileEntries.length} tiles`);
        } catch (error) {
            console.error(`❌ Error processing CHR file ${chrFilePath}:`, error);
            throw error;
        }
    }

}

// CLI handling
if (import.meta.main) {
    console.log('🚀 Starting...');
    await Main.main();
    console.log('✅ Done!');
}

// Export for use by other modules
export { Main, MassiveCompressor };