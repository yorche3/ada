with AUnit.Assertions; use AUnit.Assertions;

with Data_Structures_Advanced; use Data_Structures_Advanced;

package body Data_Structures_Advanced_Binary_Tree_Tests is
   --  Casos: «Crear vacío».
   procedure Test_Make (Self : in out Test) is
      pragma Unreferenced (Self);
      Tree : Binary_Tree;
   begin
      Make (Tree);
      Assert (Is_Empty (Tree), "BinaryTree.Make: a new tree is empty");
      Assert (Size (Tree) = 0, "BinaryTree.Make: a new tree has size 0");
      Assert (not Contains (Tree, 50),
              "BinaryTree.Make: an empty tree does not contain 50");
      Free (Tree);
   end Test_Make;

   --  Casos: «Insertar la raíz», «Insertar menor y mayor», «Ramas de varios
   --  niveles», «Duplicado idempotente» e «Inserciones ordenadas».
   procedure Test_Insert (Self : in out Test) is
      pragma Unreferenced (Self);
      Root      : Binary_Tree;
      Branches  : Binary_Tree;
      Duplicate : Binary_Tree;
      Ordered   : Binary_Tree;
   begin
      Make (Root);
      Insert (Root, 50);
      Assert (Size (Root) = 1, "BinaryTree.Insert: the root gives size 1");
      Assert (not Is_Empty (Root),
              "BinaryTree.Insert: one value is not empty");
      Assert (Contains (Root, 50),
              "BinaryTree.Insert: the root is present");

      Make (Branches);
      Insert (Branches, 50);
      Insert (Branches, 30);
      Insert (Branches, 70);
      Assert (Size (Branches) = 3,
              "BinaryTree.Insert: three values give size 3");
      Insert (Branches, 20);
      Insert (Branches, 40);
      Assert (Size (Branches) = 5,
              "BinaryTree.Insert: five values give size 5");

      Make (Duplicate);
      Insert (Duplicate, 50);
      Insert (Duplicate, 30);
      Insert (Duplicate, 70);
      Insert (Duplicate, 30);
      Assert (Size (Duplicate) = 3,
              "BinaryTree.Insert: a duplicate does not grow size");

      Make (Ordered);
      Insert (Ordered, 20);
      Insert (Ordered, 30);
      Insert (Ordered, 40);
      Insert (Ordered, 50);
      Insert (Ordered, 70);
      Assert (Size (Ordered) = 5,
              "BinaryTree.Insert: ordered insertions give size 5");

      Free (Root);
      Free (Branches);
      Free (Duplicate);
      Free (Ordered);
   end Test_Insert;

   --  Casos: «Insertar menor y mayor», «Ramas de varios niveles», «Valor
   --  ausente en árbol no vacío» e «Inserciones ordenadas».
   procedure Test_Contains (Self : in out Test) is
      pragma Unreferenced (Self);
      Tree    : Binary_Tree;
      Present : Binary_Tree;
      Ordered : Binary_Tree;
   begin
      Make (Tree);
      Insert (Tree, 50);
      Insert (Tree, 30);
      Insert (Tree, 70);
      Assert (Contains (Tree, 30), "BinaryTree.Contains should find 30");
      Assert (Contains (Tree, 70), "BinaryTree.Contains should find 70");

      Make (Present);
      Insert (Present, 50);
      Assert (not Contains (Present, 99),
              "BinaryTree.Contains should not find an absent value");
      Assert (Contains (Present, 50),
              "BinaryTree.Contains: 50 is still present");
      Assert (Size (Present) = 1,
              "BinaryTree.Contains: a failed query does not change size");

      Make (Ordered);
      Insert (Ordered, 20);
      Insert (Ordered, 30);
      Insert (Ordered, 40);
      Insert (Ordered, 50);
      Insert (Ordered, 70);
      Assert (Contains (Ordered, 20) and then Contains (Ordered, 70),
              "BinaryTree.Contains: the extremes are present");
      Assert (not Contains (Ordered, 99),
              "BinaryTree.Contains: 99 is absent from ordered insertions");

      Free (Tree);
      Free (Present);
      Free (Ordered);
   end Test_Contains;

   --  Casos: «Crear vacío» e «Insertar la raíz».
   procedure Test_Is_Empty (Self : in out Test) is
      pragma Unreferenced (Self);
      Tree : Binary_Tree;
   begin
      Make (Tree);
      Assert (Is_Empty (Tree), "BinaryTree.Is_Empty: a new tree is empty");
      Insert (Tree, 50);
      Assert (not Is_Empty (Tree),
              "BinaryTree.Is_Empty: one insert is not empty");
      Free (Tree);
   end Test_Is_Empty;

   --  Casos: «Insertar menor y mayor», «Ramas de varios niveles» y «Duplicado
   --  idempotente».
   procedure Test_Size (Self : in out Test) is
      pragma Unreferenced (Self);
      Tree      : Binary_Tree;
      Branches  : Binary_Tree;
      Duplicate : Binary_Tree;
   begin
      Make (Tree);
      Assert (Size (Tree) = 0, "BinaryTree.Size: a new tree has size 0");
      Insert (Tree, 50);
      Assert (Size (Tree) = 1, "BinaryTree.Size: one insert gives size 1");

      Make (Branches);
      Insert (Branches, 50);
      Insert (Branches, 30);
      Insert (Branches, 70);
      Assert (Size (Branches) = 3,
              "BinaryTree.Size: three inserts give size 3");
      Insert (Branches, 20);
      Insert (Branches, 40);
      Assert (Size (Branches) = 5,
              "BinaryTree.Size: five inserts give size 5");

      Make (Duplicate);
      Insert (Duplicate, 50);
      Insert (Duplicate, 30);
      Insert (Duplicate, 70);
      Insert (Duplicate, 30);
      Assert (Size (Duplicate) = 3,
              "BinaryTree.Size: a duplicate does not grow size");

      Free (Tree);
      Free (Branches);
      Free (Duplicate);
   end Test_Size;
end Data_Structures_Advanced_Binary_Tree_Tests;
