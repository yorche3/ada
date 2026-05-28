--  Generación de reporte en formato SonarQube
--  Produce un JSON compatible con SonarQube Generic Issue Data

with SastAda_Rules;          use SastAda_Rules;

package SastAda_SonarQube is

   --  Genera el reporte JSON completo para SonarQube
   function Generate_Report
     (Findings    : Finding_Vectors.Vector;
      Project_Key : String := "ada-project")
      return String;

   --  Escribe el reporte a un archivo
   procedure Write_Report_File
     (Findings    : Finding_Vectors.Vector;
      Output_Path : String;
      Project_Key : String := "ada-project");

   --  Determina si el PR debe pasar o rechazarse
   --  Retorna True si pasa (sin blocker/critical), False si se rechaza
   function Should_Pass_PR (Findings : Finding_Vectors.Vector) return Boolean;

   --  Retorna un resumen textual de los hallazgos
   function Summary_Text (Findings : Finding_Vectors.Vector) return String;

   --  Convierte un Rule_Type al valor 'type' de SonarQube
   --  Security   → "VULNERABILITY"
   --  Reliability → "BUG"
   --  Maintainability → "CODE_SMELL"
   --  Code_Style → "CODE_SMELL"
   function Kind_To_SonarQube_Type (K : Rule_Type) return String;

end SastAda_SonarQube;
