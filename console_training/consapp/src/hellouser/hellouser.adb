with Ada.Strings.Unbounded.Text_IO;
with Ada.Text_IO;
with Ada.Strings;

package body HelloUser is
   use Ada.Strings.Unbounded.Text_IO;

   procedure Run is
      Input : Unbounded_String;
   begin
      loop
         Ada.Text_IO.Put ("Enter your name: ");
         Input := Get_Line;

         if Is_Valid_Name (Input) then
            Ada.Text_IO.Put_Line ("Hello, " & To_String (Trim (Input, Ada.Strings.Both)) & "!");
            exit;
         else
            Ada.Text_IO.Put_Line ("Invalid name, please retry entring a non empty name.");
         end if;
      end loop;
   end Run;

   function Is_Valid_Name (Name : Unbounded_String) return Boolean is
   begin
      return Length (Trim (Name, Ada.Strings.Both)) > 0;
   end Is_Valid_Name;
end HelloUser;