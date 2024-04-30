pygomas manager -np 6 -j manager_yjpellam@gtirouter.dsic.upv.es -sj manager_yjpellam@gtirouter.dsic.upv.es -m map_arena
pygomas render 
pygomas run -g game_arena.json 

EN ESE ORDEN

si funciona mal pero el proceso sigue ejecutándose -> 
ejecutar en nueva terminal: fuser -n tcp -k 8001 

