module ejercicio2

// Signaturas y relaciones
sig Llave {}

sig Cliente
{
	llave : lone Llave
}

sig Habitacion
{
	llaves : set Llave ,
	llaveActual : one Llave ,
	ocupacion : lone Cliente
}

sig Hotel
{
	hab : set Habitacion
}

// Restricciones globales sobre el sistema
fact
{
	// 1.- Todas las habitaciones pertenecen a exactamente un hotel
	all h : Habitacion | one hot : Hotel | h in hot.hab

	// 2.- Las llaves de las habitaciones son disjuntas (ningun par de habitaciones
	//      comparten llaves)
	all l : Llave | one h : Habitacion | l in h.llaves
	
	// 3.- Todas las habitaciones tienen al menos una llave asociada
	all h : Habitacion | some h.llaves
	
	// 4.- La llave actual de cada habitacion es una de sus llaves
	all h : Habitacion | h.llaveActual in h.llaves
	
	// 5.- Cada cliente ocupa a lo sumo una habitacion
	all c : Cliente | lone h : Habitacion | c = h.ocupacion
	
	// 6.- Si un cliente ocupa una habitacion, entonces su llave es la llave actual
	//      de la habitacion
	all c : Cliente | all h : Habitacion | c = h.ocupacion => c.llave = h.llaveActual
	
	// 7.- Si un cliente no ocupa una habitacion, entonces no tiene ninguna llave
	//      asociada
	all c : Cliente | no ocupacion.c => no c.llave
}

// Predicados
pred show ()
{
	// Restricciones para ver mejor los ejemplos
	all hot : Hotel | #hot.hab > 1
	all h : Habitacion | #h.llaves > 1
	#hab.ocupacion > 1
	#Hotel = 1
}

run show for 6
