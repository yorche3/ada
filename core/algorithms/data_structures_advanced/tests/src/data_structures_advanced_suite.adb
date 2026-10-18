with AUnit.Test_Caller;

with Data_Structures_Advanced_Tests; use Data_Structures_Advanced_Tests;

package body Data_Structures_Advanced_Suite is
   package Caller is new AUnit.Test_Caller
     (Data_Structures_Advanced_Tests.Test);

   function Suite return Access_Test_Suite is
      Result : constant Access_Test_Suite := new Test_Suite;
   begin
      Result.Add_Test
        (Caller.Create ("TreeNode", Test_Tree_Node_Steps'Access));
      Result.Add_Test
        (Caller.Create ("BinaryTree", Test_Binary_Tree_Steps'Access));
      Result.Add_Test
        (Caller.Create ("Graph", Test_Graph_Steps'Access));
      return Result;
   end Suite;
end Data_Structures_Advanced_Suite;
