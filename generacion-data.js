const fs = require('fs');

// Definición de rangos para cada columna (puedes ajustar estos valores según tus necesidades)
const rangeC1 = { start: 21, end: 30 };   // números del 1 al 7
const rangeC2 = { start: 25, end: 33 };   // números del 1 al 6
const rangeC3 = { start: 17, end: 21 };  // números del 1 al 22
const rangeC4 = { start: 1000, end: 5000 }; // números aleatorios entre 1000 y 5000

// Función para generar números aleatorios dentro de un rango
function getRandomNumber(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

// Función para generar todas las combinaciones
function generarCombinaciones() {
    let combinaciones = [];

    for (let numC1 = rangeC1.start; numC1 <= rangeC1.end; numC1++) {
        for (let numC2 = rangeC2.start; numC2 <= rangeC2.end; numC2++) {
            for (let numC3 = rangeC3.start; numC3 <= rangeC3.end; numC3++) {
                let numC4 = getRandomNumber(rangeC4.start, rangeC4.end);
                combinaciones.push(`(4, ${numC1}, ${numC2}, ${numC3}, ${numC4}),`);
            }
        }
    }

    return combinaciones;
}

// Función para escribir las combinaciones en un archivo
function escribirArchivo(combinaciones) {
    const filename = './combinaciones.txt';

    fs.writeFile(filename, combinaciones.join('\n'), err => {
        if (err) {
            console.error('Error al escribir el archivo:', err);
            return;
        }
        console.log(`Se han generado y guardado ${combinaciones.length} combinaciones en ${filename}.`);
    });
}

// Generar las combinaciones y escribir en el archivo
let combinaciones = generarCombinaciones();
escribirArchivo(combinaciones);
