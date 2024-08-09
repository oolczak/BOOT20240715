/*
class Person {
    String name
    public def apellidos;
    
    void setName(String valor) {
        if(!valor)
            throw new Exception('valor invalido');
        this.name = valor.toUpperCase()
    }
    boolean isValid() { name != null }
}

def p = new Person()
p.apellidos = null;
//p.name = ''
p.name = 'Pepito'
assert p.valid
assert p.name == 'Pepito'
p.setName('PEPITO')
assert p.getName() == 'PEPITO'
*/

def detalle(Map args) { "Nombre: ${args.name}, Edad: ${args.age}" }
println detalle(name: 'Marie', age: 1)

def saluda(nombre = 'mundo') {
    println "Hola $nombre"
}
saluda('tu')
saluda()

double avg(int fijo1, int... lista) { 
    (lista.sum() + fijo1) / (lista.size() + 1)
}
println avg(1,2,3,4)


def a = 5, b = 7
def si(boolean condicion, Closure hacer) {
    if(condicion) hacer()
}
si(a < b) { println "es mayor" }

class Person {
    String name
    public def apellidos;
    
    void setName(String valor) {
        if(!valor)
            throw new Exception('valor invalido');
        this.name = valor.toUpperCase()
    }
    boolean isValid() { name != null }
    Person() {}
    Person(String name) {
        this.name = name
    }
}

def p = new Person(name: 'PP', apellidos: 'illo')
assert p.name == 'PP'
assert p.apellidos == 'illo'

//p.setApellidos('ll')

interface ICompararLambda {
        public boolean compara(String a, String b)
}

String extrae(List<String> lista, ICompararLambda operar) { 
    for(def i = 0; i < (lista.size() - 1); i++)
        if(operar.compara(lista[i], lista[i+1])) return lista[i];
    ''
}

def lst = ["uno", "uno", "dos", "tres"];
def s = extrae(lst, new ICompararLambda() {
            @Override
            public boolean compara(String a, String b) {
                return a.compareTo(b) > 0
            }
        });
println s
s = extrae(lst, (a, b) -> a.compareTo(b) > 0)
println s
s = extrae(lst, (a, b) -> a.compareTo(b) < 0)
println s
s = extrae(lst, {a, b -> a.compareTo(b) > 0} /* as ICompararLambda */ )

@FunctionalInterface
interface ICompararLambda {
        public boolean compara(String a, String b)
}

String extrae(List<String> lista, ICompararLambda operar) { 
    for(def i = 0; i < (lista.size() - 1); i++)
        if(operar.compara(lista[i], lista[i+1])) return lista[i];
    return ''
}
s -> s.length() > 0
String extrae(List<String> lista, Predicate<String> operar) { 
    for(def i = 0; i < (lista.size() - 1); i++)
        if(operar.compara(lista[i], lista[i+1])) return lista[i];
    return ''
}

def lst = ["uno", "uno", "dos", "tres"];
def s = extrae(lst, new ICompararLambda() {
            @Override
            public boolean compara(String a, String b) {
                return a.compareTo(b) > 0
            }
        });
       
s = extrae(lst, (a, b) -> {
    var A = a.toLowerCase();
    // ...
    return A.compareTo(b) > 0
})
s = extrae(lst, {a, b -> a.compareTo(b) < 0} as ICompararLambda)
s = extrae(lst, o::x)

def fn = {a, b -> a.compareTo(b) > 0} 
fn.call('a','b')
fn('a','b')

ICompararLambda comp = (a, b) -> a.compareTo(b) > 0;
//comp.compara('a','b')

