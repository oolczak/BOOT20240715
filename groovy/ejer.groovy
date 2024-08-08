// import javax.swing.JOptionPane

// def cad = JOptionPane.showInputDialog("Pide en GroovyConsole:")
// println "Entrada: $cad"


// Scanner teclado = new Scanner(System.in) 
// println "Pide en linea de comando:" 
// def cad = teclado.nextLine() 
// println "Entrada: $cad"


var rnd = new Random() 
def num = rnd.nextInt(10)
println "Aleatorio: $num"

println "Calcula: ${cad + 1} <> ${cad as Integer + 1} == ${cad.toInteger() + 1}"
println "Conv: ${Integer.parseInt(cad) + 1} ${(int)cad + 1}"
