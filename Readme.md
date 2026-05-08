# Ada

Monorepo de aprendizaje y experimentacion con **Ada** — desde fundamentos del lenguaje hasta microservicios, interfaces graficas, SAST y CI/CD.

## Requisitos

- **Alire** >= 2.1.0 — gestor de paquetes y build system
- **Toolchain** (configurada con `alr toolchain`):
  - `gnat_native` **15.2.1** (compilador GNAT)
  - `gprbuild` **25.0.1** (sistema de compilacion)
- **Opcional** (segun el submodulo):
  - `gtkada` — para GUI (GTK)
  - `aws` + `gnatcoll` — para microservicios REST
  - `aws` + `matreshka_soap` + `xmlada` — para microservicios SOAP
  - `libadalang` — para SAST (SastAda)

### Instalacion rapida

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

> **Tip:** Tambien puedes usar el `Dockerfile` incluido para un entorno reproducible.
> `docker build -t ada-env . && docker run --rm -it ada-env`

---

## Estructura del proyecto

```
ada/
├── console_training/consapp/   #  Aplicaciones CLI (GNAT.Terminal, etc.)
├── gui_training/guiapp/        #  Interfaces graficas con GtkAda
├── learning/                   #  Fundamentos y algoritmos
│   ├── helloworld/             #      Hola mundo
│   ├── hellouser/              #      Entrada de usuario
│   ├── numbers/                #      Algoritmos numericos (iterativo/recursivo)
│   ├── unit_test/              #      Demo de pruebas unitarias con AUnit
│   └── words/                  #      Procesamiento de texto
├── microservices/              #  APIs y servicios web
│   ├── ms_rest/                #      API REST con AWS
│   └── ms_soap/                #      API SOAP con Matreshka
├── sastada/                    #  SAST (Static Application Security Testing)
├── Dockerfile                  #  Entorno reproducible para CI/CD
├── Jenkinsfile                 #  Pipeline Jenkins
└── LICENSE                     #  Licencia GPL-3.0
```

---

## Comandos Alire

```bash
alr init --bin <project_name>   # Inicializar proyecto binario
alr init --lib <project_name>   # Inicializar biblioteca
alr with <crate_name>           # Agregar dependencia a proyecto
alr build                       # Compilar y generar ejecutables
alr run [executable_name]       # Compilar e iniciar un ejecutable especifico
alr toolchain                   # Ver toolchain configurada
alr --non-interactive build     # Build en modo no interactivo (CI/CD)
alr test                        # Ejecutar pruebas unitarias
```

### Sobre `alr test`

`alr test` busca ejecutables definidos con `alr test ...` en `alire.toml`, pero no siempre funciona segun la configuracion del proyecto. Como alternativa, este monorepo usa **dos ejecutables independientes**:

```bash
alr run project_name     # Ejecutar el programa principal
alr run run_tests        # Ejecutar las pruebas unitarias (AUnit)
```

Tambien hay scripts auxiliares en `learning/words/`:

| Script              | Plataforma  |
|---------------------|-------------|
| `execute.sh`        | Linux/macOS |
| `execute.ps1`       | Windows     |
| `execute.bat`       | Windows     |
| `execute.ab`        | Any     |

Ejemplo de uso:
```bash
cd learning/words
./execute.sh           # Compila test.gpr y ejecuta run_tests
```

---

## Submodulos en detalle

### `console_training/consapp`

Proposito: Aprender a construir aplicaciones de terminal / CLI en Ada, actualmente explorando `GNAT.Terminal` y otras opciones.

**Dependencias:** `gnatcoll`

```bash
cd console_training/consapp
alr build
alr run consapp
```

---

### `gui_training/guiapp`

Proposito: Aprender a construir interfaces graficas con **GtkAda** (bindings de GTK para Ada).

**Dependencias:** `gtkada`

```bash
cd gui_training/guiapp
alr build
alr run guiapp
```

---

### `learning/`

Proyectos de aprendizaje sobre fundamentos de Ada y algoritmos. Suelen ser bibliotecas (`--lib`) con pruebas unitarias.

| Proyecto       | Descripcion                                           |
|----------------|-------------------------------------------------------|
| `helloworld`   | Hola mundo clasico (`Ada.Text_IO`)                    |
| `hellouser`    | Entrada de usuario con `Get_Line`                     |
| `numbers`      | Algoritmos numericos (factorial, Fibonacci, etc.)     |
| `unit_test`    | Demo de pruebas unitarias con **AUnit**               |
| `words`        | Procesamiento de texto (conteo, analisis, etc.)       |

Cada proyecto `--lib` incluye:

- **`project_name.gpr`** — proyecto principal (ej. `words.gpr`, `numbers.gpr`)
- **`test.gpr`** — proyecto de pruebas que hereda fuentes del principal y depende de `aunit.gpr`
- **`tests/`** — directorio con suites y casos de prueba
- **`src/ispec/`** — especificaciones (`.ads`)
- **`src/impl/`** — implementaciones (`.adb`)

```bash
cd learning/<proyecto>

# Compilar y ejecutar el programa principal
gprbuild -p -P words.gpr
./bin/words

# Compilar y ejecutar las pruebas
gprbuild -p -P test.gpr
./run_tests
```

O usando Alire (si el ejecutable esta declarado en `alire.toml`):
```bash
alr run words      # Programa principal
alr run run_tests  # Pruebas unitarias
```

> Ver `learning/Ada_Readme.md` para una guia detallada de como estructurar pruebas con AUnit.

---

### `microservices/`

#### `ms_rest` — API REST

Servicio REST construido con **AWS** (Ada Web Server).

**Dependencias:** `aws`, `gnatcoll`, `aunit`

```bash
cd microservices/ms_rest
alr build
alr run ms_rest
alr run run_tests     # Pruebas de integracion
```

#### `ms_soap` — API SOAP

Servicio SOAP construido con **Matreshka SOAP** + **AWS**.

**Dependencias:** `aws`, `gnatcoll`, `xmlada`, `matreshka_soap`, `matreshka_league`, `matreshka_xml`, `aunit`

```bash
cd microservices/ms_soap
alr build
alr run ms_soap
alr run run_tests     # Pruebas de integracion
```

---

### `sastada` — SAST para Ada

Herramienta de **Static Application Security Testing (SAST)** para Ada. Analiza codigo fuente, aplica reglas de seguridad y genera reportes en formato **SonarQube**.

**Dependencias:** `libadalang` (analisis sintactico/semantico de Ada)

```bash
cd sastada
alr build
alr run sastada -- --help
```

**Uso:**

```bash
# Analizar un proyecto completo
sastada --project-path=/ruta/al/proyecto

# Especificar directorio fuente y archivo de salida
sastada --project-path=/ruta --output=report.json

# Directorio fuente personalizado
sastada --project-path=/ruta --src-dir=src_sub

# Analisis incremental (cache)
sastada --project-path=/ruta --cache=.sastada_cache

# Con archivo .gpr explicito
sastada --project-path=/ruta --project=mi_proyecto.gpr
```

El reporte generado (`sastada_report.json`) se puede importar directamente en **SonarQube** para el seguimiento de calidad y seguridad del codigo.

---

## CI/CD — Jenkins

El `Jenkinsfile` define un pipeline que:

1. **Build** de la imagen Docker (`gnatcheck-image`)
2. **Resolucion de dependencias y compilacion** de los proyectos:
   - `console_training/consapp`
   - `gui_training/guiapp`
   - `microservices/ms_rest`
   - `microservices/ms_soap`
3. **Archivo de reportes** de los artefactos generados

> **Nota:** El pipeline incluye una etapa de analisis con `gnatcheck`, pero actualmente **no se usa** debido a problemas de compatibilidad con Alire. La alternativa contemplada es **SastAda** (incluido en este monorepo) para el analisis SAST, y su integracion con SonarQube para la visualizacion de resultados.

```groovy
// Ejecucion en contenedor Docker
docker run --rm \
    -v $(pwd):/workspace \
    -w /workspace/${project.path} \
    gnatcheck-image \
    bash -c "alr --non-interactive build"
```

> Se usa `--non-interactive` para evitar que Alire espere entrada en modo CI.

---

## Docker

El `Dockerfile` construye una imagen basada en **Ubuntu 24.04** con:

- Alire 2.1.0
- Toolchain: `gnat_native=15.2.1`, `gprbuild=25.0.1`
- Bibliotecas de sistema: GTK3, OpenSSL, zlib, etc.
- Variables de entorno para enlazado correcto (`LIBRARY_PATH`, `LD_LIBRARY_PATH`, `PKG_CONFIG_PATH`)

```bash
# Construir
docker build -t ada-env .

# Usar
docker run --rm -v $(pwd):/workspace -w /workspace/<submodulo> ada-env alr build
```

---

## Dependencias por modulo

| Submodulo               | Dependencias principales                                                       |
|-------------------------|--------------------------------------------------------------------------------|
| `console_training`      | `gnatcoll`                                                                     |
| `gui_training`          | `gtkada`                                                                       |
| `learning/*`            | `aunit` (pruebas)                                                              |
| `microservices/ms_rest` | `aws`, `gnatcoll`, `aunit`                                                     |
| `microservices/ms_soap` | `aws`, `gnatcoll`, `xmlada`, `matreshka_soap`, `matreshka_league`, `matreshka_xml`, `aunit` |
| `sastada`               | `libadalang`                                                                   |

---

## Licencia

**GNU GENERAL PUBLIC LICENSE**
Version 3, 29 June 2007
Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>

Este programa es software libre: puedes redistribuirlo y/o modificarlo bajo los terminos de la GNU General Public License publicada por la Free Software Foundation, ya sea la version 3 de la Licencia, o (a tu eleccion) cualquier version posterior.

Ver el archivo `LICENSE` para mas detalles.

---

## Contribuciones

Las contribuciones son bienvenidas. Si tienes ejemplos, algoritmos o mejoras para compartir, abre un PR o un issue.

---

## Recursos

- [Ada Documentation](https://learn.adacore.com/)
- [Alire Package Manager](https://alire.ada.dev/)
- [GtkAda](https://github.com/AdaCore/gtkada)
- [AWS — Ada Web Server](https://github.com/AdaCore/aws)
- [Matreshka](https://forge.ada-ru.org/matreshka)
- [Libadalang](https://github.com/AdaCore/libadalang)
- [SonarQube](https://www.sonarsource.com/products/sonarqube/)
