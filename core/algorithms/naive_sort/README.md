# Naive Sort — Ada

Implementación de la especificación [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) en **Ada**, usando el patrón **biblioteca (`--lib`) + subproyecto de pruebas (`test/`, `--bin`)** con [AUnit](https://github.com/AdaCore/aunit).

Implementation of the [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) specification in **Ada**, using the **library (`--lib`) + test subproject (`test/`, `--bin`)** pattern with [AUnit](https://github.com/AdaCore/aunit).

---

## 📂 Archivos y estructura / Files & Structure

### Raíz del proyecto / Project root (`--lib`)

| Archivo / File | Propósito / Purpose |
|----------------|---------------------|
| [`src/naive_sort.ads`](src/naive_sort.ads) | Especificación del paquete `Naive_Sort`: tipo `Integer_Array` y las tres funciones. |
| [`src/naive_sort.adb`](src/naive_sort.adb) | Implementación de `Bubble_Sort`, `Insertion_Sort` y `Selection_Sort`. |
| [`naive_sort.gpr`](naive_sort.gpr) | Proyecto GPRbuild de la biblioteca; genera `libNaive_Sort.a`. |
| [`alire.toml`](alire.toml) | Manifiesto Alire — nombre, versión, autor, licencia. |
| [`.gitignore`](.gitignore) | Ignora `obj/`, `lib/`, `alire/` y `config/`. |

### Subproyecto de pruebas / Test subproject (`test/`, `--bin`)

| Archivo / File | Propósito / Purpose |
|----------------|---------------------|
| [`test/src/naive_sort_tests.ads`](test/src/naive_sort_tests.ads) | Fixture `Test`, tipo `Sort_Function` y declaración de los tres casos. |
| [`test/src/naive_sort_tests.adb`](test/src/naive_sort_tests.adb) | Casos de prueba y helper `Assert_All_Cases` con los 7 escenarios. |
| [`test/src/naive_sort_suite.ads`](test/src/naive_sort_suite.ads) / [`.adb`](test/src/naive_sort_suite.adb) | Suite AUnit que agrupa los tres algoritmos. |
| [`test/src/test.adb`](test/src/test.adb) | Punto de entrada — ejecuta la suite con `AUnit.Run.Test_Runner`. |
| [`test/test.gpr`](test/test.gpr) | Proyecto GPRbuild del ejecutable de pruebas. |
| [`test/alire.toml`](test/alire.toml) | Dependencias: `naive_sort` (local, pin `..`) y `aunit ^26.0.0`. |

**Estructura de directorios esperada / Expected directory structure:**

```text
naive_sort/                       # Biblioteca / Library (alr init --lib)
├── src/
│   ├── naive_sort.ads            # Especificación / Specification
│   └── naive_sort.adb            # Implementación / Implementation
├── test/                         # Subproyecto de pruebas / Test subproject (alr init --bin)
│   ├── src/
│   │   ├── naive_sort_tests.ads / .adb   # Casos de prueba / Test cases
│   │   ├── naive_sort_suite.ads / .adb   # Suite AUnit / AUnit suite
│   │   └── test.adb                      # Punto de entrada / Entry point
│   ├── test.gpr                  # Proyecto GPRbuild de pruebas / Test GPRbuild project
│   └── alire.toml                # Dependencias / Dependencies
├── naive_sort.gpr                # Proyecto GPRbuild de la biblioteca / Library GPRbuild project
├── alire.toml                    # Manifiesto Alire / Alire manifest
├── .gitignore
├── obj/                          # Objetos (generado) / Objects (generated)
├── lib/                          # Biblioteca compilada (generado) / Compiled library (generated)
├── alire/                        # Dependencias (generado) / Dependencies (generated)
├── config/                       # Configuración auto-generada (generado) / Auto-generated config (generated)
└── share/                        # Artefactos de instalación de Alire (generado) / Alire install artifacts (generated)
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Mismo patrón `--lib` + subproyecto de pruebas que [`numbers`](../../foundations/numbers/README.md), con la diferencia de que el subproyecto se llama `test/` (singular) para este módulo. Los algoritmos se implementan manualmente, sin invocar bibliotecas nativas de ordenamiento.

**EN:** Same `--lib` + test subproject pattern as [`numbers`](../../foundations/numbers/README.md), except the subproject is named `test/` (singular) for this module. The algorithms are implemented manually, without invoking native sort libraries.

**Salida de estilos / Style output:** GNAT aplica sus comprobaciones de estilo (`-gnaty`) y reporta avisos de formato y una sugerencia de `constant` en `naive_sort.adb`. No son errores: la compilación y el enlace terminan con éxito.

**EN:** GNAT applies its style checks (`-gnaty`) and reports formatting warnings plus a `constant` suggestion in `naive_sort.adb`. These are not errors: compilation and linking succeed.

---

## 🚀 Compilación y ejecución / Build & Run

### Compilar la biblioteca / Build the library

```bash
alr build
```

### Ejecutar pruebas unitarias / Run unit tests

```bash
alr -C test run
```

**Salida real / Actual output:**

```text
OK Bubble_Sort
OK Insertion_Sort
OK Selection_Sort

Total Tests Run:   3
Successful Tests:  3
Failed Assertions: 0
Unexpected Errors: 0
```

---

## 🧠 Algoritmos / Algorithms

| Algoritmo / Algorithm | Estrategia / Strategy | Complejidad temporal / Time complexity | In-place |
|-----------------------|-----------------------|----------------------------------------|:--------:|
| `Bubble_Sort` | Compara e intercambia adyacentes; corta antes si no hubo intercambios (`Swapped`) | $O(n^2)$ peor/promedio, $O(n)$ mejor | ✅ |
| `Insertion_Sort` | Construye el sub-array ordenado insertando cada elemento en su posición | $O(n^2)$ peor/promedio, $O(n)$ mejor | ✅ |
| `Selection_Sort` | Busca el mínimo del resto no ordenado y lo ubica al inicio | $O(n^2)$ siempre | ✅ |

### API pública / Public API

```ada
package Naive_Sort is
   type Integer_Array is array (Natural range <>) of Integer;

   function Bubble_Sort (Arr : Integer_Array) return Integer_Array;
   function Insertion_Sort (Arr : Integer_Array) return Integer_Array;
   function Selection_Sort (Arr : Integer_Array) return Integer_Array;
end Naive_Sort;
```

### Casos cubiertos por las pruebas / Cases covered by the tests

Cada algoritmo verifica los mismos 7 escenarios (21 aserciones en total) / Each algorithm checks the same 7 scenarios (21 assertions total):

| Caso / Case | Entrada / Input | Salida esperada / Expected output |
|-------------|-----------------|-----------------------------------|
| Desordenado / Unsorted | `(5, 2, 9, 1, 5, 6)` | `(1, 2, 5, 5, 6, 9)` |
| Ya ordenado / Already sorted | `(1, 2, 3, 4, 5)` | `(1, 2, 3, 4, 5)` |
| Orden inverso / Reverse order | `(5, 4, 3, 2, 1)` | `(1, 2, 3, 4, 5)` |
| Idénticos / Identical | `(7, 7, 7, 7)` | `(7, 7, 7, 7)` |
| Negativos / Negatives | `(3, -1, 4, -5, 0)` | `(-5, -1, 0, 3, 4)` |
| Un elemento / Single element | `(0 => 42)` | `(0 => 42)` |
| Vacío / Empty | `(1 .. 0 => 0)` | `(1 .. 0 => 0)` |

---

## 📝 Notas de implementación / Implementation Notes

### 🧱 Tipo de array no restringido / Unconstrained array type

**ES:** `Integer_Array` es un array no restringido (`array (Natural range <>) of Integer`). Su rango se fija con el argumento real en cada llamada, no en la declaración del tipo. Por eso un agregado de un solo elemento debe usar un índice explícito, `(0 => 42)`: `Integer_Array'First` no es válido porque el tipo no está restringido. El caso vacío se expresa como `(1 .. 0 => 0)`.

**EN:** `Integer_Array` is an unconstrained array (`array (Natural range <>) of Integer`). Its range is fixed by the actual argument on each call, not by the type declaration. Therefore a single-element aggregate must use an explicit index, `(0 => 42)`: `Integer_Array'First` is not valid because the type is not constrained. The empty case is written as `(1 .. 0 => 0)`.

### 🔁 Sobre el sentido de "in-place" / On the meaning of "in-place"

**ES:** La especificación admite ordenar in-place o devolver una copia ordenada, según el paradigma del lenguaje. En esta implementación cada función recibe el parámetro como `in` y **devuelve una copia ordenada** (`Result : Integer_Array (Arr'Range) := Arr;`), de modo que el array del llamador no se modifica. La estrategia de los tres algoritmos sigue siendo in-place sobre esa copia.

**EN:** The specification allows sorting in-place or returning a sorted copy, depending on the language paradigm. In this implementation each function takes the parameter as `in` and **returns a sorted copy** (`Result : Integer_Array (Arr'Range) := Arr;`), so the caller's array is not modified. The strategy of all three algorithms remains in-place over that copy.

### ⚠️ Indicador de fallo / Failure indicator

**ES:** El contrato de la especificación pide devolver un indicador de fallo ante entradas nulas o inválidas, y aclara que si el tipo de array no admite `null` se documente la representación equivalente. En Ada, `Integer_Array` no puede ser nulo: no existe una representación de "array nulo" para este tipo. Los casos inválidos no son representables y, por tanto, no se añade una prueba de ese escenario; se conservan los 7 casos aplicables y el caso vacío devuelve el mismo array vacío. No se lanzan excepciones.

**EN:** The specification contract requires returning a failure indicator for null or invalid inputs, and states that if the array type cannot represent `null`, the equivalent representation must be documented. In Ada, `Integer_Array` cannot be null: there is no "null array" representation for this type. Invalid cases are not representable, so no test is added for that scenario; the 7 applicable cases are kept, and the empty case returns the same empty array. No exceptions are thrown.

### 🧪 Estructura de las pruebas / Test structure

**ES:** Las tres funciones comparten el mismo perfil, así que la suite pasa cada una a un helper común mediante el tipo de acceso `Sort_Function`. Esto evita duplicar los 7 casos por algoritmo y mantiene un único punto de verdad para los datos esperados. La suite se registra con `AUnit.Test_Caller` y el runner reporta un caso por algoritmo.

**EN:** All three functions share the same profile, so the suite passes each one to a shared helper through the `Sort_Function` access type. This avoids duplicating the 7 cases per algorithm and keeps a single source of truth for the expected data. The suite is registered with `AUnit.Test_Caller` and the runner reports one case per algorithm.

---

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

This project is also implemented in other languages. Explore the [main repository](https://github.com/yorche3/programming_languages) to see all the versions.

---

*[← Volver al Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
