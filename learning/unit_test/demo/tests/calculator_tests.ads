with AUnit;
with AUnit.Test_Fixtures;

package Calculator_Tests is
   type Test is new AUnit.Test_Fixtures.Test_Fixture with null record;

   procedure Test_Add (Self : in out Test);
   procedure Test_Subtract (Self : in out Test);
end Calculator_Tests;