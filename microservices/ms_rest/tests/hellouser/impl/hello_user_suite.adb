with AUnit.Test_Caller;
with User_Protocols_Test; use User_Protocols_Test;

package body Hello_User_Suite is

   package Caller is new AUnit.Test_Caller (User_Protocols_Test.Test);

   function Suite return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test (Caller.Create ("Valid name",             Test_Valid_Name'Access));
      Ret.Add_Test (Caller.Create ("Empty body",             Test_Empty_Body'Access));
      Ret.Add_Test (Caller.Create ("Missing name field",     Test_Missing_Name_Field'Access));
      Ret.Add_Test (Caller.Create ("Empty name value",       Test_Empty_Name_Value'Access));
      Ret.Add_Test (Caller.Create ("Whitespace-only name",   Test_Name_Whitespace_Only'Access));
      Ret.Add_Test (Caller.Create ("Name too long (51)",     Test_Name_Too_Long'Access));
      Ret.Add_Test (Caller.Create ("Name max length (50)",   Test_Name_Max_Length'Access));
      Ret.Add_Test (Caller.Create ("Malformed JSON",         Test_Malformed_JSON'Access));
      Ret.Add_Test (Caller.Create ("Name not a string",      Test_Name_Not_String'Access));
      Ret.Add_Test (Caller.Create ("Get_Name trims spaces",  Test_Get_Name_Trims_Spaces'Access));
      Ret.Add_Test (Caller.Create ("Is_Valid_User",          Test_Is_Valid_User'Access));
      return Ret;
   end Suite;

end Hello_User_Suite;
