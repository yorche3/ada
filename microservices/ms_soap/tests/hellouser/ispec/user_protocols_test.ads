with AUnit;
with AUnit.Test_Fixtures;

package User_Protocols_Test is

   type Test is new AUnit.Test_Fixtures.Test_Fixture with null record;

   --  User_Protocols.Create_From_SOAP_XML
   procedure Test_Valid_Name              (Self : in out Test);
   procedure Test_Missing_Envelope        (Self : in out Test);
   procedure Test_Missing_Body            (Self : in out Test);
   procedure Test_Missing_Greetings       (Self : in out Test);
   procedure Test_Missing_Name_Field      (Self : in out Test);
   procedure Test_Empty_Name_Value        (Self : in out Test);
   procedure Test_Name_Too_Long           (Self : in out Test);
   procedure Test_Name_Max_Length         (Self : in out Test);
   procedure Test_Malformed_Name_Tag      (Self : in out Test);
   
   --  User_Protocols.Get_Name / Is_Valid_User
   procedure Test_Is_Valid_User           (Self : in out Test);

end User_Protocols_Test;