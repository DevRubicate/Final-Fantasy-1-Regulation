const fs = require('fs');

// Function to read JSON file
function readJSONFile(filePath) {
    const jsonData = fs.readFileSync(filePath, 'utf8');
    return JSON.parse(jsonData);
}

// Function to write binary file
function writeFile(filePath, data) {
    fs.writeFileSync(filePath, data, 'binary');
}

function processJson(jsonData) {
    const label = [];
    let output = '';
    for(let i=0; i<jsonData.length; ++i) {
        const node = jsonData[i];
        const binText = translateText(node.text);
        label.push({name: node.label, offset: output.length});
        output += binText;
    }
    output = output.padEnd(0x4000, String.fromCharCode(0))
    return {
        label: translateLabel(label),
        buffer: Buffer.from(output, 'binary'),
    }
}

function translateText(input) {
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
                output += String.fromCharCode(val);
            }
        } else if(mode === 'COMMAND') {
            if(char === '}') {
                output += translateCommand(commandString);
                commandString = '';
                mode = 'FREE';
            } else {
                commandString += char;
            }
        }
    }
    return output + String.fromCharCode(0);
}

function translateCommand(commandString) {
    let output = '';
    const segment = commandString.split(' ');
    switch(segment[0]) {
        case 'BYTE':
            output += String.fromCharCode(128) + String.fromCharCode(getPositiveInteger(segment[1]));
            break;
        case 'WORD': {
            const value = getPositiveInteger(segment[1]);
            const byte1 = value & 0xFF;
            const byte2 = (value >> 8) & 0xFF;
            output += String.fromCharCode(129) +
                      String.fromCharCode(byte1) +
                      String.fromCharCode(byte2);
            break;
        }
        case 'TRIBYTE': {
            const value = getPositiveInteger(segment[1]);
            const byte1 = value & 0xFF;
            const byte2 = (value >> 8) & 0xFF;
            const byte3 = (value >> 16) & 0xFF;
            output += String.fromCharCode(130) +
                      String.fromCharCode(byte1) +
                      String.fromCharCode(byte2) +
                      String.fromCharCode(byte3);
            break;
        }
        case 'READ8': {
            const address = getPositiveInteger(segment[1]);
            const lo = address & 0xFF;
            const hi = (address >> 8) & 0xFF;
            output +=   String.fromCharCode(131) +
                        String.fromCharCode(hi) +
                        String.fromCharCode(lo);
            break;
        }
        case 'READ16': {
            const address = getPositiveInteger(segment[1]);
            const lo = address & 0xFF;
            const hi = (address >> 8) & 0xFF;
            output +=   String.fromCharCode(132) +
                        String.fromCharCode(hi) +
                        String.fromCharCode(lo);
            break;
        }
        case 'READ24': {
            const address = getPositiveInteger(segment[1]);
            const lo = address & 0xFF;
            const hi = (address >> 8) & 0xFF;
            output +=   String.fromCharCode(133) +
                        String.fromCharCode(hi) +
                        String.fromCharCode(lo);
            break;
        }
        case 'ADD':
            output +=   String.fromCharCode(134);
            break;
        case 'SUB':
            output +=   String.fromCharCode(135);
            break;
        case 'DIV':
            output +=   String.fromCharCode(136);
            break;
        case 'MUL':
            output +=   String.fromCharCode(137);
            break;
        case 'MAX':
            output +=   String.fromCharCode(138);
            break;
        case 'MIN':
            output +=   String.fromCharCode(139);
            break;
        case 'AND':
            output +=   String.fromCharCode(140);
            break;
        case 'OR':
            output +=   String.fromCharCode(141);
            break;
        case 'XOR':
            output +=   String.fromCharCode(142);
            break;
        case 'HERO_LEVEL':
            output += String.fromCharCode(143);
            break;
        case 'HERO_HP':
            output += String.fromCharCode(144);
            break;
        case 'HERO_MAXHP':
            output += String.fromCharCode(145);
            break;
        case 'HERO_SPELLCHARGE1':
            output += String.fromCharCode(146);
            break;
        case 'HERO_SPELLCHARGE2':
            output += String.fromCharCode(147);
            break;
        case 'HERO_SPELLCHARGE3':
            output += String.fromCharCode(148);
            break;
        case 'HERO_SPELLCHARGE4':
            output += String.fromCharCode(149);
            break;
        case 'HERO_SPELLCHARGE5':
            output += String.fromCharCode(150);
            break;
        case 'HERO_SPELLCHARGE6':
            output += String.fromCharCode(151);
            break;
        case 'HERO_SPELLCHARGE7':
            output += String.fromCharCode(152);
            break;
        case 'HERO_SPELLCHARGE8':
            output += String.fromCharCode(153);
            break;
        case 'HERO_MAXSPELLCHARGE1':
            output += String.fromCharCode(154);
            break;
        case 'HERO_MAXSPELLCHARGE2':
            output += String.fromCharCode(155);
            break;
        case 'HERO_MAXSPELLCHARGE3':
            output += String.fromCharCode(156);
            break;
        case 'HERO_MAXSPELLCHARGE4':
            output += String.fromCharCode(157);
            break;
        case 'HERO_MAXSPELLCHARGE5':
            output += String.fromCharCode(158);
            break;
        case 'HERO_MAXSPELLCHARGE6':
            output += String.fromCharCode(159);
            break;
        case 'HERO_MAXSPELLCHARGE7':
            output += String.fromCharCode(160);
            break;
        case 'HERO_MAXSPELLCHARGE8':
            output += String.fromCharCode(161);
            break;
        case 'SUBSTRING':
            const address = getPositiveInteger(segment[1]);
            const lo = address & 0xFF;
            const hi = (address >> 8) & 0xFF;
            output +=   String.fromCharCode(128) +
                        String.fromCharCode(hi) +
                        String.fromCharCode(lo);
            break;
        case 'DIGIT1':
            output += String.fromCharCode(129);
            break;
        case 'DIGIT2L':
            output += String.fromCharCode(130);
            break;
        case 'DIGIT2R':
            output += String.fromCharCode(131);
            break;
        case 'DIGIT3L':
            output += String.fromCharCode(132);
            break;
        case 'DIGIT3R':
            output += String.fromCharCode(133);
            break;
        case 'DIGIT4L':
            output += String.fromCharCode(134);
            break;
        case 'DIGIT4R':
            output += String.fromCharCode(135);
            break;
        case 'DIGIT5L':
            output += String.fromCharCode(136);
            break;
        case 'DIGIT5R':
            output += String.fromCharCode(137);
            break;
        case 'DIGIT6L':
            output += String.fromCharCode(138);
            break;
        case 'DIGIT6R':
            output += String.fromCharCode(139);
            break;
        case 'DIGIT7L':
            output += String.fromCharCode(140);
            break;
        case 'DIGIT7R':
            output += String.fromCharCode(141);
            break;
        case 'DIGIT8L':
            output += String.fromCharCode(142);
            break;
        case 'DIGIT8R':
            output += String.fromCharCode(143);
            break;
        case 'SET_HERO':
            output += String.fromCharCode(144);
            break;
        case 'HERO_NAME':
            output += String.fromCharCode(145);
            break;
        case 'HERO_CLASS':
            output += String.fromCharCode(146);
            break;
        case 'ADDRESS': {
            const address = getPositiveInteger(segment[1]);
            const lo = address & 0xFF;
            const hi = (address >> 8) & 0xFF;
            const length = getPositiveInteger(segment[2]) + 1;
            output +=   String.fromCharCode(251) +
                        String.fromCharCode(255) +
                        String.fromCharCode(hi) +
                        String.fromCharCode(255) +
                        String.fromCharCode(lo) +
                        String.fromCharCode(255) +
                        String.fromCharCode(length);
            break;
        }
        default:
            throw new Error(`Invalid command: ${segment[0]}`);
    }
    return output;
}
function getPositiveInteger(n) {
    if(n.charAt(0) === '$') {
        return parseInt(n.substring(1), 16);
    } else if(n >>> 0 === parseFloat(n)) {
        return parseFloat(n);
    } else {
        throw new Error(`Invalid input, must be positive integer, got "${n}" instead`);
    }
}

function translateLabel(input) {
    let output = '';
    for(let i=0; i<input.length; ++i) {
        const label = input[i];
        const address = label.offset + 0xC000;
        output += `${label.name} := $${address.toString(16)}\n`
    }
    return output;
}

// Main function
function main() {
    const jsonFilePath = 'data/text.json'; // Path to your JSON file
    const binaryFilePath = 'src/bin/text.bin'; // Path for output binary file
    const labelFilePath = 'src/bin/text.inc'; // Path for output label file

    // Read JSON data
    const jsonData = readJSONFile(jsonFilePath);
    if (!jsonData) {
        console.error("Failed to read JSON file. Exiting.");
        return;
    }

    const { label, buffer } = processJson(jsonData);

    // Write binary data to file
    writeFile(binaryFilePath, buffer);

    // Write label to file
    writeFile(labelFilePath, label);
}

process.on('uncaughtException', function(error) {
    console.log(error)
    process.exit(1);
});

// Execute main function
main();

process.exit(0);
