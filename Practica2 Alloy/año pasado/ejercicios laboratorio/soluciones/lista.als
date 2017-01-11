// La signatura Lista
// representa listas con un primer nodo seguido por una secuencia lineal de nodos
// del tipo L = primer -> N1 -> N2

sig Nodo{}

sig Lista
{
	primer : one Nodo, // primer nodo de la lista
    siguiente : Nodo lone -> lone Nodo, //relación siguiente en la lista
    cont : set Nodo // conjunto de nodos de la lista, incluyendo el primero
}
{
	// f1.) el primer nodo no tiene anterior
	// no siguiente.primer

	// f2.) todos los nodos de la lista menos el primero tienen  un nodo anterior
	// all n : cont - primer | one siguiente.n

	// f3.) el contenido de la lista son los nodos alcanzables mediante siguiente desde el primer nodo
	//  cont = primer.*siguiente

	// f4.) todos los nodos de la lista son alcanzables desde el primer nodo
	// siguiente.Nodo + Nodo.siguiente in  primer.*siguiente

	// f5.) no hay ciclos en la lista. Es redundante con f2
	//  no n : cont | n in n.^siguiente
}

fact
{
	// las mismas relaciones anteriores repetidas
	// f1.)
	 all l : Lista | no anterior[l, l.primer]
	// all l : Lista | no (l.siguiente).l.primer

	// f2.)
	 all l : Lista, n : l.cont - l.primer | one anterior[l, n]
	// all l : Lista, n : l.cont - l.primer | one (l.siguiente).n

	// f3.)
	all l : Lista | l.cont = l.primer.*(l.siguiente)

	// f4.)
	all l : Lista, n : Nodo | n in l.siguiente.Nodo + Nodo.(l.siguiente) => n in l.cont

	// f5.)
	all l : Lista, n : l.cont | not (n in n.^(l.siguiente))
}

fun primero(l : Lista) : Nodo
{
	l.primer
}

fun anterior(l : Lista, n : Nodo) : Nodo
{
	(l.siguiente).n
}

fun sucesores(l : Lista, n : Nodo) : set Nodo
{
	// nodos sucesores a n en la lista l
	n.*(l.siguiente)
}

fun subLista(l : Lista, n : Nodo) : Nodo -> Nodo
{
	// sublista de l que comienza en n
	//{n1, n2 : Nodo | n1 -> n2 in l.siguiente and n1 in n.*(l.siguiente)}
	n.*(l.siguiente) <: l.siguiente
}

pred show(l : Lista)
{
 
}

run show for 5 but exactly 1 Lista
