--  Implementación del motor de análisis SAST

with Ada.Text_IO;                 use Ada.Text_IO;
with Ada.Strings.Fixed;           use Ada.Strings.Fixed;
with Ada.Characters.Handling;     use Ada.Characters.Handling;
with Ada.Exceptions;              use Ada.Exceptions;
with SastAda_SonarQube;
with SastAda_AST;                 use SastAda_AST;

package body SastAda_Analysis is

   ---------------
   -- Init_Config --
   ---------------

   function Init_Config
     (Source_Dirs  : String;
      Cache_File   : String := ".sastada_cache";
      Project_File : String := "";
      Output_File  : String := "sastada_report.json";
      Project_Path : String := "")
      return Analysis_Config
   is
      Config   : Analysis_Config;
      Dir_List : File_Vectors.Vector;
   begin
      --  Obtenemos lista de directorios separados por coma
      declare
         Start_Pos : Positive := Source_Dirs'First;
         End_Pos   : Natural;
      begin
         loop
            End_Pos := Ada.Strings.Fixed.Index
              (Source_Dirs (Start_Pos .. Source_Dirs'Last), ",");
            if End_Pos = 0 then
               --  Último directorio
               declare
                  Dir : constant String :=
                    Trim (Source_Dirs (Start_Pos .. Source_Dirs'Last), Ada.Strings.Both);
               begin
                  if Dir /= "" then
                     --  Usamos búsqueda recursiva
                     Find_Ada_Files_Recursive (Dir, Dir_List);
                  end if;
               end;
               exit;
            else
               declare
                  Dir : constant String :=
                    Trim (Source_Dirs (Start_Pos .. End_Pos - 1), Ada.Strings.Both);
               begin
                  if Dir /= "" then
                     Find_Ada_Files_Recursive (Dir, Dir_List);
                  end if;
               end;
               Start_Pos := End_Pos + 1;
            end if;
         end loop;
      end;

      Config.Source_Dirs  := Dir_List;
      Config.Cache_File   := To_Unbounded_String (Cache_File);
      Config.Project_File := To_Unbounded_String (Project_File);
      Config.Output_File  := To_Unbounded_String (Output_File);
      Config.Project_Path := To_Unbounded_String (Project_Path);

      return Config;
   end Init_Config;

   -------------------
   -- Run_Analysis --
   -------------------

   procedure Run_Analysis
     (Config  : Analysis_Config;
      Success : out Boolean)
   is
      Cache_Files  : File_Vectors.Vector;
      Modified     : File_Vectors.Vector;
      Unchanged    : File_Vectors.Vector;
      All_Findings : Finding_Vectors.Vector;
      File_Findings : Finding_Vectors.Vector;
      File_Success : Boolean;
      Cache_Path   : constant String := To_String (Config.Cache_File);
   begin
      Success := True;

      --  Cargar caché incremental
      Load_Cache (Cache_Path, Cache_Files);

      --  Filtrar archivos modificados
      Filter_Modified_Files (Config.Source_Dirs, Cache_Files, Modified, Unchanged);

      Put_Line ("=== SastAda - SAST para Ada ===");
      declare
         Total_Cnt  : constant Integer := Integer (Config.Source_Dirs.Length);
         Modif_Cnt  : constant Integer := Integer (Modified.Length);
         Unch_Cnt   : constant Integer := Integer (Unchanged.Length);
      begin
         Put_Line ("Total Ada files found: " &
                     Trim (Integer'Image (Total_Cnt), Ada.Strings.Left));
         Put_Line ("Modified/New files: " &
                     Trim (Integer'Image (Modif_Cnt), Ada.Strings.Left));
         Put_Line ("Unchanged files: " &
                     Trim (Integer'Image (Unch_Cnt), Ada.Strings.Left));
      end;
      New_Line;

      if Modified.Is_Empty then
         Put_Line ("No hay archivos para analizar. Todo está actualizado.");
         --  Guardamos caché (por si hay archivos nuevos no modificados)
         Save_Cache (Cache_Path, Config.Source_Dirs);

         --  Generamos reporte vacío
         SastAda_SonarQube.Write_Report_File
           (All_Findings, To_String (Config.Output_File));
         return;
      end if;

      --  Analizar solo archivos modificados
      Analyze_Files (Modified, File_Findings, File_Success);
      if not File_Success then
         Success := False;
      end if;

      --  Combinar hallazgos
      for F of File_Findings loop
         All_Findings.Append (F);
      end loop;

      --  Guardar caché actualizada
      Save_Cache (Cache_Path, Config.Source_Dirs);

      --  Hacer rutas relativas al project path (seguridad)
      if To_String (Config.Project_Path) /= "" then
         declare
            Base : constant String := To_String (Config.Project_Path);
         begin
            for F of All_Findings loop
               F.File_Path := To_Unbounded_String
                 (Make_Path_Relative (To_String (F.File_Path), Base));
            end loop;
         end;
      end if;

      --  Generar reporte SonarQube
      SastAda_SonarQube.Write_Report_File
        (All_Findings, To_String (Config.Output_File));

      --  Mostrar resumen
      New_Line;
      Put_Line (SastAda_SonarQube.Summary_Text (All_Findings));
      New_Line;
      Put_Line ("SonarQube report generated: " & To_String (Config.Output_File));

   exception
      when E : others =>
         Put_Line ("ERROR durante el análisis: " & Exception_Message (E));
         Success := False;
   end Run_Analysis;

   -------------------
   -- Analyze_Files --
   -------------------

   procedure Analyze_Files
     (Files    : File_Vectors.Vector;
      Findings : out Finding_Vectors.Vector;
      Success  : out Boolean)
   is
      AST_Available : constant Boolean := Is_Libadalang_Available;
   begin
      Findings.Clear;
      Success := True;

      if AST_Available then
         Put_Line ("  [AST] Using Libadalang engine: " & AST_Engine_Version);
      else
         Put_Line ("  [TEXT] Using pattern matching engine.");
      end if;

      for F of Files loop
         declare
            File_Path : constant String := To_String (F.Path);
         begin
               Put_Line ("  Analizando: " & File_Path);

            if AST_Available then
               --  Intentar con AST (Libadalang)
               Analyze_File_AST (File_Path, Findings);
            end if;

            --  Complementar con pattern matching (para reglas que
            --  el AST no cubre o como respaldo)
            declare
               File_Content : constant String :=
                 Read_File_Content (File_Path);
            begin
               if File_Content'Length > 0 then
                  Check_Security_Rules (File_Content, File_Path, Findings);
                  Check_Reliability_Rules (File_Content, File_Path, Findings);
                  Check_Maintainability_Rules (File_Content, File_Path, Findings);
                  Check_Style_Rules (File_Content, File_Path, Findings);
               else
                  Put_Line ("    Omitiendo (vacío): " & File_Path);
               end if;
            end;
         end;
      end loop;

   exception
      when E : others =>
         Put_Line ("ERROR analizando archivos: " & Exception_Message (E));
         Success := False;
   end Analyze_Files;

   -----------------
   -- Check_Pattern --
   -----------------

   function Check_Pattern
     (Line        : String;
      Pattern     : String;
      Ignore_Case : Boolean := False) return Boolean
   is
      Line_Upper    : String (Line'Range);
      Pattern_Upper : String (Pattern'Range);
   begin
      if Ignore_Case then
         for I in Line'Range loop
            Line_Upper (I) := To_Upper (Line (I));
         end loop;
         for I in Pattern'Range loop
            Pattern_Upper (I) := To_Upper (Pattern (I));
         end loop;
         return Ada.Strings.Fixed.Index (Line_Upper, Pattern_Upper) > 0;
      else
         return Ada.Strings.Fixed.Index (Line, Pattern) > 0;
      end if;
   end Check_Pattern;

   -------------------------
   -- Count_Nesting_Depth --
   -------------------------

   function Count_Nesting_Depth (Lines : String) return Natural is
      Max_Depth  : Natural := 0;
      Depth      : Natural := 0;
      In_String  : Boolean := False;
      In_Comment : Boolean := False;
   begin
      for I in Lines'Range loop
         case Lines (I) is
            when '"' =>
               if not In_Comment then
                  In_String := not In_String;
               end if;
            when '-' =>
               if not In_String and then I < Lines'Last
                 and then Lines (I + 1) = '-'
               then
                  In_Comment := True;
               end if;
            when ASCII.LF | ASCII.CR =>
               In_Comment := False;
            when others =>
               null;
         end case;

         if not In_String and not In_Comment then
            if Lines (I) = 'l' and then I + 3 <= Lines'Last
              and then Lines (I .. I + 3) = "loop"
            then
               Depth := Depth + 1;
               Max_Depth := Natural'Max (Max_Depth, Depth);
            end if;

            if Lines (I) = 'i' and then I + 1 <= Lines'Last
              and then Lines (I .. I + 1) = "if"
              and then (I + 2 > Lines'Last
                         or else Lines (I + 2) = ' '
                         or else Lines (I + 2) = ASCII.LF
                         or else Lines (I + 2) = ASCII.CR)
            then
               Depth := Depth + 1;
               Max_Depth := Natural'Max (Max_Depth, Depth);
            end if;

            if Lines (I) = 'c' and then I + 3 <= Lines'Last
              and then Lines (I .. I + 3) = "case"
            then
               Depth := Depth + 1;
               Max_Depth := Natural'Max (Max_Depth, Depth);
            end if;

            if I + 6 <= Lines'Last and then
              Lines (I .. I + 6) = "declare"
            then
               Depth := Depth + 1;
               Max_Depth := Natural'Max (Max_Depth, Depth);
            end if;

            if I + 4 <= Lines'Last and then
              Lines (I .. I + 4) = "begin"
            then
               Depth := Depth + 1;
               Max_Depth := Natural'Max (Max_Depth, Depth);
            end if;

            --  "end " cierra bloques
            if I + 3 <= Lines'Last and then
              Lines (I .. I + 3) = "end "
            then
               if Depth > 0 then
                  Depth := Depth - 1;
               end if;
            end if;
         end if;
      end loop;

      return Max_Depth;
   end Count_Nesting_Depth;

   --------------------------
   -- Check_Security_Rules --
   --------------------------

   procedure Check_Security_Rules
     (Lines     : String;
      File_Name : String;
      Findings  : in out Finding_Vectors.Vector)
   is
      Line_Num : Natural := 0;
      Start    : Positive := Lines'First;
   begin
      for I in Lines'Range loop
         if Lines (I) = ASCII.LF then
            Line_Num := Line_Num + 1;

            --  SAST-008: Credenciales hardcodeadas en la línea actual
            declare
               Line_Content : constant String :=
                 Lines (Start .. I - 1);
               Upper_Line : String (Line_Content'Range);
            begin
               for J in Line_Content'Range loop
                  Upper_Line (J) := To_Upper (Line_Content (J));
               end loop;
               if Ada.Strings.Fixed.Index (Upper_Line, "PASSWORD") > 0 or else
                 Ada.Strings.Fixed.Index (Upper_Line, "SECRET") > 0 or else
                 Ada.Strings.Fixed.Index (Upper_Line, "API_KEY") > 0
               then
                  Findings.Append
                    (Finding_Record'
                       (Rule_Id  => To_Unbounded_String ("SAST-008"),
                        File_Path => To_Unbounded_String (File_Name),
                        Line     => Line_Num,
                        Column   => 1,
                        Message  => To_Unbounded_String
                          ("Possible hardcoded credential detected. " &
                           "Use environment variables instead."),
                        Severity => BLOCKER));
               end if;
            end;
            Start := I + 1;
         end if;

         --  SAST-003: 'Address (buscar a través de todas las líneas)
         if I + 7 <= Lines'Last and then
           Lines (I .. I + 6) = "'Address"
         then
            Findings.Append
              (Finding_Record'
                 (Rule_Id  => To_Unbounded_String ("SAST-003"),
                  File_Path => To_Unbounded_String (File_Name),
                  Line     => Line_Num,
                  Column   => 1,
                  Message  => To_Unbounded_String
                    ("Usage of 'Address attribute detected. " &
                     "Consider using access types instead."),
                  Severity => CRITICAL));
         end if;
      end loop;
   end Check_Security_Rules;

   -----------------------------
   -- Check_Reliability_Rules --
   -----------------------------

   procedure Check_Reliability_Rules
     (Lines     : String;
      File_Name : String;
      Findings  : in out Finding_Vectors.Vector)
   is
      Line_Num : Natural := 0;
      Start    : Positive := Lines'First;
   begin
      for I in Lines'Range loop
         if Lines (I) = ASCII.LF then
            Line_Num := Line_Num + 1;

            declare
               Line_Content : constant String :=
                 Lines (Start .. I - 1);
            begin
               --  SAST-001: Unchecked_Deallocation
               if Check_Pattern (Line_Content,
                 "Unchecked_Deallocation")
               then
                  Findings.Append
                    (Finding_Record'
                       (Rule_Id  => To_Unbounded_String ("SAST-001"),
                        File_Path => To_Unbounded_String (File_Name),
                        Line     => Line_Num,
                        Column   => 1,
                        Message  => To_Unbounded_String
                          ("Unchecked_Deallocation usage detected. " &
                           "Consider using controlled types."),
                        Severity => CRITICAL));
               end if;

               --  SAST-002: Unchecked_Conversion
               if Check_Pattern (Line_Content,
                 "Unchecked_Conversion")
               then
                  Findings.Append
                    (Finding_Record'
                       (Rule_Id  => To_Unbounded_String ("SAST-002"),
                        File_Path => To_Unbounded_String (File_Name),
                        Line     => Line_Num,
                        Column   => 1,
                        Message  => To_Unbounded_String
                          ("Unchecked_Conversion usage detected. " &
                           "Use safe type conversions instead."),
                        Severity => MAJOR));
               end if;

               --  SAST-005: Bucle infinito (loop sin exit ni for/while)
               --  NOTA: Esta regla ahora la maneja el motor AST (SastAda_AST).
               --  El pattern matching solo detecta "loop" literal en texto,
               --  lo que genera falsos positivos con "end loop;".
               --  if Check_Pattern (Line_Content, "loop") and then
               --    not Check_Pattern (Line_Content, "for ") and then
               --    not Check_Pattern (Line_Content, "while ") and then
               --    not Check_Pattern (Line_Content, "end loop") and then
               --    not Check_Pattern (Line_Content, "exit ")
               --  then
               --     ... (delegado al AST)
               --  end if;

            exception
               when others =>
                  null;
            end;
            Start := I + 1;
         end if;
      end loop;
   end Check_Reliability_Rules;

   --------------------------------
   -- Check_Maintainability_Rules --
   --------------------------------

   procedure Check_Maintainability_Rules
     (Lines     : String;
      File_Name : String;
      Findings  : in out Finding_Vectors.Vector)
   is
      Line_Num      : Natural := 0;
      Nest_Depth    : Natural;
      In_Subprogram : Boolean := False;
      Sub_Lines     : Natural := 0;
      Start         : Positive := Lines'First;
   begin
      --  SAST-004: Longitud excesiva de función
      for I in Lines'Range loop
         if Lines (I) = ASCII.LF then
            Line_Num := Line_Num + 1;

            declare
               Line_Content : constant String :=
                 Lines (Start .. I - 1);
            begin
               --  Detectar inicio de subprograma
               if (Ada.Strings.Fixed.Index (Line_Content, "procedure ") > 0 or else
                   Ada.Strings.Fixed.Index (Line_Content, "function ") > 0) and then
                 Ada.Strings.Fixed.Index (Line_Content, "is") > 0
               then
                  if not In_Subprogram then
                     In_Subprogram := True;
                     Sub_Lines := 0;
                  end if;
               end if;

               --  Detectar final de subprograma
               if In_Subprogram and then
                 Ada.Strings.Fixed.Index (Line_Content, "end ") > 0 and then
                 Ada.Strings.Fixed.Index (Line_Content, ";") > 0
               then
                  In_Subprogram := False;
                  if Sub_Lines > 100 then
                     Findings.Append
                       (Finding_Record'
                          (Rule_Id  => To_Unbounded_String ("SAST-004"),
                           File_Path => To_Unbounded_String (File_Name),
                           Line     => Line_Num,
                           Column   => 1,
                           Message  => To_Unbounded_String
                             ("Function/procedure exceeds 100 lines (" &
                              Trim (Natural'Image (Sub_Lines), Ada.Strings.Left) &
                              " lines). Consider refactoring."),
                           Severity => MAJOR));
                  end if;
               end if;

               if In_Subprogram then
                  Sub_Lines := Sub_Lines + 1;
               end if;

            end;
            Start := I + 1;
         end if;
      end loop;

      --  SAST-007: Anidamiento profundo
      Nest_Depth := Count_Nesting_Depth (Lines);
      if Nest_Depth > 4 then
         Findings.Append
           (Finding_Record'
              (Rule_Id  => To_Unbounded_String ("SAST-007"),
               File_Path => To_Unbounded_String (File_Name),
               Line     => 1,
               Column   => 1,
               Message  => To_Unbounded_String
                 ("Deep nesting detected (" &
                  Trim (Natural'Image (Nest_Depth), Ada.Strings.Left) &
                  " levels). Maximum allowed is 4."),
               Severity => MAJOR));
      end if;

   exception
      when others =>
         null;
   end Check_Maintainability_Rules;

   -----------------------
   -- Check_Style_Rules --
   -----------------------

   procedure Check_Style_Rules
     (Lines     : String;
      File_Name : String;
      Findings  : in out Finding_Vectors.Vector)
   is
      Line_Num      : Natural := 0;
      Start         : Positive := Lines'First;
   begin
      for I in Lines'Range loop
         if Lines (I) = ASCII.LF then
            Line_Num := Line_Num + 1;

            declare
               Line_Content : constant String :=
                 Lines (Start .. I - 1);
            begin
               --  SAST-006: Sentencia GOTO
               if Check_Pattern (Line_Content, "goto ", True) or else
                 Check_Pattern (Line_Content, "goto", True)
               then
                  Findings.Append
                    (Finding_Record'
                       (Rule_Id  => To_Unbounded_String ("SAST-006"),
                        File_Path => To_Unbounded_String (File_Name),
                        Line     => Line_Num,
                        Column   => 1,
                        Message  => To_Unbounded_String
                          ("GOTO statement detected. " &
                           "Use structured control flow instead."),
                        Severity => CRITICAL));
               end if;

               --  SAST-012: Sentencia null estricta (solo punto y coma o null;)
               declare
                  Trimmed : constant String :=
                    Trim (Line_Content, Ada.Strings.Both);
               begin
                  if Trimmed = "null;" then
                     Findings.Append
                       (Finding_Record'
                          (Rule_Id  => To_Unbounded_String ("SAST-012"),
                           File_Path => To_Unbounded_String (File_Name),
                           Line     => Line_Num,
                           Column   => 1,
                           Message  => To_Unbounded_String
                             ("Sentencia null estricta detectada."),
                           Severity => MINOR));
                  end if;
               end;
            end;
            Start := I + 1;
         end if;
      end loop;
   end Check_Style_Rules;

end SastAda_Analysis;
