## 🚦 Proyecto #1: Rush Hour (Traffic Jam) en Haskell

Este proyecto implementa una solución funcional para el famoso juego de lógica **Rush Hour** (también conocido como Traffic Jam), utilizando el lenguaje de programación **Haskell**. El objetivo es encontrar la secuencia de movimientos **mínima** necesaria para liberar el vehículo principal (el "auto rojo") de un tablero lleno de obstáculos.

---

### 🌟 Características y Restricciones del Proyecto

* **Tablero Fijo:** El juego se desarrolla en una matriz fija de $6 \times 6$.
* **Vehículos:** Los vehículos tienen orientación Horizontal ('H') o Vertical ('V') y una longitud de 2 o 3 casillas.
* **Movimiento:** Los vehículos solo pueden moverse en la dirección de su orientación (sin movimientos laterales ni giros).
* **Búsqueda Óptima:** Se utiliza el algoritmo de **Búsqueda en Anchura (BFS)** para garantizar la solución más corta (mínima cantidad de movimientos).
* **Restricción de Librerías:** Solo se utilizan operaciones del `Prelude` de Haskell. No se permite el uso de `Data.Map` ni `Data.Set`.

---

### 💻 Estructura del Código

Todas las funciones requeridas están definidas dentro de un único archivo:

* `Proyecto1.hs`: Contiene la implementación de los tipos de datos y las funciones de inicialización, validación, movimiento y resolución.

---

### ⚙️ Tipos de Datos Definidos en Haskell

| Tipo | Definición en Haskell | Descripción |
| :--- | :--- | :--- |
| `Coord` | `type Coord = (Int, Int)` | Coordenada (Fila, Columna). |
| `Orientation` | `data Orientation = H | V deriving (Show, Eq)` | Orientación Horizontal (H) o Vertical (V). |
| `Vehicle` | `type Vehicle = (Orientation, Coord, Int)` | (Orientación, Coordenada Inicial, Longitud). |
| `Board` | `type Board = [Vehicle]` | Lista de vehículos. El **primer vehículo es siempre el objetivo**. |

---

### 🔑 Funcionalidades Implementadas

* `initialBoard :: [Vehicle] -> Board`
* `isValidMove :: Board -> Int -> Int -> Bool`
* `moveVehicle :: Board -> Int -> Int -> Board`
* `solveRushHour :: Board -> (Int, [Board])`

---

### 🚀 Uso (Ejemplos en GHCi)

Para probar las funciones, carga el archivo `Proyecto1.hs` en el intérprete de Haskell (`GHCi`):

```haskell
-- Caso simple (1 movimiento)
solveRushHour [(H, (2,3), 2)]
-- Retorno esperado: (1, [[(H, (2,3), 2)], [(H, (2,4), 2)]])

-- Caso complejo (Bloqueo)
solveRushHour [(H, (2,0), 2), (V, (0,3), 3)]
-- Retorno esperado: (2, ...) y la secuencia de tableros de la solución.