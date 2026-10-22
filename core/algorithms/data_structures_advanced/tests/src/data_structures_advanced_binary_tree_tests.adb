with AUnit.Assertions; use AUnit.Assertions;

with Data_Structures_Advanced; use Data_Structures_Advanced;

package body Data_Structures_Advanced_Binary_Tree_Tests is
   --  Casos: «Crear con capacidad válida» y «Capacidad inválida».
   procedure Test_Make (Self : in out Test) is
      pragma Unreferenced (Self);
      Valid   : Binary_Tree;
      Invalid : Binary_Tree;
   begin
      Make (Valid, 5);
      Assert (Is_Empty (Valid), "BinaryTree.Make: a new tree is empty");
      Assert (Size (Valid) = 0, "BinaryTree.Make: a new tree has size 0");

      Make (Invalid, 0);
      Assert (Is_Empty (Invalid),
              "BinaryTree.Make: an invalid capacity is unusable");
      Assert (Size (Invalid) = 0,
              "BinaryTree.Make: an invalid capacity has size 0");

      Free (Valid);
      Free (Invalid);
   end Test_Make;

   --  Casos: «Insertar la raíz», «Duplicado con capacidad llena» y
   --  «Capacidad agotada».
   procedure Test_Insert (Self : in out Test) is
      pragma Unreferenced (Self);
      Tree    : Binary_Tree;
      Dup     : Binary_Tree;
      Full    : Binary_Tree;
      Success : Boolean;
   begin
      Make (Tree, 5);
      Insert (Tree, 50, Success);
      Assert (Success, "BinaryTree.Insert should accept the root");
      Assert (Size (Tree) = 1, "BinaryTree.Insert: size should be 1");

      Make (Dup, 1);
      Insert (Dup, 50, Success);
      Assert (Success, "BinaryTree.Insert should accept the first 50");
      Insert (Dup, 50, Success);
      Assert (Success, "BinaryTree.Insert should accept a duplicate");
      Assert (Size (Dup) = 1, "BinaryTree.Insert: the duplicate counts once");

      Make (Full, 3);
      Insert (Full, 50, Success);
      Assert (Success, "BinaryTree.Insert should accept 50");
      Insert (Full, 30, Success);
      Assert (Success, "BinaryTree.Insert should accept 30");
      Insert (Full, 70, Success);
      Assert (Success, "BinaryTree.Insert should accept 70");
      Insert (Full, 20, Success);
      Assert (not Success,
              "BinaryTree.Insert should reject an insert over capacity");
      Assert (Size (Full) = 3,
              "BinaryTree.Insert: a rejected insert keeps size at 3");

      Free (Tree);
      Free (Dup);
      Free (Full);
   end Test_Insert;

   --  Casos: «Insertar menor y mayor», «Propiedad ABB», «Valor ausente» y
   --  «Capacidad agotada» (consulta del valor rechazado).
   procedure Test_Contains (Self : in out Test) is
      pragma Unreferenced (Self);
      Tree    : Binary_Tree;
      Full    : Binary_Tree;
      Success : Boolean;
   begin
      Make (Tree, 5);
      Insert (Tree, 50, Success);
      Insert (Tree, 30, Success);
      Insert (Tree, 70, Success);
      Assert (Contains (Tree, 30), "BinaryTree.Contains should find 30");
      Assert (Contains (Tree, 70), "BinaryTree.Contains should find 70");

      Insert (Tree, 20, Success);
      Insert (Tree, 40, Success);
      Assert (Contains (Tree, 50), "BinaryTree.Contains should find 50");
      Assert (Contains (Tree, 20), "BinaryTree.Contains should find 20");
      Assert (Contains (Tree, 40), "BinaryTree.Contains should find 40");
      Assert (not Contains (Tree, 99),
              "BinaryTree.Contains should not find an absent value");

      Make (Full, 3);
      Insert (Full, 50, Success);
      Insert (Full, 30, Success);
      Insert (Full, 70, Success);
      Insert (Full, 20, Success);
      Assert (not Contains (Full, 20),
              "BinaryTree.Contains should not find a rejected value");

      Free (Tree);
      Free (Full);
   end Test_Contains;

   --  Casos: «Tamaño y vacío».
   procedure Test_Is_Empty (Self : in out Test) is
      pragma Unreferenced (Self);
      Tree    : Binary_Tree;
      Success : Boolean;
   begin
      Make (Tree, 5);
      Assert (Is_Empty (Tree), "BinaryTree.Is_Empty: a new tree is empty");
      Insert (Tree, 50, Success);
      Assert (not Is_Empty (Tree),
              "BinaryTree.Is_Empty: one insert is not empty");
      Free (Tree);
   end Test_Is_Empty;

   --  Casos: «Tamaño y vacío», «Insertar menor y mayor» y «Propiedad ABB».
   procedure Test_Size (Self : in out Test) is
      pragma Unreferenced (Self);
      Tree    : Binary_Tree;
      Big     : Binary_Tree;
      Success : Boolean;
   begin
      Make (Tree, 5);
      Assert (Size (Tree) = 0, "BinaryTree.Size: a new tree has size 0");
      Insert (Tree, 50, Success);
      Assert (Size (Tree) = 1, "BinaryTree.Size: one insert gives size 1");

      Make (Big, 5);
      Insert (Big, 50, Success);
      Insert (Big, 30, Success);
      Insert (Big, 70, Success);
      Insert (Big, 20, Success);
      Insert (Big, 40, Success);
      Assert (Size (Big) = 5, "BinaryTree.Size: five inserts give size 5");

      Free (Tree);
      Free (Big);
   end Test_Size;
end Data_Structures_Advanced_Binary_Tree_Tests;
