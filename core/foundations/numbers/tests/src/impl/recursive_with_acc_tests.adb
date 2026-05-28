with AUnit.Assertions; use AUnit.Assertions;

with Numbers; use Numbers;

package body Recursive_With_Acc_Tests is
   procedure Test_Sum_Of_First_N_Acc (Self : in out Test) is
      N1 : constant integer := 0;
      N2 : constant integer := 3;
   begin
      Assert(Sum_Of_First_N_Acc (N1) = 0, "Sum of first 0 numbers should be 0");
      Assert(Sum_Of_First_N_Acc (N2) = 6, "Sum of first 3 numbers should be 6");
   end Test_Sum_Of_First_N_Acc;

   procedure Test_Factorial_Acc (Self : in out Test) is
      N1 : constant integer := 0;
      N2 : constant integer := 4;
   begin
      Assert(Factorial_Acc (N1) = 1, "Factorial of 0 should be 1");
      Assert(Factorial_Acc (N2) = 24, "Factorial of 4 should be 24");
   end Test_Factorial_Acc;

   procedure Test_Fibonacci_Acc (Self : in out Test) is
      N1 : constant integer := 0;
      N2 : constant integer := 1;
      N3 : constant integer := 6;
   begin
      Assert(Fibonacci_Acc (N1) = 0, "Fibonacci of 0 should be 0");
      Assert(Fibonacci_Acc (N2) = 1, "Fibonacci of 1 should be 1");
      Assert(Fibonacci_Acc (N3) = 8, "Fibonacci of 6 should be 8");
   end Test_Fibonacci_Acc;

   procedure Test_Greatest_Common_Divisor_Acc (Self : in out Test) is
      A1 : constant integer := 12;
      B1 : constant integer := 8;
      A2 : constant integer := 7;
      B2 : constant integer := 5;
   begin
      Assert(Greatest_Common_Divisor_Acc (A1, B1) = 4, "GCD of 12 and 8 should be 4");
      Assert(Greatest_Common_Divisor_Acc (A2, B2) = 1, "GCD of 7 and 5 should be 1");
   end Test_Greatest_Common_Divisor_Acc;

   procedure Test_Least_Common_Multiple_Acc (Self : in out Test) is
      A1 : constant integer := 4;
      B1 : constant integer := 6;
      A2 : constant integer := 6;
      B2 : constant integer := 8;
   begin
      Assert(Least_Common_Multiple_Acc (A1, B1) = 12, "LCM of 4 and 6 should be 12");
      Assert(Least_Common_Multiple_Acc (A2, B2) = 24, "LCM of 6 and 8 should be 24");
   end Test_Least_Common_Multiple_Acc;
end Recursive_With_Acc_Tests;