with AUnit.Test_Caller;

with Calculator_Tests; use Calculator_Tests;

package body Calculator_Suite is
   package Caller is new AUnit.Test_Caller (Calculator_Tests.Test);

   function Suite_Calculator return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test
         (Caller.Create
            ("Addition", Calculator_Tests.Test_Addition'Access));
      Ret.Add_Test
         (Caller.Create
            ("Subtraction", Calculator_Tests.Test_Subtraction'Access));
      Ret.Add_Test
         (Caller.Create
            ("Multiplication", Calculator_Tests.Test_Multiplication'Access));
      Ret.Add_Test
         (Caller.Create
            ("Division", Calculator_Tests.Test_Division'Access));
      Ret.Add_Test
         (Caller.Create
            ("Modulus", Calculator_Tests.Test_Modulus'Access));
      return Ret;
   end Suite_Calculator;
end Calculator_Suite;