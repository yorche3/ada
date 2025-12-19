package body Calculator is
   function Add (X, Y : Integer) return Integer is
   begin
      return X + Y;
   end Add;

   function Subtract (X, Y : Integer) return Integer is
   begin
      return X - Y;
   end Subtract;
end Calculator;