package body Numbers_Recursive is

   function Fibonacci (N : Integer) return Integer is
   begin
      if N <= 1 then
         return N;
      else
         return Fibonacci (N - 1) + Fibonacci (N - 2);
      end if;
   end Fibonacci;

   function Factorial (N : Integer) return Integer is
   begin
      if N <= 1 then
         return 1;
      else
         return N * Factorial (N - 1);
      end if;
   end Factorial;

   function Sum_Numbers (N : Integer) return Integer is
   begin
      if N <= 0 then
         return 0;
      else
         return N + Sum_Numbers (N - 1);
      end if;
   end Sum_Numbers;

end Numbers_Recursive;