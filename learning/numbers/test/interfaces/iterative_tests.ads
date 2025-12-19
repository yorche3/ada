with AUnit;
with AUnit.Test_Fixtures;

package Iterative_Tests is
   type Test is new AUnit.Test_Fixtures.Test_Fixture with null record;

   procedure Test_Fibonnaci (Self : in out Test);
   procedure Test_Factorial (Self : in out Test);
   procedure Test_Sum_Numbers (Self : in out Test);
end Iterative_Tests;