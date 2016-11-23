    #define NVecinos 5 //numero de  vecinos
    mtype = {sonando,descolgado,colgado,conectado,responde}
    chan ctr= [0] of {mtype,short};
    chan ctr2v[NVecinos] = [0] of {mtype,short};
    
    mtype estadoVecino[NVecinos];

    inline selIndetermista(id){
      
      seleccionar:
      
      id = 0;
      do
      :: id < NVecinos -> id++
      :: break
      od

      if
      :: estadoVecino[id] != colgado -> goto seleccionar;
      fi

    }

    proctype Vecino(short id){

      mtype estado;

      do
      :: ctr ? sonando,id;
      :: 
      od

    }

    proctype Centralita(){
      
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
