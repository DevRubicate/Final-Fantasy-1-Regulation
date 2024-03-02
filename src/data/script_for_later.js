const fs = require('fs');
const path = require('path');

// Specify the directory where you want to create the files
const directory = 'D:/sync/repo/final-fantasy-1-regulation/src/data';

// Set the starting index
const startIndex = 63;

// Set the number of files to create
const numFiles = 1;

// Function to zero-pad the number with leading zeros
function zeroPad(num) {
    return num.toString().padStart(3, '0');
}

// Create files starting from data_063.asm to data_112.asm, each containing "DATA_XXX"
for (let i = startIndex; i < startIndex + numFiles; i++) {
    const num = zeroPad(i);
    const fileName = `data_${num}.asm`;
    const filePath = path.join(directory, fileName);
    const fileContent = `.segment "DATA_${num}"`;

    fs.writeFileSync(filePath, fileContent);
    console.log(`Created file ${fileName} with "${fileContent}" content`);
}

console.log('All files created successfully.');
