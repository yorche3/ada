package body Numbers is
   function Sum_Of_First_N_Rec (N : Natural) return Natural is
      Result : Natural := 0;
   begin
      if N = 0 then
         Result := 0;
      else
         Result := N + Sum_Of_First_N_Rec (N - 1);
      end if;
      return Result;
   end Sum_Of_First_N_Rec;

   function Factorial_Rec (N : Natural) return Natural is
      Result : Natural := 0;
   begin
      if N = 0 then
         Result := 1;
      else
         Result := N * Factorial_Rec (N - 1);
      end if;
      return Result;
   end Factorial_Rec;

   function Fibonacci_Rec (N : Natural) return Natural is
      Result : Natural := 0;
   begin
      if N <= 1 then
         Result := N;
      else
         Result := Fibonacci_Rec (N - 1) + Fibonacci_Rec (N - 2);
      end if;
      return Result;
   end Fibonacci_Rec;

   function Greatest_Common_Divisor_Rec (A, B : Natural) return Natural is
      Result : Natural := 0;
   begin
      if B = 0 then
         Result := A;
      else
         Result := Greatest_Common_Divisor_Rec (B, A mod B);
      end if;
      return Result;
   end Greatest_Common_Divisor_Rec;

   function Least_Common_Multiple_Rec (A, B : Natural) return Natural is
      Result : Natural := 0;
   begin
      Result := A * B / Greatest_Common_Divisor_Rec (A, B);
      return Result;
   end Least_Common_Multiple_Rec;

   function Sum_Of_First_N_Acc (N : Natural) return Natural is
   begin
      return Sum_Of_First_N_Rec_Help (N, 0);
   end Sum_Of_First_N_Acc;

   function Sum_Of_First_N_Rec_Help (N : Natural; Acc : Natural) return Natural is
   begin
      if N = 0 then
         return Acc;
      else
         return Sum_Of_First_N_Rec_Help (N - 1, Acc + N);
      end if;
   end Sum_Of_First_N_Rec_Help;

   function Factorial_Acc (N : Natural) return Natural is
   begin
      return Factorial_Rec_Help (N, 1);
   end Factorial_Acc;

   function Factorial_Rec_Help (N : Natural; Acc : Natural) return Natural is
   begin
      if N = 0 then
         return Acc;
      else
         return Factorial_Rec_Help (N - 1, Acc * N);
      end if;
   end Factorial_Rec_Help;

   function Fibonacci_Acc (N : Natural) return Natural is
   begin
      return Fibonacci_Rec_Help (N, 0, 1);
   end Fibonacci_Acc;

   function Fibonacci_Rec_Help (N : Natural; Acc1 : Natural; Acc2 : Natural) return Natural is
   begin
      if N = 0 then
         return Acc1;
      else
         return Fibonacci_Rec_Help (N - 1, Acc2, Acc1 + Acc2);
      end if;
   end Fibonacci_Rec_Help;

   function Greatest_Common_Divisor_Acc (A, B : Natural) return Natural is
   begin
      return Greatest_Common_Divisor_Rec_Help (A, B);
   end Greatest_Common_Divisor_Acc;

   function Greatest_Common_Divisor_Rec_Help (A, B : Natural) return Natural is
   begin
      if B = 0 then
         return A;
      else
         return Greatest_Common_Divisor_Rec_Help (B, A mod B);
      end if;
   end Greatest_Common_Divisor_Rec_Help;

   function Least_Common_Multiple_Acc (A, B : Natural) return Natural is
   begin
      return (A * B) / Greatest_Common_Divisor_Acc (A, B);
   end Least_Common_Multiple_Acc;

   function Sum_Of_First_N_Iter (N : Natural) return Natural is
      Result : Natural := 0;
      I : Natural := 0;
   begin
      while I <= N loop
         Result := Result + I;
         I := I + 1;
      end loop;
      return Result;
   end Sum_Of_First_N_Iter;

   function Factorial_Iter (N : Natural) return Natural is
      Result : Natural := 1;
      I : Natural := 1;
   begin
      while I <= N loop
         Result := Result * I;
         I := I + 1;
      end loop;
      return Result;
   end Factorial_Iter;

   function Fibonacci_Iter (N : Natural) return Natural is
      Acc1 : Natural := 0;
      Acc2 : Natural := 1;
      Result : Natural := 0;
      I : Natural := 2;
   begin
      while I <= N loop
         Result := Acc1 + Acc2;
         Acc1 := Acc2;
         Acc2 := Result;
         I := I + 1;
      end loop;
      return Result;
   end Fibonacci_Iter;

   function Greatest_Common_Divisor_Iter (A, B : Natural) return Natural is
      R : Natural := 0;
      A_Copy : Natural := A;
      B_Copy : Natural := B;
   begin
      while B_Copy /= 0 loop
         R := A_Copy mod B_Copy;
         A_Copy := B_Copy;
         B_Copy := R;
      end loop;
      return A_Copy;
   end Greatest_Common_Divisor_Iter;

   function Least_Common_Multiple_Iter (A, B : Natural) return Natural is
      Result : Natural := 0;
   begin
      Result := (A * B) / Greatest_Common_Divisor_Iter (A, B);
      return Result;
   end Least_Common_Multiple_Iter;
end Numbers;