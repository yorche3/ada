with AUnit;
with AUnit.Test_Fixtures;

package User_Protocols_Test is

   type Test is new AUnit.Test_Fixtures.Test_Fixture with null record;

   --  User_Protocols.Create_From_JSON
   procedure Test_Valid_Name              (Self : in out Test);
   procedure Test_Empty_Body              (Self : in out Test);
   procedure Test_Missing_Name_Field      (Self : in out Test);
   procedure Test_Empty_Name_Value        (Self : in out Test);
   procedure Test_Name_Whitespace_Only    (Self : in out Test);
   procedure Test_Name_Too_Long           (Self : in out Test);
   procedure Test_Name_Max_Length         (Self : in out Test);
   procedure Test_Malformed_JSON          (Self : in out Test);
   procedure Test_Name_Not_String         (Self : in out Test);

   --  User_Protocols.Get_Name / Is_Valid_User
   procedure Test_Get_Name_Trims_Spaces   (Self : in out Test);
   procedure Test_Is_Valid_User           (Self : in out Test);

end User_Protocols_Test;
