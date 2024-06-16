//TEAM DEFENSOR 
recorrido([]).
i(0).

+capitan(C): team(200) 
  <-
  +capitanAux(C);
  .send(C, tell, registrarM).

+flag(F):team(200)
<-
    .get_service("capitan");
    .goto(F);
    /** Wait largo que se asegura de que la patrulla 
    se inicie cuando las posiciones están distribuidas **/
    .wait(20000);
    .print("FUNCIONO");
    ?recorrido(R);
    .print("FUNCIONO");
    .length(R,L);
    .print("FUNCIONO");
    +total_control_points(L);
    .print("FUNCIONO");
    +puntoControl(0);
    .nth(0, R, r0);
    .print(r0);
    .goto(r0).

+instanciarRecorrido(S): team(200)
<-
  .nth(0, S, s0);
  .print(s0);
  -+recorrido(S).

+target_reached(T): team(200)
<-
    ?puntoControl(P);
    -+puntoControl(P+1);  
    .cure;
    .print("Vamos al siguiente punto!");
    +crearPaquetes;
    -target_reached(T).

+puntoControl(P): total_control_points(T) & P<T
<-
    .print("funcino=");
    ?recorrido(R);
    .nth(P,R,A);
    .goto(A);
    .print("Voy a Pos: ", A).
    
+puntoControl(P): total_control_points(T) & P==T
<-
    -puntoControl(P);
    +puntoControl(0).

/** Va al centro cuando lo llaman y activa modoWAR**/
// +veteAlCentro([X,Y,Z])[source(S)]:flag(F) & not modoWAR
//   <-
//   +modoWAR;
//   +objetivo([X,Y,Z]);
//   .goto(F);
//   .print("[Coronel]: Voy al centro!!!").

+crearPaquetes: team(200) & position([X,Y,Z])
  <-
  .print("Doy vueltas.");
  .wait(4000);
  .look_at([X+1,Y,Z]);
  .wait(400);
  .look_at([X-1,Y,Z]);
  .wait(400);
  .look_at([X,Y,Z+1]);
  .wait(400);
  .look_at([X,Y,Z-1]);
  .wait(400);
  -+crearMUNICION.

/** Como último recurso, el fieldop se pondrá también a disparar**/ 
+enemies_in_fov(ID, TYPE, ANGLE, DIST, HEALTH, [X,Y,Z]):team(200)
 <-
  .look_at([X,Y,Z]);
  .shoot(5, [X,Y,Z]).