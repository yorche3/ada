package Words is
   type Natural_Array is array (Positive range <>) of Natural;

   function Reverse_String (Str : String) return String;
   function Is_Palindrome (Str : String) return Boolean;
   function KMP_Search (Pattern : String; Text : String) return Boolean;
   function LCS (Str1 : String; Str2 : String) return Natural;
private
   function Remove_Spaces (Str : String) return String;
   function Compute_LPS_Array (Pattern : String) return Natural_Array;
end Words;
