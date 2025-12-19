with AUnit.Reporter.Text;
with AUnit.Run;

with Calculator_Suite; use Calculator_Suite;

procedure Run_Tests is
   procedure Runner is new AUnit.Run.Test_Runner (Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Runner (Reporter);
end Run_Tests;