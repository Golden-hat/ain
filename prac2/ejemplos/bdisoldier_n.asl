//TEAM DEFENSOR
+flag (F):team(200)
  <-
  .print("Arranca soldado");
  .get_backups;
  .get_medics;
  .register_service("soldados");
  .wait(5000);
  .get_service("capitan");
  .wait(1500);
  +alCentro;
  +objetivo(F);
  .goto(F);
  +bucle.

/*Mediante un mensaje al capitan/medico, se registra el soldado*/
+capitan(C): team(200) 
  <-
  +captain(C);
  .send(C, tell, registrar).

/*Movimientos iniciales para agente fijo*/
+moverA(Punto)[source(S)]: team(200)
  <-
  .goto(Punto);
  +punto;
  .print("Orden recibido, punto de viligancia: ", Punto).

/*Agente fijo, da vueltas sobre la posición designada, esperando detectar a un enemigo. */
+target_reached(F): punto 
  <-
  -punto;
  !patrullandoEnemigos.

/*Aquellos soldados que no son fijos, los mandamos a patrullar de forma aleatoria*/
+target_reached(T): team(200) & alCentro & not laTorre & not combate
  <-
  -alCentro;
  !patrullar.

+!patrullar: team(200) & flag(F) & position(P) & not combate
 <-
 -combate;
 -+seguir;
 .next(P, F, D); /*se dirige al siguiente punto de patrulla*/
 .goto(D);


/** Cuando llega a su posicion de patrulla, da una vuelta de 360grados para ver 
si encuentra a alguien, y sino, pues sigue movimientos aleatorios **/
+target_reached(T):team(200) & seguir & not combate
  <-
  +check;
  !patrullar.

/** Cuando esta en pelea, y llega a su objetivo, da una vuelta de 360 con la intención de encontrar al 
enemigo y seguir disparandole, o encontrar un enemigo nuevo **/
+target_reached(T):team(200) & combate
  <-
  -amenaza(_);
  -eliminar;
  +check;
  .print("FIN").

/** ============================  fin patrulla aleatoria ===========================**/


/** Patrulla mientras no vea un objetivo dando vueltas de 360 grados sobre su eje mientras no vea a 
un objetivo, en cual caso estaria en combate **/
+!patrullandoEnemigos:team(200) & not combate
  <-
  +check;
  .wait(2100);
  !patrullandoEnemigos.

+!patrullandoEnemigos:team(200) & combate
  <-
  .print("Apatrullando la ciudad  F").

+laTorre <- .print("UPS").

/** Metodo usado en la practica primera para dar vueltas sobre el eje del agente en busqueda de 
un enemigo, al cual se puede detectar con tiempo suficiente **/
+check: team(200) & position([X,Y,Z])
  <-
  /*.print("Vuelta de reconocimiento");*/
  .look_at([X+1,Y,Z]);
  .wait(400);
  .look_at([X-1,Y,Z]);
  .wait(400);
  .look_at([X,Y,Z+1]);
  .wait(400);
  .look_at([X,Y,Z-1]);
  .wait(400);
  ?objetivo(O);
  .look_at(O);
  -check.



/** ==========================================  Enemigos y ataques =========================================**/
/** Primer contacto con un enemigo:
- se activa combate 
- se manda al fieldop al centro
- se da una vuelta alrededor para llamar a agentes compañeros para que asistan a ayudar 
**/
+enemies_in_fov(ID, TYPE, ANGLE, DIST, HEALTH, [X,Y,Z]):team(200) & not combate & coronelli(C)
 <-
 +combate;
 -+checking;
 .goto([X,Y,Z]);
 -+tg(ID);
 .look_at([X,Y,Z]);
 .shoot(5,[X,Y,Z]);
 +check;
 .send(C, tell, veteAlCentro([X,Y,Z]));
 .print("Entrando en combate!").
 /*.send(B, tell, sos([X,Y,Z], HEALTH)).*/



/** =========================================================MODO GUERRA =====================================================================***/
/** Si no va al centro por munición o vida, seguirá disparandole al objetivo y equilibrando su vision al objetivo **/
+enemies_in_fov(ID, TYPE, ANGLE, DIST, HEALTH, [X,Y,Z]):team(200) & combate & not huir 
 <-
  -+estadoAlerta(0);
  -+objetivo([X,Y,Z]);
  .look_at([X,Y,Z]);
  .goto([X,Y,Z]);
  .shoot(1, [X,Y,Z]).

/** Se calcula la distancia con el objetivo, y en caso de que este cerca, se le dispararán mas veces.
Fijese que ya que posición puede fallar a la hora de llamarla, por concurrencia, este metodo esta separado del anterior **/
+enemies_in_fov(ID, TYPE, ANGLE, DIST, HEALTH, [X,Y,Z]):team(200) & combate & position(P)
  <-
  .distance([X,Y,Z], P, D);
  if(D > 30){
    /*.goto([X,Y,Z]);*/
    .look_at([X,Y,Z]);
  };
  if(D < 20){
    .print("Esta aqui!");
    .look_at([X,Y,Z]);
    .shoot(5, [X,Y,Z]);
  }.

/** Bucle para comprobar en caso del modo guerra la vida y la municion para saber si hay que ir a por ella o no.
> como se llama a position, health y ammo, puede no entrar al chekck, asi pues, se implemento una creencia auxiliar que hará de
bucle en caso de que la principal falle **/
+check: team(200) & combate & ammo(A) & health(H) & not huir & position(P) & objetivo(O)
  <-
  /*.wait(3000);*/
  -check;
  .look_at(O);
  .goto(O);
  if(H < 40 | A < 20){
    +huir;
    +reuniendose;
    .print("Saliendo por patas...");
    ?flag(F);
    .goto(F);
    ?coronelli(C);
    .send(C, tell, help(P));
  }.
+bucle 
  <- 
  -+check; 
  .wait(3000);
  -+bucle.


/** Debugger, por si no hay amenaza o el agente se queda pillado, pues poder continuar con su labor,
utiliza el contador estado alarma que se resetea cada vez que detecta algo, si no se resetea, empezara a 
dirigirse al centro, luego inentará patrullar, si lo consigue, seguirá apatrullando **/
+checking: team(200) & estadoAlerta(E) & combate
  <- 
  .wait(2000);
  -+estadoAlerta(E +1);
  if( E > 3){
    -+estadoAlerta(0);
    -amenaza;
    ?flag(F);
    .goto(F);
    !patrullar;
    +check;
  } 
  -+checking.

/** El Fieldop propone el punto de reunion para darle los paquetes de municion, si el agente no lo recibe, ira
al centro, donde está toda la munición, se activa modo huir mientras dura el viaje a por munición, asi pues
el agente no se desviará a otros estimulos **/
+reunion(P)[source(S)]: team(200)
  <-
  -+reuniendose;
  +huir;
  .goto(P);
  .print("OK, voy a la reunión!").

/** Llegado al punto de reunión, el agente va a por paquetes, da una vueta para localizarlos**/
+target_reached(T):reuniendose
  <-
  -reuniendose;
  +paquetes;
  +check;
  .print("Estoy aqui").

/** Cuando localiza el paquete, va a por el **/
+packs_in_fov(ID, TYPE, ANGLE, DIST, HEALTH, [X,Y,Z]): paquetes
  <-
  -paquetes;
  +aporpaquete;
  .goto([X,Y,Z]);
  .wait(2000);
  .look_at([X,Y,Z]);
  .print("Vamos por paquete").

/** Llega al paquete y desactiva modo huir, con lo que puede volver a combatir,
durante su trayectoria por el paquete, podria disparar a agentes que estan delante de el
ya que hay una creencia de enemigos en vista aun activa **/
+target_reached(T): aporpaquete
  <-
  -aporpaquete;
  -huir;
  .print("Paquete cogido");
  +check.

/** Sirve para cuando encuentra a un amigo a la hora de pedir ayuda, así pues, le pedira que se venga a escoltarlo, 
en este punto tenemos la comunicacion entre agentes para prestar ayuda uno a otro, ya que ir de unos cuantos en unos cuantos 
es mas concervador y potencialmente mejor que todos juntos y morir a la vez. Es una estrategia de ataque al desgaste **/
+friends_in_fov(ID, TYPE, ANGLE, DIST, HEALTH, [X,Y,Z]):team(200) & combate & soldados(SS)
  <-
  .nth(ID, SS,S);
  .send(S, tell, ayudame([X,Y,Z]));
  .print("AYUDADME!!").

/** Se activa cuando algun agente l epide ayuda, asi pues, va en su ayuda siempre y cuando el mismo no esté en guerra,
en cual caso, no le hará caso y lo dejará morir**/
+ayudame([X,Y,Z])[source(S)]: team(200) & not combate
 <-
 .look_at([X,Y,Z]);
 .goto([X,Y,Z]);
 -+combate;
 .print("VOY!").







/** ===================================================================== **/
+ponercombate <- -+combate; -ponercombate; .print("Entrando en combate!!!").