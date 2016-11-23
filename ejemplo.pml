#define NVecinos 5 //numero de  vecinos
mtype = {sonando,descolgado,colgado,conectado,responde} //Acciones de los vecinos o centralita

chan ctr = [0] of {mtype,short}; //Canal para comunicar vecinos con centralita
chan ctr2v[NVecinos] = [0] of {mtype,short}; //Array de canales que comunica centralita con vecino i

/** Arrays para centralita **/
mtype estados[NVecinos]; //Array para saber el estado del vecino i
short relaciones[NVecinos];  //Array para saber con qué vecino está relacionado el vecino i


// De forma indetermista a un vecino para que hable con id
// !!Hay que tener en cuenta que puede que no haya ningún vecino disponible!!
// Hay que guardar la id del vecino disponible! (si lo está)
// ES SELECCIÓN SOLAMENTE, NO MANDA NI RECIBE NADA, SOLO SELECCIONA
inline selIndetermista(id) {
	if
		:: estados[0] == colgado -> id=0;
		:: estados[1] == colgado -> id=1;
		:: estados[2] == colgado -> id=2;
		:: estados[3] == colgado -> id=3;
		:: estados[4] == colgado -> id=4;
		:: else -> printf("C: No hay vecinos disponibles, %d!", id);
			id=-1;
			break; // No hay ningún vecino disponible
	fi
}


// Ejemplo
// ctr!descolgado,i    vecino i informa a la centralita que ha descolgado
proctype Vecino(short id) { //Campo short identifica al vecino
	short id2;
	do
		// Quiero hablar, le aviso a la centralita que estoy descolgado
		:: if // Indeterminista; o DESCUELGO o me está SONANDO
			:: ctr2v[id]?sonando,id2 -> // Si me está sonando el teléfono...
				ctr!responde,id -> // ...mando a la centralita que estoy respondiendo a la llamada
				printf("V%d: Estoy respondiendo la llamada de %d", id, id2);
					if
						:: ctr2v[id]?conectado, id2 -> // Estoy conectado con id2!!
							printf("V%d: Hablando con %d... ", id, id2);
							// MOMENTO EN EL QUE ME PONGO A HABLAR CON ID2 HASTA QUE ME CUELGUEN O CUELGUE YO
							// SELECCION INDETERMINISTA EN LA QUE O CUELGO O ME HAN COLGADO
							ctr!colgado,id;
							printf("V%d: Acabo de colgarle a %d", id, id2);
					fi
				
			:: ctr!descolgado,id -> // Cuando descuelgue...
					if
						:: ctr2v[id]?conectado,id2 -> // ...espero a recibir la id del id2 -> Recibida
							printf("V%d: Estoy hablando con %d", id, id2);

							ctr!colgado,id;
					fi
		fi
	od
}

//Ejemplo:
// ctr2Vec[i]!conectado,j  centralita informa al vecino i que se ha conectado con vecino j y puede hablar   
proctype Centralita() {

	short i = 0;
	short id, id2, idx;
	printf("Inicializando centralita...");
	do
		:: i<NVecinos ->
			estados[i]=colgado;
			relaciones[i]=-1;
			i++;
		:: else -> break;
	od
	printf("OK!");

	do
		:: if
			:: ctr?descolgado,id -> //Si recibe mensaje descolgado
				estados[id] = descolgado; //id pasa a estar descolgado
				//do
					printf("C: before id=%d id2=%d",id,id2);
					selIndetermista(id2); //busca un vecino disponible
					printf("C: after id=%d id2=%d",id,id2);
					if
					 	:: id2 < 0 -> break; // No ha encontrado un vecino disponible
					 	:: else -> // Ha encontrado a uno disponible (id2)
							printf("C: Actualizo relaciones %d<->%d idx=%d", id, id2, idx);
							relaciones[id]=id2; // actualizo relaciones
							relaciones[id2]=id; // 
					 		estados[id2] = sonando;
					 		ctr2v[id2]!sonando,id; // "id2, te está llamando id"
					fi
			:: 	ctr?responde,id2 -> // id2 a aceptado la llamada de id					 		
				id=relaciones[id2];
				ctr2v[id]!conectado,id2;
				estados[id] = conectado;
				ctr2v[id2]!conectado,id; //id2 lo hemos obtenido en selIndetermista
				estados[id2] = conectado;
				printf("C: V%d->V%d conectado!", id, id2);
			:: ctr?colgado,id -> // Si recibo que id ha colgado...
				printf("C: he recibido un colgado de %d",id);
				// Tengo que encontrar a su compañero de conversación y mandarle un colgado, actualizar mi lista de relaciones y estados.
				id2=relaciones[id]; //id2 es su compañero
				ctr2v[id]!colgado,id2;
				ctr2v[id2]!colgado,id;
				estados[id] = colgado;
				estados[id2] = colgado;
				relaciones[id] = -1;
				relaciones[id2] = -1;
		fi
	od
}


init {
  atomic {
    short i=0;
    atomic {
      do
      :: i<NVecinos -> run Vecino(i); i++
      :: else -> break;
      od;
      run Centralita();
    }
  }
}