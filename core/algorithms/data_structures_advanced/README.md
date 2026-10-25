# Data Structures Advanced — Ada

Implementación de la especificación [07_Data_Structures_Advanced](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) en **Ada**, usando el patrón **biblioteca (`--lib`) + subproyecto de pruebas (`tests/`, `--bin`)** con [AUnit](https://github.com/AdaCore/aunit) y **Alire** como gestor de dependencias.

Implementation of the [07_Data_Structures_Advanced](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) specification in **Ada**, using the **library (`--lib`) + test subproject (`tests/`, `--bin`)** pattern with [AUnit](https://github.com/AdaCore/aunit) and **Alire** as dependency manager.

---

## 📂 Archivos y estructura / Files & Structure

### Raíz del proyecto / Project root (`--lib`)

| Archivo / File | Propósito / Purpose |
|---|---|
| [`src/data_structures_advanced.ads`](src/data_structures_advanced.ads) | Especificación del paquete `Data_Structures_Advanced`: tipo abstracto etiquetado `Node`, tipo derivado `Tree_Node`, tipos privados `Binary_Tree` y `Graph`, tipos de acceso, array dinámico de vecinos `Neighbor_Array` y contratos de operaciones. |
| [`src/data_structures_advanced.adb`](src/data_structures_advanced.adb) | Implementación de `Node`, `Tree_Node`, `Binary_Tree`, registro enlazado canónico de vértices y adyacencia de `Graph`, junto con las rutinas de desasignación manual `Free`. |
| [`data_structures_advanced.gpr`](data_structures_advanced.gpr) | Proyecto GPRbuild de la biblioteca; genera `lib/libData_Structures_Advanced.a`. |
| [`alire.toml`](alire.toml) | Manifiesto Alire — nombre, versión, autor, licencia `GPL-3.0-or-later`. |
| [`.gitignore`](.gitignore) | Ignora artefactos generados: `obj/`, `lib/`, `alire/` y `config/`. |

### Subproyecto de pruebas / Test subproject (`tests/`, `--bin`)

| Archivo / File | Propósito / Purpose |
|---|---|
| [`tests/src/data_structures_advanced_tree_node_tests.ads`](tests/src/data_structures_advanced_tree_node_tests.ads) / [`.adb`](tests/src/data_structures_advanced_tree_node_tests.adb) | Fixture `Test` y casos de prueba para el tipo `Tree_Node`. |
| [`tests/src/data_structures_advanced_binary_tree_tests.ads`](tests/src/data_structures_advanced_binary_tree_tests.ads) / [`.adb`](tests/src/data_structures_advanced_binary_tree_tests.adb) | Fixture `Test` y casos de prueba para el tipo `Binary_Tree`. |
| [`tests/src/data_structures_advanced_graph_tests.ads`](tests/src/data_structures_advanced_graph_tests.ads) / [`.adb`](tests/src/data_structures_advanced_graph_tests.adb) | Fixture `Test` y casos de prueba para el tipo `Graph`. |
| [`tests/src/data_structures_advanced_suite.ads`](tests/src/data_structures_advanced_suite.ads) / [`.adb`](tests/src/data_structures_advanced_suite.adb) | Suite AUnit que agrega las suites de `Tree_Node`, `Binary_Tree` y `Graph`. |
| [`tests/src/tests.adb`](tests/src/tests.adb) | Punto de entrada del ejecutable de pruebas — ejecuta la suite con `AUnit.Run.Test_Runner_With_Status` y `AUnit.Reporter.Text`. |
| [`tests/tests.gpr`](tests/tests.gpr) | Proyecto GPRbuild del ejecutable de pruebas (`Main` = `tests.adb`). |
| [`tests/alire.toml`](tests/alire.toml) | Dependencias: `data_structures_advanced` (local, pin `..`) y `aunit ^26.0.0`. |
| [`tests/.gitignore`](tests/.gitignore) | Ignora `obj/`, `bin/`, `alire/` y `config/` del subproyecto de pruebas. |

**Estructura de directorios esperada / Expected directory structure:**

```text
data_structures_advanced/         # Biblioteca / Library (alr init --lib --in-place)
├── src/
│   ├── data_structures_advanced.ads  # Contrato / Contract
│   └── data_structures_advanced.adb  # Implementación / Implementation
├── tests/                       # Subproyecto de pruebas / Test subproject (alr init --bin)
│   ├── src/
│   │   ├── data_structures_advanced_tree_node_tests.ads / .adb    # Casos TreeNode / TreeNode cases
│   │   ├── data_structures_advanced_binary_tree_tests.ads / .adb # Casos BinaryTree / BinaryTree cases
│   │   ├── data_structures_advanced_graph_tests.ads / .adb       # Casos Graph / Graph cases
│   │   ├── data_structures_advanced_suite.ads / .adb             # Suite AUnit / AUnit suite
│   │   └── tests.adb                                             # Punto de entrada / Entry point
│   ├── tests.gpr                # Proyecto GPRbuild de pruebas / Test GPRbuild project
│   ├── alire.toml               # Dependencias / Dependencies
│   └── .gitignore
├── data_structures_advanced.gpr # Proyecto GPRbuild de la biblioteca / Library GPRbuild project
├── alire.toml                   # Manifiesto Alire / Alire manifest
├── .gitignore
├── obj/                         # Objetos (generado) / Objects (generated)
├── lib/                         # Biblioteca compilada (generado) / Compiled library (generated)
├── alire/                       # Dependencias resueltas (generado) / Resolved dependencies (generated)
└── config/                      # Configuración autogenerada por Alire (generado) / Alire auto-generated config (generated)
```

**Desviación respecto a la ubicación esperada / Deviation from the expected location:** la especificación propone `src/data_structures_advanced.ext` y una carpeta `test/` (singular) con `data_structures_advanced_test.ext` y `run_tests.ext`. El layout real usa `src/` con el par `.ads`/`.adb` y un subproyecto **`tests/`** (plural) con la suite y el punto de entrada separados, manteniendo la convención homologada de los demás módulos de Ada del monorepo (`data_structures_basics`, `naive_sort`, `numbers`).

**Deviation from the expected location:** the specification proposes `src/data_structures_advanced.ext` and a `test/` (singular) folder with `data_structures_advanced_test.ext` and `run_tests.ext`. The real layout uses `src/` with the `.ads`/`.adb` pair and a **`tests/`** (plural) subproject with the suite and entry point split apart, matching the convention of the other Ada modules in this monorepo (`data_structures_basics`, `naive_sort`, `numbers`).

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Proyecto estructurado como biblioteca con subproyecto de pruebas `tests/` gestionado mediante Alire (`alr`) y compilado con `gprbuild`. La base `Node` se modela como tipo abstracto etiquetado (`abstract tagged private`), heredado por `Tree_Node` y por `Graph_Node` en el cuerpo privado. No se emplean estructuras ni ordenaciones de la biblioteca estándar para el registro de vértices ni para la adyacencia de grafos; todas las operaciones e invariantes se gestionan manualmente con punteros de acceso explícitos (`access`).

**EN:** Project structured as a library crate with a `tests/` subproject managed via Alire (`alr`) and compiled with `gprbuild`. The `Node` base is modelled as an `abstract tagged private` record, inherited by `Tree_Node` and by `Graph_Node` in the private body. Neither standard library collections nor library sorting routines are used for the vertex registry or graph adjacency; all invariants and operations are handled manually via explicit access pointers (`access`).

---

## 📄 Configuración clave / Key Configuration

| Archivo / File | Propósito / Purpose |
|---|---|
| `data_structures_advanced.gpr` | Define el proyecto de biblioteca estática `Data_Structures_Advanced`, con fuentes en `src/` y `config/`, objetos en `obj/` y artefacto en `lib/libData_Structures_Advanced.a`. |
| `alire.toml` | Manifiesto del crate Alire: `name = "data_structures_advanced"`, `version = "0.1.0-dev"`, `licenses = "GPL-3.0-or-later"`. |
| `tests/tests.gpr` | Proyecto del ejecutable de pruebas con `Main := ("tests.adb")`, enlazando la biblioteca local y AUnit. |
| `tests/alire.toml` | Dependencias del ejecutable de pruebas: `data_structures_advanced = "*"` pineado a `path = ".."` y `aunit = "^26.0.0"`. |
| `config/*_config.gpr` | Archivos de configuración autogenerados por Alire (ignorados por Git). |

---

## 🚀 Compilación y ejecución / Build & Run

### Compilar la biblioteca / Build the library

```bash
alr build
```

### Ejecutar pruebas unitarias / Run unit tests

```bash
alr -C tests run
```

**Salida real / Actual output:**

```text
$ alr build
Note: Building data_structures_advanced=0.1.0-dev/data_structures_advanced.gpr...
Compile
   [Ada]          data_structures_advanced_config.ads
Build Libraries
   [gprlib]       Data_Structures_Advanced.lexch
   [archive]      libData_Structures_Advanced.a
   [index]        libData_Structures_Advanced.a
Success: Build finished successfully in 0.35 seconds.

$ alr -C tests run
Note: Building tests=0.1.0-dev/tests.gpr...
Bind
   [gprbind]      tests.bexch
   [Ada]          tests.ali
Link
   [link]         tests.adb
Success: Build finished successfully in 0.52 seconds.

OK TreeNode.Make
OK TreeNode.Get_Value
OK TreeNode.Get_Left
OK TreeNode.Get_Right
OK TreeNode.Set_Left
OK TreeNode.Set_Right
OK BinaryTree.Make
OK BinaryTree.Insert
OK BinaryTree.Contains
OK BinaryTree.Is_Empty
OK BinaryTree.Size
OK Graph.Make
OK Graph.Add_Vertex
OK Graph.Add_Edge
OK Graph.Has_Edge
OK Graph.Get_Neighbors
OK Graph.Is_Empty
OK Graph.Vertex_Count
OK Graph.Edge_Count

Total Tests Run:   19
Successful Tests:  19
Failed Assertions: 0
Unexpected Errors: 0
```

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Operación / Operation | Entrada → salida / Input → output | Complejidad / Complexity | Notas / Notes |
|---|---|---|---|
| `Get_Value` (`Node`) | `Node → Integer` | `O(1)` | Selector abstracto implementado en la base; no muta. |
| `Make` (`Tree_Node`) | `(out Tree_Node, Integer) → —` | `O(1)` | Inicializa nodo con valor y enlaces `null`. |
| `Get_Value` (`Tree_Node`) | `Tree_Node → Integer` | `O(1)` | Sobrescribe selector base (`overriding`). |
| `Get_Left` / `Get_Right` | `Tree_Node → Tree_Node_Access` | `O(1)` | Retorna puntero de acceso al subárbol o `null` si está ausente. |
| `Set_Left` / `Set_Right` | `(in out Tree_Node, Tree_Node_Access) → —` | `O(1)` | Actualiza el enlace izquierdo o derecho; no altera el conteo del árbol contenedor. |
| `Make` (`Binary_Tree`) | `out Binary_Tree → —` | `O(1)` | Crea árbol vacío utilizable (`Root => null`, `Count => 0`). |
| `Insert` (`Binary_Tree`) | `(in out Binary_Tree, Integer) → —` | `O(h)` | Inserción iterativa en ABB. Duplicados no incrementan el tamaño. |
| `Contains` (`Binary_Tree`) | `(Binary_Tree, Integer) → Boolean` | `O(h)` | Búsqueda binaria iterativa según invariante ABB. |
| `Is_Empty` (`Binary_Tree`) | `Binary_Tree → Boolean` | `O(1)` | Evalúa si `Count = 0`. |
| `Size` (`Binary_Tree`) | `Binary_Tree → Natural` | `O(1)` | Retorna `Count`. |
| `Make` (`Graph`) | `out Graph → —` | `O(1)` | Inicializa grafo vacío con registro a `null` y contadores en 0. |
| `Add_Vertex` (`Graph`) | `(in out Graph, Integer) → —` | `O(V)` | Búsqueda previa en registro `O(V)`. Inserta al frente si es nuevo (`Next_Vertex => Registry`). |
| `Add_Edge` (`Graph`) | `(in out Graph, Integer, Integer, out Boolean) → —` | `O(V + d(u))` | Localiza vértices `u` y `v` (`O(V)`). Inserta ordenado en adyacencia (`O(d(u))`). Éxito en `Success`. |
| `Has_Edge` (`Graph`) | `(Graph, Integer, Integer) → Boolean` | `O(V + d(u))` | Localiza vértices y busca `v` en la lista ordenada de adyacencia. |
| `Get_Neighbors` (`Graph`) | `(Graph, Integer) → Neighbor_Array_Access` | `O(V + d(u))` | Retorna copia dinámica independiente (`1 .. Count`). `null` si `u` no existe. |
| `Is_Empty` (`Graph`) | `Graph → Boolean` | `O(1)` | Evalúa si `Vertices = 0`. |
| `Vertex_Count` (`Graph`) | `Graph → Natural` | `O(1)` | Retorna contador `Vertices`. |
| `Edge_Count` (`Graph`) | `Graph → Natural` | `O(1)` | Retorna contador `Edges`. |
| `Free` (`Tree_Node_Access`) | `in out Tree_Node_Access → —` | `O(1)` | Desasigna un nodo individual creado dinámicamente. |
| `Free` (`Binary_Tree`) | `in out Binary_Tree → —` | `O(n)` | Recorrido post-orden que desasigna todos los nodos del árbol. |
| `Free` (`Graph`) | `in out Graph → —` | `O(V + E)` | Libera cada nodo de adyacencia y cada nodo de vértice del registro. |
| `Free` (`Neighbor_Array_Access`) | `in out Neighbor_Array_Access → —` | `O(1)` | Desasigna el arreglo devuelto por `Get_Neighbors`. |

---

## 🧩 Decisiones de diseño / Design decisions

| Decisión / Decision | Alternativa considerada / Alternative | Razón / Reason |
|---|---|---|
| Herencia en `Tree_Node` y `Graph_Node` desde `Node` (`tagged record`) | Composición por valor embebido (`Value : Integer`) | Ada soporta herencia mediante tipos etiquetados (`tagged records`). Permite compartir `Get_Value` respetando el requisito de base abstracta sin enlaces. |
| Registro de vértices enlazado manual (`Graph_Node.Next_Vertex`) | Arreglo dinámico o mapa hash | Cumple estrictamente con el modelo conceptual canónico sin capacidad contractual fija ni delegación en colecciones de alto nivel. |
| Inserción ordenada en adyacencia en `Add_Edge` | Inserción al inicio y ordenación posterior en `Get_Neighbors` | Mantiene la invariante de adyacencia ordenada permanentemente con coste `O(d(u))`, evitando penalizaciones de ordenamiento en las consultas. |
| Retorno de vecinos como puntero de acceso a arreglo (`Neighbor_Array_Access`) | Retornar lista enlazada interna o arreglo no acotado | Proporciona una copia desacoplada e inmutable respecto al estado interno del grafo, permitiendo liberar memoria explícitamente (`Free`). |
| Rango de índice `Positive range <>` en `Neighbor_Array` | `Natural range <>` empezando en 0 | Permite comparaciones directas de igualdad con agregados posicionales nativos de Ada (como `(30, 50)`), que indexan en base 1 por defecto. |

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| `TreeNode.set_left(node) -> this` / `TreeNode.set_right(node) -> this` | Procedimientos mutadores `in out Tree_Node` (`procedure Set_Left / Set_Right`) | En Ada las mutaciones de estructuras de datos imperativas se modelan de manera idiomática como procedimientos con parámetros `in out`, no encadenando `return this`. |
| `BinaryTree.insert(value) -> success` | `procedure Insert (Tree : in out Binary_Tree; Value : Integer)` | Al no existir límite contractual de capacidad ni posibilidad de fallo funcional en ABB desbalanceado, no se requiere indicador de fallo en la inserción. |
| `Graph.add_edge(u, v) -> success/failure` | `procedure Add_Edge (Item : in out Graph; U, V : Integer; Success : out Boolean)` | El reporte de fallo por extremo inexistente se modela idiomáticamente con parámetro `out Boolean Success` sin recurrir a excepciones ni tipos envoltorio. |
| Layout de pruebas `test/run_tests.ext` | Subproyecto `tests/` con ejecutable AUnit (`tests.gpr`) | Convención idiomática de Alire y estándar adoptado en los módulos de Ada del monorepo (`numbers`, `data_structures_basics`, `naive_sort`). |

---

## 🚨 Indicadores de fallo / Failure indicators

| Operación / Operation | Situación de fallo / Failure situation | Indicador / Indicator | Ejemplo / Example |
|---|---|---|---|
| `Get_Left` / `Get_Right` | Enlace ausente / hijo no asignado | `null` | `Get_Left (Node) = null` |
| `Contains` | Valor ausente en el árbol | `False` | `Contains (Tree, 99) = False` |
| `Add_Edge` | Vértice origen o destino inexistente | `Success := False` | `Add_Edge (Graph, 10, 99, Success); -- Success = False` |
| `Has_Edge` | Arista inexistente o extremo no registrado | `False` | `Has_Edge (Graph, 10, 99) = False` |
| `Get_Neighbors` | Vértice `U` no registrado en el grafo | `null` | `Get_Neighbors (Graph, 99) = null` |
| `Get_Neighbors` | Vértice `U` aislado (registrado sin aristas salientes) | Arreglo vacío (`Length = 0`), no `null` | `Get_Neighbors (Graph, 10).all'Length = 0` |

---

## ✅ Cobertura de pruebas / Test coverage

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|:--:|---|---|
| `TreeNode`: Crear un nodo de árbol | Sí | `tests/src/data_structures_advanced_tree_node_tests.adb:7` (`Test_Make`), `:17` (`Test_Get_Value`) | Verifica creación y lectura de valor. |
| `TreeNode`: Enlaces iniciales ausentes | Sí | `tests/src/data_structures_advanced_tree_node_tests.adb:27` (`Test_Get_Left`), `:37` (`Test_Get_Right`) | Verifica que enlaces iniciales son `null`. |
| `TreeNode`: Enlazar dos hijos | Sí | `tests/src/data_structures_advanced_tree_node_tests.adb:47` (`Test_Set_Left`), `:89` (`Test_Set_Right`) | Enlaza hijos izquierdo y derecho y verifica valores. |
| `TreeNode`: Recorrer cada enlace | Sí | `tests/src/data_structures_advanced_tree_node_tests.adb:47` (`Test_Set_Left`) | Recorre enlaces de hijos comprobando ausencia de descendencia. |
| `TreeNode`: Desenlazar hijos | Sí | `tests/src/data_structures_advanced_tree_node_tests.adb:47` (`Test_Set_Left`) | Comprueba desenlace progresivo manteniendo integridad de datos. |
| `TreeNode`: Adaptación inmutable | Omitido | `N/A` | Ada implementa nodos mutables vía punteros de acceso; no aplica semántica inmutable funcional. |
| `BinaryTree`: Crear vacío | Sí | `tests/src/data_structures_advanced_binary_tree_tests.adb:7` (`Test_Make`) | Comprueba `Is_Empty = True`, `Size = 0` y `Contains = False`. |
| `BinaryTree`: Insertar la raíz | Sí | `tests/src/data_structures_advanced_binary_tree_tests.adb:21` (`Test_Insert`) | Inserta 50 y comprueba tamaño 1 y pertenencia. |
| `BinaryTree`: Insertar menor y mayor | Sí | `tests/src/data_structures_advanced_binary_tree_tests.adb:21` (`Test_Insert`), `:72` (`Test_Contains`) | Inserta 50, 30, 70 y comprueba tamaño 3 y búsqueda. |
| `BinaryTree`: Ramas de varios niveles | Sí | `tests/src/data_structures_advanced_binary_tree_tests.adb:21` (`Test_Insert`), `:72` (`Test_Contains`) | Inserta 50, 30, 70, 20, 40 y comprueba tamaño 5. |
| `BinaryTree`: Valor ausente en árbol no vacío | Sí | `tests/src/data_structures_advanced_binary_tree_tests.adb:72` (`Test_Contains`) | Comprueba fallo con 99 conservando tamaño y pertenencia de 50. |
| `BinaryTree`: Duplicado idempotente | Sí | `tests/src/data_structures_advanced_binary_tree_tests.adb:21` (`Test_Insert`) | Inserta 50, 30, 70, 30 y comprueba que tamaño permanece en 3. |
| `BinaryTree`: Inserciones ordenadas | Sí | `tests/src/data_structures_advanced_binary_tree_tests.adb:21` (`Test_Insert`), `:72` (`Test_Contains`) | Inserta 20, 30, 40, 50, 70 y valida búsqueda de todos y fallo de 99. |
| `Graph`: Crear vacío | Sí | `tests/src/data_structures_advanced_graph_tests.adb:7` (`Test_Make`), `:235` (`Test_Is_Empty`) | Comprueba `Is_Empty = True`, contadores en 0 y fallos de consulta. |
| `Graph`: Vértice aislado | Sí | `tests/src/data_structures_advanced_graph_tests.adb:23` (`Test_Add_Vertex`) | Verifica 1 vértice, 0 aristas y vecinos vacíos (`Length = 0`). |
| `Graph`: Etiquetas no consecutivas y arista dirigida | Sí | `tests/src/data_structures_advanced_graph_tests.adb:58` (`Test_Add_Edge`), `:142` (`Test_Has_Edge`) | Comprueba arista `10 -> 70`, fallo en reversa `70 -> 10` y contadores. |
| `Graph`: Vértice duplicado conserva adyacencia | Sí | `tests/src/data_structures_advanced_graph_tests.adb:23` (`Test_Add_Vertex`) | Re-agrega vértice 10 y valida que vecinos `[30]` se conservan. |
| `Graph`: Arista duplicada | Sí | `tests/src/data_structures_advanced_graph_tests.adb:58` (`Test_Add_Edge`), `:281` (`Test_Edge_Count`) | Añade `10 -> 30` dos veces y verifica que `Edge_Count = 1`. |
| `Graph`: Extremo inexistente sin mutación | Sí | `tests/src/data_structures_advanced_graph_tests.adb:58` (`Test_Add_Edge`) | Intenta 4 aristas inválidas y verifica fallos e inmutabilidad de contadores. |
| `Graph`: Vecinos ordenados y contadores | Sí | `tests/src/data_structures_advanced_graph_tests.adb:170` (`Test_Get_Neighbors`), `:249` (`Test_Vertex_Count`) | Verifica secuencia ordenada `[30, 50, 70]` y contadores. |
| `Graph`: Consulta de arista ausente | Sí | `tests/src/data_structures_advanced_graph_tests.adb:142` (`Test_Has_Edge`) | Valida fallo de `Has_Edge(10, 30)` sin alterar vértices ni aristas. |
| `Graph`: Vecinos de vértice inexistente | Sí | `tests/src/data_structures_advanced_graph_tests.adb:170` (`Test_Get_Neighbors`) | Comprueba `Get_Neighbors(99) = null`, distinguiéndolo de vacío. |
| `Graph`: Bucle y duplicado | Sí | `tests/src/data_structures_advanced_graph_tests.adb:58` (`Test_Add_Edge`), `:142` (`Test_Has_Edge`) | Inserta bucle `10 -> 10` dos veces; valida éxito y conteo unitario. |
| `Graph`: Aislamiento del resultado de vecinos | Sí | `tests/src/data_structures_advanced_graph_tests.adb:170` (`Test_Get_Neighbors`) | Modifica copia devuelta y confirma que grafo y consultas previas no mutan. |

---

## ⚠️ Limitaciones conocidas / Known limitations

| Limitación / Limitation | Impacto / Impact | Alternativa o plan / Workaround or plan |
|---|---|---|
| Gestión manual de memoria en tipos dinámicos | El llamador debe invocar explícitamente `Free` para evitar fugas de memoria al descartar árboles, grafos o arreglos de vecinos | Proporcionado en el paquete mediante instancias de `Ada.Unchecked_Deallocation` para cada tipo dinámico. Se contempla el uso de tipos controlados (`Ada.Finalization`) en fases avanzadas. |
| Búsqueda de vértices `O(V)` en el registro enlazado canónico | Grafos con gran número de vértices experimentan latencia lineal al añadir vértices o aristas | Conforme con la especificación puramente algorítmica del módulo; no se permite usar tablas hash en esta fase. |

---

## 📝 Notas de implementación / Implementation Notes

- **Herencia e invariantes:** `Tree_Node` y `Graph_Node` derivan del tipo base abstracto etiquetado `Node`. La base aloja exclusivamente `Value`, mientras que los tipos derivados validan y gestionan sus propios enlaces.
- **Registro enlazado canónico:** El grafo implementa una lista enlazada de vértices mediante `Next_Vertex`. No se preasignan índices ni capacidades en array, preservando la definición conceptual del ADT.
- **Adyacencia ordenada:** `Add_Edge` realiza una inserción ordenada ascendente sobre la lista de adyacencia de cada vértice (`O(d(u))`), permitiendo detectar aristas duplicadas en el mismo paso y garantizando que `Get_Neighbors` recorra los vecinos en orden creciente sin necesidad de ordenar en la lectura.
- **Aislamiento en consultas de vecinos:** `Get_Neighbors` cuenta los vecinos, crea un nuevo bloque de memoria (`Neighbor_Array`) en el montón y copia las etiquetas, garantizando que mutaciones posteriores sobre el arreglo o sobre el grafo no afecten resultados ya entregados.

Este proyecto también está implementado en otros lenguajes. Explora el repositorio principal para consultar las demás versiones.

This project is also implemented in other languages. Explore the main repository to see the other versions.

---

## 🔍 Checklist de validación / Validation checklist

- [x] La suite nativa se ejecutó y su salida real está copiada en este README.
- [x] Cada caso de la especificación tiene su fila en _Cobertura de pruebas_ (o `Omitido` con razón).
- [x] Cada desviación del pseudocódigo o de la ubicación esperada está en _Adaptaciones idiomáticas_.
- [x] Cada operación con fallo posible está en _Indicadores de fallo_.
- [x] No hay rutas absolutas del autor, credenciales ni salidas inventadas.
- [x] Los enlaces relativos resuelven dentro del repositorio y el documento es bilingüe.
- [x] Ninguna sección repite lo que ya dice la especificación.

---

## 📚 Referencias / References

| Tipo / Kind | Referencia / Reference |
|---|---|
| Especificación / Specification | [`07_Data_Structures_Advanced.md`](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) |
| Primera base del lenguaje / First language reference | `data_structures_basics` — [`../data_structures_basics/README.md`](../data_structures_basics/README.md) |
| Segunda base del lenguaje / Second language reference | `numbers` — [`../../foundations/numbers/README.md`](../../foundations/numbers/README.md) |
| Guía de inicialización / Initialisation guide | [`core/00_Project_Initialization_Guide.md`](https://yorche3.github.io/programming_languages/core/00_Project_Initialization_Guide/) |
| Adaptaciones idiomáticas / Idiomatic adaptations | [`AGENT_Template.md`](https://github.com/yorche3/programming_languages/blob/main/docs/AGENT_Template.md) |
| Validación de la documentación / Documentation validation | [`WORKFLOW.md`](https://github.com/yorche3/programming_languages/blob/main/docs/WORKFLOW.md) |
| Documentación oficial del lenguaje / Language official docs | [AdaCore GNAT / Ada Reference Manual](https://www.adacore.com/documentation) |
