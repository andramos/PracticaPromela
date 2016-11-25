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
      fi
    }

    proctype Vecino(short id){
      short id2;

      do
        // espera a que suene
        :: ctr2v[id]?sonando,id2 ->

          ctr!responde,id;
          ctr2v[id]?conectado,id2; // espera a que le conecten
          if
            :: ctr2v[id]?colgado,id2; // espera a que le cuelguen
              
            :: ctr!colgado,id; // decide colgar
          fi      
          
        // descuelga
        :: (estadoVecino[id] == colgado) -> 
          ctr!descolgado,id;
          ctr2v[id]?conectado,id2 // espera a que lo conecten
      od
    }

    proctype Centralita(){
      short id, id2;
      short i = 0;

      do
        :: ctr?descolgado,id ->

            selIndetermista(id2);

            // si estan colgados y no es él mismo
            if
              :: (id2 >= 0 && id != id2) ->
                atomic{
                  conversacion[id]=id2;
                  conversacion[id2]=id;

                  estadoVecino[id] = descolgado;
                  estadoVecino[id2] = sonando;

                  ctr2v[id2]!sonando,id;
                }
            fi

        :: ctr?responde,id2 ->
          atomic{
            id=conversacion[id2]; 
            
            estadoVecino[id] = conectado;
            estadoVecino[id2] = conectado;

            ctr2v[id]!conectado,id2; 
            ctr2v[id2]!conectado,id;
          }

        :: ctr?colgado,id ->
          atomic{
            id2=conversacion[id];

            conversacion[id] = -1;
            conversacion[id2] = -1;

            estadoVecino[id] = colgado;
            estadoVecino[id2] = colgado;

            ctr2v[id2]!colgado,id;
          }
      od
    }

    init{
      atomic{
         short i = 0; 
           do
           :: i<NVecinos -> run Vecino(i);
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
