with AUnit.Test_Caller;

with Data_Structures_Advanced_Tree_Node_Tests;
with Data_Structures_Advanced_Binary_Tree_Tests;
with Data_Structures_Advanced_Graph_Tests;

package body Data_Structures_Advanced_Suite is
   package Tree_Node_Caller is new AUnit.Test_Caller
     (Data_Structures_Advanced_Tree_Node_Tests.Test);
   package Binary_Tree_Caller is new AUnit.Test_Caller
     (Data_Structures_Advanced_Binary_Tree_Tests.Test);
   package Graph_Caller is new AUnit.Test_Caller
     (Data_Structures_Advanced_Graph_Tests.Test);

   function Tree_Node_Suite return Access_Test_Suite is
      Result : constant Access_Test_Suite := new Test_Suite;
      use Data_Structures_Advanced_Tree_Node_Tests;
   begin
      Result.Add_Test
        (Tree_Node_Caller.Create ("TreeNode.Make", Test_Make'Access));
      Result.Add_Test
        (Tree_Node_Caller.Create
           ("TreeNode.Get_Value", Test_Get_Value'Access));
      Result.Add_Test
        (Tree_Node_Caller.Create
           ("TreeNode.Get_Left", Test_Get_Left'Access));
      Result.Add_Test
        (Tree_Node_Caller.Create
           ("TreeNode.Get_Right", Test_Get_Right'Access));
      Result.Add_Test
        (Tree_Node_Caller.Create
           ("TreeNode.Set_Left", Test_Set_Left'Access));
      Result.Add_Test
        (Tree_Node_Caller.Create
           ("TreeNode.Set_Right", Test_Set_Right'Access));
      return Result;
   end Tree_Node_Suite;

   function Binary_Tree_Suite return Access_Test_Suite is
      Result : constant Access_Test_Suite := new Test_Suite;
      use Data_Structures_Advanced_Binary_Tree_Tests;
   begin
      Result.Add_Test
        (Binary_Tree_Caller.Create ("BinaryTree.Make", Test_Make'Access));
      Result.Add_Test
        (Binary_Tree_Caller.Create ("BinaryTree.Insert", Test_Insert'Access));
      Result.Add_Test
        (Binary_Tree_Caller.Create
           ("BinaryTree.Contains", Test_Contains'Access));
      Result.Add_Test
        (Binary_Tree_Caller.Create
           ("BinaryTree.Is_Empty", Test_Is_Empty'Access));
      Result.Add_Test
        (Binary_Tree_Caller.Create ("BinaryTree.Size", Test_Size'Access));
      return Result;
   end Binary_Tree_Suite;

   function Graph_Suite return Access_Test_Suite is
      Result : constant Access_Test_Suite := new Test_Suite;
      use Data_Structures_Advanced_Graph_Tests;
   begin
      Result.Add_Test
        (Graph_Caller.Create ("Graph.Make", Test_Make'Access));
      Result.Add_Test
        (Graph_Caller.Create ("Graph.Add_Vertex", Test_Add_Vertex'Access));
      Result.Add_Test
        (Graph_Caller.Create ("Graph.Add_Edge", Test_Add_Edge'Access));
      Result.Add_Test
        (Graph_Caller.Create ("Graph.Has_Edge", Test_Has_Edge'Access));
      Result.Add_Test
        (Graph_Caller.Create
           ("Graph.Get_Neighbors", Test_Get_Neighbors'Access));
      Result.Add_Test
        (Graph_Caller.Create ("Graph.Is_Empty", Test_Is_Empty'Access));
      Result.Add_Test
        (Graph_Caller.Create
           ("Graph.Vertex_Count", Test_Vertex_Count'Access));
      Result.Add_Test
        (Graph_Caller.Create ("Graph.Edge_Count", Test_Edge_Count'Access));
      return Result;
   end Graph_Suite;

   function Suite return Access_Test_Suite is
      Result : constant Access_Test_Suite := new Test_Suite;
   begin
      Result.Add_Test (Tree_Node_Suite);
      Result.Add_Test (Binary_Tree_Suite);
      Result.Add_Test (Graph_Suite);
      return Result;
   end Suite;
end Data_Structures_Advanced_Suite;
