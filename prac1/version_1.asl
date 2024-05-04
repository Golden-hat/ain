/**Creencia inicial**/
puntos_pantrulla([[80,0,127],[127,0,80],[129,0,176],[176,0,129]]).

+flag(F):team(200)
<-
    !puntoproximo;
    ?dist(dist1, dist2, dist3, dist4);
    .min([dist1, dist2, dist3, dist4], minpunto);

    ?punto(P);
    .length(P, Long);
    +puntos_pratulla(Long);
    +vigilando;

    +encuentros(0); //
    +nofijado; //


    ?health(H);
    +salud(H);
    ?ammo(A);
    +balas(A);
    
    
    !vida;

    ?min_index([dist1, dist2, dist3, dist4], Minimo, Index);
    ?nth(Index, P, Destino);
    .goto(Destino);
    !!vida; //


    if(Minimo == D1){
        +punto_vigilado(0);
        .goto([80,0,127]);
    };
    if(Minimo == D2){
        +punto_vigilado(1);
        .goto([127,0,80]);

    };
    if(Minimo == D3){
        +punto_vigilado(2);
        .goto([129,0,176]);
    };
    if(Minimo == D4){
        +punto_viligado(3);
        .goto([176,0,129]);

    };


+!puntoproximo
<-  
    ?position([X,Y,Z]);
    +dist(((X-80)**2+(Z-127)**2)**(0.5),
          ((X-127)**2+(Z-80)**2)**(0.5),
          ((X-129)**2+(Z-176)**2)**(0.5),
          ((X-176)**2+(Z-129)**2)**(0.5)).


+!vida: health(H) & ammo(AA) & ((H > 50)|| AA==0) 
<-
    +destinocentro;
    .goto([125,0,125]);
    !!vida.


+morosenlacosta(M): vigilando & punto_vigilado(P) & P<3
<-
    !agirar;
    ?punto_vigilado(P);
    -+punto_vigilado(P+1);
    -target_reached(T).

+morosenlacosta(M): vigilando & punto_vigilado(P) & P=3
<-
    !agirar;
    ?punto_vigilado(P);
    -+punto_vigilado(0);
    -target_reached(T).


+visitandocentro(C): destinocentro
<-
    -destinocentro
    +buscandopaquetes
    .wait(500);
    .turn(1.5708);
    .turn(1.5708);
    .turn(1.5708);
    .turn(1.5708);
    +enelcentro;
    -visitandocentro(C).

+maspaquetes(M): buscandopaquetes && health(H) & ammo(AA) & (AA<=85 || H<=85)
<-
    .wait(500);
    .turn(1.5708);
    .turn(1.5708);
    .turn(1.5708);
    .turn(1.5708);

+reanudarmarcha(M): vigilando & health(H) & ammo(AA) & AA>=85 & H>=85
    -buscandopaquetes;
    ?punto_vigilado(P);
    -+punto_vigilado(P+1);
    ?health(H2);
    -+salud(H2);
    !!vida.
    


+!agirar: estado(E) & E<4
<-
    ?miradas(X);
    if(X <= 4){
        ?mirando(L);
        .nth(E, L, P);
        .look_at(P);
        .wait(500);
        -estado(_);
        +estado(E+1);
        -+miradas(X+1);
        !agirar;
    }.

+!agirar: estado(E) & E=4
<-
    ?miradas(X);
    if(X <= 4){
        -estado(_);
        +estado(0);
        !agirar;
    }.