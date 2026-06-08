# Numbers — Ada

Implementación de la especificación [04_Numbers](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) en **Ada**, usando el patrón **biblioteca (`--lib`) + subproyecto de pruebas (`--bin`)** con [AUnit](https://github.com/AdaCore/aunit).

---

## 📂 Archivos y estructura / Files & Structure

### Raíz del proyecto / Project root (`--lib`)

| Archivo | Propósito |
|---------|-----------|
| [`src/numbers.ads`](src/numbers.ads) | Especificación del paquete `Numbers` — declara funciones para los 3 enfoques. |
| [`src/numbers.adb`](src/numbers.adb) | Implementación: suma, factorial, Fibonacci, MCD, MCM en 3 enfoques. |
| [`numbers.gpr`](numbers.gpr) | Proyecto GPRbuild de la biblioteca; genera `libnumbers.a`. |
| [`alire.toml`](alire.toml) | Manifiesto Alire — nombre, versión, autor, licencia. |
| [`.gitignore`](.gitignore) | Ignora `alire/`, `bin/`, `obj/`, `config/`, `lib/`. |

### Subproyecto de pruebas / Test subproject (`tests/ --bin`)

| Archivo | Propósito |
|---------|-----------|
| `tests/src/recursive_tests.ads / .adb` | Tests del enfoque recursivo directo |
| `tests/src/recursive_with_acc_tests.ads / .adb` | Tests del enfoque recursivo con acumulador |
| `tests/src/iterative_tests.ads / .adb` | Tests del enfoque iterativo |
| `tests/src/recursive_suite.ads / .adb` | Suite que agrupa los tests recursivos |
| `tests/src/recursive_with_acc_suite.ads / .adb` | Suite que agrupa los tests con acumulador |
| `tests/src/iterative_suite.ads / .adb` | Suite que agrupa los tests iterativos |
| `tests/src/tests.adb` | Punto de entrada — ejecuta las 3 suites con `AUnit.Run.Test_Runner` |
| `tests/tests.gpr` | Proyecto GPRbuild del ejecutable de pruebas |
| `tests/alire.toml` | Manifiesto Alire con dependencias: `numbers` (local) y `aunit` |

**Estructura de directorios esperada:**

```text
numbers/                          # Biblioteca / Library (alr init --lib)
├── src/
│   ├── numbers.ads               # Especificación / Specification
│   └── numbers.adb               # Implementación / Implementation
├── tests/                        # Subproyecto de pruebas / Test subproject (alr init --bin)
│   ├── src/
│   │   ├── recursive_tests.ads / .adb          # Tests recursivos directos
│   │   ├── recursive_with_acc_tests.ads / .adb # Tests recursivos con acumulador
│   │   ├── iterative_tests.ads / .adb          # Tests iterativos
│   │   ├── recursive_suite.ads / .adb          # Suite recursiva
│   │   ├── recursive_with_acc_suite.ads / .adb # Suite con acumulador
│   │   ├── iterative_suite.ads / .adb          # Suite iterativa
│   │   └── tests.adb                           # Punto de entrada
│   ├── tests.gpr                 # Proyecto GPRbuild de pruebas
│   └── alire.toml                # Dependencias: numbers (local), aunit
├── numbers.gpr                   # Proyecto GPRbuild de la biblioteca
├── alire.toml                    # Manifiesto Alire
├── .gitignore
├── obj/                          # Objetos (generado)
├── lib/                          # Biblioteca compilada (generado)
├── bin/                          # Ejecutables (generado)
├── config/                       # Configuración auto-generada (generado)
└── alire/                        # Dependencias (generado)
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Mismo patrón `--lib` + subproyecto `tests/` (`--bin`) que [`calculator`](../unit_test/calculator/).

**EN:** Same `--lib` + `tests/` subproject (`--bin`) pattern as [`calculator`](../unit_test/calculator/).

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

**Salida esperada / Expected output:**

```text
Submitted   :  15 test case(s) to the test runner.
...
Total tests :  15
Passed      :  15
Failed      :  0
```

---

## 🧠 Algoritmos / operaciones (según el módulo)

### 3 enfoques × 5 algoritmos = 15 funciones

| Algoritmo | `_Rec` | `_Acc` | `_Iter` |
|-----------|--------|--------|---------|
| `Sum_Of_First_N` | ✅ | ✅ | ✅ |
| `Factorial` | ✅ | ✅ | ✅ |
| `Fibonacci` | ✅ | ✅ | ✅ |
| `Greatest_Common_Divisor` | ✅ | ✅ | ✅ |
| `Least_Common_Multiple` | ✅ | ✅ | ✅ |

---

## 📝 Notas de implementación / Implementation Notes

### 🔁 Sobre recursión con acumulador y Tail Call Optimization (TCO) / On recursion with accumulator and Tail Call Optimization (TCO)

**ES:**

Tail recursion ocurre cuando la llamada recursiva es la última acción que ejecuta una función/método; después de la llamada no hay más instrucciones, la función devuelve el resultado de la llamada recursiva. La recursión con acumulador consigue esto pasando el estado previo como parámetro a cada llamada, sin dejar trabajo pendiente en la pila.

En **Ada**, el compilador **GNAT** puede optimizar llamadas terminales (TCO) con niveles de optimización como `-O2` o superiores. Sin embargo, la especificación del lenguaje Ada **no garantiza** TCO de forma explícita. En la práctica, GNAT aplica TCO en muchos casos cuando detecta una llamada terminal, especialmente en modo de optimización.

Dado que Ada ofrece esta optimización en tiempo de compilación, las funciones con acumulador (`_Acc`) tienen tests directos (5 tests) al igual que los otros enfoques, ya que representan una implementación válida y eficiente en la práctica.

**EN:**

Tail recursion occurs when the recursive call is the last action that runs a function/method; after the call there are no more instructions, the function returns the result of the recursive call. Recursion with accumulator achieves this by passing the previous state as a parameter to each call, without leaving any pending work on the stack.

In **Ada**, the **GNAT** compiler can optimize tail calls (TCO) with optimization levels like `-O2` or higher. However, the Ada language specification **does not guarantee** TCO explicitly. In practice, GNAT applies TCO in many cases when a tail call is detected, especially in optimization mode.

Since Ada offers this optimization at compile time, the accumulator functions (`_Acc`) have direct tests (5 tests) just like the other approaches, as they represent a valid and efficient implementation in practice.

---

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
