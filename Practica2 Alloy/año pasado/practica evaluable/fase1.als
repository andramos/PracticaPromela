module fase1

// Signaturas y relaciones
sig Objeto {}

sig SistemaFicheros
{
	// 1.a) raiz asocia cada sistema de ficheros con su objeto raiz.
	raiz : one Objeto,
	// 1.b) hijos asocia cada sistema de ficheros con la relacion padre/hijos dentro de la estructura.
	hijos : Objeto -> set Objeto,
	// 1.c) cont relaciona cada sistema de ficheros con el conjunto de objetos que contiene.
	cont : set Objeto
}

// Restricciones globales sobre el sistema
fact
{
	// 2.a) Cada sistema de ficheros contiene un unico objeto raiz que no tiene padre.
	all s : SistemaFicheros | one s.raiz && no padre[s, s.raiz]
	
	// 2.b) En cada sistema de ficheros, todos los objetos, salvo el raiz, tienen un unico padre.
	all s : SistemaFicheros, o : s.cont - s.raiz | one padre[s, o]
	
	// 2.c) La relacion cont asocia cada sistema de ficheros con los nodos alcanzables (mediante
	// la relacion hijos) desde el nodo raiz
	all s : SistemaFicheros | s.raiz + descendientes[s, s.raiz] = s.cont
	
	// 2.d) Ningun sistema de ficheros contiene ciclos.
	no s : SistemaFicheros | some o : s.cont | o in  descendientes[s, o]
	
	// 2.e) Todos los objetos del sistema de ficheros son alcanzables desde el objeto raiz
	all s : SistemaFicheros, o : s.cont - s.raiz | o in descendientes[s, s.raiz]
}

// Funciones
fun padre (s : SistemaFicheros, o : Objeto) : Objeto
{
	// 3.a) La funcion padre que devuelve el objeto que es el padre de o en el sistema de ficheros s
	(s.hijos).o
}

fun descendientes (s : SistemaFicheros, o : Objeto) : set Objeto
{
	// 3.b) La funcion descendientes que devuelve el conjunto de objetos que son descendientes de
	//        o en el sistema de ficheros s
	o.^(s.hijos)
}

fun subarbol (s : SistemaFicheros, o : Objeto) : Objeto -> Objeto
{
	// 3.c) La funcion subarbol que devuelve el subarbol del sistema de ficheros s que tiene como
	//        raiz el objeto o
	(o + descendientes[s, o]) <: s.hijos
}

// Predicados
pred show ()
{
	// Restricciones para ver mejor los ejemplos
	#SistemaFicheros = 1
	all o : Objeto | some cont.o
}

run show for 4
