#define NVecinos 5 //numero de  vecinos
mtype = {sonando,descolgado,colgado,conectado,responde} //Acciones de los vecinos o centralita

chan ctr = [0] of {mtype,short}; //Canal para comunicar vecinos con centralita
chan ctr2v[NVecinos] = [0] of {mtype,short}; //Array de canales que comunica centralita con vecino i

/** Arrays para centralita **/
mtype estados[NVecinos]; //Array para saber el estado del vecino i
short relaciones[NVecinos];  //Array para saber con qué vecino está relacionado el vecino i


// Busca de forma indeterminista a un vecino colgado
inline selIndetermista(id) {
	if
		:: estados[0] == colgado -> id=0;
		:: estados[1] == colgado -> id=1;
		:: estados[2] == colgado -> id=2;
		:: estados[3] == colgado -> id=3;
		:: estados[4] == colgado -> id=4;
		:: else -> 	printf("C: No hay vecinos disponibles, %d!", id);
					id=-1; // No hay ningún vecino disponible
					break; 
	fi
}


// Ejemplo
// ctr!descolgado,i  vecino i informa a la centralita que ha descolgado
proctype Vecino(short id) { //Campo short identifica al vecino
	short id2;
	do

		:: if
			:: ctr2v[id]?sonando,id2 -> // Me suena el teléfono

respondo:		printf("V%d: Estoy respondiendo la llamada de %d", id, id2);
				ctr!responde,id -> //Respondo la llamada
					ctr2v[id]?conectado, id2 -> // Estoy conectado con id2!!
llamada:			printf("V%d: Hablando con %d... ", id, id2);
					// MOMENTO EN EL QUE ME PONGO A HABLAR CON ID2 HASTA QUE ME CUELGUEN O CUELGUE YO
					// SELECCION INDETERMINISTA EN LA QUE O CUELGO O ME HAN COLGADO
					if
						:: ctr2v[id]?colgado,id2 ->
							printf("V%d: Me ha colgado %d ",id,id2);
						:: ctr!colgado,id ->
							printf("V%d: Acabo de colgarle a %d ", id, id2);
					fi			
				

			:: ctr!descolgado,id -> // Descuelgo

				printf("V%d: Acabo de descolgar",id);

				if
					:: ctr2v[id]?conectado,id2 -> // ...espero a recibir la id del id2 -> Recibida
						goto llamada;
					:: ctr2v[id]?sonando,id2 -> // En caso de que el teléfono suene cuando estoy descolgado
						goto respondo;
				fi
		fi
	od
	
	printf("V%d: He acabado y no debería.");
}

//Ejemplo:
// ctr2Vec[i]!conectado,j  centralita informa al vecino i que se ha conectado con vecino j y puede hablar   
proctype Centralita() {

	short i = 0;
	short id, id2;
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
			:: ctr?descolgado,id -> // id descuelga

					selIndetermista(id2); //busca un vecino colgado

					if
					 	:: (id2 < 0 || id == id2) -> // Es importante que no llame a sí mismo
					 		printf("C: No ha encontrado a nadie disponible para vecino %d",id);
					 	:: else -> // Ha encontrado a uno disponible (id2)
							printf("C: Actualizo relaciones %d<->%d ", id, id2);

							relaciones[id]=id2; // actualizo relaciones
							relaciones[id2]=id; // idem

							estados[id] = descolgado; //id pasa a estar descolgado
							estados[id2] = sonando;

							printf("C: %d, te está llamando %d ",id2,id);
					 		ctr2v[id2]!sonando,id;
					fi


			:: 	ctr?responde,id2 -> // id2 acepta la llamada de id

				id=relaciones[id2];
				printf("C: V%d->V%d conectado!", id, id2);					 		
				
				estados[id] = conectado;
				estados[id2] = conectado;

				ctr2v[id]!conectado,id2; 
				ctr2v[id2]!conectado,id;

			:: ctr?colgado,id -> // id decide colgar

				id2=relaciones[id]; //id2 es su compañero

				printf("C: he recibido una petición de %d para colgar con %d ",id,id2);

				estados[id] = colgado;
				estados[id2] = colgado;

				relaciones[id] = -1;
				relaciones[id2] = -1;

				ctr2v[id2]!colgado,id; //id2, te ha colgado id
		fi
	od

	printf("C: He acabado y no debería.");
}


init {
  atomic {
    short i=0;
    atomic {
      do
      :: i<NVecinos -> run Vecino(i); i++
      :: else -> break;
      od;
    }
    run Centralita();
  }
}