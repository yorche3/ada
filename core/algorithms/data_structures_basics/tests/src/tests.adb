with AUnit.Reporter.Text; use AUnit.Reporter.Text;
with AUnit.Run; use AUnit.Run;
with AUnit; use AUnit;

with Data_Structures_Basics_Suite;

procedure Tests is
   Failed_Tests : exception;

   function Runner is new Test_Runner_With_Status (Data_Structures_Basics_Suite.Suite);
   Reporter : Text_Reporter;
begin
   if Runner (Reporter) /= Success then
      raise Failed_Tests;
   end if;
end Tests;