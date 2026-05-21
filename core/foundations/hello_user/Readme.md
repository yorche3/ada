# Hello, User! — Ada

Implementación de la especificación [`02_Hello_User.md`](../../../../docs/core/foundations/02_Hello_User.md) en **Ada**, siguiendo el mismo enfoque **manual y minimalista** que [`hello_world`](../hello_world/).

---

## 📂 Archivos / Files

| Archivo | Propósito |
|---------|-----------|
| [`hello_user.adb`](hello_user.adb) | Código fuente: solicita un nombre al usuario y saluda. |
| [`hello_user.gpr`](hello_user.gpr) | Proyecto GPRbuild (misma estructura que `hello_world`). |
| [`alire.toml`](alire.toml) | Manifiesto Alire con ejecutable `hello_user`. |
| [`.gitignore`](.gitignore) | Ignora `alire/`, `bin/`, `obj/` y `config/`. |
| [`Readme.md`](Readme.md) | Este archivo. |

---

## 📄 Archivos clave / Key Files

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

**ES:** Misma estructura que `hello_world`, solo cambia el nombre del proyecto. Ver [`hello_world/Readme.md`](../hello_world/Readme.md) para la explicación detallada.

**EN:** Same structure as `hello_world`, only the project name changes. See [`hello_world/Readme.md`](../hello_world/Readme.md) for the detailed explanation.

### `.gitignore` — ¿Por qué `config/`?

**ES:** Al usar `alr run` (comando sugerido por Alire para ejecutar el proyecto), la herramienta genera automáticamente un directorio `config/` con un archivo de configuración del proyecto (`*_Config.gpr`). Este archivo es **auto-generado** según la toolchain y el entorno local, por lo que no debe versionarse.

**EN:** When using `alr run` (the command suggested by Alire to run the project), the tool automatically generates a `config/` directory with a project configuration file (`*_Config.gpr`). This file is **auto-generated** based on the toolchain and local environment, so it must not be versioned.

```gitignore
alire/
bin/
config/
obj/
```

---

## 🚀 Compilar y ejecutar / Build & Run

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

**ES:** Para más detalles sobre la toolchain y la estructura de proyectos manuales, ver [`hello_world/Readme.md`](../hello_world/Readme.md) y [`ada/Readme.md`](../../../Readme.md).  
**EN:** For more details about the toolchain and manual project structure, see [`hello_world/Readme.md`](../hello_world/Readme.md) and [`ada/Readme.md`](../../../Readme.md).

---

## 📁 Estructura / Structure

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

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages)*
