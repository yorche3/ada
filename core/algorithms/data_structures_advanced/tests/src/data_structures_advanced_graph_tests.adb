with AUnit.Assertions; use AUnit.Assertions;

with Data_Structures_Advanced; use Data_Structures_Advanced;

package body Data_Structures_Advanced_Graph_Tests is
   --  Casos: «Crear con capacidad válida» y «Capacidad inválida».
   procedure Test_Make (Self : in out Test) is
      pragma Unreferenced (Self);
      Valid   : Graph;
      Invalid : Graph;
   begin
      Make (Valid, 4);
      Assert (Is_Empty (Valid), "Graph.Make: a new graph is empty");
      Assert (Size (Valid) = 0, "Graph.Make: a new graph has size 0");

      Make (Invalid, 0);
      Assert (Is_Empty (Invalid),
              "Graph.Make: an invalid capacity is unusable");
      Assert (Size (Invalid) = 0,
              "Graph.Make: an invalid capacity has size 0");

      Free (Valid);
      Free (Invalid);
   end Test_Make;

   --  Casos: «Arista dirigida», «Arista duplicada», «Nodo fuera de rango» y
   --  «Capacidad inválida» (arista sobre un grafo inutilizable).
   procedure Test_Add_Edge (Self : in out Test) is
      pragma Unreferenced (Self);
      Item    : Graph;
      Dup     : Graph;
      Invalid : Graph;
      Success : Boolean;
   begin
      Make (Item, 4);
      Add_Edge (Item, 0, 1, Success);
      Assert (Success, "Graph.Add_Edge should accept 0 -> 1");
      Assert (Size (Item) = 1, "Graph.Add_Edge: size should be 1");

      Add_Edge (Item, 0, 4, Success);
      Assert (not Success,
              "Graph.Add_Edge should reject a label out of range");
      Assert (Size (Item) = 1,
              "Graph.Add_Edge: a rejected edge is not counted");

      Make (Dup, 4);
      Add_Edge (Dup, 0, 1, Success);
      Assert (Success, "Graph.Add_Edge should accept the first 0 -> 1");
      Add_Edge (Dup, 0, 1, Success);
      Assert (Success, "Graph.Add_Edge should accept a duplicate");
      Assert (Size (Dup) = 1, "Graph.Add_Edge: the duplicate counts once");

      Make (Invalid, 0);
      Add_Edge (Invalid, 0, 0, Success);
      Assert (not Success, "Graph.Add_Edge should fail on an unusable graph");
      Assert (Size (Invalid) = 0,
              "Graph.Add_Edge: an unusable graph keeps size 0");

      Free (Item);
      Free (Dup);
      Free (Invalid);
   end Test_Add_Edge;

   --  Casos: «Arista dirigida» y «Dirección inversa».
   procedure Test_Has_Edge (Self : in out Test) is
      pragma Unreferenced (Self);
      Item    : Graph;
      Success : Boolean;
   begin
      Make (Item, 4);
      Add_Edge (Item, 0, 1, Success);
      Assert (Has_Edge (Item, 0, 1), "Graph.Has_Edge should see 0 -> 1");
      Assert (not Has_Edge (Item, 1, 0),
              "Graph.Has_Edge should not see the reverse 1 -> 0");
      Free (Item);
   end Test_Has_Edge;

   --  Casos: «Vecinos en orden creciente», «Nodo sin aristas» y «Vecinos de un
   --  nodo fuera de rango».
   procedure Test_Get_Neighbors (Self : in out Test) is
      pragma Unreferenced (Self);
      Expected  : constant Neighbor_Array := (1, 2, 3);
      Item      : Graph;
      Neighbors : Neighbor_Array_Access;
      Success   : Boolean;
   begin
      Make (Item, 4);
      Add_Edge (Item, 0, 3, Success);
      Add_Edge (Item, 0, 1, Success);
      Add_Edge (Item, 0, 2, Success);
      Neighbors := Get_Neighbors (Item, 0);
      Assert (Neighbors /= null, "Graph.Get_Neighbors should succeed");
      Assert (Neighbors.all = Expected,
              "Graph.Get_Neighbors should return 1, 2, 3 in order");
      Free (Neighbors);

      Neighbors := Get_Neighbors (Item, 3);
      Assert (Neighbors /= null,
              "Graph.Get_Neighbors should succeed on a node with no edges");
      Assert (Neighbors.all'Length = 0,
              "Graph.Get_Neighbors should return an empty sequence");
      Free (Neighbors);

      Assert (Get_Neighbors (Item, 4) = null,
              "Graph.Get_Neighbors should fail on a label out of range");
      Free (Item);
   end Test_Get_Neighbors;

   --  Casos: «Contar aristas y vacío».
   procedure Test_Is_Empty (Self : in out Test) is
      pragma Unreferenced (Self);
      Item    : Graph;
      Success : Boolean;
   begin
      Make (Item, 4);
      Assert (Is_Empty (Item), "Graph.Is_Empty: a new graph is empty");
      Add_Edge (Item, 0, 1, Success);
      Add_Edge (Item, 0, 2, Success);
      Add_Edge (Item, 1, 2, Success);
      Assert (not Is_Empty (Item),
              "Graph.Is_Empty: three edges are not empty");
      Free (Item);
   end Test_Is_Empty;

   --  Casos: «Contar aristas y vacío» y «Arista duplicada».
   procedure Test_Size (Self : in out Test) is
      pragma Unreferenced (Self);
      Item    : Graph;
      Dup     : Graph;
      Success : Boolean;
   begin
      Make (Item, 4);
      Assert (Size (Item) = 0, "Graph.Size: a new graph has size 0");
      Add_Edge (Item, 0, 1, Success);
      Add_Edge (Item, 0, 2, Success);
      Add_Edge (Item, 1, 2, Success);
      Assert (Size (Item) = 3, "Graph.Size: three edges give size 3");

      Make (Dup, 4);
      Add_Edge (Dup, 0, 1, Success);
      Add_Edge (Dup, 0, 1, Success);
      Assert (Size (Dup) = 1, "Graph.Size: a duplicate counts once");

      Free (Item);
      Free (Dup);
   end Test_Size;
end Data_Structures_Advanced_Graph_Tests;
