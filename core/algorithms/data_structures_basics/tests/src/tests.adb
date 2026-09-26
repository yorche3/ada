with AUnit.Reporter.Text; use AUnit.Reporter.Text;
with AUnit.Run; use AUnit.Run;

with Data_Structures_Basics_Suite;

procedure Tests is
   procedure Runner is new Test_Runner
      (Data_Structures_Basics_Suite.Suite);
   Reporter : Text_Reporter;
begin
   Runner (Reporter);
end Tests;
