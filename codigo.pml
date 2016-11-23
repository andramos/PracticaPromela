    #define NVecinos 5 //numero de  vecinos
    mtype = {sonando,descolgado,colgado,conectado,responde}
    chan ctr= [0] of {mtype,short};
    chan ctr2v[NVecinos] = [0] of {mtype,short};
    
    mtype estadoVecino[NVecinos];
    short conversacion[NVecinos];

    inline selIndetermista(id){
      
      if
        :: (estadoVecino[0] == colgado) -> id=0;
        :: (estadoVecino[1] == colgado) -> id=1;
        :: (estadoVecino[2] == colgado) -> id=2;
        :: (estadoVecino[3] == colgado) -> id=3;
        :: (estadoVecino[4] == colgado) -> id=4;
        :: else -> id=-1;
              break;
      fi

    }

    proctype Vecino(short id){

      short id2;
      do

        :: if
          :: ctr2v[id]?sonando,id2 -> // Me suena el teléfono

respondo:   
            ctr!responde,id -> //Respondo la llamada
              ctr2v[id]?conectado, id2 -> // Estoy conectado con id2!!
llamada:      
              if
                :: ctr2v[id]?colgado,id2 ->
                  printf("V%d: Me ha colgado %d ",id,id2);
                :: ctr!colgado,id ->
                  printf("V%d: Acabo de colgarle a %d ", id, id2);
              fi      
            

          :: ctr!descolgado,id -> // Descuelgo

            

            if
              :: ctr2v[id]?conectado,id2 -> // ...espero a recibir la id del id2 -> Recibida
                goto llamada;
              :: ctr2v[id]?sonando,id2 -> // En caso de que el teléfono suene cuando estoy descolgado
                goto respondo;
            fi
        fi
      od

    }

    proctype Centralita(){
      short i = 0;
      short id, id2;

      do
        :: if
          :: ctr?descolgado,id -> // id descuelga

              selIndetermista(id2); //busca un vecino colgado

              if
                :: (id2 < 0 || id == id2) -> // Es importante que no llame a sí mismo
                  printf("C: No ha encontrado a nadie disponible para vecino %d",id);
                :: else -> // Ha encontrado a uno disponible (id2)

                  conversacion[id]=id2; // actualizo conversacion
                  conversacion[id2]=id; // idem

                  estadoVecino[id] = descolgado; //id pasa a estar descolgado
                  estadoVecino[id2] = sonando;

                  printf("C: %d, te está llamando %d ",id2,id);
                  ctr2v[id2]!sonando,id;
              fi


          ::  ctr?responde,id2 -> // id2 acepta la llamada de id

            id=conversacion[id2];
            printf("C: V%d->V%d conectado!", id, id2);              
            
            estadoVecino[id] = conectado;
            estadoVecino[id2] = conectado;

            ctr2v[id]!conectado,id2; 
            ctr2v[id2]!conectado,id;

          :: ctr?colgado,id -> // id decide colgar

            id2=conversacion[id]; //id2 es su compañero

            estadoVecino[id] = colgado;
            estadoVecino[id2] = colgado;

            conversacion[id] = -1;
            conversacion[id2] = -1;

            ctr2v[id2]!colgado,id; //id2, te ha colgado id
        fi
      od
    }

    init{
      atomic{
         short i = 0; 
           do
           :: i<NVecinos-> run Vecino(i);
              estadoVecino[i] = colgado;
              conversacion[i] = -1;
              i++
           :: else->break;
           od;
           run Centralita();
      }
    }  

    ltl p2 { [] ( conversacion[1] != 1 && conversacion[2] != 2 ) };
    ltl p3 { [] 
                ( (estadoVecino[1] == hablando) -> (ctr2v[1] != colgado) && (ctr2v[1] == colgado) -> (estadoVecino[1] != hablando) ) && 
                ( (estadoVecino[2] == hablando) -> (ctr2v[2] != colgado) && (ctr2v[2] == colgado) -> (estadoVecino[2] != hablando) )
           };
    ltl p5 { <> ( estadoVecino[1] == sonando || estadoVecino[2] == sonando || estadoVecino[3] == sonando || estadoVecino[4] == sonando )};
    ltl p6 { <> ( estadoVecino[1] == hablando && estadoVecino[2] == hablando && conversacion[1] == 2 && conversacion[2] == 1 )};
