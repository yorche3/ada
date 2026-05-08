--  Motor de análisis SAST usando Libadalang
--  Analiza archivos Ada y genera hallazgos (findings)

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with SastAda_Rules;  use SastAda_Rules;
with SastAda_Utils;  use SastAda_Utils;

package SastAda_Analysis is

   type Analysis_Config is record
      Source_Dirs  : File_Vectors.Vector;  --  Directorios a analizar
      Cache_File   : Unbounded_String;     --  Archivo de caché incremental
      Project_File : Unbounded_String;     --  Archivo .gpr del proyecto
      Output_File  : Unbounded_String;     --  Archivo de reporte SonarQube
      Project_Path : Unbounded_String;     --  Ruta base del proyecto (para rutas relativas)
   end record;

   --  Inicializa la configuración de análisis
   function Init_Config
     (Source_Dirs  : String;
      Cache_File   : String := ".sastada_cache";
      Project_File : String := "";
      Output_File  : String := "sastada_report.json";
      Project_Path : String := "")
      return Analysis_Config;

   --  Ejecuta el análisis incremental
   procedure Run_Analysis
     (Config : Analysis_Config;
      Success : out Boolean);

   --  Ejecuta el análisis para una lista de archivos
   procedure Analyze_Files
     (Files     : File_Vectors.Vector;
      Findings  : out Finding_Vectors.Vector;
      Success   : out Boolean);

private
   --  Análisis basado en texto (pattern matching) por simplicidad
   --  En producción, usaría Libadalang para AST completo

   --  Busca patrones de texto en una línea
   function Check_Pattern
     (Line      : String;
      Pattern   : String;
      Ignore_Case : Boolean := False) return Boolean;

   --  Cuenta el nivel de indentación (profundidad de anidamiento aproximada)
   function Count_Nesting_Depth (Lines : String) return Natural;

   --  Verifica reglas de seguridad
   procedure Check_Security_Rules
     (Lines     : String;
      File_Name : String;
      Findings  : in out Finding_Vectors.Vector);

   --  Verifica reglas de confiabilidad
   procedure Check_Reliability_Rules
     (Lines     : String;
      File_Name : String;
      Findings  : in out Finding_Vectors.Vector);

   --  Verifica reglas de mantenibilidad
   procedure Check_Maintainability_Rules
     (Lines     : String;
      File_Name : String;
      Findings  : in out Finding_Vectors.Vector);

   --  Verifica reglas de estilo
   procedure Check_Style_Rules
     (Lines     : String;
      File_Name : String;
      Findings  : in out Finding_Vectors.Vector);

end SastAda_Analysis;
