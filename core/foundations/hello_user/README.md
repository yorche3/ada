# Hello, User! — Ada

Implementación de la especificación [02_Hello_User](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) en **Ada**, siguiendo el mismo enfoque **manual y minimalista** que [`hello_world`](../hello_world/).

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`hello_user.adb`](hello_user.adb) | Código fuente: solicita un nombre al usuario y saluda. |
| [`hello_user.gpr`](hello_user.gpr) | Proyecto GPRbuild (misma estructura que `hello_world`). |
| [`alire.toml`](alire.toml) | Manifiesto Alire con ejecutable `hello_user`. |
| [`.gitignore`](.gitignore) | Ignora `alire/`, `bin/`, `obj/` y `config/`. |

**Estructura de directorios esperada:**

```text
hello_user/
├── hello_user.adb    # Código fuente
├── hello_user.gpr    # Proyecto GPRbuild
├── alire.toml         # Manifiesto Alire
├── .gitignore         # Ignora alire/, bin/, config/, obj/
├── bin/               # Ejecutable (generado)
├── obj/               # Objetos (generado)
├── config/            # Configuración auto-generada por `alr run`
└── alire/             # Dependencias (generado)
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Este proyecto fue creado **manualmente**, sin usar `alr init`. Sigue la misma estructura que [`hello_world`](../hello_world/), solo cambian los nombres de archivo y el contenido del código fuente.

**EN:** This project was created **manually**, without using `alr init`. It follows the same structure as [`hello_world`](../hello_world/), only the file names and source code content change.

---

## 📄 Archivos de configuración clave / Key Configuration Files

### `hello_user.adb` — Código fuente

**ES:** A diferencia de `hello_world`, este programa:

- Usa `Ada.Text_IO` en lugar del abreviado `Text_IO`
- Declara una variable `Name` como `String(1 .. 100)` con un `Length` natural
- Llama a `Get_Line(Name, Length)` para leer entrada del usuario
- Construye el saludo con concatenación `"Hello, " & Name(1 .. Length) & "!"`

**EN:** Unlike `hello_world`, this program:

- Uses `Ada.Text_IO` instead of the abbreviated `Text_IO`
- Declares a `Name` variable as `String(1 .. 100)` with a natural `Length`
- Calls `Get_Line(Name, Length)` to read user input
- Builds the greeting with concatenation `"Hello, " & Name(1 .. Length) & "!"`

```ada
with Ada.Text_IO; use Ada.Text_IO;

procedure Hello_User is
    Name : String(1 .. 100);
    Length : Natural;
begin
    Put("What is your name? ");
    Get_Line(Name, Length);
    Put_Line("Hello, " & Name(1 .. Length) & "!");
end Hello_User;
```

### `hello_user.gpr` y `alire.toml`

**ES:** Misma estructura que `hello_world`, solo cambia el nombre del proyecto. Ver [`hello_world/README.md`](https://yorche3.github.io/programming_languages/ada/core/foundations/hello_world/) para la explicación detallada.

**EN:** Same structure as `hello_world`, only the project name changes. See [`hello_world/README.md`](https://yorche3.github.io/programming_languages/ada/core/foundations/hello_world/) for the detailed explanation.

### `.gitignore` — ¿Por qué `config/`?

**ES:** Al usar `alr run`, la herramienta genera automáticamente un directorio `config/` con un archivo de configuración del proyecto (`*_Config.gpr`). Este archivo es **auto-generado** según la toolchain y el entorno local, por lo que no debe versionarse.

**EN:** When using `alr run`, the tool automatically generates a `config/` directory with a project configuration file (`*_Config.gpr`). This file is **auto-generated** based on the toolchain and local environment, so it must not be versioned.

```gitignore
alire/
bin/
config/
obj/
```

---

## 🚀 Compilación y ejecución / Build & Run

### Con Alire (recomendado)

```bash
# Compilar
alr exec -- gprbuild -P hello_user.gpr

# Ejecutar
./bin/hello_user
```

O directamente con `alr run` (genera `config/` automáticamente):

```bash
alr run
```

**Salida esperada / Expected output:**

```text
What is your name? Ada
Hello, Ada!
```

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** El buffer `Name(1 .. 100)` es de tamaño fijo; `Get_Line` devuelve la longitud real en `Length` para evitar imprimir basura.
- **EN:** The `Name(1 .. 100)` buffer is fixed-size; `Get_Line` returns the actual length in `Length` to avoid printing garbage.
- **ES:** `alr run` genera `config/` automáticamente; este directorio es específico del entorno y no debe versionarse.
- **EN:** `alr run` generates `config/` automatically; this directory is environment-specific and must not be versioned.

---

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
