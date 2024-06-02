/*Falta registrar servicio*/
+flag(F): team(200)
    <-
    +f(F);
    .wait(3000);
    .get_service("Capitan");
    .goto(F).


/**/
+dejarMuni: team(200) & vigilantes(V) & not combate
  <-
  .nth(0, V, R);
  +repartir;
  .goto(R);
  .delF(V,W);
  .concat(W, [R], E);
  -+vigilantes(E);
  -dejarMuni.


  /** En no haber visto aún enemigos, va al centro para concentrar recursos**/
+dejarMuni: team(200) & not combate
 <-
 .goto(F);
 +repartir;
 -dejarMuni.



/** Cuando llegue a su objetivo para dejar la munición, generará un paquete y seguirá generando más
 **/
+target_reached(T): team(200) & repartir & not combate
  <-
  .print("Munición generada");
  .reload;
  -repartir;
  +dejarMuni.


/** Cuando se carguen los medicos, los guarda en una variable a parte para
poder usarlo en caso de emergencia **/
+myMedics(M) <- +medico(M).


/*Modo combate*/

/** En caso de amenaza, el fieldop se irá al centro, ya que como no podemos seguir la flag
nos jugamos la partida a no dejar que pase nadie al centro,y se quedará campeando  **/
+veteAlCentro([X,Y,Z])[source(S)]:flag(F) & not combate
    <-
  +combate;
  +objetivo([X,Y,Z]);
  .goto(F);
  .print("[Coronel]: Voy al centro!!!").

/** Cuando llega al centro, empieza a generar paquetes de municion y llama al
medico para que venga al centro a gnerar tambien paquetes**/
+target_reached(T): team(200) & combate & objetivo([X,Y,Z]) & medico(M)
  <-
  .look_at([X,Y,Z]);
  .print("Estoy en el centro");
  .send(M, tell, venAlCentro);
  .reload;
  +crearMUNICION.

/** Cuando llega al punto de reencuentro con un agente que lo pidio, 
resetea e uso de ayuda para que otro agente pueda llamarlo **/
+target_reached(T): ayudando
  <-
  -ayudando.

/** Crea municion cada 4 segundos, así pues, siempre habrán paquetes por el campo **/
+crearMUNICION
  <-
  .wait(4000);
  -+crearMUNICION.


/** Cuando un agente pide ayuda, se decide una posicion donde quedar, 
que será el punto medio entre los dos **/
+help(P)[source(S)]: not ayudando & position(PP)
  <-
  +ayudando;
  .distMedia(P, PP, D);
  .send(S, tell, reunion(D));
  .print("Apunta punto de reunion ").

/** Debugger para position, ya que suele fallar, con lo que mandará al agente al centro 
Si flag falla, no habrá ayuda para el soldado**/
+help(P)[source(S)]: ayudando & flag(F)
  <-
  .send(S, tell, reunion(F));
  .print("Ahora no puedo ayudarte").


/** Debugguer para flag **/
+help(P)[source(S)]: team(200) & not flag(F)
  <-
  -ayudando.


/** El fieldop tambien dispara, si ve a algun enemigo en campo de vision, le diparara **/
+enemies_in_fov(ID, TYPE, ANGLE, DIST, HEALTH, [X,Y,Z]):team(200) & combate
 <-
  .look_at([X,Y,Z]);
  .shoot(5, [X,Y,Z]).
