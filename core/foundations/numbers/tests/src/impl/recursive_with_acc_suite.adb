with AUnit.Test_Caller;

with Recursive_With_Acc_Tests; use Recursive_With_Acc_Tests;

package body Recursive_With_Acc_Suite is
   package Caller is new AUnit.Test_Caller (Recursive_With_Acc_Tests.Test);
   
   function Suite_Recursive_With_Acc return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test
         (Caller.Create
            ("Sum_Of_First_N_Acc", Recursive_With_Acc_Tests.Test_Sum_Of_First_N_Acc'Access));
      Ret.Add_Test
         (Caller.Create
            ("Factorial_Acc", Recursive_With_Acc_Tests.Test_Factorial_Acc'Access));
      Ret.Add_Test
         (Caller.Create
            ("Fibonacci_Acc", Recursive_With_Acc_Tests.Test_Fibonacci_Acc'Access));
      Ret.Add_Test
         (Caller.Create
            ("Greatest_Common_Divisor_Acc", Recursive_With_Acc_Tests.Test_Greatest_Common_Divisor_Acc'Access));
      Ret.Add_Test
         (Caller.Create
            ("Least_Common_Multiple_Acc", Recursive_With_Acc_Tests.Test_Least_Common_Multiple_Acc'Access));
      return Ret;
   end Suite_Recursive_With_Acc;
end Recursive_With_Acc_Suite;