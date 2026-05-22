with AUnit;
with AUnit.Test_Fixtures;

package Calculator_Tests is
   type Test is new AUnit.Test_Fixtures.Test_Fixture with null record;

   procedure Test_Addition (Self : in out Test);
   procedure Test_Subtraction (Self : in out Test);
   procedure Test_Multiplication (Self : in out Test);
   procedure Test_Division (Self : in out Test);
   procedure Test_Modulus (Self : in out Test);
end Calculator_Tests;