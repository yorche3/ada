with AUnit.Run; use AUnit.Run;
with AUnit.Reporter.Text; use AUnit.Reporter.Text;

with Calculator_Suite;

procedure Tests is
   procedure Calculator_Runner is new AUnit.Run.Test_Runner (Calculator_Suite.Suite_Calculator);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Calculator_Runner (Reporter);
end Tests;