package Naive_Sort is
   --  Integer_Array is a value type (not access), so no object of this type
   --  can ever be null; only Arr'Length = 0 (empty array) is representable
   --  and checked, per 05_Naive_Sort.md's null/invalid-input clause.
   type Integer_Array is array (Natural range <>) of Integer;

   function Selection_Sort (Arr : Integer_Array) return Integer_Array;
   function Bubble_Sort (Arr : Integer_Array) return Integer_Array;
   function Insertion_Sort (Arr : Integer_Array) return Integer_Array;
end Naive_Sort;
