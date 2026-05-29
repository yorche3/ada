--  Implementación de SastAda_Utils

with Ada.Text_IO;                 use Ada.Text_IO;
with Ada.Directories;             use Ada.Directories;
with Ada.Calendar;                use Ada.Calendar;
with Ada.Strings.Fixed;           use Ada.Strings.Fixed;

package body SastAda_Utils is

   ------------
   -- Read_File_Content --
   ------------

   function Read_File_Content (Path : String) return String is
      F      : File_Type;
      Result : Unbounded_String;
   begin
      if not File_Exists (Path) then
         return "";
      end if;
      Open (F, In_File, Path);
      while not End_Of_File (F) loop
         declare
            Line : constant String := Get_Line (F);
         begin
            Append (Result, Line);
            Append (Result, ASCII.LF);
         end;
      end loop;
      Close (F);
      return To_String (Result);
   exception
      when others =>
         if Is_Open (F) then
            Close (F);
         end if;
         return "";
   end Read_File_Content;

   ----------------
   -- Write_File_Content --
   ----------------

   procedure Write_File_Content (Path : String; Content : String) is
      F : File_Type;
   begin
      Create (F, Out_File, Path);
      Put (F, Content);
      Close (F);
   end Write_File_Content;

   -----------------
   -- File_Exists --
   -----------------

   function File_Exists (Path : String) return Boolean is
   begin
      return Exists (Path) and then Kind (Path) = Ordinary_File;
   end File_Exists;

   -----------------------
   -- Get_File_Timestamp --
   -----------------------

   function Get_File_Timestamp (Path : String) return String is
   begin
      if not File_Exists (Path) then
         return "0";
      end if;
      --  Usamos Modification_Time para detectar cambios reales
      declare
         Mod_Time : constant Ada.Calendar.Time :=
           Modification_Time (Path);
         Year     : Year_Number;
         Month    : Month_Number;
         Day      : Day_Number;
         Seconds  : Day_Duration;
      begin
         Split (Mod_Time, Year, Month, Day, Seconds);
         return Trim (Year_Number'Image (Year), Ada.Strings.Left) &
                "/" & Trim (Month_Number'Image (Month), Ada.Strings.Left) &
                "/" & Trim (Day_Number'Image (Day), Ada.Strings.Left) &
                " " & Trim (Duration'Image (Seconds), Ada.Strings.Left);
      end;
   end Get_File_Timestamp;

   ---------------
   -- Load_Cache --
   ---------------

   procedure Load_Cache (Cache_Path : String; Files : out File_Vectors.Vector) is
      F       : File_Type;
      Line    : String (1 .. 4096);
      Last    : Natural;
      Info    : File_Info;
      Sep_Pos : Natural;
   begin
      Files.Clear;
      if not File_Exists (Cache_Path) then
         return;
      end if;
      Open (F, In_File, Cache_Path);
      while not End_Of_File (F) loop
         Get_Line (F, Line, Last);
         declare
            S : constant String := Line (1 .. Last);
         begin
            Sep_Pos := Index (S, "|");
            if Sep_Pos > 0 then
               Info.Path   := To_Unbounded_String (S (1 .. Sep_Pos - 1));
               Info.Hash   := To_Unbounded_String (S (Sep_Pos + 1 .. S'Last));
               Info.Status := Unmodified;
               Files.Append (Info);
            end if;
         end;
      end loop;
      Close (F);
   exception
      when others =>
         if Is_Open (F) then
            Close (F);
         end if;
   end Load_Cache;

   ---------------
   -- Save_Cache --
   ---------------

   procedure Save_Cache (Cache_Path : String; Files : File_Vectors.Vector) is
      F : File_Type;
   begin
      Create (F, Out_File, Cache_Path);
      for Info of Files loop
         Put_Line (F, To_String (Info.Path) & "|" & To_String (Info.Hash));
      end loop;
      Close (F);
   end Save_Cache;

   -----------------------------
   -- Is_Ada_Source_File --
   -----------------------------

   function Is_Ada_Source_File (Name : String) return Boolean is
      Ext : constant Natural := Ada.Strings.Fixed.Index (Name, ".", Ada.Strings.Backward);
   begin
      if Ext = 0 then
         return False;
      end if;
      declare
         Suffix : constant String := Name (Ext .. Name'Last);
      begin
         return Suffix = ".ads" or else Suffix = ".adb";
      end;
   end Is_Ada_Source_File;

   --------------------------
   -- Should_Skip_Dir --
   --------------------------

   function Should_Skip_Dir (Dir_Path : String) return Boolean is
      Last_Sep : constant Natural :=
        Ada.Strings.Fixed.Index (Dir_Path, "/", Ada.Strings.Backward);
      Dir_Name : constant String :=
        (if Last_Sep > 0 then Dir_Path (Last_Sep + 1 .. Dir_Path'Last)
         else Dir_Path);
   begin
      return Dir_Name = ".git" or else
        Dir_Name = "obj" or else
        Dir_Name = "bin" or else
        Dir_Name = ".alire" or else
        Dir_Name = "config" or else
        Dir_Name = "alire" or else
        Dir_Name = "build";
   end Should_Skip_Dir;

   --------------------------
   -- Scan_Dir_Recursive --
   --------------------------

   procedure Scan_Dir_Recursive (Dir_Path : String; Files : in out File_Vectors.Vector) is
      Info   : File_Info;
      Search : Search_Type;
      DirEnt : Directory_Entry_Type;
   begin
      Start_Search (Search, Dir_Path, "*");
      while More_Entries (Search) loop
         Get_Next_Entry (Search, DirEnt);
         declare
            Name : constant String := Simple_Name (DirEnt);
            Path : constant String := Full_Name (DirEnt);
         begin
            if Name /= "." and then Name /= ".." then
               if Kind (DirEnt) = Ordinary_File then
                  if Is_Ada_Source_File (Name) then
                     Info.Path   := To_Unbounded_String (Path);
                     Info.Hash   := To_Unbounded_String (Get_File_Timestamp (Path));
                     Info.Status := Modified;
                     Files.Append (Info);
                  end if;
               elsif Kind (DirEnt) = Directory then
                  if not Should_Skip_Dir (Path) then
                     Scan_Dir_Recursive (Path, Files);
                  end if;
               end if;
            end if;
         end;
      end loop;
      End_Search (Search);
   end Scan_Dir_Recursive;

   -----------------
   -- Find_Ada_Files --
   -----------------

   procedure Find_Ada_Files (Dir : String; Files : out File_Vectors.Vector) is
      Info    : File_Info;
      Search  : Search_Type;
      DirEnt  : Directory_Entry_Type;
   begin
      Files.Clear;
      if not Exists (Dir) or else Kind (Dir) /= Directory then
         return;
      end if;
      Start_Search (Search, Dir, "*");
      while More_Entries (Search) loop
         Get_Next_Entry (Search, DirEnt);
         declare
            Name : constant String := Simple_Name (DirEnt);
            Path : constant String := Full_Name (DirEnt);
         begin
            if Kind (DirEnt) = Ordinary_File then
               if Is_Ada_Source_File (Name) then
                  Info.Path   := To_Unbounded_String (Path);
                  Info.Hash   := To_Unbounded_String (Get_File_Timestamp (Path));
                  Info.Status := Modified;
                  Files.Append (Info);
               end if;
            end if;
         end;
      end loop;
      End_Search (Search);
   end Find_Ada_Files;

   --------------------------
   -- Find_Ada_Files_Recursive --
   --------------------------

   procedure Find_Ada_Files_Recursive (Dir : String; Files : out File_Vectors.Vector) is
   begin
      Files.Clear;
      if not Exists (Dir) or else Kind (Dir) /= Directory then
         return;
      end if;
      Scan_Dir_Recursive (Dir, Files);
   end Find_Ada_Files_Recursive;

   ---------------------------
   -- Make_Path_Relative --
   ---------------------------

   function Make_Path_Relative (Full_Path : String; Base_Dir : String) return String is
   begin
      --  Verificar que Full_Path comienza con Base_Dir
      if Full_Path'Length > Base_Dir'Length
        and then Full_Path (Full_Path'First .. Full_Path'First + Base_Dir'Length - 1) = Base_Dir
        and then Full_Path (Full_Path'First + Base_Dir'Length) = '/'
      then
         --  Retornar la parte después de Base_Dir + '/'
         return Full_Path (Full_Path'First + Base_Dir'Length + 1 .. Full_Path'Last);
      end if;

      --  Si no coincide al inicio, retornamos la ruta completa
      return Full_Path;
   end Make_Path_Relative;

   -------------------------------
   -- Make_Vector_Paths_Relative --
   -------------------------------

   procedure Make_Vector_Paths_Relative
     (Files : in out File_Vectors.Vector; Base_Dir : String) is
   begin
      for F of Files loop
         declare
            Rel_Path : constant String :=
              Make_Path_Relative (To_String (F.Path), Base_Dir);
         begin
            F.Path := To_Unbounded_String (Rel_Path);
         end;
      end loop;
   end Make_Vector_Paths_Relative;

   ---------------------------
   -- Filter_Modified_Files --
   ---------------------------

   procedure Filter_Modified_Files
     (All_Files   : File_Vectors.Vector;
      Cache_Files : File_Vectors.Vector;
      Modified    : out File_Vectors.Vector;
      Unchanged   : out File_Vectors.Vector)
   is
      Found : Boolean;
   begin
      Modified.Clear;
      Unchanged.Clear;

      for Info of All_Files loop
         Found := False;
         for Cached of Cache_Files loop
            if To_String (Info.Path) = To_String (Cached.Path) then
               Found := True;
               if To_String (Info.Hash) /= To_String (Cached.Hash) then
                  --  El archivo ha cambiado
                  declare
                     New_Info : File_Info := Info;
                  begin
                     New_Info.Status := SastAda_Utils.Modified;
                     Modified.Append (New_Info);
                  end;
               else
                  declare
                     Old_Info : File_Info := Info;
                  begin
                     Old_Info.Status := Unmodified;
                     Unchanged.Append (Old_Info);
                  end;
               end if;
               exit;
            end if;
         end loop;
         if not Found then
            --  Archivo nuevo
            declare
               New_Info : File_Info := Info;
            begin
               New_Info.Status := New_File;
               Modified.Append (New_Info);
            end;
         end if;
      end loop;
   end Filter_Modified_Files;

end SastAda_Utils;
