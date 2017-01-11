open util/ordering[Tiempo]

sig Tiempo {}

sig Cliente
{
	llave : Llave lone -> Tiempo
}

sig Llave {}

sig Hotel
{
	hab : set Habitacion
}

sig Habitacion
{
	ocupacion : Cliente lone -> Tiempo,
	llaves : set Llave,
	llaveActual : Llave one -> Tiempo
}
{
	// f4:  la llave actual de cada habitacion es una de sus llaves
	all t : Tiempo | llaveActual.t in llaves
}

fact
{
	// f1: Las habitaciones pertenecen a un sólo hotel
	all h : Habitacion | one hab.h
	// f2: Las llaves de  habitaciones distintas son distintas
	all disj hab1, hab2 : Habitacion | no hab1.llaves & hab2.llaves
	// f3:  todas las habitaciones tienen al menos una llave
	all hab : Habitacion | some hab.llaves
	// ocupación relaciona a cada hotel con sus habitaciones
	// all hotel : Hotel | hotel.ocupacion.Cliente in hotel.hab
	// f5: cada cliente esta a lo sumo en una habitación
	all c : Cliente, t : Tiempo | lone ocupacion.t.c
	// f6: la llave del cliente es la de la ocupación que ocupa
	all c : Cliente, h : Habitacion, t : Tiempo | h.ocupacion.t = c implies c.llave.t = h.llaveActual.t
	// si un cliente no tiene habitación entonces no tiene llave
	all c : Cliente, t : Tiempo| no ocupacion.t.c implies no c.llave.t
}

pred todaOcupacionIgualSalvo (h : Habitacion, t, t' : Tiempo)
{
	all h' : Habitacion - h | h'.ocupacion.t = h.ocupacion.t'  
}

pred todaLlaveActualIgualSalvo (h : Habitacion, t, t' : Tiempo)
{
	all h' : Habitacion - h | h'.llaveActual.t = h'.llaveActual.t'
}

pred ocupar (h : Habitacion, c : Cliente, t, t' : Tiempo)
{
	//pre: la habitacion esta vacia en t
	no h.ocupacion.t           
	//pre: c no ocupa habitacion en t
	not c in Habitacion.ocupacion.t 
	//post:  c ocupa h en t'
	c in h.ocupacion.t'  
	// condiciones de marco
	todaOcupacionIgualSalvo[h, t, t'] 
	todaLlaveActualIgualSalvo[none, t, t']
}

pred desocupar (h : Habitacion, t, t' : Tiempo)
{
	// pre: la habitacion h esta ocupada en t
	some h.ocupacion.t
	// post: la habitacion h esta desocupada en t'
	no h.ocupacion.t'
	// post: la llaveActual de h cambia cuando se desocupa la habitacion
	h.llaveActual.t != h.llaveActual.t'
	// condiciones de marco
	todaOcupacionIgualSalvo[h, t, t']
	todaLlaveActualIgualSalvo[h, t, t']
}

pred inicio (t : Tiempo)
{
	all h : Habitacion | no h.ocupacion.t
}

pred traza ()
{
	inicio[first]
	all t : Tiempo - last |
	let t' = next[t] | some h : Habitacion | (some c : Cliente | ocupar[h, c, t, t']) || desocupar[h, t, t']
}

pred show () {}

run traza for 5
