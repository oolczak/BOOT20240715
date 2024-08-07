// Tablas de multiplicar
for(def tabla in 1..10) {
    println "Tabla del $tabla"
    for(def factor in 1..10) {
        println "$factor x $tabla = ${factor * tabla}"
    }
}

// Calcula el factorial de un número
def num =javax.swing.JOptionPane.showInputDialog("Número a factorizar:") as Integer
def result = 1
for(def i=num; i > 1; result *= i--);
println "El factorial de $num es $result"

// Crear una función que valide un NIF
def nif = javax.swing.JOptionPane.showInputDialog("NIF:")
if (nif =~ /^\d{1,8}[A-Za-z]$/) {
    def letterValue = nif[-1]
    def numberValue = Integer.parseInt(nif.substring(0, nif.length() - 1))
    if(letterValue.toUpperCase() == 'TRWAGMYFPDXBNJZSQVHLCKE'[numberValue % 23])
        println "Valido"
    else
        println "Invalido"
} else {
    println "Formato invalido"
}

// Muestra los números primos entre 1 y 100.
var maximo = 100
var rslt = []
var candidato = 2
    while (maximo > candidato) {
        var esPrimo = true
        for (var indice in rslt) {
            if (candidato % indice == 0) {
                esPrimo = false
                break
            }
        }

        candidato++
        if (esPrimo) {
            if (candidato < maximo)
               rslt << (candidato - 1)
        }
    }
rslt.each { print "$it " } 

// Juego de “Adivina el número que estoy pensando”, un número del 1 al 100, ya te diré si es mayor o menor que el mío, pero tienes 10 intentos como mucho.
var rnd = new Random() 
def numeroBuscado = rnd.nextInt(100) + 1
def numeroIntroducido;
def intentos = 0;
def encontrado = false;
do {
    intentos += 1;
    numeroIntroducido = (javax.swing.JOptionPane.showInputDialog("Dame tu numero (${intentos} de 10) [${numeroBuscado}]:")?:"0") as Integer
    if (numeroBuscado == numeroIntroducido) {
        encontrado = true;
        break;
    } else if (numeroBuscado > numeroIntroducido) {
        println 'Mi número es mayor.'
    } else {
        println 'Mi número es menor.'
    }
} while (intentos < 10)
if (encontrado) {
    println 'Bieeen!!! Acertaste.'
} else {
    println "Upsss! Se acabaron los intentos, el número era el $numeroBuscado"
}

// Crea un función que reciba un texto y devuelva la vocal que más veces se repita (con y sin tilde son la misma vocal).
def cad = 'La ruta nos aporto otró paso natural de llegar'
cad = cad.toLowerCase()

def rslt = [
    a: (cad =~ /[aá]/).size(),
    e: (cad =~ /[eé]/).size(),
    i: (cad =~ /[ií]/).size(),
    o: (cad =~ /[oó]/).size(),
    u: (cad =~ /[uúü]/).size()
]

println rslt 

rslt = [a: 0, e: 0, i: 0, o: 0, u: 0]
for(def letra in cad)
    switch(letra) {
        case ['a', 'á']: rslt.a++; break
        case 'e':
        case 'é':
            rslt.e++; break
        case ['i', 'í']: rslt.i++; break
        case ~/[oó]/: rslt.o++; break
        case ~/[uúü]/: rslt.u++; break
    }
println rslt 
def letra = '', max = 0
rslt.each { key, value -> if(value > max) {letra=key; max=value} }
println "La vocal mas repetida es la '$letra' ($max ${max > 1 ? 'repeticiones':'repetición'})"
//rslt.sort { a, b -> a.value <=> b.value }


// Definir una función que determine si la cadena de texto que se le pasa como parámetro es un palíndromo, es decir, si se lee de la misma forma desde la izquierda y desde la derecha. Ejemplo de palíndromo complejo: "La ruta nos aporto otro paso natural".
// def esPalindromo(cadena) {
//     cadena = cadena.replace(/[ .,;:#¿?¡!()[\]{}=+\-*/_`~$%^&'"]/, '').toLowerCase();
//     for (let i = 0; i < cadena.length - i; i++) {
//         if (cadena.charAt(i) !== cadena.charAt(cadena.length - 1 - i)) return false;
//     }
//     return true;
// }
