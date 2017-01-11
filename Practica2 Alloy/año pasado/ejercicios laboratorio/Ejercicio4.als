module prision

// Signaturas y relaciones
sig Banda
{
	miembros : set Interno
}

sig Interno
{
	celda : one Celda
}

sig Celda {}

// Restricciones globales sobre el sistema
fact
{
	// a.- Que un preso no pertenezca a mas de una banda.
	all p : Interno | lone miembros.p

	// b.- Que una banda tenga algun miembro.
	all b : Banda | some b.miembros

	// 4.-   Añade una restriccion como un hecho (fact) que asegure que la condicion de
	// seguridad tambien implica la condicion de felicidad.
	asigSegura[] => asigFeliz[]
}

// Predicados
pred asigSegura ()
{
	// 2.- Restricciones  que  garanticen  una  asignacion  segura  de internos a celdas.
	all c : Celda | all disj p1, p2 : celda.c | some miembros.p1 => no miembros.p2 || miembros.p1 = miembros.p2
}

pred asigFeliz ()
{
	// 3.- Escribe un nuevo predicado llamado asigFeliz, que represente que los miembros
	// de una banda solo comparten celda con miembros de la misma banda.
	all c : Celda | all disj p1, p2 : celda.c | miembros.p1 = miembros.p2
}

// Asertos
assert asignacion
{
	// 3.- Una asignacion segura no implica necesariamente una asignacion feliz.
	 (asigSegura[] => asigFeliz[])
}

//check asignacion for 6

pred show ()
{
	// 2.- Genera ejemplos de asignaciones seguras.
	asigSegura[]
	// 2.- Genera ejemplos de asignaciones no seguras.
	//!asigSegura[]

	// Restricciones para ver mejor los ejemplos
	#Banda = 2
	all c : Celda | #celda.c > 1
	some disj p : Interno | no miembros.p
}

run show for 6
