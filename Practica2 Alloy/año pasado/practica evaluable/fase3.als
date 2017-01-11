module fase3

// Signaturas y relaciones
abstract sig Objeto {}

sig Directorio extends Objeto {}

sig Fichero extends Objeto
{
	fcontenido : lone Datos,
	estado : one Estado,
	fbuffers : lone Buffer
}

sig SistemaFicheros
{
	raiz : one Directorio,
	hijos : Directorio -> set Objeto,
	cont : set Objeto,
	buffers : set Buffer
}

sig Datos
{
	igual : set Datos
}

sig Buffer
{
	bcontenido : lone Datos
}

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

	all disj d1, d2 : Datos | d1 in d2.igual <=> d2 in d1.igual

	all f : Fichero |  some f.fbuffers <=> f.estado = Abierto

	no disj f1, f2 : Fichero | f1.fbuffers = f2.fbuffers

	all f : Fichero | some f.fbuffers => buffers.(f.fbuffers) = cont.f

	all b : Buffer | some fbuffers.b => no b.bcontenido || b.bcontenido in (fbuffers.b).fcontenido.igual

	all d : Datos | no disj f1, f2 : Fichero | f1.fcontenido = d && f2.fcontenido = d

	all d : Datos | no disj b1, b2 : Buffer | b1.bcontenido = d && b2.bcontenido = d

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
pred TodoContIgualSalvo (s, s': SistemaFicheros, o :  Objeto)
{
	all o' : s.cont - o | o' in s'.cont
}

pred RaizIgual (s, s': SistemaFicheros)
{
	s.raiz = s'.raiz
}

pred TodoHijoIgualSalvo (s, s': SistemaFicheros, h : Directorio -> Objeto)
{
	all h' : s.hijos - h | h' in s'.hijos
}

pred TodoBufferIgual (s, s': SistemaFicheros)
{
	s.buffers = s'.buffers
}

// 1.a) crear que construye el sistema de ficheros s', añadiendo el objeto o al sistema de ficheros s
//        como hijo de padre.
pred crear (s, s' : SistemaFicheros, p, o : Objeto)
{
	// Precondiciones
	not o in s.cont
	p in s.cont
	
	// Postcondiciones
	o in s'.cont
	o in descendientes[s', p]
	s.hijos + p -> o = s'.hijos
	
	// Condiciones de marco
	TodoContIgualSalvo[s, s', o]
	RaizIgual[s, s']
	TodoHijoIgualSalvo[s, s', p -> o]
	TodoBufferIgual[s, s']
}

// 1.b) mover que construye el sistema de ficheros s', moviendo el subarbol que cuelga del objeto o
//        (incluyendolo) en el sistema de ficheros s, para pasar a ser hijo de padre en s'.
pred mover (s, s' : SistemaFicheros, o, p : Objeto)
{
	// Precondiciones
	o in s.cont
	not o = s.raiz
	p in s.cont
	not p in descendientes[s, o]
	
	// Postcondiciones
	o in p.(s'.hijos)
	
	// Condiciones de marco
	TodoContIgualSalvo[s, s', none]
	RaizIgual[s, s']
	TodoHijoIgualSalvo[s, s', padre[s, o] -> o]
	TodoBufferIgual[s, s']
}

// 1.c) borrar que construye el sistema de ficheros s', borrando el subarbol que cuelga del objeto o
//        (incluyendolo) en el sistema de ficheros s.
pred borrar (s, s' : SistemaFicheros, o : Objeto)
{
	// Precondiciones
	o in s.cont
	not o = s.raiz
	
	// Postcondiciones
	not o in s'.cont
	not descendientes[s, o] in s'.cont
	
	// Condiciones de marco
	
	TodoContIgualSalvo[s, s', none]
	RaizIgual[s, s']
	TodoHijoIgualSalvo[s, s', subarbol[s, o]]
	TodoBufferIgual[s, s']
}

// DIFICIL
// 1.d) copiar que construye el sistema de ficheros s' a partir de s, copiando (duplicando) el subarbol
//        que cuelga del objeto o (incluyendolo) como hijo del objeto padre.
pred copiar (s, s' : SistemaFicheros, o, p : Objeto)
{
	// Precondiciones

	// Postcondiciones

	// Condiciones de marco

}

pred show ()
{
	// Restricciones para ver mejor los ejemplos
	//#SistemaFicheros = 2
	//all o : Objeto | some cont.o
	//all b : Buffer | some f : Fichero | f.fbuffers = b && some f.fcontenido && some b.bcontenido
	//some estado.Cerrado
	//some f : Fichero | no f.fbuffers
}

run show for 4
