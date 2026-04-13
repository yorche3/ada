with AUnit.Run;
with AUnit.Reporter.Text;

with Hello_User_Suite; use Hello_User_Suite;

procedure Run_Tests is
   procedure Hello_User_Runner is new AUnit.Run.Test_Runner (Hello_User_Suite.Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Hello_User_Runner (Reporter);
end Run_Tests;