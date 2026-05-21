with Ada.Text_IO; use Ada.Text_IO;

procedure Hello_User is
    Name : String(1 .. 100);
    Length : Natural;
begin
    Put("What is your name? ");
    Get_Line(Name, Length);
    Put_Line("Hello, " & Name(1 .. Length) & "!");
end Hello_User;