# 🔍 SastAda — SAST for Ada

[![License](https://img.shields.io/badge/Licencia-MIT-yellow.svg)](LICENSE)
[![Alire](https://img.shields.io/badge/alire-2.1.0-blue)](https://alire.ada.dev)
[![Libadalang](https://img.shields.io/badge/Libadalang-%E2%89%A526.0.0-blue)](https://github.com/AdaCore/libadalang)

**Static Application Security Testing** para código fuente Ada.  
Escanea archivos `.ads`/`.adb`, aplica reglas de calidad y seguridad, y genera reportes **JSON compatibles con SonarQube**.

---

## 📋 Estado / Status

> **MVP — Minimum Viable Product**  
> Herramienta funcional lista para usar como base.  
> Functional tool ready to use as a foundation.

### ✅ Implementado / Implemented

| Aspecto | Estado |
|---------|--------|
| CLI con argumentos (`--project-path`, `--src-dir`, `--output`, `--cache`, `--suppress`) | ✅ |
| Análisis vía AST con **Libadalang** | ✅ |
| Fallback textual (cuando Libadalang no está disponible) | ✅ |
| 14 reglas SAST (SAST-001 a SAST-014) | ✅ |
| Análisis incremental con caché | ✅ |
| Reporte JSON compatible con **SonarQube Generic Issue Data** | ✅ |
| Supresión de reglas (`--suppress=SAST-NNN` / `--suppress=SAST-NNN:file`) | ✅ |
| Decisión de PR (pass/reject) basada en blocker/critical | ✅ |
| Búsqueda recursiva de fuentes Ada | ✅ |
| Rutas relativas en reportes (seguridad) | ✅ |

### 📋 Pendiente / Roadmap

| Aspecto | Estado |
|---------|--------|
| Tests unitarios | 📋 Pendiente |
| Documentación de reglas en `docs/` | 📋 Pendiente |
| Integración CI/CD (GitHub Actions, Jenkins) | 📋 Pendiente |
| Más reglas SAST | 📋 Pendiente |
| Reportes en otros formatos (SARIF, HTML) | 📋 Pendiente |

---

## 🚀 Uso / Usage

### Requisitos / Requirements

- [Alire](https://alire.ada.dev/) 2.1.0+
- [Libadalang](https://github.com/AdaCore/libadalang) ^26.0.0 (opcional — sin él usa fallback textual)

### Compilar / Build

```bash
cd ada/sastada
alr build
```

### Ejecutar / Run

```bash
# Ayuda
alr run sastada -- --help

# Analizar un proyecto (busca src/ automáticamente)
alr run sastada -- --project-path=/ruta/al/proyecto

# Analizar con directorio fuente explícito
alr run sastada -- --project-path=/ruta --src-dir=src_sub

# Especificar archivo de salida
alr run sastada -- --project-path=/ruta --output=report.json

# Suprimir reglas
alr run sastada -- --project-path=/ruta --suppress=SAST-009
alr run sastada -- --project-path=/ruta --suppress=SAST-005:src/seguro.adb

# Directorio actual
alr run sastada -- --src-dir=.
```

### Opciones / Options

| Opción | Descripción |
|--------|-------------|
| `--project-path=<path>` | Ruta completa del proyecto a analizar |
| `--src-dir=<dir>` | Directorio fuente (por defecto: `<project-path>/src/` o `.`) |
| `--output=<file>` | Archivo de reporte (por defecto: `<project-path>/sastada_report.json`) |
| `--cache=<file>` | Archivo de caché para análisis incremental (por defecto: `<project-path>/.sastada_cache`) |
| `--project=<file>` | Archivo `.gpr` del proyecto (opcional) |
| `--suppress=<rule>[:file]` | Suprime una regla (opcionalmente solo para un archivo) |
| `--help` | Muestra ayuda |

### Integrar con SonarQube

Una vez generado el reporte, impórtalo en SonarQube:

```bash
sonar-scanner \
  -Dsonar.externalIssuesReportPaths=sastada_report.json \
  -Dsonar.projectKey=mi-proyecto-ada \
  -Dsonar.sources=.
```

SastAda genera el JSON en el formato **SonarQube Generic Issue Data** — no necesita transformación extra.

---

## 🧪 Reglas / Rules

| ID | Nombre | Severidad | Tipo | Descripción |
|----|--------|-----------|------|-------------|
| SAST-001 | `Unchecked_Deallocation` | CRITICAL | Security | Uso de `Unchecked_Deallocation` — usar tipos controlados |
| SAST-002 | `Unchecked_Conversion` | MAJOR | Reliability | Uso de `Unchecked_Conversion` — usar conversiones seguras |
| SAST-003 | `Address Usage` | CRITICAL | Security | Uso de `'Address` — usar tipos access |
| SAST-004 | `Excessive Function Length` | MAJOR | Maintainability | Función >100 líneas — refactorizar |
| SAST-005 | `Infinite Loop Risk` | CRITICAL | Reliability | Bucle sin `exit` — riesgo de infinito |
| SAST-006 | `GOTO Statement` | CRITICAL | Code Style | Sentencia `goto` — usar flujo estructurado |
| SAST-007 | `Deep Nesting` | MAJOR | Maintainability | Anidamiento >4 niveles — refactorizar |
| SAST-008 | `Hardcoded Credentials` | BLOCKER | Security | Credenciales hardcodeadas — usar variables de entorno |
| SAST-009 | `Missing Pure/Preelaborate` | MINOR | Code Style | Paquete sin `Pure`/`Preelaborate` |
| SAST-010 | `Exception Handling Missing` | MAJOR | Reliability | Subprograma sin manejador de excepciones |
| SAST-011 | `Long Identifier` | MINOR | Maintainability | Identificador >40 caracteres |
| SAST-012 | `Strictly Null Statement` | MINOR | Code Style | `null;` sin contexto |
| SAST-013 | `Uninitialized Variable` | MAJOR | Reliability | Variable sin inicialización |
| SAST-014 | `Unvalidated System Call` | CRITICAL | Security | Uso de `Command_Line`, `Directories`, `Environment_Variables` sin validación previa |

> **Nota:** SAST-008 funciona con pattern matching (fallback textual) incluso sin Libadalang. Las demás reglas usan el motor AST.
>
> Documentación detallada de cada regla con ejemplos: [`docs/RULES.md`](docs/RULES.md).

---

## 🏗️ Arquitectura / Architecture

```text
sastada/
├── src/
│   ├── sastada.adb              # Entry point + CLI
│   ├── sastada_rules.ads/.adb   # Definición de reglas y hallazgos
│   ├── sastada_analysis.ads/.adb # Motor de análisis (orquestación)
│   ├── sastada_ast.ads/.adb     # Análisis AST con Libadalang
│   ├── sastada_sonarqube.ads/.adb # Generación de reportes SonarQube
│   └── sastada_utils.ads/.adb   # Utilidades (caché, archivos, rutas)
├── sastada.gpr                  # Proyecto GPRbuild
├── alire.toml                   # Manifiesto Alire
└── .gitignore                   # Ignora alire/, bin/, obj/, config/
```

### Flujo de análisis / Analysis Flow

```text
[CLI Args] → sastada.adb (Parse_Args)
    ↓
sastada_analysis.adb (Run_Analysis)
    ├── Load_Cache → archivos no modificados se saltan
    ├── Filter_Modified_Files → solo analiza cambios
    ├── Analyze_Files
    │   ├── [AST] sastada_ast.adb → Libadalang → reglas SAST-001..014
    │   └── [TEXT] sastada_analysis.adb → pattern matching → SAST-008, 014
    ├── Save_Cache
    ├── Apply Suppressions
    └── sastada_sonarqube.adb → Write_Report_File (JSON)
```

> **ES:** El motor AST requiere Libadalang. Si no está disponible, se usa un fallback textual que solo cubre SAST-008 (credenciales) y SAST-014 (llamadas a sistema).  
> **EN:** The AST engine requires Libadalang. If unavailable, a text-based fallback covers only SAST-008 (credentials) and SAST-014 (system calls).

---

## 📁 Estructura / Structure

```text
sastada/
├── src/
│   ├── sastada.adb              # Punto de entrada / Entry point
│   ├── sastada_rules.ads/.adb   # Reglas / Rules
│   ├── sastada_analysis.ads/.adb# Análisis / Analysis engine
│   ├── sastada_ast.ads/.adb     # AST / Libadalang analysis
│   ├── sastada_sonarqube.ads/.adb # Reportes / SonarQube reports
│   └── sastada_utils.ads/.adb   # Utilidades / Utilities
├── sastada.gpr                  # Proyecto GPRbuild
├── alire.toml                   # Manifiesto Alire
├── .gitignore
├── README.md                    # Este archivo / This file
├── bin/                         # Ejecutable (generado)
├── obj/                         # Objetos (generado)
├── config/                      # Configuración (generado)
└── alire/                       # Dependencias (generado)
```

---

## 🤝 Contribuir / Contributing

**ES:** Este es un proyecto de aprendizaje. Si encuentras bugs o quieres mejorar reglas, siéntete libre de abrir issues o PRs.

**EN:** This is a learning project. If you find bugs or want to improve rules, feel free to open issues or PRs.

### Próximos pasos / Next Steps

1. Agregar **tests unitarios** con AUnit
2. Documentar cada regla en `docs/` con ejemplos
3. Integrar con **GitHub Actions** para PR analysis
4. Agregar más reglas (SQL injection, path traversal, etc.)

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/programming_languages) · [Ada](../)*
