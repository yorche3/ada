package Numbers is
   function Sum_Of_First_N_Rec (N : Natural) return Natural;
   function Factorial_Rec (N : Natural) return Natural;
   function Fibonacci_Rec (N : Natural) return Natural;
   function Greatest_Common_Divisor_Rec (A, B : Natural) return Natural;
   function Least_Common_Multiple_Rec (A, B : Natural) return Natural;

   function Sum_Of_First_N_Acc (N : Natural) return Natural;
   function Factorial_Acc (N : Natural) return Natural;
   function Fibonacci_Acc (N : Natural) return Natural;
   function Greatest_Common_Divisor_Acc (A, B : Natural) return Natural;
   function Least_Common_Multiple_Acc (A, B : Natural) return Natural;

   function Sum_Of_First_N_Iter (N : Natural) return Natural;
   function Factorial_Iter (N : Natural) return Natural;
   function Fibonacci_Iter (N : Natural) return Natural;
   function Greatest_Common_Divisor_Iter (A, B : Natural) return Natural;
   function Least_Common_Multiple_Iter (A, B : Natural) return Natural;

private
   function Sum_Of_First_N_Rec_Help (N : Natural; Acc : Natural) return Natural;
   function Factorial_Rec_Help (N : Natural; Acc : Natural) return Natural;
   function Fibonacci_Rec_Help (N : Natural; Acc1 : Natural; Acc2 : Natural) return Natural;
   function Greatest_Common_Divisor_Rec_Help (A, B : Natural) return Natural;
end Numbers;