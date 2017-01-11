sig Planta{}

sig Ascensor{
   ascPlanta:Planta,
   ascPersonas:set Persona
}{
//8. La relacion ascPersonas contiene exactamente a las personas 
 //que estan en el ascesor
  //ascPersonas = {p:Persona | p.ascensor = this}
}

sig Edificio{
   edifPlantas:set Planta,
   edifAscensores:set Ascensor
}{

  //3- El numero de ascensores de 
  //un edi cio es estrictamente menor que el numero de plantas del edificio
  #edifAscensores < #edifPlantas
 // 4- Si un edificio tiene menos de 3 plantas entonces no tiene ascensores
   #edifPlantas<3 implies no edifAscensores
  //5. Si un edi cio tiene mas de 3 plantas entonces tiene algun ascensor
  #edifPlantas>3 implies some edifAscensores
//8. La relacion ascPersonas contiene exactamente a las personas 
 //que estan en el a
  ascPersonas = ~ ascensor
  
}

sig Persona{
    edificio:lone Edificio,
    ascensor:lone Ascensor
}{
  //7.  Si una persona esta en un ascensor, 
  //entonces debe encontrarse tambien en el edi cio en el que esta dicho ascensor
   some ascensor implies edificio = edifAscensores.ascensor

}


fact{
 //1- Cada planta está  exactamente en un edificio
  all p:Planta | one edifPlantas.p

// 2- Cada ascensor esta exactamente en un edi cio
  all a:Ascensor | one edifAscensores.a

//6-  Cada ascensor se encuentra en una planta del edi cio al que pertence
 all a:Ascensor | a.ascPlanta in (edifAscensores.a).edifPlantas

}


pred personaEdificio1(p:Persona){
   some p.edificio
   no p.ascensor
}


pred ascensor2Personas(a:Ascensor){

  #a.ascPersonas = 2
}



pred todosAscensoresMismaPlanta(e:Edificio){
  one (e.edifAscensores).ascPlanta
}

pred todosAscensoresPlantaDiferente(e:Edificio){
 //hay al menos 2 ascensores en e
 #e.edifAscensores>1
 all disj a1,a2:e.edifAscensores |a1.ascPlanta!=a2.ascPlanta
}
pred show(){}


run todosAscensoresPlantaDiferente for 7