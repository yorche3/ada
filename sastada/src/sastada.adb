--  SastAda - SAST (Static Application Security Testing) para Ada
--  Genera reportes en formato SonarQube para análisis de calidad
--  Soporta análisis incremental para eficiencia en PRs
--
--  Uso como ejecutable standalone:
--    sastada --project-path=/ruta/al/proyecto
--    sastada --project-path=/ruta --output=report.json
--    sastada --project-path=/ruta --src-dir=src_sub

with Ada.Text_IO;                 use Ada.Text_IO;
with Ada.Command_Line;            use Ada.Command_Line;
with Ada.Strings.Unbounded;       use Ada.Strings.Unbounded;
with Ada.Exceptions;              use Ada.Exceptions;
with Ada.Directories;             use Ada.Directories;
with SastAda_Analysis;            use SastAda_Analysis;

procedure SastAda is

   procedure Print_Usage is
   begin
      Put_Line ("Usage: sastada [options]");
      New_Line;
      Put_Line ("Required (uno de ellos):");
      Put_Line ("  --project-path=<path>  Full path to the project to analyze");
      Put_Line ("  --src-dir=<dir>        Source directory (default: current dir)");
      New_Line;
      Put_Line ("Options:");
      Put_Line ("  --output=<file>        Output report file");
      Put_Line ("                         (default: <project-path>/sastada_report.json)");
      Put_Line ("  --cache=<file>         Cache file for incremental analysis");
      Put_Line ("                         (default: <project-path>/.sastada_cache)");
      Put_Line ("  --project=<file>       Archivo .gpr del proyecto (opcional)");
      Put_Line ("  --help                 Muestra esta ayuda");
      New_Line;
      Put_Line ("Ejemplos:");
      Put_Line ("  sastada --project-path=/ada/console_training/consapp");
      Put_Line ("  sastada --project-path=/ada/console_training/consapp --output=report.json");
      Put_Line ("  sastada --project-path=/ada/proyecto --src-dir=src_sub");
      Put_Line ("  sastada --src-dir=.");
      New_Line;
      Put_Line ("Nota: Por defecto busca fuentes Ada en <project-path>/src/");
      Put_Line ("      El reporte y caché se guardan dentro de <project-path>.");
   end Print_Usage;

   function Strip_Trailing_Slash (Path : String) return String is
   begin
      if Path'Length > 1 and then
        (Path (Path'Last) = '/' or else Path (Path'Last) = '\')
      then
         return Path (Path'First .. Path'Last - 1);
      end if;
      return Path;
   end Strip_Trailing_Slash;

   procedure Parse_Args
     (Project_Path : out Unbounded_String;
      Src_Dir      : out Unbounded_String;
      Output       : out Unbounded_String;
      Cache        : out Unbounded_String;
      Project_File : out Unbounded_String)
   is
      Got_Project_Path : Boolean := False;
      Got_Src_Dir      : Boolean := False;
   begin
      Project_Path := To_Unbounded_String ("");
      Src_Dir      := To_Unbounded_String ("");
      Output       := To_Unbounded_String ("");
      Cache        := To_Unbounded_String ("");
      Project_File := To_Unbounded_String ("");

      for I in 1 .. Argument_Count loop
         declare
            Full_Arg : constant String := Argument (I);
         begin
            if Full_Arg = "--help" then
               Print_Usage;
               return;
            elsif Full_Arg'Length >= 15
              and then Full_Arg (Full_Arg'First .. Full_Arg'First + 14) = "--project-path="
            then
               Project_Path := To_Unbounded_String
                 (Strip_Trailing_Slash
                    (Full_Arg (Full_Arg'First + 15 .. Full_Arg'Last)));
               Got_Project_Path := True;
            elsif Full_Arg'Length >= 10
              and then Full_Arg (Full_Arg'First .. Full_Arg'First + 9) = "--src-dir="
            then
               Src_Dir := To_Unbounded_String
                 (Full_Arg (Full_Arg'First + 10 .. Full_Arg'Last));
               Got_Src_Dir := True;
            elsif Full_Arg'Length >= 9
              and then Full_Arg (Full_Arg'First .. Full_Arg'First + 8) = "--output="
            then
               Output := To_Unbounded_String
                 (Full_Arg (Full_Arg'First + 9 .. Full_Arg'Last));
            elsif Full_Arg'Length >= 8
              and then Full_Arg (Full_Arg'First .. Full_Arg'First + 7) = "--cache="
            then
               Cache := To_Unbounded_String
                 (Full_Arg (Full_Arg'First + 8 .. Full_Arg'Last));
            elsif Full_Arg'Length >= 10
              and then Full_Arg (Full_Arg'First .. Full_Arg'First + 9) = "--project="
            then
               Project_File := To_Unbounded_String
                 (Full_Arg (Full_Arg'First + 10 .. Full_Arg'Last));
            else
               Put_Line ("Warning: Unknown argument: " & Full_Arg);
            end if;
         end;
      end loop;

      --  Si tenemos project-path, llenamos los valores por defecto
      if Got_Project_Path then
         declare
            Proj_Path : constant String := To_String (Project_Path);
         begin
            --  Si no se especificó src-dir, buscar src/ dentro del proyecto
            if not Got_Src_Dir then
               declare
                  Possible_Src : constant String := Proj_Path & "/src";
               begin
                  if Exists (Possible_Src) and then
                    Kind (Possible_Src) = Directory
                  then
                     Src_Dir := To_Unbounded_String (Possible_Src);
                  else
                     --  Si no encuentra src/, usa el mismo project path
                     Src_Dir := To_Unbounded_String (Proj_Path);
                  end if;
               end;
            end if;

            --  Output por defecto dentro del proyecto
            if To_String (Output) = "" then
               Output := To_Unbounded_String (Proj_Path & "/sastada_report.json");
            end if;

            --  Cache por defecto dentro del proyecto
            if To_String (Cache) = "" then
               Cache := To_Unbounded_String (Proj_Path & "/.sastada_cache");
            end if;
         end;
      else
         --  Sin project-path: usamos defaults relativos
         if To_String (Src_Dir) = "" then
            Src_Dir := To_Unbounded_String (".");
         end if;
         if To_String (Output) = "" then
            Output := To_Unbounded_String ("sastada_report.json");
         end if;
         if To_String (Cache) = "" then
            Cache := To_Unbounded_String (".sastada_cache");
         end if;
      end if;
   end Parse_Args;

   Project_Path : Unbounded_String;
   Src_Dir      : Unbounded_String;
   Output       : Unbounded_String;
   Cache        : Unbounded_String;
   Project      : Unbounded_String;
   Config       : Analysis_Config;
   Success      : Boolean;

begin
   --  Parsear argumentos
   Parse_Args (Project_Path, Src_Dir, Output, Cache, Project);

   if Argument_Count = 0 then
      Print_Usage;
      return;
   end if;

   if Argument_Count > 0 and then Argument (1) = "--help" then
      return;
   end if;

   --  Inicializar configuración
   New_Line;
   Put_Line ("SastAda v0.1.0 - SAST for Ada");
   Put_Line ("================================");
   if To_String (Project_Path) /= "" then
      Put_Line ("Project path: " & To_String (Project_Path));
   end if;
   Put_Line ("Source directory: " & To_String (Src_Dir));
   Put_Line ("Output file: " & To_String (Output));
   Put_Line ("Cache file: " & To_String (Cache));
   New_Line;

   Config := Init_Config
     (Source_Dirs  => To_String (Src_Dir),
      Cache_File   => To_String (Cache),
      Project_File => To_String (Project),
      Output_File  => To_String (Output),
      Project_Path => To_String (Project_Path));

   --  Ejecutar análisis
   Run_Analysis (Config, Success);

   --  Salida final
   New_Line;
   if Success then
      Put_Line ("Análisis completado exitosamente.");
   else
      Put_Line ("Análisis completado con errores.");
      Set_Exit_Status (Failure);
   end if;

exception
   when E : others =>
      Put_Line ("Fatal error: " & Exception_Information (E));
      Set_Exit_Status (Failure);

end SastAda;

