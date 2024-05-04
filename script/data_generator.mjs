import {promises as fs}           from 'fs';
import path                       from 'path';

class Packer {
    pages = [
        {address: 0, page: 0, size: 0x2000, occupied: null, next: null, previous: null},
        {address: 0, page: 1, size: 0x2000, occupied: null, next: null, previous: null},
        {address: 0, page: 2, size: 0x2000, occupied: null, next: null, previous: null},
    ];
    stuff = [];

    constructor() {

    }
    addStatic(param) {
        const extraPages = Math.floor(param.size / 256);
        const height = Math.min(param.size, 256);

        this.stuff.push({
            data: param.data,
            name: param.name,
            size: param.size,
            height,
            lastHeight: param.size % 256,
            extraPages,
            priority: (extraPages << 16) + height,
        })
    }
    addTableStatic(param) {
        const childSize = param.children[0].size;
        if(param.children.find(a => a.size !== childSize)) {
            throw new Error('addTableStatic: Mismatch in child size');
        }
        const tableSize = param.children.length;
        const height = Math.min(tableSize, 256);
        const extraPages = Math.floor(param.children.length / 256);
        
        this.stuff.push({
            data: param.data,
            name: param.name,
            size: tableSize,
            height,
            lastHeight: param.size % 256,
            extraPages,
            priority: (extraPages << 16) + (height * childSize),
            variants: childSize,
        })
    }
    addTableReference(param) {
        this.stuff.push({
            
        })
    }
    addTablePointer(param) {
        this.stuff.push({
            
        })
    }
    allocateGreedy(thing) {
        const sortedNodes = this.getFreeNodes()
            .sort((a, b) => {
                if(!a && !b) {
                    return 0;
                } else if(!a) {
                    return 1;
                } else if(!b) {
                    return -1;
                } else {
                    return a.address - b.address;
                }
            });

        while(true) {
            let stuck = true;
            for(let i=0; i<sortedNodes.length; ++i) {
                if(!sortedNodes[i]) {
                    continue;
                }
                stuck = false;
                const currentNode = sortedNodes[i];
                const currentPage = currentNode.page;
                const currentAddress = currentNode.address;

                let neededPages = thing.extraPages+1;
                let foundPages = 1;


                let pagesToTheLeft = [];
                for(let j=currentPage-1; j>=0; --j) {
                    if(foundPages === neededPages) {
                        break;
                    }

                    let node = this.pages[j];
                    while(
                        node &&
                        node.occupied &&
                        node.address+node.size <= currentAddress
                    ) {
                        node = node.next;
                    }
                    const wastedSize = currentAddress - node.address;
                    const neededSize = 256;
                    if(node.size - wastedSize >= neededSize) {
                        ++foundPages;
                        pagesToTheLeft.push(node);
                    } else {
                        break;
                    }
                }

                let pagesToTheRight = [];
                for(let j=currentPage+1; j<this.pages.length; ++j) {
                    if(foundPages === neededPages) {
                        break;
                    }

                    let node = this.pages[j];
                    while(
                        node &&
                        node.occupied &&
                        node.address+node.size <= currentAddress
                    ) {
                        node = node.next;
                    }
                    const wastedSize = currentAddress - node.address;
                    const neededSize = (foundPages < neededPages) ? 256 : thing.lastHeight;

                    if(node.size - wastedSize >= neededSize) {
                        ++foundPages;
                        pagesToTheRight.push(node);
                    } else {
                        break;
                    }
                }

                if(foundPages === neededPages) {
                    let pageCounter = 0;
                    let remainingPages = foundPages;
                    for(let j=0; j<pagesToTheLeft.length; ++j) {
                        const leftNode = pagesToTheLeft[j];
                        const from = pageCounter * 256;
                        const to = pageCounter * 256 + 256;
                        this.data.takeCell(
                            thing.subData(from, to),
                            pageCounter === 0 ? `${thing.name}` : `${thing.name}_PART${pageCounter+1}`,
                            `${from} - ${to}`,
                            leftNode,
                            currentAddress,
                            256
                        );
                        ++pageCounter;
                    }
                    
                    const requiredSize = pageCounter < neededPages ? 256 : thing.lastHeight;
                    const from = pageCounter * 256;
                    const to = pageCounter * 256 + requiredSize;
                    this.takeCell(
                        thing.data.subData(from, to),
                        pageCounter === 0 ? `${thing.name}` : `${thing.name}_PART${pageCounter+1}`,
                        `${from} - ${to}`,
                        currentNode,
                        currentAddress,
                        requiredSize
                    );
                    ++pageCounter;
                    
                    for(let j=0; j<pagesToTheRight.length; ++j) {
                        const rightNode = pagesToTheRight[j];
                        const requiredSize = pageCounter < neededPages ? 256 : thing.lastHeight;
                        const from = pageCounter * 256;
                        const to = pageCounter * 256 + requiredSize;
                        this.takeCell(
                            thing.data.subData(from, to),
                            `${thing.name}_PART${pageCounter+1}`,
                            `${from} - ${to}`,
                            rightNode,
                            currentAddress,
                            requiredSize
                        );
                        ++pageCounter;
                    }
                    return;
                }
            }
            if(stuck) {
                throw new Error('stuck');
            }
        }
    }
    allocateGenerous(thing) {
        const sortedNodes = this.getFreeNodes()
            .sort((a, b) => {
                return a.size - b.size;
            });

        for(let i=0; i<sortedNodes.length; ++i) {
            const node = sortedNodes[i];
            const currentPage = node.page;
            const currentAddress = node.address;
            if(node.size >= thing.size) {

                this.takeCell(
                    thing.data,
                    thing.name,
                    `${currentAddress} - ${currentAddress + thing.size}`,
                    node,
                    currentAddress,
                    thing.size
                );
                return;
            }
        }
        throw new Error('No more room');
    }
    takeCell(data, labelName, comment, cell, address, size) {
        if(cell.address === address) {
            if(cell.size === size) {
                cell.occupied = data;
            } else if(cell.size > size) {
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
                if(cell.next) {cell.next.previous = nextCell;}
                cell.next = nextCell;
                cell.comment = comment;
            } else {
                throw new Error('fatal');
            }
        } else if(cell.address < address) {
            const wastedSize = address - cell.address;
            if(cell.size - wastedSize === size) {
                const previousCell = {
                    address: cell.address,
                    page: cell.page,
                    size: wastedSize,
                    occupied: null,
                    comment: null,
                    next: cell,
                    previous: cell.previous
                }
                cell.occupied = data;
                cell.size = size;
                if(cell.previous) {cell.previous.next = previousCell;}
                cell.previous = previousCell;
                cell.comment = comment;
            } else if(cell.size > size) {
                const previousCell = {
                    address: cell.address,
                    page: cell.page,
                    size: wastedSize,
                    occupied: null,
                    comment: null,
                    next: cell,
                    previous: cell.previous
                }
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
                if(cell.previous) {cell.previous.next = previousCell;}
                cell.previous = previousCell;
                if(cell.next) {cell.next.previous = nextCell;}
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
    getFreeNodes() {
        const freeNodes = [];
        for(let i=0; i<this.pages.length; ++i) {
            let node = this.pages[i];
            while(node) {
                if(!node.occupied) {freeNodes.push(node);}
                node = node.next;   
            }
        }
        return freeNodes;
    }
    build() {
        this.stuff.sort((a, b) => b.priority - a.priority);

        for(let i=0; i<this.stuff.length; ++i) {
            const thing = this.stuff[i];
            if(thing.extraPages === 0) {
                this.allocateGenerous(thing);
            } else {
                this.allocateGreedy(thing);
            }
        }

        const files = [];
        for(let i=0; i<this.pages.length; ++i) {
            const file = {name: `data_${String(124+i).padStart(3, '0')}.asm`, output: ''}
            files.push(file);

            file.output += `.segment "DATA_${String(124+i).padStart(3, '0')}"\n\n`

            {
                const labelExports = [];
                let node = this.pages[i];
                do {
                    if(node.occupied) {
                        labelExports.push(node.name);
                    }
                } while(node = node.next);
                if(labelExports.length > 0) {
                    file.output += '.export ' + labelExports.join(', ') + '\n\n';
                }
            }

            let node = this.pages[i];
            do {
                if(node.occupied) {
                    file.output += `; ${node.comment}\n`;
                    file.output += `${node.name}:\n`;
                    file.output += `.byte ${node.occupied.getOutput()}\n\n`;
                } else {
                    file.output += `; ${node.address} - ${node.address+node.size}\n`;
                    file.output += `.res ${node.size}\n\n`;
                }
            } while(node = node.next);
        }

        return files;
    }
}

class BinaryBuffer {
    constructor(arr) {
        this.arr = arr ?? [];
    }
    push(value) {
        this.arr.push(value & 0xFF);
    }
    getLength() {
        return this.arr.length;
    }
    getOutput() {
        return this.arr.map(a => `$${a.toString(16).padStart(2, '0')}`).join(', ');
    }
    subData(start, end) {
        return new BinaryBuffer(this.arr.slice(start, end));
    }
}

class Preprocessor {
    constructor() {}
    processJson(jsonData) {
        const packer = new Packer();
        const label = [];

        if(jsonData.text) {
            for(let i=0; i<jsonData.text.length; ++i) {
                const node = jsonData.text[i];
                const textData = this.compileText(node.text);

                packer.addStatic({
                    name: `TEXT_${node.name}`,
                    size: textData.buffer.getLength(),
                    data: textData.buffer
                });
                /*
                packer.addStatic(textData.binary.length, (address) => {
                    //label.push({name: `TEXT_${node.name}`, value: address});
                    return textData.binary;
                });
                */
            }
        }

        if(jsonData.item) {

            const items = [];

            for(let i=0; i<jsonData.item.length; ++i) {
                const node = jsonData.item[i];

                // Add this item to the output
                //const itemData = compileItem(node);
                //packer.addStatic(itemData.binary.length, () => {
                //    label.push({name: `ITEM_${node.name}`, value: i + 1});
                //    return itemData.binary;
                //});

                // Add this item's text to the output
                const textData = this.compileText(node.text);
                /*
                items.push(
                    packer.addStatic(textData.binary.length, (address) => {
                        //label.push({name: `TEXT_${node.name}`, value: address});
                        return textData.binary;
                    });
                );
                */
                packer.addStatic({
                    name: `TEXT_ITEM_${node.name}`,
                    size: textData.buffer.getLength(),
                    data: textData.buffer
                });

                
            }


            /*
            packer.addTwoDimensional(items.length, (address) => {
                label.push({name: `TABLE_ITEM_NAME_LO`, value: address});
                return items.map(a => String.fromCharCode(a.node.address & 0xFF)).join('');
            });
            packer.addTwoDimensional(items.length, (address) => {
                label.push({name: `TABLE_ITEM_NAME_HI`, value: address});
                return items.map(a => (a.node.address >> 8) & 0xFF).join('');
            });
            */

        }


        return packer.build();

        /*
        return {
            label: translateLabel(label),
            buffer: Buffer.from(output, 'binary'),
        }
        */
    }

    compileItem() {

        return {binary: ''};
    }

    compileText(input) {
        const dict = {
            '/': 26,
            '0': 32,
            '1': 33,
            '2': 34,
            '3': 35,
            '4': 36,
            '5': 37,
            '6': 38,
            '7': 39,
            '8': 40,
            '9': 41,
            'A': 42,
            'B': 43,
            'C': 44,
            'D': 45,
            'E': 46,
            'F': 47,
            'G': 48,
            'H': 49,
            'I': 50,
            'J': 51,
            'K': 52,
            'L': 53,
            'M': 54,
            'N': 55,
            'O': 56,
            'P': 57,
            'Q': 58,
            'R': 59,
            'S': 60,
            'T': 61,
            'U': 62,
            'V': 63,
            'W': 64,
            'X': 65,
            'Y': 66,
            'Z': 67,
            'a': 68,
            'b': 69,
            'c': 70,
            'd': 71,
            'e': 72,
            'f': 73,
            'g': 74,
            'h': 75,
            'i': 76,
            'j': 77,
            'k': 78,
            'l': 79,
            'm': 80,
            'n': 81,
            'o': 82,
            'p': 83,
            'q': 84,
            'r': 85,
            's': 86,
            't': 87,
            'u': 88,
            'v': 89,
            'w': 90,
            'x': 91,
            'y': 92,
            'z': 93,
            '\'':94,
            ',': 95,
            '.': 96,
            ' ': 97,
            '-': 98,
            '"': 99,
            '!': 100,
            '?': 101,
            '\n': 127,
        };

        let mode = 'FREE';
        let commandString = '';


        let output = '';
        const buffer = new BinaryBuffer();
        for(let i=0; i<input.length; ++i) {
            const char = input[i]

            if(mode === 'FREE') {
                if(char === '{') {
                    mode = 'COMMAND';
                } else {
                    const val = dict[char];
                    if(typeof val === 'undefined') {
                        throw new Error(`Invalid character "${char}" in text: "${input}"`);
                    }
                    buffer.push(val);
                }
            } else if(mode === 'COMMAND') {
                if(char === '}') {
                    this.translateCommand(commandString, buffer);
                    commandString = '';
                    mode = 'FREE';
                } else {
                    commandString += char;
                }
            }
        }


        buffer.push(0); // Terminator

        return {buffer: buffer};
    }

    translateCommand(commandString, buffer) {
        const segment = commandString.split(' ');
        switch(segment[0]) {
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
                const address = this.getPositiveInteger(segment[1]);
                const lo = address & 0xFF;
                const hi = (address >> 8) & 0xFF;
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
            case 'SUBSTRING':
                const address = getPositiveInteger(segment[1]);
                const lo = address & 0xFF;
                const hi = (address >> 8) & 0xFF;
                buffer.push(128);
                buffer.push(hi);
                buffer.push(lo);
                break;
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
            case 'ADDRESS': {
                const address = getPositiveInteger(segment[1]);
                const lo = address & 0xFF;
                const hi = (address >> 8) & 0xFF;
                const length = getPositiveInteger(segment[2]) + 1;
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
        return buffer;
    }

    getPositiveInteger(n) {
        if(n.charAt(0) === '$') {
            return parseInt(n.substring(1), 16);
        } else if(n >>> 0 === parseFloat(n)) {
            return parseFloat(n);
        } else {
            throw new Error(`Invalid input, must be positive integer, got "${n}" instead`);
        }
    }

    translateLabel(input) {
        let output = '';
        for(let i=0; i<input.length; ++i) {
            const label = input[i];
            const address = label.value;
            output += `${label.name} := $${address.toString(16)}\n`
        }
        return output;
    }
}

class Main {
    // Main function
    static async main() {
        const dataFolder = 'src/data/';
        const binaryFilePath = 'src/bin/text.bin'; // Path for output binary file
        const labelFilePath = 'src/bin/text.inc'; // Path for output label file
        // Read JSON data
        const jsonData = await Main.processDirectory('data/');
        if (!jsonData) {
            console.error("Failed to read JSON file. Exiting.");
            return;
        }

        const preprocessor = new Preprocessor();

        const files = preprocessor.processJson(jsonData);

        for(let i=0; i<files.length; ++i) {
            // Write binary data to file
            await fs.writeFile(`${dataFolder}${files[i].name}`, files[i].output, 'utf8');
        }
    }
    // Function to read a JSON file and log its contents
    static async readJsonFile(filePath, output) {
        try {
            const data = await fs.readFile(filePath, 'utf8');
            const content = JSON.parse(data);
            const keys = Object.keys(content);
            for(let i=0; i<keys.length; ++i) {
                const key = keys[i];
                output[key] = output[key] ?? [];
                for(let j=0; j<content[key].length; ++j) {
                    const thing = content[key][j];
                    if(!!output[key].find(a => a.name === thing.name)) {
                        throw new Error(`The data ${thing.name} appears more than once`);
                    }
                    output[key].push(thing);
                }
            }
        } catch (err) {
            console.error(`Error reading file ${filePath}: ${err}`);
        }
    }

    // Recursive function to process all files in the directory
    static async processDirectory(directory, output = {}) {
        try {
            const entries = await fs.readdir(directory, { withFileTypes: true });
            for(const entry of entries) {
                const entryPath = path.join(directory, entry.name);
                if (entry.isDirectory()) {
                    await Main.processDirectory(entryPath, output); // Recurse into subdirectories
                } else if (entry.isFile() && entry.name.endsWith('.json')) {
                    await Main.readJsonFile(entryPath, output); // Read JSON files
                }
            }
            return output;
        } catch(err) {
            console.error(`Error processing directory ${directory}: ${err}`);
        }
    }
}

// Execute main function
await Main.main();

process.exit(0);

/*
AllocateStatic
    Allocates into pages at 256 byte increments that are aligned
AllocateTableStatic
    Will split into separate tables to account for the length of the children
AllocateTableReference
    Will split into a hi and lo table for the pointer
        Allocate children to the same page that the table is stretching into.
        If children are of equal length, allocate them right after the table
        If children are of different length, allocate them at the bottom of the page
AllocateTablePointer
    Will split into a hi, lo, and bank table for existing allocations.
*/

