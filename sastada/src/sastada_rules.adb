--  Implementación de las reglas SAST

package body SastAda_Rules is

   ---------------------
   -- Get_Active_Rules --
   ---------------------

   function Get_Active_Rules return Rule_Vectors.Vector is
      Rules : Rule_Vectors.Vector;
   begin
      --  Regla SAST-001: Uso de Unchecked_Deallocation
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-001"),
            Name        => To_Unbounded_String ("Unchecked_Deallocation Usage"),
            Description =>
              To_Unbounded_String
                ("Avoid using Unchecked_Deallocation directly. " &
                 "Consider using controlled types."),
            Severity    => CRITICAL,
            Kind        => Reliability,
            Active      => True));

      --  Regla SAST-002: Uso de Unchecked_Conversion
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-002"),
            Name        => To_Unbounded_String ("Unchecked_Conversion Usage"),
            Description =>
              To_Unbounded_String
                ("Unchecked_Conversion bypasses type safety. " &
                 "Use safe type conversions instead."),
            Severity    => MAJOR,
            Kind        => Reliability,
            Active      => True));

      --  Regla SAST-003: Uso de Address (System.Address)
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-003"),
            Name        => To_Unbounded_String ("Address Usage"),
            Description =>
              To_Unbounded_String
                ("Direct use of Address may lead to memory safety issues. " &
                 "Consider using access types."),
            Severity    => CRITICAL,
            Kind        => Security,
            Active      => True));

      --  Regla SAST-004: Funciones demasiado largas (>100 líneas)
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-004"),
            Name        => To_Unbounded_String ("Excessive Function Length"),
            Description =>
              To_Unbounded_String
                ("Functions should not exceed 100 lines. " &
                 "Consider breaking down into smaller procedures."),
            Severity    => MAJOR,
            Kind        => Maintainability,
            Active      => True));

      --  Regla SAST-005: Bucles infinitos (loop sin exit)
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-005"),
            Name        => To_Unbounded_String ("Infinite Loop Risk"),
            Description =>
              To_Unbounded_String
                ("Loop statements should have an explicit exit condition " &
                 "or a bounded iteration."),
            Severity    => CRITICAL,
            Kind        => Reliability,
            Active      => True));

      --  Regla SAST-006: Sentencia GOTO
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-006"),
            Name        => To_Unbounded_String ("GOTO Statement"),
            Description =>
              To_Unbounded_String
                ("GOTO statements are considered harmful. " &
                 "Use structured control flow instead."),
            Severity    => CRITICAL,
            Kind        => Code_Style,
            Active      => True));

      --  Regla SAST-007: Anidamiento profundo (>4 niveles)
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-007"),
            Name        => To_Unbounded_String ("Deep Nesting"),
            Description =>
              To_Unbounded_String
                ("Code nesting depth exceeds 4 levels. " &
                 "Refactor to improve readability."),
            Severity    => MAJOR,
            Kind        => Maintainability,
            Active      => True));

      --  Regla SAST-008: Credenciales hardcodeadas
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-008"),
            Name        => To_Unbounded_String ("Hardcoded Credentials"),
            Description =>
              To_Unbounded_String
                ("Avoid hardcoding passwords, tokens, or credentials. " &
                 "Use environment variables or config files."),
            Severity    => BLOCKER,
            Kind        => Security,
            Active      => True));

      --  Regla SAST-009: Falta de pragma Pure/Preelaborate
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-009"),
            Name        => To_Unbounded_String ("Missing Pure/Preelaborate"),
            Description =>
              To_Unbounded_String
                ("Library-level packages should be Pure or Preelaborate " &
                 "when possible to improve safety."),
            Severity    => MINOR,
            Kind        => Code_Style,
            Active      => True));

      --  Regla SAST-010: Excepciones no manejadas
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-010"),
            Name        => To_Unbounded_String ("Exception Handling Missing"),
            Description =>
              To_Unbounded_String
                ("Subprograms with exception sources should have " &
                 "proper exception handlers."),
            Severity    => MAJOR,
            Kind        => Reliability,
            Active      => True));

      --  Regla SAST-011: Identificador demasiado largo (>40 caracteres)
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-011"),
            Name        => To_Unbounded_String ("Long Identifier"),
            Description =>
              To_Unbounded_String
                ("Identifier names should not exceed 40 characters."),
            Severity    => MINOR,
            Kind        => Maintainability,
            Active      => True));

      --  Regla SAST-012: Solo un punto y coma (null;)
      Rules.Append
        (Rule_Record'
           (Id          => To_Unbounded_String ("SAST-012"),
            Name        => To_Unbounded_String ("Strictly Null Statement"),
            Description =>
              To_Unbounded_String
                ("Standalone 'null;' statement without surrounding context."),
            Severity    => MINOR,
            Kind        => Code_Style,
            Active      => True));

      return Rules;
   end Get_Active_Rules;

   -------------------------
   -- Severity_To_String --
   -------------------------

   function Severity_To_String (S : Rule_Severity) return String is
   begin
      case S is
         when BLOCKER   => return "BLOCKER";
         when CRITICAL  => return "CRITICAL";
         when MAJOR     => return "MAJOR";
         when MINOR     => return "MINOR";
         when INFO      => return "INFO";
      end case;
   end Severity_To_String;

   ------------------------------
   -- Severity_To_SonarQube --
   ------------------------------

   function Severity_To_SonarQube (S : Rule_Severity) return String is
   begin
      --  SonarQube usa: BLOCKER, CRITICAL, MAJOR, MINOR, INFO
      return Severity_To_String (S);
   end Severity_To_SonarQube;

end SastAda_Rules;
