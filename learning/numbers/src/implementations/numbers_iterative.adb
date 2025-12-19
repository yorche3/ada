package body Numbers_Iterative is

   function Fibonacci_Accumulator (
      N : Integer;
      Acc2 : Integer;
      Acc1 : Integer) return Integer;
   function Factorial_Accumulator (N : Integer; A : Integer) return Integer;
   function Sum_Numbers_Accumulator (N : Integer; A : Integer) return Integer;

   function Fibonacci (N : Integer) return Integer is
   begin
      return Fibonacci_Accumulator (N, 0, 1);
   end Fibonacci;

   function Fibonacci_Accumulator (
      N : Integer;
      Acc2 : Integer;
      Acc1 : Integer) return Integer is
   begin
      if N <= 1 then
         return N;
      elsif N = 2 then
         return Acc1 + Acc2;
      else
         return Fibonacci_Accumulator (N - 1, Acc1, Acc1 + Acc2);
      end if;
   end Fibonacci_Accumulator;

   function Factorial (N : Integer) return Integer is
   begin
      return Factorial_Accumulator (N - 1, N);
   end Factorial;

   function Factorial_Accumulator (N : Integer; A : Integer) return Integer is
   begin
      if N <= 1 then
         return A;
      else
         return Factorial_Accumulator (N - 1, N * A);
      end if;
   end Factorial_Accumulator;

   function Sum_Numbers (N : Integer) return Integer is
   begin
      return Sum_Numbers_Accumulator (N - 1, N);
   end Sum_Numbers;

   function Sum_Numbers_Accumulator (
      N : Integer;
      A : Integer) return Integer is
   begin
      if N <= 0 then
         return A;
      else
         return Sum_Numbers_Accumulator (N - 1, N + A);
      end if;
   end Sum_Numbers_Accumulator;


end Numbers_Iterative;