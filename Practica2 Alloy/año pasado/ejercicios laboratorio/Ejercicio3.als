module ejercicio3

// Signaturas y relaciones
sig Planta {}

sig Persona
{
	edificio : lone Edificio,
	ascensor : lone Ascensor
}

sig Ascensor
{
	ascPlanta : one Planta,
	ascPersonas : set Persona
}

sig Edificio
{
	edifPlantas : some Planta,
	edifAscensores : set Ascensor
}

// Restricciones globales sobre el sistema
fact
{
	// 1.- Cada planta esta exactamente en un ediﬁcio
	all p : Planta | one e : Edificio | p in e.edifPlantas
	
	// 2.- Cada ascensor esta exactamente en un ediﬁcio
	all a : Ascensor | one e : Edificio | a in e.edifAscensores
	
	// 3.- El numero de ascensores de un ediﬁcio es estrictamente menor que el
	//      numero de plantas del ediﬁcio
	all e : Edificio | #e.edifAscensores < #e.edifPlantas
	
	// 4.- Si un ediﬁcio tiene menos de 3 plantas entonces no tiene ascensores
	all e : Edificio | #e.edifPlantas < 3 => no e.edifAscensores
	
	// 5.- Si un ediﬁcio tiene mas de 3 plantas entonces tiene algun ascensor
	all e : Edificio | #e.edifPlantas > 3 => some e.edifAscensores
	
	// 6.- Cada ascensor se encuentra en una planta del ediﬁcio al que pertence
	all a : Ascensor | all e : Edificio | a.ascPlanta in e.edifPlantas => a in e.edifAscensores
	
	// 7.- Si una persona esta en un ascensor, entonces debe encontrarse tambien
	//      en el ediﬁcio en el que esta dicho ascensor
	all p : Persona | some p.ascensor => p.edificio = edifAscensores.(p.ascensor)
	
	// 8.- La relacion ascPersonas contiene exactamente a las personas que estan
	//      en el ascensor
	all a : Ascensor | ascensor.a = a.ascPersonas
}

// Predicados
pred show ()
{
	// 1.- Es posible que una persona este en un ediﬁcio, pero no este en ningun
	//      ascensor
	some p : Persona | some p.edificio && no p.ascensor
	
	// 2.- Es posible que un ascensor lleve a dos personas
	some a : Ascensor | #a.ascPersonas = 2
	
	// 3.- Es posible que todos los ascensores de un ediﬁcio esten en la misma
	//      planta
	some e : Edificio | some p : Planta | ascPlanta.p = e.edifAscensores
	
	// 4.- Es posible que todos los ascensores de un ediﬁcio esten en plantas
	//      diferentes
	some e : Edificio | all disj a1, a2 : e.edifAscensores |  not a1.ascPlanta = a2.ascPlanta
	
	// Restricciones para ver mejor los ejemplos
	#Edificio = 2
	all e : Edificio | #e.edifPlantas > 2
	all e : Edificio | #e.edifAscensores = 2
}

run show for 6
