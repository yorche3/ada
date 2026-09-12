with AUnit.Assertions; use AUnit.Assertions;

with Naive_Sort; use Naive_Sort;

package body Naive_Sort_Tests is
   Standard_Input : constant Integer_Array := (5, 2, 9, 1, 5, 6);
   Standard_Output : constant Integer_Array := (1, 2, 5, 5, 6, 9);
   Sorted_Input : constant Integer_Array := (1, 2, 3, 4, 5);
   Reverse_Input : constant Integer_Array := (5, 4, 3, 2, 1);
   Reverse_Output : constant Integer_Array := (1, 2, 3, 4, 5);
   Equal_Input : constant Integer_Array := (7, 7, 7, 7);
   Negative_Input : constant Integer_Array := (3, -1, 4, -5, 0);
   Negative_Output : constant Integer_Array := (-5, -1, 0, 3, 4);
        Single_Input : constant Integer_Array := (0 => 42);
   Empty_Input : constant Integer_Array := (1 .. 0 => 0);

   -- Assert all test cases for a given sorting algorithm
   -- Sort : access to the sorting function to be tested that must return a sorted integer array
   -- Algorithm_Name : the name of the sorting algorithm, used in assertion messages
        procedure Assert_All_Cases
                (Sort : Sort_Function; Algorithm_Name : String) is
   begin
      Assert (Sort (Standard_Input) = Standard_Output,
              Algorithm_Name & " should sort an unsorted array");
      Assert (Sort (Sorted_Input) = Sorted_Input,
              Algorithm_Name & " should preserve an already sorted array");
      Assert (Sort (Reverse_Input) = Reverse_Output,
              Algorithm_Name & " should sort a reverse-order array");
      Assert (Sort (Equal_Input) = Equal_Input,
              Algorithm_Name & " should preserve equal elements");
      Assert (Sort (Negative_Input) = Negative_Output,
              Algorithm_Name & " should sort negative values");
      Assert (Sort (Single_Input) = Single_Input,
              Algorithm_Name & " should preserve a single-element array");
      Assert (Sort (Empty_Input) = Empty_Input,
              Algorithm_Name & " should preserve an empty array");
   end Assert_All_Cases;

   -- Test cases for each sorting algorithm
   -- Test_Selection_Sort : tests the Selection_Sort algorithm
   procedure Test_Selection_Sort (Self : in out Test) is
   begin
      Assert_All_Cases (Selection_Sort'Access, "Selection_Sort");
   end Test_Selection_Sort;

   -- Test_Bubble_Sort : tests the Bubble_Sort algorithm
   procedure Test_Bubble_Sort (Self : in out Test) is
   begin
      Assert_All_Cases (Bubble_Sort'Access, "Bubble_Sort");
   end Test_Bubble_Sort;

   -- Test_Insertion_Sort : tests the Insertion_Sort algorithm
   procedure Test_Insertion_Sort (Self : in out Test) is
   begin
      Assert_All_Cases (Insertion_Sort'Access, "Insertion_Sort");
   end Test_Insertion_Sort;
end Naive_Sort_Tests;