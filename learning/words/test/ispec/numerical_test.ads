with AUnit;
with AUnit.Test_Fixtures;

package Numerical_Test is
   type Test is new AUnit.Test_Fixtures.Test_Fixture with null record;

   procedure Test_Fibonnaci (Self : in out Test);
   procedure Test_Factorial (Self : in out Test);
   procedure Test_GCD (Self : in out Test);
   procedure Test_LCM (Self : in out Test);
end Numerical_Test;