# Data Structures Basics — Ada

Implementación de la especificación [06_Data_Structures_Basics](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) en **Ada**, usando el patrón **biblioteca (`--lib`) + subproyecto de pruebas (`tests/`, `--bin`)** con [AUnit](https://github.com/AdaCore/aunit) y **Alire** como gestor de dependencias.

Implementation of the [06_Data_Structures_Basics](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) specification in **Ada**, using the **library (`--lib`) + test subproject (`tests/`, `--bin`)** pattern with [AUnit](https://github.com/AdaCore/aunit) and **Alire** as dependency manager.

---

## 📂 Archivos y estructura / Files & Structure

### Raíz del proyecto / Project root (`--lib`)

| Archivo / File | Propósito / Purpose |
|----------------|---------------------|
| [`src/data_structures_basics.ads`](src/data_structures_basics.ads) | Especificación del paquete `Data_Structures_Basics`: `Failure_Value`, `Node` con su tipo de acceso, los tipos privados `Linked_List`, `Stack` y `Queue`, y el contrato de cada operación. |
| [`src/data_structures_basics.adb`](src/data_structures_basics.adb) | Implementación de los cuatro ADT sobre el mismo `Node`, con un nodo por elemento en memoria dinámica. |
| [`data_structures_basics.gpr`](data_structures_basics.gpr) | Proyecto GPRbuild de la biblioteca; genera `lib/libData_Structures_Basics.a`. |
| [`alire.toml`](alire.toml) | Manifiesto Alire — nombre, versión, autor, licencia `GPL-3.0-or-later`. |
| [`.gitignore`](.gitignore) | Ignora los artefactos generados: `obj/`, `lib/`, `alire/` y `config/`. |

### Subproyecto de pruebas / Test subproject (`tests/`, `--bin`)

| Archivo / File | Propósito / Purpose |
|----------------|---------------------|
| [`tests/src/data_structures_basics_tests.ads`](tests/src/data_structures_basics_tests.ads) | Fixture `Test` (deriva de `AUnit.Test_Fixtures.Test_Fixture`) y declaración de los cuatro casos. |
| [`tests/src/data_structures_basics_tests.adb`](tests/src/data_structures_basics_tests.adb) | Los cuatro casos, uno por ADT, como pasos sucesivos sobre una misma instancia. |
| [`tests/src/data_structures_basics_suite.ads`](tests/src/data_structures_basics_suite.ads) / [`.adb`](tests/src/data_structures_basics_suite.adb) | Suite AUnit que registra los cuatro casos con `AUnit.Test_Caller`. |
| [`tests/src/tests.adb`](tests/src/tests.adb) | Punto de entrada — ejecuta la suite con `AUnit.Run.Test_Runner_With_Status` y `AUnit.Reporter.Text`. |
| [`tests/tests.gpr`](tests/tests.gpr) | Proyecto GPRbuild del ejecutable de pruebas (`Main` = `tests.adb`). |
| [`tests/alire.toml`](tests/alire.toml) | Dependencias: `data_structures_basics` (local, pin `..`) y `aunit ^26.0.0`. |
| [`tests/.gitignore`](tests/.gitignore) | Ignora `obj/`, `bin/`, `alire/` y `config/` del subproyecto. |

**Estructura de directorios esperada / Expected directory structure:**

```text
data_structures_basics/            # Biblioteca / Library (alr init --lib --in-place)
├── src/
│   ├── data_structures_basics.ads  # Contrato / Contract
│   └── data_structures_basics.adb  # Implementación / Implementation
├── tests/                          # Subproyecto de pruebas / Test subproject (alr init --bin)
│   ├── src/
│   │   ├── data_structures_basics_tests.ads / .adb   # Casos / Cases
│   │   ├── data_structures_basics_suite.ads / .adb   # Suite AUnit / AUnit suite
│   │   └── tests.adb                                  # Punto de entrada / Entry point
│   ├── tests.gpr                   # Proyecto GPRbuild de pruebas / Test GPRbuild project
│   ├── alire.toml                  # Dependencias / Dependencies
│   └── .gitignore
├── data_structures_basics.gpr      # Proyecto GPRbuild de la biblioteca / Library GPRbuild project
├── alire.toml                      # Manifiesto Alire / Alire manifest
├── .gitignore
├── obj/                            # Objetos (generado) / Objects (generated)
├── lib/                            # Biblioteca compilada (generado) / Compiled library (generated)
├── alire/                          # Dependencias resueltas (generado) / Resolved dependencies (generated)
└── config/                         # Configuración autogenerada por Alire (generado) / Alire auto-generated config (generated)
```

**Desviación respecto a la ubicación esperada / Deviation from the expected location:** la especificación propone `src/data_structures_basics.ext` y una carpeta `test/` (singular) con `data_structures_basics_test.ext` y `run_tests.ext`. El layout real usa `src/` con el par `.ads`/`.adb` y un subproyecto **`tests/`** (plural) con la suite y el punto de entrada separados, que es la convención de los demás módulos de Ada de este repositorio. La especificación autoriza el cambio: «El layout real puede seguir las convenciones del lenguaje; toda desviación se declara en el README».

**Deviation from the expected location:** the specification proposes `src/data_structures_basics.ext` and a `test/` (singular) folder with `data_structures_basics_test.ext` and `run_tests.ext`. The real layout uses `src/` with the `.ads`/`.adb` pair and a **`tests/`** (plural) subproject with the suite and the entry point split apart, which is the convention of the other Ada modules in this repository. The specification allows it: "The real layout may follow the language's conventions; every deviation is declared in the README".

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se creó con las herramientas de Alire, ancladas a la carpeta del módulo con `--in-place` para que el crate no quede anidado, y el subproyecto de pruebas con `--bin`. Los ADT se implementan **manualmente**, sin colecciones de la biblioteca estándar y sin que `Stack` y `Queue` envuelvan a `LinkedList`: cada uno gestiona sus propios punteros (`Top`, o `Front`/`Rear`) y su contador sobre el mismo tipo `Node`. Los cuatro casos de la suite se escribieron sobre el contrato del paso `4b` del sprint.

**EN:** The project was created with Alire's tools, anchored to the module folder with `--in-place` so the crate is not nested, and the test subproject with `--bin`. The ADTs are implemented **manually**, with no standard-library collections and without `Stack` and `Queue` wrapping `LinkedList`: each one manages its own pointers (`Top`, or `Front`/`Rear`) and its counter over the same `Node` type. The four suite cases were written against the contract from sprint step `4b`.

**Comandos de inicialización ejecutados / Initialisation commands run:**

```bash
alr -n init --lib --in-place data_structures_basics
alr -n init --bin tests
cd tests && alr with data_structures_basics --use=..
cd tests && alr with aunit
```

**Salida de estilos y avisos / Style and warning output:** con `-gnaty` activo, una compilación limpia de la biblioteca deja **8 avisos de estilo** (`line too long [-gnatyM]`: 7 en `src/data_structures_basics.adb` y 1 en `src/data_structures_basics.ads`) y **7 warnings**, ninguno de ellos error: 4 de `"New_Node" is not modified, could be declared constant [-gnatwk]`, 1 de `Removed_Value` asignada y nunca leída `[-gnatwm]` y 2 de variables declaradas y no referenciadas (`Failure`, `Result`) `[-gnatwu]`. La compilación, el enlazado y las pruebas terminan con éxito.

**Style and warning output:** with `-gnaty` enabled, a clean build of the library leaves **8 style notices** (`line too long [-gnatyM]`: 7 in `src/data_structures_basics.adb` and 1 in `src/data_structures_basics.ads`) and **7 warnings**, none of them an error: 4 of `"New_Node" is not modified, could be declared constant [-gnatwk]`, 1 of `Removed_Value` assigned but never read `[-gnatwm]` and 2 of variables declared and not referenced (`Failure`, `Result`) `[-gnatwu]`. Compilation, linking and tests all succeed.

---

## 📄 Configuración clave / Key Configuration

| Archivo / File | Qué aporta / What it provides |
|----------------|-------------------------------|
| `data_structures_basics.gpr` | Proyecto de la biblioteca: `Source_Dirs ("src/", "config/")`, `Library_Name` y `Library_Version` tomados de `Data_Structures_Basics_Config.Crate_Version`, tipo de biblioteca seleccionable por variable externa (`DATA_STRUCTURES_BASICS_LIBRARY_TYPE`, por defecto `static`) y `Binder` con `-Es` para traza simbólica. |
| `tests/tests.gpr` | Proyecto del ejecutable: `Main` = `tests.adb`, `Exec_Dir` = `bin`, y los switch de compilación desde `Tests_Config.Ada_Compiler_Switches`. |
| `alire.toml` | Manifiesto del crate: `name = "data_structures_basics"`, `licenses = "GPL-3.0-or-later"`. Sin dependencias. |
| `tests/alire.toml` | `executables = ["tests"]`; `[[depends-on]] data_structures_basics = "*"` con `[[pins]] path = '..'` (la biblioteca local, no una versión publicada) y `[[depends-on]] aunit = "^26.0.0"`. |
| `config/*_config.gpr` | **Autogenerados por Alire**; no se editan y no se versionan (están en `.gitignore`). Aportan `Crate_Version`, `Build_Profile` y `Ada_Compiler_Switches`. |

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
Build Libraries
   [gprlib]       Data_Structures_Basics.lexch
   [archive]      libData_Structures_Basics.a
   [index]        libData_Structures_Basics.a
Success: Build finished successfully in 0.40 seconds.

$ alr -C tests run
Note: Building tests=0.1.0-dev/tests.gpr...
Bind
   [gprbind]      tests.bexch
   [Ada]          tests.ali
Link
   [link]         tests.adb
Success: Build finished successfully in 0.49 seconds.

OK Node
OK LinkedList
OK Stack
OK Queue

Total Tests Run:   4
Successful Tests:  4
Failed Assertions: 0
Unexpected Errors: 0
```

**ES:** Salida copiada de la última ejecución real del 2026-09-26, sin editar. El acta completa del sprint está en [`docs/evidence/algorithms/data_structures_basics/ada.md`](https://github.com/yorche3/programming_languages/blob/main/docs/evidence/algorithms/data_structures_basics/ada.md).

**EN:** Output copied from the last real run on 2026-09-26, unedited. The full sprint record is in [`docs/evidence/algorithms/data_structures_basics/ada.md`](https://github.com/yorche3/programming_languages/blob/main/docs/evidence/algorithms/data_structures_basics/ada.md).

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Operación / Operation | Entrada → salida / Input → output | Complejidad / Complexity | Notas / Notes |
|---|---|---|---|
| `Make` (`Node`) | `(out Node, Integer) → —` | `O(1)` | Asigna `Value` y deja `Next` en `null`. |
| `Get_Value` | `Node → Integer` | `O(1)` | No muta. |
| `Get_Next` | `Node → Node_Access` | `O(1)` | La ausencia de enlace es `null`. |
| `Set_Next` | `(in out Node, Node_Access) → —` | `O(1)` | Enlaza o desenlaza el nodo. |
| `Make` (`Linked_List`) | `out Linked_List → —` | `O(1)` | `Head`/`Tail` a `null` y `Count` a `0`. |
| `Is_Empty` / `Size` (lista) | `Linked_List → Boolean` / `Natural` | `O(1)` | Leen `Count`. |
| `Get_Head` | `Linked_List → Integer` | `O(1)` | `Failure_Value` si la lista está vacía. |
| `Insert_Head` | `(in out Linked_List, Integer) → —` | `O(1)` | Ajusta `Tail` cuando la lista estaba vacía. |
| `Insert_Tail` | `(in out Linked_List, Integer) → —` | `O(1)` | Ajusta `Head` y `Tail` cuando estaba vacía. |
| `Delete` | `(in out Linked_List, Integer, out Boolean) → —` | `O(n)` | Elimina la **primera** aparición; `Success` informa del resultado. |
| `Make` (`Stack`) | `out Stack → —` | `O(1)` | `Top` a `null` y `Count` a `0`. |
| `Is_Empty` / `Size` (pila) | `Stack → Boolean` / `Natural` | `O(1)` | Leen `Count`. |
| `Push` | `(in out Stack, Integer) → —` | `O(1)` | Nuevo nodo por delante de `Top`. |
| `Peek` (pila) | `Stack → Integer` | `O(1)` | Observa sin extraer; `Failure_Value` si está vacía. |
| `Pop` | `(in out Stack, out Integer) → —` | `O(1)` | Extrae el tope; `Failure_Value` si está vacía. |
| `Make` (`Queue`) | `out Queue → —` | `O(1)` | `Front`/`Rear` a `null` y `Count` a `0`. |
| `Is_Empty` / `Size` (cola) | `Queue → Boolean` / `Natural` | `O(1)` | Leen `Count`. |
| `Enqueue` | `(in out Queue, Integer) → —` | `O(1)` | Encadena tras `Rear`; ajusta `Front` si estaba vacía. |
| `Peek` (cola) | `Queue → Integer` | `O(1)` | Observa sin extraer; `Failure_Value` si está vacía. |
| `Dequeue` | `(in out Queue, out Integer) → —` | `O(1)` | Extrae `Front`; deja `Rear` en `null` si la cola queda vacía. |

---

## 🧩 Decisiones de diseño / Design decisions

| Decisión / Decision | Alternativa considerada / Alternative | Razón / Reason |
|---|---|---|
| Indicador de fallo `Failure_Value : constant Integer := -1` | Lanzar una excepción (`Constraint_Error`) o devolver `Boolean` | El contrato pide un valor **representable y no ambiguo** que los tests puedan comparar. Una excepción cambiaría el flujo del contrato; el `Boolean` no permite devolver el valor y el fallo a la vez. |
| `Make` como procedimiento `out` | Función constructora que devuelve el nodo | El contrato exige **declarar primero e inicializar después**: con `out` la instancia tiene que existir antes de la llamada, así que el orden no se puede saltar. |
| Tipos privados con parte privada declarada | Registros públicos | Oculta `Head`/`Tail`/`Count` y `Top`/`Front`/`Rear`: las aserciones observan solo operaciones del contrato, no campos internos. |
| `Node` como registro más un tipo de acceso (`access all Node`) | Nodos en pila dentro de un array, o una lista ligada con índices | El tamaño no se conoce de antemano y cada elemento se enlaza individualmente, que es lo que el módulo enseña. |
| Un único `Node` compartido por los tres ADT | Un tipo de nodo por estructura | La especificación lo fija: `Stack` y `Queue` deben gestionar sus propios punteros, no duplicar el nodo. |
| Un caso de prueba por ADT con pasos sucesivos | Un caso por operación | El estado de un ADT es lo que se quiere comprobar: una instancia inicializada una vez, recorriendo las operaciones en el orden de la especificación. |
| La suite registra los casos con `AUnit.Test_Caller` | `AUnit.Test_Cases.Register_Routine` directo | `Test_Caller` envuelve la creación del caso y deja el nombre visible en el informe (`OK Node`), que es lo que se lee en la salida real. |

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| `init` como nombre conceptual uniforme | `Make` (procedimiento `out`) | La especificación lo autoriza explícitamente para Ada: la inicialización se expresa como procedimiento y conserva la obligación de declarar, inicializar una vez y solo después usar el resto de operaciones. |
| `Node.init(value)` devuelve el nodo (`return this`) | `Make (New_Node : out Node; Value : Integer)` | En Ada un tipo definido en el mismo paquete no se puede devolver desde su propia operación de inicialización sin añadir una función extra; el parámetro `out` cumple la misma obligación. |
| `set_next(next)` devuelve el nodo | `Set_Next (Item : in out Node; Next : Node_Access)` | La mutación sobre el propio registro es la forma nativa; el encadenamiento del pseudocódigo se resuelve llamada a llamada. |
| `get_next()` devuelve «ausente» | `Get_Next` devuelve `Node_Access`, con `null` como ausencia | La especificación no fuerza un centinela: la ausencia de enlace usa la **representación nativa** del lenguaje, que aquí es `null` sobre un tipo de acceso. |
| `delete(value)` devuelve éxito o fallo | `Delete (List, Value, Success : out Boolean)` | El contrato separa el resultado de la operación (`Success`) del indicador de valor (`Failure_Value`), que es para las operaciones que devuelven un valor. |
| `pop()` y `dequeue()` devuelven el valor o un fallo | Procedimiento con `Popped` / `Dequeued : out Integer` | Evita mezclar en un mismo retorno el valor extraído y el indicador; el fallo va en el parámetro de salida con `Failure_Value`. |
| `get_value(get_next(a))` | `Get_Value (Get_Next (First.all).all)` | El tipo de acceso necesita desreferencia explícita (`.all`) para volver al registro. |
| Ubicación esperada: `src/…ext` y `test/` (singular) | `src/` (`.ads`/`.adb`) y subproyecto `tests/` (plural) | Convención del repositorio para Ada; la propia especificación remite a las convenciones del lenguaje y pide declarar la desviación. |
| Valores de prueba dentro del dominio entero | `Integer` con valores positivos (`5, 10, 20, 30, 40`) y `Failure_Value = -1` | Los valores de los casos no colisionan con el indicador de fallo; el contenedor usa `Natural`, que es donde la especificación sugiere `Natural` en Ada. |

---

## 🚨 Indicadores de fallo / Failure indicators

| Operación / Operation | Situación de fallo / Failure situation | Indicador / Indicator | Ejemplo / Example |
|---|---|---|---|
| `Make` (Node/lista/pila/cola) | No aplica: inicialización | — | — |
| `Get_Head` | Lista vacía | `Failure_Value` (`-1`) | `Get_Head (List) = -1` |
| `Delete` | El valor no está en la lista | `Success = False` | `Delete (List, 99, Success)` |
| `Peek` (pila) | Pila vacía | `Failure_Value` (`-1`) | `Peek (S) = -1` |
| `Pop` | Pila vacía | `Failure_Value` (`-1`) en `Popped` | `Pop (S, Popped)` → `Popped = -1` |
| `Peek` (cola) | Cola vacía | `Failure_Value` (`-1`) | `Peek (Q) = -1` |
| `Dequeue` | Cola vacía | `Failure_Value` (`-1`) en `Dequeued` | `Dequeue (Q, Dequeued)` → `Dequeued = -1` |
| Entrada nula o inválida | **No representable** para los ADT | — | No aplica: un tipo privado de Ada no admite `null` como instancia; la ausencia se representa en los enlaces (`Node_Access`), no en la estructura. |

---

## ✅ Cobertura de pruebas / Test coverage

La salida real declara **4 pruebas** (una por ADT) y **4 correctas**. Cada prueba recorre los pasos de la especificación sobre la misma instancia inicializada una sola vez.

The real output states **4 tests** (one per ADT) and **4 successful**. Each test walks the specification's steps over the same instance, initialised once.

### `Node` — `Test_Node_Steps` (`tests/src/data_structures_basics_tests.adb`)

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|:--:|---|---|
| Inicializar y observar valor/enlace | Sí / Yes | `Test_Node_Steps` | `Get_Value = 10` y `Get_Next = null`. |
| Inicializar otro nodo, enlazar y recorrer | Sí / Yes | `Test_Node_Steps` | `Set_Next` y recorrido hasta `20`. |

### `LinkedList` — `Test_Linked_List_Steps`

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|:--:|---|---|
| Estado vacío | Sí / Yes | `Test_Linked_List_Steps` | `Is_Empty`, `Size = 0`, `Get_Head = Failure_Value`. |
| Insertar por ambos extremos | Sí / Yes | `Test_Linked_List_Steps` | `Size = 4` y cabeza `5`. |
| Eliminar primera aparición | Sí / Yes | `Test_Linked_List_Steps` | Tras borrar `10`, `5` y `20`, la cabeza es `10`. |
| Valor ausente | Sí / Yes | `Test_Linked_List_Steps` | `Success = False` y el estado no cambia. |
| Vaciar | Sí / Yes | `Test_Linked_List_Steps` | Vuelve a `Is_Empty`, `Size = 0` y `Failure_Value`. |

### `Stack` — `Test_Stack_Steps`

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|:--:|---|---|
| Estado vacío y extracción fallida | Sí / Yes | `Test_Stack_Steps` | `Peek` y `Pop` devuelven `-1` y el estado sigue vacío. |
| LIFO y `peek` no mutante | Sí / Yes | `Test_Stack_Steps` | `Peek = 30` y `Size = 3` tras los tres `Push`. |
| Extracción y reutilización | Sí / Yes | `Test_Stack_Steps` | `30`, `40`, `20`, `10`; al final vacía y `Size = 0`. |
| Vacío tras extracción | Sí / Yes | `Test_Stack_Steps` | `Pop` falla y la pila sigue vacía. |

### `Queue` — `Test_Queue_Steps`

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|:--:|---|---|
| Estado vacío y extracción fallida | Sí / Yes | `Test_Queue_Steps` | `Peek` y `Dequeue` devuelven `-1` y el estado sigue vacío. |
| FIFO y `peek` no mutante | Sí / Yes | `Test_Queue_Steps` | `Peek = 10` y `Size = 3` tras los tres `Enqueue`. |
| Extracción y reutilización | Sí / Yes | `Test_Queue_Steps` | `10`, `20`, `30`, `40`; al final vacía y `Size = 0`. |
| Vacío tras extracción | Sí / Yes | `Test_Queue_Steps` | `Dequeue` falla y la cola sigue vacía. |

**ES:** La especificación incluye el caso de «entrada nula o inválida» en la política de resultados. En Ada no es representable para estos tipos —un tipo privado no admite `null` como instancia— así que no se añade una prueba para ese escenario; la ausencia solo existe en los enlaces (`Node_Access`). Está declarado en _Adaptaciones idiomáticas_ e _Indicadores de fallo_.

**EN:** The specification includes the "null or invalid input" case in the result policy. In Ada it is not representable for these types —a private type admits no `null` as an instance— so no test is added for that scenario; absence exists only in the links (`Node_Access`). It is declared under _Idiomatic adaptations_ and _Failure indicators_.

---

## ⚠️ Limitaciones conocidas / Known limitations

| Limitación / Limitation | Impacto / Impact | Alternativa o plan / Workaround or plan |
|---|---|---|
| Los nodos se reservan con `new` y **no se liberan**: el módulo no expone ninguna operación de destrucción | Un programa de larga duración que inserte muchos elementos acumula memoria | Fuera del alcance de la fase: la especificación no define ninguna operación de liberación ni de vaciado de la estructura completa. Se resolvería con `Ada.Unchecked_Deallocation` y una operación de limpieza, que sería contrato nuevo. |
| El contador (`Count`) es `Natural` y no hay tope de capacidad | `Size` no puede desbordar en la práctica, pero no hay error definido si se agotara la memoria del sistema | No hay límite artificial por contrato: la especificación lo prohíbe explícitamente. El fallo de reserva lo señala el propio `new` con `Storage_Error`. |
| La compilación limpia deja 8 avisos de estilo y 7 warnings (ninguno es error) | Ruido en la salida de compilación | Los 8 de estilo son `-gnatyM` (línea larga, mayoritariamente en comentarios). De los 7 warnings, 4 son `-gnatwk` (un puntero de trabajo que no se reasigna) y 3 son de código no usado (`Removed_Value`, `Failure`, `Result`), declarados y no leídos. |

---

## 📝 Notas de implementación / Implementation Notes

### 🧱 Un `Node` compartido y tres estructuras independientes / One shared `Node`, three independent structures

**ES:** `Linked_List`, `Stack` y `Queue` son tres tipos privados distintos que envuelven el mismo `Node`. Ninguno delega en otro: `Stack` solo conoce `Top`; `Queue`, `Front` y `Rear`. Compartir el tipo de nodo es lo que pide la especificación; envolver una estructura en otra es lo que prohíbe.

**EN:** `Linked_List`, `Stack` and `Queue` are three distinct private types wrapping the same `Node`. None delegates to another: `Stack` only knows `Top`; `Queue`, `Front` and `Rear`. Sharing the node type is what the specification asks for; wrapping one structure inside another is what it forbids.

### 🔁 La inicialización no se puede saltar / Initialisation cannot be skipped

**ES:** Todos los ADT son tipos privados sin inicialización implícita. `Make` es obligatorio antes de cualquier otra operación, y el compilador lo refuerza: los procedimientos reciben `in out` o `out` sobre el tipo privado, así que un objeto sin inicializar no tiene forma de llegar a ellos. `Is_Empty` y `Size` solo leen `Count`, que `Make` deja a cero.

**EN:** All ADTs are private types with no implicit initialisation. `Make` is mandatory before any other operation, and the compiler enforces it: the procedures take `in out` or `out` on the private type, so an uninitialised object has no path to them. `Is_Empty` and `Size` only read `Count`, which `Make` sets to zero.

### 🧪 Estructura de las pruebas / Test structure

**ES:** La suite registra **un caso por ADT** (no uno por operación) porque lo que se comprueba es el estado completo de la estructura a lo largo de la secuencia de la especificación. Cada caso declara su instancia, llama a `Make` una vez y encadena las operaciones sin reiniciar el escenario; así el caso de «extracción y reutilización» de `Stack` y `Queue` comprueba de verdad que el puntero se reutiliza tras extraer. Los mensajes de las aserciones llevan el número de paso (`"Stack 3: reused top should return 40"`) para localizar el punto exacto cuando algo falla.

**EN:** The suite registers **one case per ADT** (not one per operation) because what is checked is the structure's whole state along the specification's sequence. Each case declares its instance, calls `Make` once and chains the operations without resetting the scenario; that way the "removal and reuse" case in `Stack` and `Queue` really checks that the pointer is reused after extraction. Assertion messages carry the step number (`"Stack 3: reused top should return 40"`) so the exact point can be located when something fails.

### 🎫 Convenciones idiomáticas de Ada / Idiomatic Ada conventions

**ES:** El paquete usa la forma `Make` para la inicialización, `Is_Empty` en lugar de una función `Empty`, y los accesos se leen con `.all` explícito. La parte privada del paquete declara los tres registros con sus campos a `null`/`0` como valores por defecto, de modo que un objeto recién declarado es coherente aunque el contrato siga exigiendo `Make` antes de usarlo.

**EN:** The package uses `Make` for initialisation, `Is_Empty` instead of an `Empty` function, and accesses are read with explicit `.all`. The package's private part declares the three records with their fields defaulting to `null`/`0`, so a freshly declared object is coherent even though the contract still requires `Make` before use.

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

This project is also implemented in other languages. Explore the [main repository](https://github.com/yorche3/programming_languages) to see all the versions.

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
| Especificación / Specification | [`06_Data_Structures_Basics.md`](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) |
| Acta de evidencia / Evidence record | [`docs/evidence/algorithms/data_structures_basics/ada.md`](https://github.com/yorche3/programming_languages/blob/main/docs/evidence/algorithms/data_structures_basics/ada.md) |
| Módulo homologado del lenguaje / Homologated module | [`../naive_sort/README.md`](../naive_sort/README.md) |
| Guía de inicialización / Initialisation guide | [`core/00_Project_Initialization_Guide.md`](https://yorche3.github.io/programming_languages/core/00_Project_Initialization_Guide/) |
| Adaptaciones idiomáticas / Idiomatic adaptations | [`AGENT_Template.md`](https://yorche3.github.io/programming_languages/AGENT_Template/) |
| Validación de la documentación / Documentation validation | [`WORKFLOW.md`](https://yorche3.github.io/programming_languages/WORKFLOW/) |
| Plantilla del README / README template | [`README_Template.md`](https://yorche3.github.io/programming_languages/README_Template/) |
| Documentación oficial del lenguaje / Language official docs | [AUnit](https://github.com/AdaCore/aunit) · [Alire](https://alire.ada.dev/docs/) |

---

*[← Volver al Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
