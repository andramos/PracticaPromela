sig Color{}

sig Objeto{
   color:Color
}

sig Caja{
   contiene:set Objeto
}

fact{
  // cada objeto esta en una y solo una caja
  all o:Objeto | one contiene.o

}

pred todosMismoColor(caja:Caja){
   // todos los objetos de caja son del mismo color
   one  caja.contiene.color

}

pred todosDistintoColor(caja:Caja){
   // caja tiene más de dos objetos, y todos son de distinto color
   #caja.contiene>2
   all disj o1,o2:caja.contiene | o1.color!=o2.color

}


pred show(){}

run todosDistintoColor for 5