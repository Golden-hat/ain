/**Creencia inicial**/
recorrido([[20,0,130],[130,0,240],[240,0,130],[130,0,20]]).

+flag(F):team(200)
<-
    !puntoproximo;
    ?dist1(D1);
    ?dist2(D2);
    ?dist3(D3);  
    ?dist4(D4);
    .min([D1,D2,D3,D4], Minimo);
    .print(D1, D2, D3, D4, Minimo);
    .print("El minimo es", Minimo);

    ?recorrido(R);
    .length(R,L);
    +total_control_points(L);
    +patrolling;

    +giros(0);

    ?health(H);
    +vidaIni(H);
    ?ammo(A);
    +balasIni(A);

    !bajoAtaque;
    !stats_criticos;

    if(Minimo == D1){
        .print("d1");
        +puntoControl(0);
        .goto([20,0,130]);
    };
    if(Minimo == D2){
        .print("d2");
        +puntoControl(1);
        .goto([130,0,240]);
    };
    if(Minimo == D3){
        .print("d3");
        +puntoControl(2);
        .goto([240,0,130]);
    };
    if(Minimo == D4){
        .print("d4");
        +puntoControl(3);
        .goto([130,0,20]);
    };
    +mirando([[0,0,0],[250,0,0],[250,0,250],[0,0,250]]);
    +estado(0).

+!puntoproximo
<-  
    ?position([X,Y,Z]);
    +dist1(((X-20)**2+(Z-130)**2)**(0.5));
    +dist2(((X-130)**2+(Z-240)**2)**(0.5));
    +dist3(((X-240)**2+(Z-130)**2)**(0.5));
    +dist4(((X-130)**2+(Z-20)**2)**(0.5)).

+target_reached(T): patrolling & team(200)
<-
    -buscopaquete;
    ?puntoControl(P);
    -+puntoControl(P+1);
    -target_reached(T).

+puntoControl(P): total_control_points(T) & P<T
<-
    ?recorrido(R);
    .nth(P,R,A);
    .goto(A);
    .print("Voy a Pos: ", A).
    
+puntoControl(P): total_control_points(T) & P==T
<-
    -puntoControl(P);
    +puntoControl(0).

+!agirar: estado(E) & E<4
<-
    ?giros(X);
    if(X <= 4){
        ?mirando(L);
        .nth(E, L, P);
        .look_at(P);
        .wait(300);
        -estado(_);
        +estado(E+1);
        -+giros(X+1);
        !agirar;
    }.

+!agirar: estado(E) & E=4
<-
    ?giros(X);
    if(X <= 4){
        -estado(_);
        +estado(0);
        !agirar;
    }.

+friends_in_fov(ID,Type,Angle,Distance,Health,Position) 
<-
    ?ammo(A);
    if(A > 0 & not buscopaquete){
        .look_at(Position);
        .print("Disparo");
        ?health(H);
        if(Health>H){
            if(A>20){
                .shoot(10, Position);            
            }
            else{
                .shoot(5, Position);
            };
        };
        .shoot(3,Position);
        .goto(Position);
        ?ammo(BB);
        -+balasIni(BB);
    }.

+!stats_criticos: health(H) & ammo(A) & (H <= 45 | A == 0) & not buscopaquete
<- 
    .print("me revientan tete"); /*ir al centro a reponer*/
    .goto([125,0,125]);
    +buscopaquete.

+!stats_criticos: health(H) & ammo(A)
<-
    !!stats_criticos.

+!bajoAtaque: health(H) & ammo(A) & vidaIni(X) & (H < X) & (H > 45)
<-
    if(A > 0 & not buscopaquete){
        !agirar;
        -+giros(0);
        ?health(T);
        -+vidaIni(T);
    }.

+!bajoAtaque: health(H) & ammo(A) & vidaIni(X)
<-
    !!bajoAtaque.

+packs_in_fov(ID,Type,Angle,Distance,Health,Position): Type<1003 & health(H) & ammo(A) & (A \== 100 | H \== 100) & buscopaquete & not locked
<-
    ?position([X,Y,Z]);
    .goto(Position);
    +locked;
    if(Position == [X,Y,Z]){
        +packetReached;
        ?health(H2);
        -+vidaIni(H2);
        ?ammo(A2);
        -+balasIni(A2);
        -locked;
    }.

+!notSatisfied: packetReached & buscopaquete 
<-
    if(A2 \== 100 | H2 \== 100){
        .wait(125);
        .turn(1.5708);
        .wait(125);
        .turn(1.5708);
        .wait(125);
        .turn(1.5708);
        -packetReached;
    }else{
        -buscopaquete;
    }.

+!notSatisfied: health(H) & ammo(A)
<-
    !!notSatisfied.