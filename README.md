---
layout: default
title: Ada
description: Monorepo de aprendizaje y experimentación con Ada — fundamentos, microservicios, interfaces gráficas, SAST y CI/CD / Learning and experimentation monorepo with Ada — foundations, microservices, GUI, SAST and CI/CD
nav_order: 1
has_children: true
---

# 🅰️ Ada

> [← Volver al inicio / Back to home](https://yorche3.github.io/programming_languages/)

---

**ES:** Monorepo de aprendizaje y experimentación con **Ada** — desde fundamentos del lenguaje hasta microservicios, interfaces gráficas, SAST y CI/CD.

**EN:** Learning and experimentation monorepo with **Ada** — from language foundations to microservices, GUI, SAST and CI/CD.

---

## 📋 Toolchain

**ES:** Todos los proyectos Ada usan la misma toolchain, configurada globalmente con [Alire](https://alire.ada.dev/).

**EN:** All Ada projects use the same toolchain, globally configured with [Alire](https://alire.ada.dev/).

| Herramienta / Tool | Versión | Instalación / Installation |
|-------------------|---------|--------------------------|
| **Alire** ([docs](https://alire.ada.dev/docs/)) | 2.1.0 | `alr toolchain --select gnat_native=15.2.1` |
| **gnat_native** (GNAT) | 15.2.1 | `alr toolchain --select gprbuild=25.0.1` |
| **gprbuild** ([docs](https://github.com/AdaCore/gprbuild)) | 25.0.1 | `alr toolchain` _(verificar / verify)_ |

### Instalación / Installation

```bash
# 1. Descargar Alire / Download Alire
curl -fSL https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip -o /tmp/alr.zip
unzip /tmp/alr.zip -d /tmp/alr_extracted
sudo mv /tmp/alr_extracted/bin/alr /usr/bin/alr
chmod +x /usr/bin/alr && rm -rf /tmp/alr.zip /tmp/alr_extracted

# 2. Configurar toolchain global / Configure global toolchain
alr toolchain --select gnat_native=15.2.1
alr toolchain --select gprbuild=25.0.1

# 3. Verificar / Verify
alr toolchain
```

> **Tip:** Usa el [`Dockerfile`](Dockerfile) para un entorno reproducible:
> ```bash
> docker build -t ada-env . && docker run --rm -v $(pwd):/workspace -w /workspace ada-env
> ```

---

## 🏗️ Tipos de proyecto / Project Types

**ES:** Ada maneja dos enfoques de proyecto. Ambos requieren un archivo `.gpr` (GPRbuild) y un `alire.toml` para que Alire los reconozca.

**EN:** Ada handles two project approaches. Both require a `.gpr` file (GPRbuild) and an `alire.toml` for Alire to recognize them.

### 1. Proyecto Manual / Manual Project (`--bin`)

**ES:** Archivos creados a mano, estructura plana. Ideal para fundamentos.

**EN:** Hand-created files, flat structure. Ideal for foundations.

```text
project/
├── main.adb           # Código fuente / Source code
├── project.gpr        # Proyecto GPRbuild
├── alire.toml         # Manifiesto Alire
├── .gitignore         # Ignora alire/, bin/, obj/
├── bin/               # Ejecutable (generado)
├── obj/               # Objetos (generado)
└── alire/             # Dependencias (generado)
```

> **ES:** Ejemplo: [`core/foundations/hello_world/`](core/foundations/hello_world/) | Especificación: [01_Hello_World](https://yorche3.github.io/programming_languages/core/foundations/01_Hello_World/)

### 2. Proyecto Biblioteca + Tests / Library + Tests (`--lib` + `--bin`)

**ES:** Para proyectos con pruebas unitarias, se crea una **biblioteca** (`--lib`) con el código fuente, y dentro de ella un **subproyecto ejecutable** (`--bin`) para las pruebas, que depende de la biblioteca madre.

**EN:** For projects with unit tests, create a **library** (`--lib`) with the source code, and inside it a **test subproject** (`--bin`) that depends on the parent library.

```text
project/                    # Biblioteca / Library (alr init --lib project)
├── src/                    # Código fuente / Source code
│   ├── module.ads          # Especificación / Specification
│   └── module.adb          # Implementación / Implementation
├── tests/                  # Subproyecto de pruebas / Test subproject (alr init --bin tests)
│   ├── src/
│   │   ├── test_suite.ads
│   │   ├── test_suite.adb
│   │   ├── test_cases.ads
│   │   ├── test_cases.adb
│   │   └── run_tests.adb
│   ├── tests.gpr           # Depende de project.gpr con --use=..
│   └── alire.toml          # with "calculator" --use=.., with "aunit"
├── project.gpr
├── alire.toml
├── .gitignore
├── obj/                    # Objetos (generado)
├── lib/                    # Biblioteca compilada (generado)
├── bin/                    # Ejecutables (generado)
└── alire/                  # Dependencias (generado)
```

#### Inicialización / Initialization

```bash
# 1. Crear la biblioteca / Create the library
alr init --lib calculator
cd calculator

# 2. Crear el subproyecto de pruebas / Create the test subproject
alr init --bin tests
cd tests

# 3. Dependencia local hacia la biblioteca madre / Local dependency to parent library
alr with calculator --use=..

# 4. Agregar AUnit y otras dependencias / Add AUnit and other dependencies
alr with aunit

# 5. Volver a la raíz del proyecto / Back to project root
cd ..
```

#### Compilar y ejecutar pruebas / Build & Run Tests

```bash
# Compila y ejecuta las pruebas desde la raíz del proyecto
# Build and run tests from the project root
alr -C tests run
```

> **ES:** El flag `-C tests` le indica a Alire que ejecute el comando dentro del subdirectorio `tests/`.
> **EN:** The `-C tests` flag tells Alire to run the command inside the `tests/` subdirectory.

> **ES:** Ejemplo: [`core/foundations/unit_test/calculator/`](core/foundations/unit_test/calculator/) | Especificación: [03_Unit_Test_Calculator](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/)

---

## 🚀 Comandos básicos / Basic Commands

| Comando / Command | Descripción / Description |
|-------------------|--------------------------|
| `alr init --bin <name>` | Inicializar proyecto ejecutable / Init binary project |
| `alr init --lib <name>` | Inicializar proyecto biblioteca / Init library project |
| `alr exec -- gprbuild -P <project>.gpr` | Compilar proyecto manual / Build manual project |
| `alr build` | Compilar con Alire (proyectos `alr init`) |
| `alr run [name]` | Ejecutar / Run |
| `alr -C tests run` | Compilar y ejecutar pruebas (proyecto lib+bin) / Build & run tests |
| `alr with <crate> --use=<path>` | Dependencia local hacia otro proyecto / Local dependency |
| `alr with <crate>` | Agregar dependencia / Add dependency |
| `alr toolchain` | Ver toolchain / View toolchain |

---

## 🧩 Submódulos / Submodules

### `core/` — Fundamentos ([docs](https://yorche3.github.io/programming_languages/core/foundations/))

**ES:** Implementaciones siguiendo la estructura definida en las especificaciones. Cada proyecto es **manual** (sin `alr init`), con archivos mínimos.

**EN:** Implementations following the structure defined in the specifications. Each project is **manual** (without `alr init`), with minimal files.

| Proyecto / Project | Especificación / Specification | Enfoque / Approach |
|-------------------|-------------------------------|-------------------|
| [`hello_world`](core/foundations/hello_world/) | [01_Hello_World](https://yorche3.github.io/programming_languages/core/foundations/01_Hello_World/) | Manual (`--bin`) |
| [`hello_user`](core/foundations/hello_user/) | [02_Hello_User](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) | Manual (`--bin`) |
| [`unit_test/calculator`](core/foundations/unit_test/calculator/) | [03_Unit_Test_Calculator](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) | `--lib` + subproyecto `tests/` `--bin` |

### `learning/` — Proyectos de aprendizaje / Learning projects

**ES:** Proyectos previos de referencia. Usan estructura `src/` + `test/` con AUnit.

**EN:** Previous reference projects. Use `src/` + `test/` structure with AUnit.

| Proyecto / Project | Descripción / Description |
|-------------------|--------------------------|
| [`helloworld`](learning/helloworld/) | `Ada.Text_IO.Put_Line("Hello, World!")` |
| [`hellouser`](learning/hellouser/) | Entrada de usuario con `Get_Line` / User input |
| [`numbers`](learning/numbers/) | Algoritmos numéricos (Fibonacci, factorial, suma) |
| [`unit_test`](learning/unit_test/) | Demo de pruebas unitarias con AUnit |
| [`words`](learning/words/) | Procesamiento de texto (conteo, análisis) |

### `console_training/` — CLI

**ES:** Aplicaciones de terminal con `gnatcoll`.

**EN:** Terminal applications with `gnatcoll`.

```bash
cd console_training/consapp
alr build && alr run consapp
```

### `gui_training/` — GUI

**ES:** Interfaces gráficas con [GtkAda](https://github.com/AdaCore/gtkada).

**EN:** Graphical interfaces with [GtkAda](https://github.com/AdaCore/gtkada).

```bash
cd gui_training/guiapp
alr build && alr run guiapp
```

### `microservices/` — APIs

| Proyecto / Project | Tipo / Type | Dependencias / Dependencies |
|-------------------|-------------|---------------------------|
| `ms_rest` | REST con [AWS](https://github.com/AdaCore/aws) | `aws`, `gnatcoll`, `aunit` |
| `ms_soap` | SOAP con [Matreshka](https://forge.ada-ru.org/matreshka) | `aws`, `gnatcoll`, `xmlada`, `matreshka_soap`, `aunit` |

```bash
cd microservices/ms_rest   # o ms_soap
alr build && alr run ms_rest
alr run run_tests          # Pruebas de integración
```

### `sastada/` — SAST

**ES:** Herramienta de **Static Application Security Testing** para Ada. Analiza código fuente, aplica reglas de seguridad y genera reportes en formato SonarQube.  

**EN:** **Static Application Security Testing** tool for Ada. Analyzes source code, applies security rules and generates SonarQube-format reports.

**Dependencias:** [Libadalang](https://github.com/AdaCore/libadalang)

```bash
cd sastada
alr build && alr run sastada -- --help
```

---

## 🐳 Docker / CI/CD

**ES:** El [`Dockerfile`](Dockerfile) construye una imagen **Ubuntu 24.04** con Alire 2.1.0 y la toolchain completa. El [`Jenkinsfile`](Jenkinsfile) define un pipeline que compila todos los submódulos.

**EN:** The [`Dockerfile`](Dockerfile) builds an **Ubuntu 24.04** image with Alire 2.1.0 and the full toolchain. The [`Jenkinsfile`](Jenkinsfile) defines a pipeline that compiles all submodules.

```bash
# Construir / Build
docker build -t ada-env .

# Usar / Use (ej: compilar core/foundations/hello_world)
docker run --rm -v $(pwd):/workspace -w /workspace ada-env \
    bash -c "cd core/foundations/hello_world && alr exec -- gprbuild -P hello_world.gpr"
```

---

## 📚 Recursos / Resources

- [Documentación Ada — learn.adacore.com](https://learn.adacore.com/)
- [Alire Package Manager](https://alire.ada.dev/) · [Docs](https://alire.ada.dev/docs/) · [GitHub](https://github.com/alire-project/alire)
- [GPRbuild](https://github.com/AdaCore/gprbuild) — Sistema de compilación / Build system
- [GNAT Reference Manual](https://gcc.gnu.org/onlinedocs/gnat_rm/)
- [AUnit](https://github.com/AdaCore/aunit) — Testing framework
- [GtkAda](https://github.com/AdaCore/gtkada) — Bindings GTK
- [AWS](https://github.com/AdaCore/aws) — Ada Web Server
- [Matreshka](https://forge.ada-ru.org/matreshka) — SOAP, XML, SQL
- [Libadalang](https://github.com/AdaCore/libadalang) — Análisis estático / Static analysis
- [SonarQube](https://www.sonarsource.com/products/sonarqube/) — Calidad de código / Code quality

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
