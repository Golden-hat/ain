pygomas manager -np 16 -j manager_yjpellam@gtirouter.dsic.upv.es -sj service_yjpellam@gtirouter.dsic.upv.es
pygomas render
pygomas run -g pygomas.json 


Para listar los procesos abiertos en el puerto 8001...
sudo netstat -nlp | grep 8001
sudo ss -lptn 'sport = :8001'

Luego matar dichos procesos con un kill -9