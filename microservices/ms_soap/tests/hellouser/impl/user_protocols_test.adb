with AUnit.Assertions; use AUnit.Assertions;
with User_Protocols;   use User_Protocols;

package body User_Protocols_Test is

   -- -------------------------------------------------------------------------
   --  Create_From_SOAP_XML
   -- -------------------------------------------------------------------------

   procedure Test_Valid_Name (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
      XML    : constant String := "<Envelope><Body><greetings><name>Jorge</name></greetings></Body></Envelope>";
   begin
      Result := Create_From_SOAP_XML (XML, User);
      Assert (Result = Valid,          "should be Valid");
      Assert (Get_Name (User) = "Jorge", "name should be ""Jorge""");
   end Test_Valid_Name;

   procedure Test_Missing_Envelope (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
      XML    : constant String := "<Body><greetings><name>Jorge</name></greetings></Body>";
   begin
      Result := Create_From_SOAP_XML (XML, User);
      Assert (Result = Invalid_XML_Format, "missing Envelope should be Invalid_XML_Format");
   end Test_Missing_Envelope;

   procedure Test_Missing_Body (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
      XML    : constant String := "<Envelope><greetings><name>Jorge</name></greetings></Envelope>";
   begin
      Result := Create_From_SOAP_XML (XML, User);
      Assert (Result = Missing_XML_Element, "missing Body should be Missing_XML_Element");
   end Test_Missing_Body;

   procedure Test_Missing_Greetings (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
      XML    : constant String := "<Envelope><Body><name>Jorge</name></Body></Envelope>";
   begin
      Result := Create_From_SOAP_XML (XML, User);
      Assert (Result = Unsupported_Operation, "missing greetings should be Unsupported_Operation");
   end Test_Missing_Greetings;

   procedure Test_Missing_Name_Field (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
      XML    : constant String := "<Envelope><Body><greetings></greetings></Body></Envelope>";
   begin
      Result := Create_From_SOAP_XML (XML, User);
      Assert (Result = Missing_XML_Element, "missing name should be Missing_XML_Element");
   end Test_Missing_Name_Field;

   procedure Test_Empty_Name_Value (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
      XML    : constant String := "<Envelope><Body><greetings><name></name></greetings></Body></Envelope>";
   begin
      Result := Create_From_SOAP_XML (XML, User);
      Assert (Result = Empty_Content, "empty name should be Empty_Content");
   end Test_Empty_Name_Value;

   procedure Test_Name_Too_Long (Self : in out Test) is
      pragma Unreferenced (Self);
      User        : User_Request;
      Result      : Validation_Result;
      Long_Name   : constant String (1 .. 51) := (others => 'a');
      XML         : constant String := "<Envelope><Body><greetings><name>" & Long_Name & "</name></greetings></Body></Envelope>";
   begin
      Result := Create_From_SOAP_XML (XML, User);
      Assert (Result = Invalid_Content_Length, "51-char name should be Invalid_Content_Length");
   end Test_Name_Too_Long;

   procedure Test_Name_Max_Length (Self : in out Test) is
      pragma Unreferenced (Self);
      User      : User_Request;
      Result    : Validation_Result;
      Max_Name  : constant String (1 .. 50) := (others => 'b');
      XML       : constant String := "<Envelope><Body><greetings><name>" & Max_Name & "</name></greetings></Body></Envelope>";
   begin
      Result := Create_From_SOAP_XML (XML, User);
      Assert (Result = Valid, "50-char name should be Valid");
   end Test_Name_Max_Length;

   procedure Test_Malformed_Name_Tag (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
      XML    : constant String := "<Envelope><Body><greetings><name>Jorge<name></greetings></Body></Envelope>";
   begin
      Result := Create_From_SOAP_XML (XML, User);
      Assert (Result = Malformed_XML, "malformed name tag should be Malformed_XML");
   end Test_Malformed_Name_Tag;

   -- -------------------------------------------------------------------------
   --  Get_Name / Is_Valid_User
   -- -------------------------------------------------------------------------

   procedure Test_Is_Valid_User (Self : in out Test) is
      pragma Unreferenced (Self);
      User   : User_Request;
      Result : Validation_Result;
      XML    : constant String := "<Envelope><Body><greetings><name>Carlos</name></greetings></Body></Envelope>";
   begin
      Result := Create_From_SOAP_XML (XML, User);
      Assert (Result = Valid,          "should be Valid");
      Assert (Is_Valid_User (User),    "Is_Valid_User should return True");
   end Test_Is_Valid_User;

end User_Protocols_Test;
