package Naive_Sort is
   type Integer_Array is array (Natural range <>) of Integer;

   function Selection_Sort (Arr : Integer_Array) return Integer_Array;
   function Bubble_Sort (Arr : Integer_Array) return Integer_Array;
   function Insertion_Sort (Arr : Integer_Array) return Integer_Array;
end Naive_Sort;
