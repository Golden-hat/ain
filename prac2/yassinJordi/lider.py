from loguru import logger
from pygomas.agents.bditroop import BDITroop
from pygomas.agents.bdifieldop import BDIFieldOp
from pygomas.agents.bdimedic import BDIMedic
import random

class BDITropa(BDIFieldOp, BDITroop):

        def add_custom_actions(self, actions):
            super().add_custom_actions(actions)

        
            @actions.add_function(".distance", (tuple,tuple, ))
            def _distance(p1, p2):
                '''
                    distance between two points
                '''
                return ((p1[0]-p2[0])**2+(p1[2]-p2[2])**2)**0.5

            @actions.add_function(".flagTaken", ())
            def _flagTaken():
                '''
                    @rerturn 1 if the flag is taken, else  0
                '''
                return 1 if self.is_objective_carried else 0
                
            @actions.add_function(".soldiers",())
            def _soldiers():
                '''
                    Returns the number of alive soldiers
                '''
                return self.soldiers_count
            
            @actions.add_function(".distMedia", (tuple,tuple, ))
            def _distMedia(p1, p2):
                '''
                    Mean distance between two points
                '''
                return ((p1[0] + p2[0])/2, 0, (p1[2]+ p2[2])/2)
            
            @actions.add_function(".delF",(tuple,))
            def _delF(t):
                '''
                    Returns the list without 0 index element
                '''
                return t[1:]

            @actions.add_function(".canGO", (tuple, ))
            def _canGO(position):
                '''
                    Looks if the agent can got to the position or not, 
                    very grateful when you need to know if the wall are there
                '''
                
                X, Y, Z = position
                return 1 if self.map.can_walk(X, Z) else 0
            
            @actions.add_function(".tryGO", (tuple, tuple, ))
            def _tryGO(position, posEnemy):
                '''
                    Looks if we can move to the position, if yes, we move there, 
                    if not, we just move to the enemy position
                '''
                X, Y, Z = position
                if self.map.can_walk(X,Z):
                    print("We can go !")
                    return position
                else:
                    return posEnemy


            @actions.add_function(".next", (tuple,tuple, ))
            def _next(pos, flag):
                '''
                    Gives the next possible point to go randomly
                '''
                (px, py, pz) = pos
                (fx, fy, fz) = flag
                points  = [(px, pz), (fx, fz)]

                def dist(p1, p2):
                    return ((p1[0]-p2[0])**2+(p1[1]-p2[1])**2)**0.5
                
                for i in range(len(points)):
                    p1 = points[i][0] + random.randint(10,10)
                    p2 = points[i][1] + random.randint(10,10)
                    while(not self.map.can_walk(p1, p2) and dist((p1, p2),(fx, fz)) > 80):
                        p1 = points[i][0] + random.randint(10,10)
                        p2 = points[i][1] + random.randint(10,10)
                
                return (p1, 0, p2)
        
            @actions.add_function(".focusedAT", ())
            def _focusedAT():
                '''
                    Returns the agent ID of the agent or None
                ''' 
                return self.aimed_agent
            
            @actions.add_function(".focuseAT", (tuple,tuple ))
            def _focuseAT(pos, flag):
                '''
                    Returns the agent ID of the nearest to flag
                ''' 
                def dist(p1, p2):
                    return ((p1[0]-p2[0])**2+(p1[2]-p2[2])**2)**0.5
                mi = flag
                d = 200
                for i in range(len(pos)):
                    if dist(pos[i], flag) < d:
                        mi = pos[i]
                return mi

            # MÉTODOS LÍDER # 

            # * La formación inicial será un Hexágono irregular
            #   alrededor de la bandera. Se ajustará si la posición
            #   de este hexágono no es posible por la existencia de paredes
            #   u obstáculos
            # 
            # * # 
            @actions.add_function(".defencePOS", (tuple, ))
            def _defencePOS(flagPOS):
                fX, fY, fZ = flagPOS

                dist = 20
                print("[ L ]: The flag is at [",fX,",",fZ,"]" )
                   
                x = 0; z = 0; i = 0

                # izq arriba
                x = fX - dist
                z = fZ + dist
                while not self.map.can_walk(fX - dist, fZ + dist):
                    x = fX - dist + i; z = fZ + dist - i; i += 1
                pos1 = (x, 0, z)    

                i = 0
                # derecha arriba
                x = fX + dist
                z = fZ + dist
                while not self.map.can_walk(fX - dist, fZ + dist):
                    x = fX + dist - i; z = fZ + dist - i; i += 1
                pos2 = (x, 0, z) 

                i = 0
                # izquierda abajo
                x = fX - dist
                z = fZ - dist
                while not self.map.can_walk(fX - dist, fZ + dist):
                    x = fX - dist + i; z = fZ - dist + i; i += 1
                pos3 = (x, 0, z) 

                i = 0
                # derecha abajo
                x = fX + dist
                z = fZ - dist
                while not self.map.can_walk(fX - dist, fZ + dist):
                    x = fX + dist - i; z = fZ - dist + i; i += 1
                pos4 = (x, 0, z) 

                # punto izquierda
                x = fX - 1.5*dist
                z = fZ
                while not self.map.can_walk(fX - dist, fZ + dist):
                    x = fX - 1.5*dist - i; i += 1
                pos5 = (x, 0, z) 

                # punto derecha
                x = fX + 1.5*dist
                z = fZ
                while not self.map.can_walk(fX - dist, fZ + dist):
                    x = fX + 1.5*dist + i; i += 1
                pos6 = (x, 0, z) 

                return (pos1, pos2, pos3, pos4, pos5, pos6)





