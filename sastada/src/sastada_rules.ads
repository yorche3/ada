--  Reglas de SAST para Ada
--  Define las reglas de calidad y seguridad a verificar

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package SastAda_Rules is

   type Rule_Severity is (BLOCKER, CRITICAL, MAJOR, MINOR, INFO);

   type Rule_Type is (Security, Reliability, Maintainability, Code_Style);

   type Rule_Record is record
      Id          : Unbounded_String;  --  Código único: SAST-001
      Name        : Unbounded_String;
      Description : Unbounded_String;
      Severity    : Rule_Severity;
      Kind        : Rule_Type;
      Active      : Boolean;
   end record;

   package Rule_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Rule_Record);

   type Finding_Record is record
      Rule_Id     : Unbounded_String;
      File_Path   : Unbounded_String;
      Line        : Natural;
      Column      : Natural;
      Message     : Unbounded_String;
      Severity    : Rule_Severity;
   end record;

   package Finding_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Finding_Record);

   --  Retorna la lista de reglas activas
   function Get_Active_Rules return Rule_Vectors.Vector;

   --  Convierte severidad a string para el reporte
   function Severity_To_String (S : Rule_Severity) return String;

   --  Convierte severidad a valor numérico para SonarQube
   function Severity_To_SonarQube (S : Rule_Severity) return String;

end SastAda_Rules;
