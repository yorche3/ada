with AUnit.Test_Fixtures; use AUnit.Test_Fixtures;
with Naive_Sort;

package Naive_Sort_Tests is
   type Test is new Test_Fixture with null record;
   subtype Integer_Array is Naive_Sort.Integer_Array;
   type Sort_Function is access function
      (Arr : Integer_Array) return Integer_Array;

   procedure Assert_All_Cases
      (Sort : Sort_Function; Algorithm_Name : String);
   procedure Test_Selection_Sort (Self : in out Test);
   procedure Test_Bubble_Sort (Self : in out Test);
   procedure Test_Insertion_Sort (Self : in out Test);
end Naive_Sort_Tests;