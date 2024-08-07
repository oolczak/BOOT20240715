import groovy.transform.*

@ToString @EqualsAndHashCode
class Punto {

    int x, y

    Punto plus(Punto p) {
        new Punto([x: x + p.x, y: y + p.y])
    }

    Punto plus(int delta) {
        new Punto([x: x + delta, y: y + delta])
    }
    
    Punto minus(Punto p) {
        new Punto([x: x - p.x, y: y - p.y])
    }

}

def p1 = new Punto([x: 10, y: 5]), p2 = new Punto([x: 5, y: 10])
assert (p1 + p2) == new Punto([x: 15, y: 15])
assert (p1 + 1) == new Punto([x: 11, y: 6])
assert (p1 - p2) == new Punto([x: 5, y: -5])
println 'ok'

