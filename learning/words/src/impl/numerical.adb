package body Numerical is
   function Fibonacci (N : Integer) return Integer is
      Acc2 : Integer := 0;
      Acc1 : Integer := 1;
      Aux : Integer := 0;
   begin
      if N < 0 then
         return -1;
      elsif N = 0 then
         return Acc2;
      elsif N = 1 then
         return Acc1;
      else
         for I in 2 .. N - 1 loop
            Aux := Acc1 + Acc2;
            Acc2 := Acc1;
            Acc1 := Aux;
         end loop;
         return Acc1 + Acc2;
      end if;
   end Fibonacci;

   function Factorial (N : Integer) return Integer is
      Acc : Integer := 1;
   begin
      if N < 0 then
         return -1;
      else
         for I in 2 .. N loop
            Acc := Acc * I;
         end loop;
         return Acc;
      end if;
   end Factorial;

   function GCD (A : Integer; B : Integer) return Integer is
      Aux : Integer := 0;
      X : Integer := A;
      Y : Integer := B;
   begin
      while Y /= 0 loop
         Aux := X mod Y;
         X := Y;
         Y := Aux;
      end loop;
      return X;
   end GCD;

   function LCM (A : Integer; B : Integer) return Integer is
   begin
      return (A / GCD (A, B)) * B;
   end LCM;
end Numerical;