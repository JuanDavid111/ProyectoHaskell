
type Coord = (Int, Int)
data Orientation = H | V deriving (Show, Eq)
-- deriving (Show, Eq) crea automáticamente instancias de las clases Show y Eq para el tipo Orientation.
--Se usa deriving (Show, Eq) para permitir la impresión (Show) de los valores de este tipo
-- y la comparación de igualdad (Eq) de ello. sin esto, no podríamos comparar dos valores de tipo Orientation
type Vehicle = (Orientation, Coord, Int) -- (Orientación, Coordenada Inicial, Longitud)
type Board = [Vehicle]


--Condiciones
--El primer carro es H
--los carros tienen longitud 2 o 3     
--El tablero es de 6x6 y los carros no se salen del tablero
--los carros no se pueden solapar

--- la funcion any y all del prelude
--- any :: (a -> Bool) -> [a] -> Bool (devuelve True si algun elemento de la lista cumple la condicion)
--- all :: (a -> Bool) -> [a] -> Bool (devuelve True si todos los elementos de la lista cumplen la condicion)


------FUNCIONES AUXILIARES------
--Evalua si el primer carro es valido H L=2 O L=3
primerH :: Vehicle -> Bool
primerH (H, _, l) = l == 2 || l == 3
primerH  _  = False

--Evalua si todos los carros tienen longitud 2 o 3
tamano :: Vehicle -> Bool
tamano (_, _, l) = l == 2 || l == 3

--Evalua si un carro esta dentro del tablero 
dentroTablero :: Vehicle -> Bool
dentroTablero (H, (f,c), l) = f >= 0 && f < 6 && c >= 0 && c + l - 1 < 6
dentroTablero (V, (f,c), l) = f >= 0 && f + l - 1 < 6 && c >= 0 && c < 6


-- Devuelve las coordenadas ocupadas por un vehiculo
ocupa:: Vehicle -> [Coord]
ocupa (H, (f,c), l) = [(f, c + i) | i <- [0 .. l - 1]]
ocupa (V, (f,c), l) = [(f + i, c) | i <- [0 .. l - 1]]


--Evalua si un vehiculo se solapa con alguno de una lista
solapar2 :: [Vehicle]->Vehicle-> Bool
solapar2 [] _ = False
solapar2 (v:vs) v1 | any (`elem` c2) c1 = True
                  | otherwise = solapar2 vs v1
    where
        c1= ocupa v1
        c2= ocupa v

-- Comprueba que no haya solapamientos en toda la lista de vehículos
solapar :: [Vehicle] -> Bool
solapar [] = True
solapar (v:vs) = not (solapar2 vs v) && solapar vs

--- Función para obtener un nuevo vehículo con la coordenada modificada
newCoor :: Vehicle -> Int -> Vehicle
newCoor (H, (f,c), l) k = (H, (f, c+k), l)
newCoor (V, (f,c), l) k = (V, (f+k, c), l)    

--- Función para crear una nueva lista de vehículos con el vehículo modificado
listaMovida :: [Vehicle] -> Int -> Int -> Vehicle -> Board
listaMovida [] _ _ _ = []
listaMovida (x:xs) index cont newV 
    | cont == index = newV : xs -- Si encontramos el índice, ponemos el nuevo vehículo mas el resto
    | otherwise = x : listaMovida xs index (cont + 1) newV -- Si no, lo dejamos y llamamos recursivamente

-- Comprueba si el tablero actual es solución (el primer vehículo ha llegado al borde derecho)
esSolucion :: Board -> Bool
esSolucion ((H, (f,c), l):_) | c + l - 1 >= 5 = True
                             | otherwise = False

--- Búsqueda en anchura (BFS) para encontrar la solución
bfs :: [(Board, [Board])] -> [Board] -> (Int, [Board])
bfs [] _ = (-1, []) -- No hay solución
bfs ((currentBoard, path):queue) visited   | esSolucion currentBoard = (length path-1, reverse path) --retorna el tamaño del camino y el camino invertido
                                            | otherwise = bfs newQueue newVisited
        where
            newStates = [(newBoard, newBoard:path) | i <- [0..length currentBoard - 1],    -- índice del vehículo a mover
                                                          k <- [-5..5],                    -- número de posiciones a mover
                                                          k /= 0,                          -- evitar movimiento nulo
                                                          isValidMove currentBoard i k,    -- verificar si el movimiento es válido
                                                          let newBoard = moveVehicle currentBoard i k, -- nuevo tablero después del movimiento
                                                          newBoard /= currentBoard,                    -- evitar estados repetidos
                                                          newBoard `notElem` visited]                  -- evitar estados ya visitados
            -- queue es una tupla (Tablero Actual, [Camino hasta TA])--
            newQueue = queue ++ newStates -- agregar nuevos estados a la cola             
            newVisited = visited ++ map fst newStates  -- agregar nuevos tableros visitados


----------- FUNCIONES PRINCIPALES ------

--- PARTE 1 (Construcción y validación del tablero inicial)
--- Construye el tablero inicial validando las condiciones del enunciado.
--- initialBoard devuelve el tablero si es válido, o [] si no lo es.
initialBoard :: [Vehicle] -> Board
initialBoard [] = []
initialBoard (v:vs) | not (primerH v) = []
                    | not (all tamano (v:vs)) = []
                    | not (all dentroTablero (v:vs)) = []
                    | not (solapar (v:vs)) = []
                    | otherwise = v:vs



--- PARTE 2 ( validación de movimiento )
---- isValidMove devuelve True si el movimiento es válido, o False en caso contrario.
isValidMove :: Board -> Int -> Int -> Bool
isValidMove _ _ 0 = True
isValidMove lista index k | k>0 = dentroTablero vNew && solapar newL && isValidMove lista index (k-1) 
                          | k<0 =  dentroTablero vNew && solapar newL && isValidMove lista index (k+1) 
        where
            v = lista !! index
            vNew = newCoor v k 
            newL = listaMovida lista index 0 vNew



--- PARTE 3
--- moveVehicle devuelve el nuevo tablero después de mover el vehículo en la posición index k posiciones.        
moveVehicle :: Board -> Int -> Int -> Board
moveVehicle lista index k = newL    
    where
        v = lista !! index
        vNew = newCoor v k 
        newL = listaMovida lista index 0 vNew 


--- PARTE 4
--- solveRushHour devuelve una tupla con el número mínimo de movimientos para resolver el tablero
--- y la lista de tableros que representan el camino desde el tablero inicial hasta la solución
solveRushHour :: Board -> (Int, [Board])
solveRushHour [] = (-1, [])
solveRushHour tablero | null (initialBoard tablero) = (-1, []) -- si el tablero inicial no es válido
                      | esSolucion tablero = (0, [tablero]) -- si el tablero inicial ya es solución
                      | otherwise = bfs [(tablero, [tablero])] [tablero] --[(Tablero Actual, [Camino hasta TA])] [Visitados]
