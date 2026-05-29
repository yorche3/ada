# 📜 Reglas SAST — SastAda

Reglas de análisis estático para código Ada, ordenadas por severidad.

---

## 🔴 Blocker

### SAST-008 — Hardcoded Credentials

**Severidad:** BLOCKER · **Tipo:** Security · **Motor:** Texto (fallback)

Detecta cadenas con apariencia de contraseñas, tokens o credenciales hardcodeadas.

**❌ Malo:**

```ada
Password : constant String := "supersecret123";
DB_URL   : constant String := "postgres://admin:pass@localhost/db";
API_Key  : constant String := "sk-abc123def456";
```

**✅ Bueno:**

```ada
Password : constant String := Get_Env ("APP_PASSWORD");
DB_URL   : constant String := Get_Env ("DATABASE_URL");
```

---

## 🟠 Critical

### SAST-001 — Unchecked_Deallocation

**Severidad:** CRITICAL · **Tipo:** Security · **Motor:** AST

Uso de `Ada.Unchecked_Deallocation`. Puede causar dobles liberaciones o usar punteros colgantes.

**❌ Malo:**

```ada
with Ada.Unchecked_Deallocation;

procedure Free is new Ada.Unchecked_Deallocation (Object, Object_Access);
```

**✅ Bueno:**

```ada
-- Usar tipos controlados (Ada.Finalization.Controlled)
-- o contenedores (Ada.Containers.Vectors, etc.)
```

---

### SAST-003 — Address Attribute

**Severidad:** CRITICAL · **Tipo:** Security · **Motor:** AST

Uso del atributo `'Address`. Permite manipular memoria directamente.

**❌ Malo:**

```ada
Buffer : aliased Integer;
Ptr    : System.Address := Buffer'Address;
```

**✅ Bueno:**

```ada
type Ptr is access all Integer;
Buffer : aliased Integer;
Ptr    : Ptr := Buffer'Access;
```

---

### SAST-005 — Infinite Loop Risk

**Severidad:** CRITICAL · **Tipo:** Reliability · **Motor:** AST

Bucle sin sentencia `exit`. Riesgo de ejecución infinita.

**❌ Malo:**

```ada
loop
   Process_Request;
end loop;
```

**✅ Bueno:**

```ada
loop
   Process_Request;
   exit when Shutdown_Requested;
end loop;
```

---

### SAST-006 — GOTO Statement

**Severidad:** CRITICAL · **Tipo:** Code Style · **Motor:** AST

Sentencia `goto`. Dificulta el flujo de control estructurado.

**❌ Malo:**

```ada
goto Cleanup;
<<Cleanup>>
   Close_File;
```

**✅ Bueno:**

```ada
-- Usar bloques anidados o excepciones
begin
   Process;
exception
   when others => Close_File;
end;
```

---

### SAST-014 — Unvalidated System Call

**Severidad:** CRITICAL · **Tipo:** Security · **Motor:** AST + Texto

Uso de `Ada.Command_Line`, `Ada.Directories` o `Ada.Environment_Variables` sin validación previa.

**❌ Malo:**

```ada
with Ada.Command_Line;
Name : String := Ada.Command_Line.Argument (1);  -- ¿existe Argument_Count >= 1?
```

**✅ Bueno:**

```ada
if Ada.Command_Line.Argument_Count >= 1 then
   Name := Ada.Command_Line.Argument (1);
end if;
```

---

## 🟡 Major

### SAST-002 — Unchecked_Conversion

**Severidad:** MAJOR · **Tipo:** Reliability · **Motor:** AST

Uso de `Ada.Unchecked_Conversion`. Evita chequeos de tipos en conversiones.

**❌ Malo:**

```ada
with Ada.Unchecked_Conversion;
function Cast is new Ada.Unchecked_Conversion (Source, Target);
```

**✅ Bueno:**

```ada
-- Usar conversiones de tipo seguras o 'Val / 'Pos
```

---

### SAST-004 — Excessive Function Length

**Severidad:** MAJOR · **Tipo:** Maintainability · **Motor:** AST

Subprograma que supera las 100 líneas. Dificulta lectura y mantenimiento.

**❌ Malo:**

```ada
procedure Large_Procedure is
begin
   -- ... 150 líneas de código ...
end Large_Procedure;
```

**✅ Bueno:**

```ada
procedure Small_Procedure is
begin
   Step_One;
   Step_Two;
   Step_Three;
end Small_Procedure;
```

---

### SAST-007 — Deep Nesting

**Severidad:** MAJOR · **Tipo:** Maintainability · **Motor:** AST

Anidamiento de control > 4 niveles. Código difícil de seguir.

**❌ Malo:**

```ada
if A then
   if B then
      if C then
         if D then
            if E then   -- nivel 5
               null;
            end if;
         end if;
      end if;
   end if;
end if;
```

**✅ Bueno:**

```ada
-- Extraer lógica a funciones auxiliares
procedure Handle_Conditions is
begin
   if not A or else not B or else not C then
      return;
   end if;
   Handle_D;
   Handle_E;
end Handle_Conditions;
```

---

### SAST-010 — Exception Handling Missing

**Severidad:** MAJOR · **Tipo:** Reliability · **Motor:** AST

Subprograma > 5 líneas sin bloque `exception`. Riesgo de aborto inesperado.

**❌ Malo:**

```ada
procedure Process_File (Path : String) is
   F : File_Type;
begin
   Open (F, In_File, Path);
   -- ... varias líneas ...
   Close (F);
end Process_File;  -- si Open falla, aborta
```

**✅ Bueno:**

```ada
procedure Process_File (Path : String) is
   F : File_Type;
begin
   Open (F, In_File, Path);
   -- ... varias líneas ...
   Close (F);
exception
   when others =>
      if Is_Open (F) then Close (F); end if;
      raise;
end Process_File;
```

---

### SAST-013 — Uninitialized Variable

**Severidad:** MAJOR · **Tipo:** Reliability · **Motor:** AST

Variable declarada sin valor inicial. Contiene valor indeterminado.

**❌ Malo:**

```ada
Counter : Integer;  -- valor basura
Buffer  : array (1..10) of Character;
```

**✅ Bueno:**

```ada
Counter : Integer := 0;
Buffer  : array (1..10) of Character := (others => ' ');
```

---

## 🟢 Minor

### SAST-009 — Missing Pure/Preelaborate

**Severidad:** MINOR · **Tipo:** Code Style · **Motor:** AST

Paquete de biblioteca sin `Pure` o `Preelaborate`. Mejora la seguridad de compilación.

**❌ Malo:**

```ada
package Math_Utils is
   function Square (X : Integer) return Integer;
end Math_Utils;
```

**✅ Bueno:**

```ada
package Math_Utils is
   pragma Pure;
   function Square (X : Integer) return Integer;
end Math_Utils;
```

---

### SAST-011 — Long Identifier

**Severidad:** MINOR · **Tipo:** Maintainability · **Motor:** AST

Identificador que excede 40 caracteres. Dificulta legibilidad.

**❌ Malo:**

```ada
Total_Amount_After_Tax_And_Discounts_Applied : Integer;
```

**✅ Bueno:**

```ada
Total_Final : Integer;
```

---

### SAST-012 — Strictly Null Statement

**Severidad:** MINOR · **Tipo:** Code Style · **Motor:** AST

Sentencia `null;` fuera de contextos idiomáticos (handlers, cases).

**❌ Malo:**

```ada
if Condition then
   null;  -- ¿olvido o intencional?
end if;
```

**✅ Bueno:**

```ada
if Condition then
   Log ("Condition met, nothing to do");
end if;
```

**Contextos donde `null;` es idiomático (no reporta):**

```ada
exception
   when Constraint_Error => null;  -- se ignora

case Option is
   when Valid => Process;
   when others => null;  -- casos no implementados
end case;
```

---

## Resumen por severidad

| Severidad | Reglas |
|-----------|--------|
| 🔴 BLOCKER | SAST-008 |
| 🟠 CRITICAL | SAST-001, SAST-003, SAST-005, SAST-006, SAST-014 |
| 🟡 MAJOR | SAST-002, SAST-004, SAST-007, SAST-010, SAST-013 |
| 🟢 MINOR | SAST-009, SAST-011, SAST-012 |

---

*Parte de [SastAda — SAST for Ada](../README.md).*
