with AUnit.Test_Caller;

with Iterative_Tests; use Iterative_Tests;

package body Iterative_Suite is

   package Caller is new AUnit.Test_Caller (Iterative_Tests.Test);

   function Suite_Ite return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test
         (Caller.Create
            ("Iterative_Fibonnaci", Test_Fibonnaci'Access));
      Ret.Add_Test
         (Caller.Create
            ("Iterative_Factorial", Test_Factorial'Access));
      Ret.Add_Test
         (Caller.Create
            ("Iterative_Sum_Numbers", Test_Sum_Numbers'Access));
      return Ret;
   end Suite_Ite;
end Iterative_Suite;