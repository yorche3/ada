with AUnit.Test_Caller;

with Recursive_Tests; use Recursive_Tests;

package body Recursive_Suite is
   package Caller is new AUnit.Test_Caller (Recursive_Tests.Test);

   function Suite_Recursive return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test
         (Caller.Create
            ("Sum_Of_First_N_Rec", Recursive_Tests.Test_Sum_Of_First_N_Rec'Access));
      Ret.Add_Test
         (Caller.Create
            ("Factorial_Rec", Recursive_Tests.Test_Factorial_Rec'Access));
      Ret.Add_Test
         (Caller.Create
            ("Fibonacci_Rec", Recursive_Tests.Test_Fibonacci_Rec'Access));
      Ret.Add_Test
         (Caller.Create
            ("Greatest_Common_Divisor_Rec", Recursive_Tests.Test_Greatest_Common_Divisor_Rec'Access));
      Ret.Add_Test
         (Caller.Create
            ("Least_Common_Multiple_Rec", Recursive_Tests.Test_Least_Common_Multiple_Rec'Access));
      return Ret;
   end Suite_Recursive;
end Recursive_Suite;