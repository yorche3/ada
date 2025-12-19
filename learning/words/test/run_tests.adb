with AUnit.Run;
with AUnit.Reporter.Text;

with Numerical_Suite; use Numerical_Suite;
with Words_Suite; use Words_Suite;

procedure Run_Tests is
   procedure Numerical_Runner is new AUnit.Run.Test_Runner (Suite_Numerical);
   procedure Words_Runner is new AUnit.Run.Test_Runner (Suite_Words);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Numerical_Runner (Reporter);
   Words_Runner (Reporter);
end Run_Tests;