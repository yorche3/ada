with AUnit.Test_Caller;

with Iterative_Tests; use Iterative_Tests;

package body Iterative_Suite is
   package Caller is new AUnit.Test_Caller (Iterative_Tests.Test);

   function Suite_Iterative return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test
         (Caller.Create
            ("Sum_Of_First_N_Iter", Iterative_Tests.Test_Sum_Of_First_N_Iter'Access));
      Ret.Add_Test
         (Caller.Create
            ("Factorial_Iter", Iterative_Tests.Test_Factorial_Iter'Access));
      Ret.Add_Test
         (Caller.Create
            ("Fibonacci_Iter", Iterative_Tests.Test_Fibonacci_Iter'Access));
      Ret.Add_Test
         (Caller.Create
            ("Greatest_Common_Divisor_Iter", Iterative_Tests.Test_Greatest_Common_Divisor_Iter'Access));
      Ret.Add_Test
         (Caller.Create
            ("Least_Common_Multiple_Iter", Iterative_Tests.Test_Least_Common_Multiple_Iter'Access));
      return Ret;
   end Suite_Iterative;
end Iterative_Suite;