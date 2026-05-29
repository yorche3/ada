--  Módulo de análisis AST usando Libadalang (API Ada nativa)
--  Reemplaza el pattern matching línea-por-línea con análisis
--  sintáctico y semántico real del código Ada.

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with SastAda_Rules;          use SastAda_Rules;
with Langkit_Support.Text;   use Langkit_Support.Text;

package SastAda_AST is

   --  Analiza un archivo Ada usando Libadalang y genera hallazgos
   --  Retorna una lista de hallazgos (findings) encontrados
   procedure Analyze_File_AST
     (File_Path : String;
      Findings  : in out Finding_Vectors.Vector);

   --  Verifica si Libadalang está disponible en el sistema
   function Is_Libadalang_Available return Boolean;

   --  Versión del motor AST
   function AST_Engine_Version return String;

   function Ada_Text_To_String (T : Text_Type) return String;

end SastAda_AST;
