with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package HelloUser is
   procedure Run;
   function Greetings (Name : String) return String;
   function Is_Valid_Name (Name : Unbounded_String) return Boolean;
end HelloUser;