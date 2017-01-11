
// Signaturas y relaciones
sig Puerto {
	conectado: Puerto
}

abstract sig Nodo {
	puertos: set Puerto,
	conectadoCon: set Nodo
}

sig Host extends Nodo {

}

sig Switch extends Nodo {

}

sig Controlador extends Nodo {

}

// Restricciones globales sobre el sistema
fact
{
}

// Funciones

// Predicados
pred show ()
{
	// Restricciones para ver mejor los ejemplos
	
}

run show for 4
