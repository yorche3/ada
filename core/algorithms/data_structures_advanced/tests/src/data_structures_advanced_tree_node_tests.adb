with Ada.Unchecked_Deallocation;

with AUnit.Assertions; use AUnit.Assertions;

with Data_Structures_Advanced; use Data_Structures_Advanced;

package body Data_Structures_Advanced_Tree_Node_Tests is
   procedure Release is new Ada.Unchecked_Deallocation
     (Tree_Node, Tree_Node_Access);

   --  Casos: «Crear un nodo de árbol».
   procedure Test_Make (Self : in out Test) is
      pragma Unreferenced (Self);
      Item : Tree_Node;
   begin
      Make (Item, 10);
      Assert (Get_Value (Item) = 10,
              "TreeNode.Make should leave the value 10");
   end Test_Make;

   --  Casos: «Crear un nodo de árbol» (lectura del valor).
   procedure Test_Get_Value (Self : in out Test) is
      pragma Unreferenced (Self);
      Item : Tree_Node;
   begin
      Make (Item, 42);
      Assert (Get_Value (Item) = 42,
              "TreeNode.Get_Value should return 42");
   end Test_Get_Value;

   --  Casos: «Enlaces iniciales ausentes».
   procedure Test_Get_Left (Self : in out Test) is
      pragma Unreferenced (Self);
      Item : Tree_Node;
   begin
      Make (Item, 10);
      Assert (Get_Left (Item) = null,
              "TreeNode.Get_Left should be absent on a new node");
   end Test_Get_Left;

   --  Casos: «Enlaces iniciales ausentes».
   procedure Test_Get_Right (Self : in out Test) is
      pragma Unreferenced (Self);
      Item : Tree_Node;
   begin
      Make (Item, 10);
      Assert (Get_Right (Item) = null,
              "TreeNode.Get_Right should be absent on a new node");
   end Test_Get_Right;

   --  Casos: «Enlazar dos hijos» y «Recorrer cada enlace» (izquierda).
   procedure Test_Set_Left (Self : in out Test) is
      pragma Unreferenced (Self);
      Parent : Tree_Node;
      Child  : Tree_Node_Access := new Tree_Node;
   begin
      Make (Parent, 10);
      Make (Child.all, 20);
      Set_Left (Parent, Child);
      Assert (Get_Left (Parent) = Child,
              "TreeNode.Set_Left should link the child");
      Assert (Get_Value (Get_Left (Parent).all) = 20,
              "TreeNode.Set_Left: the left child should hold 20");
      Assert (Get_Left (Child.all) = null
              and then Get_Right (Child.all) = null,
              "TreeNode.Set_Left: the child's own links should be absent");
      Release (Child);
   end Test_Set_Left;

   --  Casos: «Enlazar dos hijos» y «Recorrer cada enlace» (derecha).
   procedure Test_Set_Right (Self : in out Test) is
      pragma Unreferenced (Self);
      Parent : Tree_Node;
      Child  : Tree_Node_Access := new Tree_Node;
   begin
      Make (Parent, 10);
      Make (Child.all, 30);
      Set_Right (Parent, Child);
      Assert (Get_Right (Parent) = Child,
              "TreeNode.Set_Right should link the child");
      Assert (Get_Value (Get_Right (Parent).all) = 30,
              "TreeNode.Set_Right: the right child should hold 30");
      Assert (Get_Left (Child.all) = null
              and then Get_Right (Child.all) = null,
              "TreeNode.Set_Right: the child's own links should be absent");
      Release (Child);
   end Test_Set_Right;
end Data_Structures_Advanced_Tree_Node_Tests;
