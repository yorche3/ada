with AUnit.Test_Fixtures; use AUnit.Test_Fixtures;

package Recursive_Tests is
   type Test is new Test_Fixture with null record;

   procedure Test_Sum_Of_First_N_Rec (Self : in out Test);
   procedure Test_Factorial_Rec (Self : in out Test);
   procedure Test_Fibonacci_Rec (Self : in out Test);
   procedure Test_Greatest_Common_Divisor_Rec (Self : in out Test);
   procedure Test_Least_Common_Multiple_Rec (Self : in out Test);
end Recursive_Tests;