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

class Person {
    String name
    public def apellidos;
    
    void setName(String valor) {
        if(!valor)
            throw new Exception('valor invalido');
        this.name = valor.toUpperCase()
    }
    boolean isValid() { name != null }
    Person() {
        super('')
    }
    Person(String name) {
        this.name = name;
    }
}

def p = new Person(name: 'PP', apellidos: 'illo')
assert p.name == 'PP'
assert p.apellidos == 'illo'

