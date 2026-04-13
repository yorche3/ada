with Ada.Strings.Fixed;
with Ada.Strings;
with GNATCOLL.JSON;

package body User_Protocols is

   function Create_From_JSON (JSON_Content : String; Result : out User_Request) 
                             return Validation_Result is
      use GNATCOLL.JSON;
      JSON_Data : JSON_Value;
   begin
      Result.Name := Null_Unbounded_String;
      
      if JSON_Content'Length = 0 then
         return Invalid_Format;
      end if;

      begin
         JSON_Data := GNATCOLL.JSON.Read (JSON_Content);
      exception
         when others =>
            return Invalid_Format;
      end;

      return Parse_JSON_To_User (JSON_Data, Result);
   end Create_From_JSON;

   function Parse_JSON_To_User (JSON_Data : GNATCOLL.JSON.JSON_Value; 
                               Result : out User_Request) return Validation_Result is
      use GNATCOLL.JSON;
      Name_Value : JSON_Value;
   begin
      if not JSON_Data.Has_Field ("name") then
         return Missing_Field;
      end if;

      Name_Value := JSON_Data.Get ("name");
      
      if Kind (Name_Value) /= JSON_String_Type then
         return Invalid_Format;
      end if;

      declare
         Raw_Name : constant String := Get (Name_Value);
      begin
         declare
            use Ada.Strings.Fixed;
            Clean_Name : constant String := Trim (Raw_Name, Ada.Strings.Both);
         begin
            if Clean_Name'Length = 0 then
               return Empty_Value;
            elsif Clean_Name'Length > 50 then
               return Invalid_Length;
            end if;
            
            Result.Name := To_Unbounded_String (Clean_Name);
            return Valid;
         end;
      end;
   end Parse_JSON_To_User;

   function Validate_Name (Name_Value : String) return Boolean is
      use Ada.Strings.Fixed;
      Clean_Name : constant String := Trim (Name_Value, Ada.Strings.Both);
   begin
      return Clean_Name'Length > 0;
   end Validate_Name;

   function Is_Valid_User (User_Data : User_Request) return Boolean is
   begin
      return Length (User_Data.Name) > 0;
   end Is_Valid_User;

   function Get_Name (User_Data : User_Request) return String is
   begin
      return To_String (User_Data.Name);
   end Get_Name;

end User_Protocols;