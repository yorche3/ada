with AUnit.Assertions; use AUnit.Assertions;

with Calculator; use Calculator;

package body Calculator_Tests is
   procedure Test_Addition (Self : in out Test) is
     Result : Integer;
   begin
      Result := Addition(2, 3);
      Assert (Result = 5, "Addition of 2 and 3 should be 5");
   end Test_Addition;

   procedure Test_Subtraction (Self : in out Test) is
     Result : Integer;
   begin
      Result := Subtraction(5, 2);
      Assert (Result = 3, "Subtraction of 5 and 2 should be 3");
   end Test_Subtraction;

   procedure Test_Multiplication (Self : in out Test) is
     Result : Integer;
   begin
      Result := Multiplication(4, 3);
      Assert (Result = 12, "Multiplication of 4 and 3 should be 12");
   end Test_Multiplication;

   procedure Test_Division (Self : in out Test) is
      Result : Integer;
   begin
      Result := Division(10, 3);
      Assert (Result = 3, "Division of 10 and 3 should be 3");
   end Test_Division;

   procedure Test_Modulus (Self : in out Test) is
      Result : Integer;
   begin
      Result := Modulus(10, 3);
      Assert (Result = 1, "Modulus of 10 and 3 should be 1");
   end Test_Modulus;
end Calculator_Tests;