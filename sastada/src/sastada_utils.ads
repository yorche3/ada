--  Utilidades para SastAda
--  Proporciona funciones auxiliares compartidas

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package SastAda_Utils is

   type File_Status is (Modified, Unmodified, New_File);
   
   type File_Info is record
      Path   : Unbounded_String;
      Status : File_Status;
      Hash   : Unbounded_String;  --  MD5 simplificado o timestamp
   end record;

   package File_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => File_Info);

   --  Lee el contenido completo de un archivo
   function Read_File_Content (Path : String) return String;

   --  Escribe contenido a un archivo
   procedure Write_File_Content (Path : String; Content : String);

   --  Comprueba si un archivo existe
   function File_Exists (Path : String) return Boolean;

   --  Obtiene la hora de modificación de un archivo (string)
   function Get_File_Timestamp (Path : String) return String;

   --  Carga el estado previo de la caché incremental
   procedure Load_Cache (Cache_Path : String; Files : out File_Vectors.Vector);

   --  Guarda el estado de la caché incremental
   procedure Save_Cache (Cache_Path : String; Files : File_Vectors.Vector);

   --  Encuentra archivos Ada .ads/.adb (solo un nivel, no recursivo)
   procedure Find_Ada_Files (Dir : String; Files : out File_Vectors.Vector);

   --  Encuentra archivos Ada .ads/.adb recursivamente usando Ada.Directories
   procedure Find_Ada_Files_Recursive (Dir : String; Files : out File_Vectors.Vector);

   --  Comprueba qué archivos han cambiado
   procedure Filter_Modified_Files
     (All_Files    : File_Vectors.Vector;
      Cache_Files  : File_Vectors.Vector;
      Modified     : out File_Vectors.Vector;
      Unchanged    : out File_Vectors.Vector);

   --  Convierte una ruta absoluta a relativa respecto a Base_Dir
   function Make_Path_Relative (Full_Path : String; Base_Dir : String) return String;

   --  Convierte todas las rutas de un vector a relativas respecto a Base_Dir
   procedure Make_Vector_Paths_Relative
     (Files : in out File_Vectors.Vector; Base_Dir : String);

end SastAda_Utils;
