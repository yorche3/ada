with AUnit.Test_Caller;

with Numerical_Test; use Numerical_Test;

package body Numerical_Suite is

   package Caller is new AUnit.Test_Caller (Numerical_Test.Test);

   function Suite_Numerical return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test
         (Caller.Create
            ("Fibonacci", Test_Fibonnaci'Access));
      Ret.Add_Test
         (Caller.Create
            ("Factorial", Test_Factorial'Access));
      Ret.Add_Test
         (Caller.Create
            ("Greatest Common Divisor", Test_GCD'Access));
      Ret.Add_Test
         (Caller.Create
            ("Lowest Common Multiple", Test_LCM'Access));
      return Ret;
   end Suite_Numerical;
end Numerical_Suite;