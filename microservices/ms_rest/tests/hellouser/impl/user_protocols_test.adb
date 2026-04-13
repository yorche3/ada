with AUnit.Assertions; use AUnit.Assertions;
with User_Protocols;   use User_Protocols;

package body User_Protocols_Test is

   -- -------------------------------------------------------------------------
   --  Create_From_JSON
   -- -------------------------------------------------------------------------

   procedure Test_Valid_Name (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
   begin
      Result := Create_From_JSON ("{""name"": ""Jorge""}", User);
      Assert (Result = Valid,          "should be Valid");
      Assert (Get_Name (User) = "Jorge", "name should be ""Jorge""");
   end Test_Valid_Name;

   procedure Test_Empty_Body (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
   begin
      Result := Create_From_JSON ("", User);
      Assert (Result = Invalid_Format, "empty body should be Invalid_Format");
   end Test_Empty_Body;

   procedure Test_Missing_Name_Field (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
   begin
      Result := Create_From_JSON ("{""age"": 30}", User);
      Assert (Result = Missing_Field, "missing field should be Missing_Field");
   end Test_Missing_Name_Field;

   procedure Test_Empty_Name_Value (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
   begin
      Result := Create_From_JSON ("{""name"": """"}", User);
      Assert (Result = Empty_Value, "empty name should be Empty_Value");
   end Test_Empty_Name_Value;

   procedure Test_Name_Whitespace_Only (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
   begin
      Result := Create_From_JSON ("{""name"": ""   ""}", User);
      Assert (Result = Empty_Value, "whitespace-only name should be Empty_Value");
   end Test_Name_Whitespace_Only;

   procedure Test_Name_Too_Long (Self : in out Test) is
      pragma Unreferenced (Self);
      User        : User_Request;
      Result      : Validation_Result;
      Long_Name   : constant String (1 .. 51) := (others => 'A');
   begin
      Result := Create_From_JSON ("{""name"": """ & Long_Name & """}", User);
      Assert (Result = Invalid_Length, "51-char name should be Invalid_Length");
   end Test_Name_Too_Long;

   procedure Test_Name_Max_Length (Self : in out Test) is
      pragma Unreferenced (Self);
      User      : User_Request;
      Result    : Validation_Result;
      Max_Name  : constant String (1 .. 50) := (others => 'B');
   begin
      Result := Create_From_JSON ("{""name"": """ & Max_Name & """}", User);
      Assert (Result = Valid, "50-char name should be Valid");
   end Test_Name_Max_Length;

   procedure Test_Malformed_JSON (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
   begin
      Result := Create_From_JSON ("not json at all", User);
      Assert (Result = Invalid_Format, "malformed JSON should be Invalid_Format");
   end Test_Malformed_JSON;

   procedure Test_Name_Not_String (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
   begin
      Result := Create_From_JSON ("{""name"": 123}", User);
      Assert (Result = Invalid_Format, "numeric name should be Invalid_Format");
   end Test_Name_Not_String;

   -- -------------------------------------------------------------------------
   --  Get_Name / Is_Valid_User
   -- -------------------------------------------------------------------------

   procedure Test_Get_Name_Trims_Spaces (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
   begin
      Result := Create_From_JSON ("{""name"": ""  Ana  ""}", User);
      Assert (Result = Valid,          "should be Valid");
      Assert (Get_Name (User) = "Ana", "name should be trimmed to ""Ana""");
   end Test_Get_Name_Trims_Spaces;

   procedure Test_Is_Valid_User (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
   begin
      Result := Create_From_JSON ("{""name"": ""Carlos""}", User);
      Assert (Result = Valid,          "should be Valid");
      Assert (Is_Valid_User (User),    "Is_Valid_User should return True");
   end Test_Is_Valid_User;

end User_Protocols_Test;
