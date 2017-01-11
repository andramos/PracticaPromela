// one	 -> 1
// lone	 -> [0..1]
// some -> [1..N]
// set	 -> [0..N]

module ejercicio1

// Signaturas y relaciones
sig Color {}

sig Objeto
{
	color : Color
}

sig Caja
{
	contiene : set Objeto
}

// Restricciones globales sobre el sistema
fact
{
	// Cada objeto esta en una y solo una caja
	all o : Objeto | one c : Caja | o in c.contiene
}

// Predicados
pred show ()
{
	// 1.- En alguna caja todos los objetos sean del mismo color
	some c : Caja | one c.contiene.color
	
	// 2.- Alguna caja tenga mas de dos objetos, y todos los objetos que contienen
	//      son de distinto color
	some c : Caja | #c.contiene > 2 && #c.contiene.color = #c.contiene
}

run show for 6
