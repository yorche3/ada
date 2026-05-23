with AUnit.Test_Fixtures; use AUnit.Test_Fixtures;

package Recursive_With_Acc_Tests is
   type Test is new Test_Fixture with null record;
   
   procedure Test_Sum_Of_First_N_Acc (Self : in out Test);
   procedure Test_Factorial_Acc (Self : in out Test);
   procedure Test_Fibonacci_Acc (Self : in out Test);
   procedure Test_Greatest_Common_Divisor_Acc (Self : in out Test);
   procedure Test_Least_Common_Multiple_Acc (Self : in out Test);
end Recursive_With_Acc_Tests;