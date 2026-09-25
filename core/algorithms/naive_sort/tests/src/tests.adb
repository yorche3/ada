with AUnit.Reporter.Text; use AUnit.Reporter.Text;
with AUnit.Run; use AUnit.Run;

with Naive_Sort_Suite;

procedure Tests is
   procedure Runner is new Test_Runner
      (Naive_Sort_Suite.Suite);
   Reporter : Text_Reporter;
begin
   Runner (Reporter);
end Tests;
