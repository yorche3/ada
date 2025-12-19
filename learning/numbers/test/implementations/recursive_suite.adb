with AUnit.Test_Caller;

with Recursive_Tests; use Recursive_Tests;

package body Recursive_Suite is

   package Caller is new AUnit.Test_Caller (Recursive_Tests.Test);

   function Suite_Rec return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test
         (Caller.Create
            ("Recursive_Fibonacci", Test_Fibonacci'Access));
      Ret.Add_Test
         (Caller.Create
            ("Recursive_Factorial", Test_Factorial'Access));
      Ret.Add_Test
         (Caller.Create
            ("Recursive_Sum_Numbers", Test_Sum_Numbers'Access));
      return Ret;
   end Suite_Rec;

end Recursive_Suite;