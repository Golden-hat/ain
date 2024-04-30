
+flag(F): team(200)
    <-
        +amiesquina;
        .goto([20, 0, 20]);
        +miposicion([20, 0, 20])

+friends_in_fov(ID,Type,Angle,Distance,Health,Position)
    <-
        .print("Disparo");
        .shoot(3,Position).

+!agirar: estado(E) & E<4
    <-
        ?mirando(L);
        .nth(E, L, P);
        .look_at(P);
        .wait(1000);
        -estado(_);
        +estado(E+1);
        !agirar.

+!agirar: estado(E) & E=4
    <-
        -estado(_);
        +estado(0);
        !agirar.