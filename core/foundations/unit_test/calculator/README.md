# Calculator — Ada

Implementación de la especificación [03_Unit_Test_Calculator](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) en **Ada**, usando el patrón **biblioteca (`--lib`) + subproyecto de pruebas (`--bin`)** con [AUnit](https://github.com/AdaCore/aunit).

---

## 📂 Archivos / Files

### Raíz del proyecto / Project root (`--lib`)

| Archivo | Propósito |
|---------|-----------|
| [`src/calculator.ads`](src/calculator.ads) | Especificación del paquete `Calculator` — declara `Addition`, `Subtraction`, `Multiplication`, `Division`, `Modulus`. |
| [`src/calculator.adb`](src/calculator.adb) | Implementación del cuerpo — suma repetitiva para multiplicación, resta repetitiva para división. |
| [`calculator.gpr`](calculator.gpr) | Proyecto GPRbuild de la biblioteca; genera `libcalculator.a`. |
| [`alire.toml`](alire.toml) | Manifiesto Alire — nombre, versión, autor, licencia. |
| [`.gitignore`](.gitignore) | Ignora `alire/`, `bin/`, `obj/`, `config/`, `lib/`. |

### Subproyecto de pruebas / Test subproject (`tests/ --bin`)

| Archivo | Propósito |
|---------|-----------|
| `tests/src/calculator_tests.ads` | Especificación de los casos de prueba — declara `Test_Addition`, `Test_Subtraction`, etc. |
| `tests/src/calculator_tests.adb` | Implementación de las aserciones con `AUnit.Assertions`. |
| `tests/src/calculator_suite.ads` | Especificación de la suite que agrupa todos los tests. |
| `tests/src/calculator_suite.adb` | Registra cada test en la suite usando `AUnit.Test_Caller`. |
| `tests/src/tests.adb` | Punto de entrada — ejecuta la suite con `AUnit.Run.Test_Runner`. |
| `tests/tests.gpr` | Proyecto GPRbuild del ejecutable de pruebas. |
| `tests/alire.toml` | Manifiesto Alire con dependencias: `calculator` (local) y `aunit`. |

---

## 🏗️ Enfoque / Approach

**ES:** Este proyecto sigue el patrón `--lib` + subproyecto `tests/` (`--bin`):

1. Se crea la biblioteca con `alr init --lib calculator`
2. Dentro de ella, se crea el subproyecto de pruebas con `alr init --bin tests`
3. El subproyecto `tests/` declara dependencia local hacia la biblioteca madre con `alr with calculator --use=..`
4. Se agrega AUnit con `alr with aunit`

**EN:** This project follows the `--lib` + `tests/` subproject (`--bin`) pattern:

1. Create the library with `alr init --lib calculator`
2. Inside it, create the test subproject with `alr init --bin tests`
3. The `tests/` subproject declares a local dependency on the parent library with `alr with calculator --use=..`
4. Add AUnit with `alr with aunit`

### Inicialización / Initialization

```bash
# 1. Crear la biblioteca / Create the library
alr init --lib calculator
cd calculator

# 2. Crear el subproyecto de pruebas / Create the test subproject
alr init --bin tests
cd tests

# 3. Dependencia local hacia la biblioteca madre / Local dependency
alr with calculator --use=..

# 4. Agregar AUnit / Add AUnit
alr with aunit

# 5. Volver a la raíz / Back to root
cd ..
```

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
Submitted   :  5 test case(s) to the test runner.
Used seed   :  ...
Addition    :  1/1
Subtraction :  1/1
Multiplication: 1/1
Division    :  1/1
Modulus     :  1/1
Total tests :  5
Passed      :  5
Failed      :  0
```

> **ES:** El flag `-C tests` ejecuta `alr run` dentro del subdirectorio `tests/`.
> **EN:** The `-C tests` flag runs `alr run` inside the `tests/` subdirectory.

---

## 📁 Estructura / Structure

```text
calculator/                       # Biblioteca / Library (alr init --lib)
├── src/
│   ├── calculator.ads            # Especificación / Specification
│   └── calculator.adb            # Implementación / Implementation
├── tests/                        # Subproyecto de pruebas / Test subproject (alr init --bin)
│   ├── src/
│   │   ├── calculator_tests.ads  # Casos de prueba / Test cases (spec)
│   │   ├── calculator_tests.adb  # Casos de prueba / Test cases (body)
│   │   ├── calculator_suite.ads  # Suite de pruebas / Test suite (spec)
│   │   ├── calculator_suite.adb  # Suite de pruebas / Test suite (body)
│   │   └── tests.adb             # Punto de entrada / Entry point
│   ├── tests.gpr                 # Proyecto GPRbuild de pruebas
│   └── alire.toml                # Dependencias: calculator (local), aunit
├── calculator.gpr                # Proyecto GPRbuild de la biblioteca
├── alire.toml                    # Manifiesto Alire
├── .gitignore
├── obj/                          # Objetos (generado)
├── lib/                          # Biblioteca compilada (generado)
├── bin/                          # Ejecutables (generado)
├── config/                       # Configuración auto-generada (generado)
└── alire/                        # Dependencias (generado)
```

---

## 🧪 Operaciones / Operations

| Función / Function | Implementación / Implementation |
|-------------------|-------------------------------|
| `Addition(A, B)` | `A + B` (suma directa / direct addition) |
| `Subtraction(A, B)` | `A - B` (resta directa / direct subtraction) |
| `Multiplication(A, B)` | Suma repetitiva de `A`, `B` veces / Repeated addition |
| `Division(A, B)` | Resta repetitiva: cuántas veces cabe `B` en `A` / Repeated subtraction |
| `Modulus(A, B)` | `A - (Division(A, B) * B)` usando `Multiplication` y `Subtraction` |

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
