with AUnit.Run; use AUnit.Run;
with AUnit.Reporter.Text; use AUnit.Reporter.Text;

with Recursive_Suite; use Recursive_Suite;
with Recursive_With_Acc_Suite; use Recursive_With_Acc_Suite;
with Iterative_Suite; use Iterative_Suite;

procedure Tests is
   procedure Recursive_Runner is new AUnit.Run.Test_Runner (Recursive_Suite.Suite_Recursive);
   procedure Recursive_With_Acc_Runner is new AUnit.Run.Test_Runner (Recursive_With_Acc_Suite.Suite_Recursive_With_Acc);
   procedure Iterative_Runner is new AUnit.Run.Test_Runner (Iterative_Suite.Suite_Iterative);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Recursive_Runner (Reporter);
   Recursive_With_Acc_Runner (Reporter);
   Iterative_Runner (Reporter);
end Tests;