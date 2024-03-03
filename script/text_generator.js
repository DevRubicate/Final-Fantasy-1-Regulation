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
        '\n': 255,
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
    const segment = commandString.split(' ');
    switch(segment[0]) {
        case 'SET_HERO':
            const index = getPositiveInteger(segment[1]);
            return String.fromCharCode(254) + String.fromCharCode(String(index));
        case 'HERO':
            switch(segment[1]) {
                case 'NAME':
                    return String.fromCharCode(253) + String.fromCharCode(0);
                default:
                    throw new Error('Invalid HERO command');
            }
        default:
            throw new Error('Invalid command');
    }
}

function getPositiveInteger(n) {
    if(n >>> 0 === parseFloat(n)) {
        return parseFloat(n);
    } else {
        throw new Error('Invalid input, must be positive integer');
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
