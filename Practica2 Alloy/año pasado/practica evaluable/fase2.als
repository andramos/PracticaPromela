module fase2

// Signaturas y relaciones
// 1.) Define la signatura Objeto como abstracta.
abstract sig Objeto {}

// 1.) Define dos nuevas signaturas Directorio y Fichero como los dos unicos tipos de objetos.
sig Directorio extends Objeto {}

sig Fichero extends Objeto
{
	// 4.c) fcontenido, que asocia cada fichero con el dato (de Datos) que contiene, si no esta vacio
	fcontenido : lone Datos,
	// 4.d) estado, que asocia cada fichero con su estado (de Estado)
	estado : one Estado,
	// 4.e) fbuffers, que asocia cada fichero con 0/1 buffer (de Buffer)
	fbuffers : lone Buffer
}

sig SistemaFicheros
{
	// 1.) Redefine las relaciones raiz y hijos de manera que la raiz y el padre de cualquier objeto
	//      del sistema deba ser un Directorio
	raiz : one Directorio,
	hijos : Directorio -> set Objeto,
	cont : set Objeto,
	// 4.f ) Dentro de la signatura SistemaFicheros define la relacion buffers que asocia a cada sistema
	//        de ficheros con el conjunto de sus buffers
	buffers : set Buffer
}

//	2.) Define dos signaturas Datos y Buffer para representar, de forma muy abstracta, el contenido
//      de los ficheros, y los buffers de la memoria.
sig Datos
{
	// 4.a) igual, que asocia cada dato con el conjunto de datos que son iguales a el
	igual : set Datos
}

sig Buffer
{
	// 4.b) bcontenido, que asocia cada buffer con el dato (de Datos) que contiene, si no esta vacio
	bcontenido : lone Datos
}

// 3.) Define la signatura abstracta Estado, que tiene solo dos atomos, Abierto y Cerrado, que
//      representan el estado de los ficheros.
abstract sig Estado {}

one sig Abierto, Cerrado extends Estado {}

// Restricciones globales sobre el sistema
fact
{
	all s : SistemaFicheros | one s.raiz && no padre[s, s.raiz]
	
	all s : SistemaFicheros, o : s.cont - s.raiz | one padre[s, o]
	
	all s : SistemaFicheros | s.raiz + descendientes[s, s.raiz] = s.cont
	
	no s : SistemaFicheros | some o : s.cont | o in  descendientes[s, o]
	
	all s : SistemaFicheros, o : s.cont - s.raiz | o in descendientes[s, s.raiz]

	// 5.a) La relacion igual es simetrica, es decir, el dato D0 es igual a D1 si, y solo si, D1 es igual a D0.
	all disj d1, d2 : Datos | d1 in d2.igual <=> d2 in d1.igual

	// 5.b) Un fichero tiene asociado un buffer si, y solo si, esta abierto
	all f : Fichero |  some f.fbuffers <=> f.estado = Abierto

	// 5.c) No es posible que dos ficheros distintos tengan asociado el mismo buffer
	no disj f1, f2 : Fichero | f1.fbuffers = f2.fbuffers

	// 5.d) Si un fichero tiene asociado un buffer (mediante fbuffer), este debe ser uno de los del sistema de
	//        ficheros en el que se encuentra
	all f : Fichero | some f.fbuffers => buffers.(f.fbuffers) = cont.f

	// 5.e) El buffer asociado a un fichero, o esta vacio o contiene un dato igual que el del fichero
	all b : Buffer | some fbuffers.b => no b.bcontenido || b.bcontenido in (fbuffers.b).fcontenido.igual

	// 5.f ) Un dato no puede ser el contenido de dos ficheros distintos
	all d : Datos | no disj f1, f2 : Fichero | f1.fcontenido = d && f2.fcontenido = d

	// g) Un dato no puede ser el contenido de dos buffers distintos
	all d : Datos | no disj b1, b2 : Buffer | b1.bcontenido = d && b2.bcontenido = d

	// h) Los buffers y los ficheros no comparten datos.
	all d : Datos | (some fcontenido.d => no bcontenido.d) && (some bcontenido.d => no fcontenido.d)
}

// Funciones
fun padre (s : SistemaFicheros, o : Objeto) : Objeto
{
	(s.hijos).o
}

fun descendientes (s : SistemaFicheros, o : Objeto) : set Objeto
{
	o.^(s.hijos)
}

fun subarbol (s : SistemaFicheros, o : Objeto) : Objeto -> Objeto
{
	(o + descendientes[s, o]) <: s.hijos
}

// Predicados
pred show ()
{
	// Restricciones para ver mejor los ejemplos
	#SistemaFicheros = 1
	all o : Objeto | some cont.o
	all b : Buffer | some f : Fichero | f.fbuffers = b && some f.fcontenido && some b.bcontenido
	some estado.Cerrado
	some f : Fichero | no f.fbuffers	
}

run show for 4
