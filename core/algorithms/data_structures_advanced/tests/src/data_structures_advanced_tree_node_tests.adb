with AUnit.Assertions; use AUnit.Assertions;

with Data_Structures_Advanced; use Data_Structures_Advanced;

package body Data_Structures_Advanced_Tree_Node_Tests is
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

   --  Casos: «Enlazar dos hijos», «Recorrer cada enlace» y «Desenlazar hijos».
   procedure Test_Set_Left (Self : in out Test) is
      pragma Unreferenced (Self);
      Parent : Tree_Node;
      Left   : Tree_Node_Access := new Tree_Node;
      Right  : Tree_Node_Access := new Tree_Node;
   begin
      Make (Parent, 10);
      Make (Left.all, 20);
      Make (Right.all, 30);
      Set_Left (Parent, Left);
      Set_Right (Parent, Right);
      Assert (Get_Left (Parent) = Left,
              "TreeNode.Set_Left should link the child");
      Assert (Get_Left (Parent) /= null,
              "TreeNode.Set_Left: the left link should be present");
      Assert (Get_Value (Get_Left (Parent).all) = 20,
              "TreeNode.Set_Left: the left child should hold 20");
      Assert (Get_Left (Left.all) = null
              and then Get_Right (Left.all) = null,
              "TreeNode.Set_Left: the child's own links should be absent");

      Set_Left (Parent, null);
      Assert (Get_Left (Parent) = null,
              "TreeNode.Set_Left: clearing leaves no left link");
      Assert (Get_Value (Parent) = 10,
              "TreeNode.Set_Left: clearing keeps the parent value");
      Assert (Get_Right (Parent) /= null,
              "TreeNode.Set_Left: clearing keeps the right link");
      Assert (Get_Value (Get_Right (Parent).all) = 30,
              "TreeNode.Set_Left: clearing keeps the right child");

      Set_Right (Parent, null);
      Assert (Get_Left (Parent) = null and then Get_Right (Parent) = null,
              "TreeNode.Set_Left: both links are absent after clearing");
      Assert (Get_Value (Parent) = 10,
              "TreeNode.Set_Left: the parent value survives clearing");

      Free (Left);
      Free (Right);
   end Test_Set_Left;

   --  Casos: «Enlazar dos hijos», «Recorrer cada enlace» y «Desenlazar hijos».
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
      Assert (Get_Right (Parent) /= null,
              "TreeNode.Set_Right: the right link should be present");
      Assert (Get_Value (Get_Right (Parent).all) = 30,
              "TreeNode.Set_Right: the right child should hold 30");
      Assert (Get_Left (Child.all) = null
              and then Get_Right (Child.all) = null,
              "TreeNode.Set_Right: the child's own links should be absent");

      Set_Right (Parent, null);
      Assert (Get_Right (Parent) = null,
              "TreeNode.Set_Right: clearing leaves no right link");
      Assert (Get_Value (Parent) = 10,
              "TreeNode.Set_Right: clearing keeps the parent value");

      Free (Child);
   end Test_Set_Right;
end Data_Structures_Advanced_Tree_Node_Tests;
