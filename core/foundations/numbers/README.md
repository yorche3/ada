# Numbers — Ada

Implementación de la especificación [04_Numbers](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) en **Ada**, usando el patrón **biblioteca (`--lib`) + subproyecto de pruebas (`--bin`)** con [AUnit](https://github.com/AdaCore/aunit).

---

## 📂 Archivos / Files

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

---

## 🏗️ Enfoque / Approach

**ES:** Mismo patrón `--lib` + subproyecto `tests/` (`--bin`) que [`calculator`](../unit_test/calculator/).

**EN:** Same `--lib` + `tests/` subproject (`--bin`) pattern as [`calculator`](../unit_test/calculator/).

---

## 🚀 Compilar y ejecutar / Build & Run

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

## 🧪 Algoritmos / Algorithms

### 3 enfoques × 5 algoritmos = 15 funciones

| Algoritmo | `_Rec` | `_Acc` | `_Iter` |
|-----------|--------|--------|---------|
| `Sum_Of_First_N` | ✅ | ✅ | ✅ |
| `Factorial` | ✅ | ✅ | ✅ |
| `Fibonacci` | ✅ | ✅ | ✅ |
| `Greatest_Common_Divisor` | ✅ | ✅ | ✅ |
| `Least_Common_Multiple` | ✅ | ✅ | ✅ |

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
