package body Calculator is
   function Addition(A, B : Integer) return Integer is
   begin
    return A + B;
   end Addition;

   function Subtraction(A, B : Integer) return Integer is
   begin
    return A - B;
   end Subtraction;

   function Multiplication(A, B : Integer) return Integer is
      I : Integer; 
      Result : Integer := 0;
   begin
      for I in 1 .. B loop
         Result := Addition(Result, A);
      end loop;
      return Result;
   end Multiplication;

   function Division(A, B : Integer) return Integer is
      New_Dividend : Integer := A;
      Quotient : Integer := 0;
   begin
      while New_Dividend >= B loop
         New_Dividend := Subtraction(New_Dividend, B);
         Quotient := Addition(Quotient, 1);
      end loop;
      return Quotient;
   end Division;

   function Modulus(A, B : Integer) return Integer is
      Quotient : Integer;
      Remainder : Integer;
   begin
      Quotient := Division(A, B);
      Remainder := Subtraction(A, Multiplication(B, Quotient));
      return Remainder;
   end Modulus;
end Calculator;