# 🚀 Algoritmos Puros / Algorithms Pure — Ada

Implementaciones de la [Fase 1 — Algoritmos Puros](https://yorche3.github.io/programming_languages/ROADMAP/#fase-1--algoritmos-puros--algorithms-pure-) en **Ada**: ordenamientos elementales y estructuras de datos construidas desde cero.

Los módulos de esta fase siguen el patrón **biblioteca (`alr init --lib`) + subproyecto de pruebas (`tests/`, `alr init --bin`)** con **AUnit**, y declaran el indicador de fallo como constante del paquete en lugar de lanzar excepciones.

---

## 📖 Módulos / Modules

| Módulo | Especificación | Enfoque | Tests | Estado |
|--------|---------------|---------|:-----:|:------:|
| [`naive_sort/`](naive_sort/) | [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) | `--lib` + `tests/` (`--bin`) | 3 | ✅ |
| [`data_structures_basics/`](data_structures_basics/) | [06_Data_Structures_Basics](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) | `--lib` + `tests/` (`--bin`) | 4 | ✅ |
| `data_structures_advanced` | [07_Data_Structures_Advanced](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) | — | — | 📋 |
| `efficient_sort` | [08_Efficient_Sort](https://yorche3.github.io/programming_languages/core/algorithms/08_Efficient_Sort/) | — | — | 📋 |
| `distributed_sort` | [09_Distributed_Sort](https://yorche3.github.io/programming_languages/core/algorithms/09_Distributed_Sort/) | — | — | 📋 |
| `searching` | [10_Searching](https://yorche3.github.io/programming_languages/core/algorithms/10_Searching/) | — | — | 📋 |

> **ES:** Los módulos se listan en el orden canónico de la numeración `05_` a `10_`. Los pendientes se documentan al implementarse.
> **EN:** Modules are listed in the canonical order of the `05_` to `10_` numbering. Pending ones are documented as they are implemented.

---

## 📁 Estructura / Structure

```text
algorithms/
├── naive_sort/                     # 05_Naive_Sort — lib + tests
│   ├── src/
│   │   ├── naive_sort.ads
│   │   └── naive_sort.adb
│   ├── tests/
│   │   ├── src/
│   │   ├── tests.gpr
│   │   └── alire.toml
│   ├── naive_sort.gpr
│   ├── alire.toml
│   └── README.md
└── data_structures_basics/         # 06_Data_Structures_Basics — lib + tests
    ├── src/
    │   ├── data_structures_basics.ads
    │   └── data_structures_basics.adb
    ├── tests/
    │   ├── src/
    │   ├── tests.gpr
    │   └── alire.toml
    ├── data_structures_basics.gpr
    ├── alire.toml
    └── README.md
```

---

## 🛠️ Patrón común / Common Pattern

| Característica | Descripción |
|---------------|-------------|
| **Runtime** | Alire 2.1.0 con `gnat_native` 15.2.1 y `gprbuild` 25.0.1 |
| **CLI** | `alr build` para la biblioteca y `alr -C tests run` para la suite |
| **Andamiaje** | `alr init --lib --in-place {modulo}` + `alr init --bin tests` + `alr with {modulo} --use=..` + `alr with aunit` |
| **Framework de tests** | AUnit 26.0.0, registrado con `AUnit.Test_Caller` y ejecutado con `AUnit.Run.Test_Runner_With_Status` |
| **Separación** | `src/` (contrato `.ads` + implementación `.adb`) ↔ `tests/` (subproyecto ejecutable) |
| **Indicador de fallo** | Constante del paquete (`Failure_Value : constant Integer := -1`); nunca excepciones |
| **Contrato** | El `.ads` declara los tipos y las firmas; los ADT son tipos privados con la representación en la parte privada |
| **Verificación estática** | Las comprobaciones de estilo de GNAT en la propia compilación (`-gnaty`) |
| **Artefactos** | `obj/`, `lib/`, `bin/`, `alire/` y `config/` los ignora el `.gitignore` de cada módulo |

---

## 🚀 Compilación rápida / Quick Build

```bash
# Naive Sort
cd naive_sort && alr build && alr -C tests run

# Data Structures Basics
cd ../data_structures_basics && alr build && alr -C tests run
```

---

## ▶️ Siguiente / Next

👉 Continúa con los módulos pendientes de esta fase en el [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).

👉 Continue with the pending modules of this phase in the [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).

---

*[← Volver a Core](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
