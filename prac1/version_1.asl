`puntos([[127,0,80],[80,0,127],[129,0,176],[176,0,129]]).

+flag(F):team(200)
<-
    !puntoproximo;
    ?dist(dist1, dist2, dist3, dist4);
    .min([dist1, dist2, dist3, dist4], minpunto);

    ?punto(P);
    .length(P, Long);
    +puntos_seguros(Long);
    +vigilando;

    +encuentros(0);
    +nofijado;


    ?health(H);
    +salud(H);
    ?ammo(A);
    +balas(A);
    !vida;

    ?min_index([dist1, dist2, dist3, dist4], Minimo, Index);
    ?nth(Index, P, Destino);
    .goto(Destino);
    !!vida;


+!puntoproximo
<-  
    ?position([X,Y,Z]);
    +dist(((X-127)**2+(Z-80)**2)**(0.5),
          ((X-80)**2+(Z-127)**2)**(0.5),
          ((X-129)**2+(Z-176)**2)**(0.5),
          ((X-176)**2+(Z-129)**2)**(0.5)).


+!vida: health(H) & ammo(AA) & salud(X) & (H < X) & (H > 65)
<-
    .stop;
    +medisparan;
    -+miradas(0); //*Enemigos que ha visto o le están disparando*//
    !agirar; //*Se pone a girar sobre si mismo*//
    -+salud(H); 
    ?puntos_seguros(P);
    ?punto(P);
    .nth(P,Punto);
    .goto(Punto);
    !!vida.