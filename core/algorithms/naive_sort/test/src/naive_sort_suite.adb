with AUnit.Test_Caller;

with Naive_Sort_Tests; use Naive_Sort_Tests;

package body Naive_Sort_Suite is
   --  The test suite for the Naive_Sort algorithms
   package Caller is new AUnit.Test_Caller (Naive_Sort_Tests.Test);

   --  The Caller package is used to create test cases for each sorting algorithm
   --  The Suite function returns an access to the test suite containing all the test cases for the Naive_Sort algorithms.
   function Suite return Access_Test_Suite is
      Result : constant Access_Test_Suite := new Test_Suite;
   begin
      Result.Add_Test
         (Caller.Create ("Bubble_Sort", Test_Bubble_Sort'Access));
      Result.Add_Test
         (Caller.Create ("Insertion_Sort", Test_Insertion_Sort'Access));
      Result.Add_Test
         (Caller.Create ("Selection_Sort", Test_Selection_Sort'Access));
      return Result;
   end Suite;
end Naive_Sort_Suite;