---
layout: default
title: Ada
description: Monorepo de aprendizaje y experimentación con Ada — fundamentos, microservicios, interfaces gráficas, SAST y CI/CD / Learning and experimentation monorepo with Ada — foundations, microservices, GUI, SAST and CI/CD
nav_order: 1
has_children: true
---

# 🅰️ Ada

> [← Volver al inicio / Back to home](../index.md)

---

**ES:** Monorepo de aprendizaje y experimentación con **Ada** — desde fundamentos del lenguaje hasta microservicios, interfaces gráficas, SAST y CI/CD. Cada proyecto dentro de este directorio implementa una o más especificaciones definidas en [`docs/`](../docs/).

**EN:** Learning and experimentation monorepo with **Ada** — from language foundations to microservices, GUI, SAST and CI/CD. Each project within this directory implements one or more specifications defined in [`docs/`](../docs/).

---

## 📋 Toolchain

**ES:** Todos los proyectos Ada usan la misma toolchain, configurada globalmente con Alire:

**EN:** All Ada projects use the same toolchain, globally configured with Alire:

| Herramienta / Tool | Versión | Propósito / Purpose |
|-------------------|---------|--------------------|
| **Alire** | 2.1.0 | Gestor de paquetes y sistema de compilación / Package manager and build system |
| **gnat_native** | 15.2.1 | Compilador GNAT para Ada / GNAT compiler for Ada |
| **gprbuild** | 25.0.1 | Sistema de compilación basado en proyectos / Project-based build system |

### Instalación / Installation

```bash
# Descargar e instalar Alire 2.1.0 (Linux x86_64)
curl -fSL https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip -o /tmp/alr.zip
unzip /tmp/alr.zip -d /tmp/alr_extracted
sudo mv /tmp/alr_extracted/bin/alr /usr/bin/alr
chmod +x /usr/bin/alr
rm -rf /tmp/alr.zip /tmp/alr_extracted

# Configurar toolchain
alr toolchain --select gnat_native=15.2.1
alr toolchain --select gprbuild=25.0.1

# Verificar
alr toolchain
```

> **Tip:** También puedes usar el `Dockerfile` incluido para un entorno reproducible.  
> **Tip:** You can also use the included `Dockerfile` for a reproducible environment.
> ```bash
> docker build -t ada-env . && docker run --rm -it ada-env
> ```

---

## 📁 Estructura / Structure

```text
ada/
├── core/                    # Implementaciones de docs/core/ (fundamentos)
│   └── foundations/
│       ├── hello_world/     # 01_Hello_World.md
│       └── hello_user/      # 02_Hello_User.md
├── console_training/        # Aplicaciones CLI (GNAT.Terminal, etc.)
├── gui_training/            # Interfaces gráficas con GtkAda
├── learning/                # Proyectos de aprendizaje previos (referencia)
├── microservices/           # APIs y servicios web
├── sastada/                 # SAST (Static Application Security Testing)
├── Dockerfile               # Entorno reproducible para CI/CD
├── Jenkinsfile              # Pipeline Jenkins
└── LICENSE                  # Licencia GPL-3.0
```

---

## 🚀 Comandos básicos / Basic Commands

| Comando / Command | Descripción / Description |
|-------------------|--------------------------|
| `alr exec -- gprbuild -P <project>.gpr` | Compilar un proyecto manual / Build a manual project |
| `alr build` | Compilar con Alire (proyectos `alr init`) |
| `alr run [name]` | Ejecutar un proyecto Alire |
| `alr toolchain` | Ver toolchain configurada / View configured toolchain |
| `alr with <crate>` | Agregar dependencia / Add dependency |

---

## 🔬 Pruebas unitarias / Unit Testing

**ES:** Los proyectos usan **AUnit** (el framework de pruebas unitarias estándar para Ada). Ver [`learning/Ada_Readme.md`](learning/Ada_Readme.md) para una guía detallada de estructura de pruebas.

**EN:** Projects use **AUnit** (the standard unit testing framework for Ada). See [`learning/Ada_Readme.md`](learning/Ada_Readme.md) for a detailed guide on test structure.

---

## 🧩 Submódulos / Submodules

### `core/` — Fundamentos (nuevo / new)

**ES:** Implementaciones siguiendo la estructura definida en [`docs/core/`](../docs/core/). Cada proyecto es **manual** (sin `alr init`), con archivos mínimos.

**EN:** Implementations following the structure defined in [`docs/core/`](../docs/core/). Each project is **manual** (without `alr init`), with minimal files.

| Proyecto / Project | Especificación / Specification |
|-------------------|-------------------------------|
| [`hello_world`](core/foundations/hello_world/) | [`01_Hello_World.md`](../docs/core/foundations/01_Hello_World.md) |
| [`hello_user`](core/foundations/hello_user/) | [`02_Hello_User.md`](../docs/core/foundations/02_Hello_User.md) |

### `learning/` — Proyectos de aprendizaje / Learning projects

**ES:** Proyectos previos de referencia. Suelen ser bibliotecas (`alr init --lib`) con pruebas unitarias.

**EN:** Previous reference projects. Usually libraries (`alr init --lib`) with unit tests.

| Proyecto / Project | Descripción / Description |
|-------------------|--------------------------|
| `helloworld` | Hola mundo clásico (`Ada.Text_IO`) |
| `hellouser` | Entrada de usuario con `Get_Line` |
| `numbers` | Algoritmos numéricos (factorial, Fibonacci, etc.) |
| `unit_test` | Demo de pruebas unitarias con AUnit |
| `words` | Procesamiento de texto (conteo, análisis, etc.) |

### `console_training/` — CLI

**ES:** Aplicaciones de terminal.  
**EN:** Terminal applications.

**Dependencias:** `gnatcoll`

```bash
cd console_training/consapp
alr build
alr run consapp
```

### `gui_training/` — GUI

**ES:** Interfaces gráficas con **GtkAda** (bindings de GTK para Ada).  
**EN:** Graphical interfaces with **GtkAda** (GTK bindings for Ada).

**Dependencias:** `gtkada`

```bash
cd gui_training/guiapp
alr build
alr run guiapp
```

### `microservices/` — APIs

| Proyecto / Project | Tipo / Type | Dependencias / Dependencies |
|-------------------|-------------|---------------------------|
| `ms_rest` | API REST con AWS | `aws`, `gnatcoll`, `aunit` |
| `ms_soap` | API SOAP con Matreshka | `aws`, `gnatcoll`, `xmlada`, `matreshka_soap`, `aunit` |

```bash
cd microservices/ms_rest   # o ms_soap
alr build
alr run ms_rest           # o ms_soap
alr run run_tests         # Pruebas de integración
```

### `sastada/` — SAST

**ES:** Herramienta de **Static Application Security Testing** para Ada. Analiza código fuente, aplica reglas de seguridad y genera reportes en formato SonarQube.  
**EN:** **Static Application Security Testing** tool for Ada. Analyzes source code, applies security rules and generates SonarQube-format reports.

**Dependencias:** `libadalang`

```bash
cd sastada
alr build
alr run sastada -- --help
```

---

## 🐳 Docker / CI/CD

**ES:** El `Dockerfile` construye una imagen basada en **Ubuntu 24.04** con Alire 2.1.0 y la toolchain completa. El `Jenkinsfile` define un pipeline que compila todos los submódulos.

**EN:** The `Dockerfile` builds an image based on **Ubuntu 24.04** with Alire 2.1.0 and the full toolchain. The `Jenkinsfile` defines a pipeline that compiles all submodules.

```bash
# Construir imagen / Build image
docker build -t ada-env .

# Usar / Use
docker run --rm -v $(pwd):/workspace -w /workspace/<submodulo> ada-env alr build
```

---

## 📚 Recursos / Resources

- [Ada Documentation — learn.adacore.com](https://learn.adacore.com/)
- [Alire Package Manager — alire.ada.dev](https://alire.ada.dev/)
- [GtkAda](https://github.com/AdaCore/gtkada)
- [AWS — Ada Web Server](https://github.com/AdaCore/aws)
- [Matreshka](https://forge.ada-ru.org/matreshka)
- [Libadalang](https://github.com/AdaCore/libadalang)
- [SonarQube](https://www.sonarsource.com/products/sonarqube/)

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages)*
