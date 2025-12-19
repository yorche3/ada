with AUnit.Test_Caller;

with Calculator_Tests; use Calculator_Tests;

package body Calculator_Suite is

   package Caller is new AUnit.Test_Caller (Calculator_Tests.Test);

   function Suite return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test
        (Caller.Create ("Test addition", Test_Add'Access));
      Ret.Add_Test
        (Caller.Create ("Test subtraction", Test_Subtract'Access));
      return Ret;
   end Suite;

end Calculator_Suite;