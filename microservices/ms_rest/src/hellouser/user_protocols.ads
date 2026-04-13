with GNATCOLL.JSON;
with Ada.Strings.Unbounded;

package User_Protocols is

   use Ada.Strings.Unbounded;

   type User_Request is record
      Name : Unbounded_String;
   end record;

   type Validation_Result is (Valid, Invalid_Format, Missing_Field, Empty_Value, Invalid_Length);

   function Create_From_JSON (JSON_Content : String; Result : out User_Request) 
                             return Validation_Result;
   
   function Is_Valid_User (User_Data : User_Request) return Boolean;
   
   function Get_Name (User_Data : User_Request) return String;

private
   
   function Validate_Name (Name_Value : String) return Boolean;
   function Parse_JSON_To_User (JSON_Data : GNATCOLL.JSON.JSON_Value; 
                               Result : out User_Request) return Validation_Result;

end User_Protocols;