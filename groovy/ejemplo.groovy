/*
def number = 1L, algo = 'hola'
def cad = 'Dime\n $algo'
cad = "Dime\n ${algo}" +
    " seguir";
cad = "Dime\n ${->algo}"
println cad
algo = 'adios'
println cad
cad = "Numero: ${->number++ + 1}"
println cad
println cad

def ex = $/$/ $$number \d/$

cad = """\
Esta\
salta
de linea $number
"""
println cad
int n = 1L
println n / 2d
*/
/*
def vacia = []
def letters = ['a', 'b', 'c', 'd']
assert letters[0] == 'a'   
assert letters[-1] == 'd'
assert letters[-4] == 'a'
letters << 'e'               
assert letters[1, 3] == ['b', 'd']         
assert letters[2..4] == ['c', 'd', 'e'] 
assert letters[-5] == 'a'

def ints = '1'..'9' // new IntRange(1, 10)
ints = ints.step(2)
ints.each { print "$it " } 
assert ints.from == '1'
assert ints.to == '9'
println ints.toString()
assert ints == ['1','3','5','7','9']
assert ints.class.name == 'groovy.lang.IntRange'
*/

def regex = ~/\d[A-Za-z]/
assert 'ss12345678zkk' =~ regex

a += 1 // a = a + 1

if( a?.m()?.algo?.otro?[0]?.prop != null) {
}
r = a?.m()?.algo
println 'termine'

class Persona {
 def plus(Persona p) {
     new Persona()
 }
 def plus(int p) {
     new Persona()
 }
}

Persona p1, p2, p3

p3 = p1 + p2
p3 = p1 + "1"
p3 = p1.plus(p2)



