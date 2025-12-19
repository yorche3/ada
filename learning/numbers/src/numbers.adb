with Ada.Text_IO; use Ada.Text_IO;
with NumbersRecursive; use NumbersRecursive;
with NumbersIterative; use NumbersIterative;

procedure Numbers is
    N : Integer := 10;
begin
    Put_Line("Recursive Implementations:");
    Put_Line("Fibonacci(" & Integer'Image(N) & ") = " & Integer'Image(NumbersRecursive.Fibonacci(N)));
    Put_Line("Factorial(" & Integer'Image(N) & ") = " & Integer'Image(NumbersRecursive.Factorial(N)));
    Put_Line("Sum of first " & Integer'Image(N) & " numbers = " & Integer'Image(NumbersRecursive.Sum_Numbers(N)));

    Put_Line("");
    
    Put_Line("Iterative Implementations:");
    Put_Line("Fibonacci(" & Integer'Image(N) & ") = " & Integer'Image(NumbersIterative.Fibonacci(N)));
    Put_Line("Factorial(" & Integer'Image(N) & ") = " & Integer'Image(NumbersIterative.Factorial(N)));
    Put_Line("Sum of first " & Integer'Image(N) & " numbers = " & Integer'Image(NumbersIterative.Sum_Numbers(N)));
end Numbers;