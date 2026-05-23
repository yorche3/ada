with AUnit.Test_Fixtures; use AUnit.Test_Fixtures;

package Iterative_Tests is
   type Test is new Test_Fixture with null record;
   
   procedure Test_Sum_Of_First_N_Iter (Self : in out Test);
   procedure Test_Factorial_Iter (Self : in out Test);
   procedure Test_Fibonacci_Iter (Self : in out Test);
   procedure Test_Greatest_Common_Divisor_Iter (Self : in out Test);
   procedure Test_Least_Common_Multiple_Iter (Self : in out Test);
end Iterative_Tests;