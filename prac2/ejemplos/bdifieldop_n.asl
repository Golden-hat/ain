cont(0).
soldiers(0).
soldados([]).
i(0).

/*Falta registrar servicio*/


/** Se obtiene la posicion de cada vigilante, y si no hay amenaza, el fieldop
ira dando vueltas de uno en uno dejandoles la municion al lado, por si en caso de 
una emboscada, puedan tener munición rapidamente a su alcance y no perder tiempo 
comunicandose con otros **/
+dejarMuni: team(200) & vigilantes(V) & not modoWAR
  <-
  .nth(0, V, R);
  +repartir;
  .goto(R);
  .delF(V,W);
  .concat(W, [R], E);
  -+vigilantes(E);
  -dejarMuni.


  /** En no haber visto aún enemigos, va al centro para concentrar recursos**/
+dejarMuni: team(200) & not modoWAR
 <-
 .goto(F);
 +repartir;
 -dejarMuni.



/** Cuando llegue a su objetivo para dejar la munición, generará un paquete y seguirá generando más
 **/
+target_reached(T): team(200) & repartir & not modoWAR
  <-
  .print("Munición generada");
  .reload;
  -repartir;
  +dejarMuni.


/** Cuando se carguen los medicos, los guarda en una variable a parte para
poder usarlo en caso de emergencia **/
+myMedics(M) <- +medico(M).


/*Modo combate*/

