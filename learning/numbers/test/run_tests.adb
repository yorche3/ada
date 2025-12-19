with AUnit.Run;
with AUnit.Reporter.Text;

with Recursive_Suite; use Recursive_Suite;
with Iterative_Suite; use Iterative_Suite;

procedure Run_Tests is
   procedure Recursive_Runner is new AUnit.Run.Test_Runner (Suite_Rec);
   procedure Iterative_Runner is new AUnit.Run.Test_Runner (Suite_Ite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Recursive_Runner (Reporter);
   Iterative_Runner (Reporter);
end Run_Tests;