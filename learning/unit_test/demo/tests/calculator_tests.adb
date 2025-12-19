with AUnit.Assertions; use AUnit.Assertions;

with Calculator;

package body Calculator_Tests is

   procedure Test_Add (Self : in out Test) is
   begin
      Assert (Calculator.Add (2, 3) = 5, "2 + 3 should be 5");
   end Test_Add;

   procedure Test_Subtract (Self : in out Test) is
   begin
      Assert (Calculator.Subtract (5, 3) = 2, "5 - 3 should be 2");
   end Test_Subtract;

end Calculator_Tests;