with Ada.Command_Line;
with AUnit.Reporter.Text; use AUnit.Reporter.Text;
with AUnit.Run; use AUnit.Run;
with AUnit; use AUnit;
with Data_Structures_Advanced_Suite;

procedure Tests is
   function Runner is new Test_Runner_With_Status
     (Data_Structures_Advanced_Suite.Suite);
   Reporter : Text_Reporter;
begin
   if Runner (Reporter) /= Success then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Tests;
