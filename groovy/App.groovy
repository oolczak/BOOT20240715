/**
    Clase principal
    @author Yo mismo
    @version 1.0.0
*/
public class App {
	static class Educada {
		private String nombre;
	    
		public Educada() {}
		public Educada(String nombre) { this.nombre = nombre; }
	    
		public String getNombre() { return nombre; }
		public void setNombre(String nombre) { this.nombre = nombre; }

		/**
            Metodo bien educado que saluda
            @return Saluda al nombre de la clase
        */
        public String saluda() { return "Hola " + nombre; }
	}

	public static void main(String[] args) {
		var obj = new Educada("mundo");
		System.out.println(obj.saluda());
		obj.setNombre("tu");
		System.out.println(obj.getNombre());
		System.out.println(obj.saluda());
	}
}
