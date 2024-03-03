const fs = require('fs');

// Function to read JSON file
function readJSONFile(filePath) {
    try {
        const jsonData = fs.readFileSync(filePath, 'utf8');
        return JSON.parse(jsonData);
    } catch (error) {
        console.error("Error reading JSON file:", error);
        return null;
    }
}

// Function to write binary file
function writeFile(filePath, data) {
    try {
        fs.writeFileSync(filePath, data, 'binary');
        console.log("File created successfully:", filePath);
    } catch (error) {
        console.error("Error writing file:", error);
    }
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
        'A': 1,
        'B': 2,
        'C': 3,
        'D': 4,
        'E': 5,
        'F': 6,
        'G': 7,
        'H': 8,
        'I': 9,
        'J': 10,
        'K': 11,
        'L': 12,
        'M': 13,
        'N': 14,
        'O': 15,
        'P': 16,
        'Q': 17,
        'R': 18,
        'S': 19,
        'T': 20,
        'U': 21,
        'V': 22,
        'W': 23,
        'X': 24,
        'Y': 25,
        'Z': 26,
        'a': 27,
        'b': 28,
        'c': 29,
        'd': 30,
        'e': 31,
        'f': 32,
        'g': 33,
        'h': 34,
        'i': 35,
        'j': 36,
        'k': 37,
        'l': 38,
        'm': 39,
        'n': 40,
        'o': 41,
        'p': 42,
        'q': 43,
        'r': 44,
        's': 45,
        't': 46,
        'u': 47,
        'v': 48,
        'w': 49,
        'x': 50,
        'y': 51,
        'z': 52,
        '\'': 53,
        ',': 54,
        '.': 55,
        ' ': 56,
        '-': 57,
        '!': 59,
        '?': 60,
    };

    let output = '';
    for(let i=0; i<input.length; ++i) {
        const char = input[i]
        const val = dict[char];
        if(typeof val === 'undefined') {
            throw new Error(`Invalid character "${char}" in text: "${input}"`);
        }
        output += String.fromCharCode(val);
    }
    return output + String.fromCharCode(0);
}

function translateLabel(input) {
    let output = '';
    for(let i=0; i<input.length; ++i) {
        const label = input[i];
        const address = label.offset + 0xC000;
        output += `TEXT_${label.name} := $${address.toString(16)}\n`
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
