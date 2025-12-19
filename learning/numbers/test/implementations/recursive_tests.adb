with AUnit.Assertions; use AUnit.Assertions;

with Numbers_Recursive; use Numbers_Recursive;

package body Recursive_Tests is

   procedure Test_Fibonacci (Self : in out Test) is
   begin
      Assert (Fibonacci (5) = 5, "Fibonnaci of 5 should be 5");
   end Test_Fibonacci;

   procedure Test_Factorial (Self : in out Test) is
   begin
      Assert (Factorial (5) = 120, "Factorial of 5 should be 120");
   end Test_Factorial;

   procedure Test_Sum_Numbers (Self : in out Test) is
   begin
      Assert (Sum_Numbers (5) = 15, "Sum up to 5 should be 15");
   end Test_Sum_Numbers;

end Recursive_Tests;