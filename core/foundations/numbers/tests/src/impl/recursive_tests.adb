with AUnit.Assertions; use AUnit.Assertions;

with Numbers; use Numbers;

package body Recursive_Tests is
   procedure Test_Sum_Of_First_N_Rec (Self : in out Test) is
      N1 : Integer := 0;
      N2 : Integer := 3;
   begin
      Assert (Sum_Of_First_N_Rec (N1) = 0, "Sum of first 0 numbers should be 0");
      Assert (Sum_Of_First_N_Rec (N2) = 6, "Sum of first 3 numbers should be 6");
   end Test_Sum_Of_First_N_Rec;

   procedure Test_Factorial_Rec (Self : in out Test) is
      N1 : Integer := 0;
      N2 : Integer := 4;
   begin
      Assert (Factorial_Rec (N1) = 1, "Factorial of 0 should be 1");
      Assert (Factorial_Rec (N2) = 24, "Factorial of 4 should be 24");
   end Test_Factorial_Rec;

   procedure Test_Fibonacci_Rec (Self : in out Test) is
      N1 : Integer := 0;
      N2 : Integer := 6;
   begin
      Assert (Fibonacci_Rec (N1) = 0, "Fibonacci of 0 should be 0");
      Assert (Fibonacci_Rec (N2) = 8, "Fibonacci of 6 should be 8");
   end Test_Fibonacci_Rec;
   
   procedure Test_Greatest_Common_Divisor_Rec (Self : in out Test) is
      A1 : Integer := 12;
      B1 : Integer := 8;
      A2 : Integer := 7;
      B2 : Integer := 5;
   begin
      Assert (Greatest_Common_Divisor_Rec (A1, B1) = 4, "GCD of 12 and 8 should be 4");
      Assert (Greatest_Common_Divisor_Rec (A2, B2) = 1, "GCD of 7 and 5 should be 1");
   end Test_Greatest_Common_Divisor_Rec;

   procedure Test_Least_Common_Multiple_Rec (Self : in out Test) is
      A1 : Integer := 4;
      B1 : Integer := 6;
      A2 : Integer := 6;
      B2 : Integer := 8;
   begin
      Assert (Least_Common_Multiple_Rec (A1, B1) = 12, "LCM of 4 and 6 should be 12");
      Assert (Least_Common_Multiple_Rec (A2, B2) = 24, "LCM of 6 and 8 should be 24");
   end Test_Least_Common_Multiple_Rec;
end Recursive_Tests;

