    #define NVecinos 5 //numero de  vecinos
    mtype = {sonando,descolgado,colgado,conectado,responde}
    chan ctr= [0] of {mtype,short};
    chan ctr2v[NVecinos] = [0] of {mtype,short};
    
    mtype estadoVecino[NVecinos];

    inline selIndetermista(id){
      
      seleccionar:
      
      // selecciona uno de forma indeterminista
      id = 0;
      do
      :: id < NVecinos -> id++
      :: break
      od

      // comprueba que el vecino seleccionado este colgado
      if
      :: estadoVecino[id] != colgado -> goto seleccionar;
      fi

    }

    proctype Vecino(short id){

      mtype estado;

      do
      :: ctr ? sonando,id ->


      :: ctr!descolgado,id ->


      od

    }

    proctype Centralita(){
      short id;

      if
      :: ctr?descolgado,id ->
          estadoVecino[id]=descolgado;


      :: ctr?responde,id2 ->

      :: ctr?colgado,id ->

      fi
    }

    init{
      atomic{
         short i = 0; 
           do
           :: i<NVecinos-> run Vecino(i);
              estadoVecino[i] = colgado;
              i++
           :: else->break;
           od;
           run Centralita();
      }
    }  
