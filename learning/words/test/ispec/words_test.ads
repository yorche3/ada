with AUnit;
with AUnit.Test_Fixtures;

package Words_Test is
   type Test is new AUnit.Test_Fixtures.Test_Fixture with null record;

   procedure Test_Reverse_String (Self : in out Test);
   procedure Test_Is_Palindrome (Self : in out Test);
   procedure Test_Is_Substring (Self : in out Test);
   procedure Test_LCS (Self : in out Test);
end Words_Test;