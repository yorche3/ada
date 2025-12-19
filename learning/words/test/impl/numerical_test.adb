with AUnit.Assertions; use AUnit.Assertions;

with Numerical; use Numerical;

package body Numerical_Test is

   procedure Test_Fibonnaci (Self : in out Test) is
   begin
      Assert (Fibonacci (-3) = -1, "Fibonnaci of -3 should be -1");
      Assert (Fibonacci (10) = 55, "Fibonacci of 10 should be 55");
      Assert (Fibonacci (15) = 610, "Fibonacci of 15 should be 610");
   end Test_Fibonnaci;

   procedure Test_Factorial (Self : in out Test) is
   begin
      Assert (Factorial (-3) = -1, "Factorial of -3 should be -1");
      Assert (Factorial (5) = 120, "Factorial of 5 should be 120");
      Assert (Factorial (10) = 3628800, "Factorial of 10 should be 3628800");

   end Test_Factorial;

   procedure Test_GCD (Self : in out Test) is
   begin
      Assert (GCD (48, 18) = 6, "G C D of 48 and 18 should be 6");
      Assert (GCD (100, 25) = 25, "G C D of 100 and 25 should be 25");
      Assert (GCD (17, 13) = 1, "G C D of 17 and 13 should be 1");
   end Test_GCD;

   procedure Test_LCM (Self : in out Test) is
   begin
      Assert (LCM (4, 6) = 12, "L C M of 4 and 6 should be 12");
      Assert (LCM (21, 6) = 42, "L C M of 21 and 6 should be 42");
      Assert (LCM (7, 3) = 21, "L C M of 7 and 3 should be 21");
   end Test_LCM;

end Numerical_Test;