with AUnit.Assertions; use AUnit.Assertions;

with Data_Structures_Advanced; use Data_Structures_Advanced;

package body Data_Structures_Advanced_Graph_Tests is
   --  Casos: «Crear vacío».
   procedure Test_Make (Self : in out Test) is
      pragma Unreferenced (Self);
      Item : Graph;
   begin
      Make (Item);
      Assert (Is_Empty (Item), "Graph.Make: a new graph is empty");
      Assert (Vertex_Count (Item) = 0, "Graph.Make: no vertices");
      Assert (Edge_Count (Item) = 0, "Graph.Make: no edges");
      Assert (not Has_Edge (Item, 10, 30),
              "Graph.Make: has_edge fails on an empty graph");
      Assert (Get_Neighbors (Item, 10) = null,
              "Graph.Make: get_neighbors fails on a missing vertex");
      Free (Item);
   end Test_Make;

   --  Casos: «Vértice aislado» y «Vértice duplicado conserva adyacencia».
   procedure Test_Add_Vertex (Self : in out Test) is
      pragma Unreferenced (Self);
      Item      : Graph;
      Neighbors : Neighbor_Array_Access;
      Success   : Boolean;
   begin
      Make (Item);
      Add_Vertex (Item, 10);
      Assert (not Is_Empty (Item),
              "Graph.Add_Vertex: one vertex is not empty");
      Assert (Vertex_Count (Item) = 1, "Graph.Add_Vertex: one vertex");
      Assert (Edge_Count (Item) = 0, "Graph.Add_Vertex: no edges yet");
      Neighbors := Get_Neighbors (Item, 10);
      Assert (Neighbors /= null,
              "Graph.Add_Vertex: an isolated vertex has empty neighbours");
      Assert (Neighbors.all'Length = 0,
              "Graph.Add_Vertex: the isolated neighbour list is empty");
      Free (Neighbors);

      Add_Vertex (Item, 30);
      Add_Edge (Item, 10, 30, Success);
      Add_Vertex (Item, 10);
      Assert (Vertex_Count (Item) = 2,
              "Graph.Add_Vertex: a duplicate vertex is not counted twice");
      Assert (Edge_Count (Item) = 1,
              "Graph.Add_Vertex: a duplicate vertex keeps the edge");
      Neighbors := Get_Neighbors (Item, 10);
      Assert (Neighbors /= null and then Neighbors.all = (1 => 30),
              "Graph.Add_Vertex: a duplicate vertex keeps adjacency");
      Free (Neighbors);
      Free (Item);
   end Test_Add_Vertex;

   --  Casos: «Etiquetas no consecutivas y arista dirigida», «Arista
   --  duplicada», «Extremo inexistente sin mutación» y «Bucle y duplicado».
   procedure Test_Add_Edge (Self : in out Test) is
      pragma Unreferenced (Self);
      Directed  : Graph;
      Duplicate : Graph;
      Missing   : Graph;
      Loop_Item : Graph;
      Neighbors : Neighbor_Array_Access;
      Success   : Boolean;
   begin
      Make (Directed);
      Add_Vertex (Directed, 10);
      Add_Vertex (Directed, 70);
      Add_Edge (Directed, 10, 70, Success);
      Assert (Success, "Graph.Add_Edge should accept 10 -> 70");
      Assert (Has_Edge (Directed, 10, 70),
              "Graph.Add_Edge: the forward edge is present");
      Assert (not Has_Edge (Directed, 70, 10),
              "Graph.Add_Edge: the reverse edge is absent");
      Assert (Vertex_Count (Directed) = 2 and then Edge_Count (Directed) = 1,
              "Graph.Add_Edge: two vertices and one edge");

      Make (Duplicate);
      Add_Vertex (Duplicate, 10);
      Add_Vertex (Duplicate, 30);
      Add_Edge (Duplicate, 10, 30, Success);
      Assert (Success, "Graph.Add_Edge should accept the first 10 -> 30");
      Add_Edge (Duplicate, 10, 30, Success);
      Assert (Success, "Graph.Add_Edge should accept a duplicate edge");
      Assert (Edge_Count (Duplicate) = 1,
              "Graph.Add_Edge: a duplicate edge counts once");
      Neighbors := Get_Neighbors (Duplicate, 10);
      Assert (Neighbors /= null and then Neighbors.all = (1 => 30),
              "Graph.Add_Edge: the duplicate leaves neighbours at 30");
      Free (Neighbors);

      Make (Missing);
      Add_Vertex (Missing, 10);
      Add_Vertex (Missing, 30);
      Add_Edge (Missing, 10, 30, Success);
      Add_Edge (Missing, 10, 99, Success);
      Assert (not Success, "Graph.Add_Edge should reject 10 -> 99");
      Add_Edge (Missing, 99, 10, Success);
      Assert (not Success, "Graph.Add_Edge should reject 99 -> 10");
      Add_Edge (Missing, 98, 99, Success);
      Assert (not Success, "Graph.Add_Edge should reject 98 -> 99");
      Add_Edge (Missing, 99, 99, Success);
      Assert (not Success, "Graph.Add_Edge should reject the loop 99 -> 99");
      Assert (Vertex_Count (Missing) = 2 and then Edge_Count (Missing) = 1,
              "Graph.Add_Edge: four failures leave the counts unchanged");
      Neighbors := Get_Neighbors (Missing, 10);
      Assert (Neighbors /= null and then Neighbors.all = (1 => 30),
              "Graph.Add_Edge: a failure keeps the original adjacency");
      Free (Neighbors);
      Neighbors := Get_Neighbors (Missing, 30);
      Assert (Neighbors /= null and then Neighbors.all'Length = 0,
              "Graph.Add_Edge: vertex 30 has no neighbours");
      Free (Neighbors);
      Assert (not Has_Edge (Missing, 10, 99),
              "Graph.Add_Edge: an attempted edge stays absent");

      Make (Loop_Item);
      Add_Vertex (Loop_Item, 10);
      Add_Edge (Loop_Item, 10, 10, Success);
      Assert (Success, "Graph.Add_Edge should accept the loop 10 -> 10");
      Add_Edge (Loop_Item, 10, 10, Success);
      Assert (Success, "Graph.Add_Edge should accept a duplicate loop");
      Assert (Has_Edge (Loop_Item, 10, 10),
              "Graph.Add_Edge: the loop is present");
      Neighbors := Get_Neighbors (Loop_Item, 10);
      Assert (Neighbors /= null and then Neighbors.all = (1 => 10),
              "Graph.Add_Edge: the loop is the only neighbour");
      Free (Neighbors);
      Assert (Vertex_Count (Loop_Item) = 1
              and then Edge_Count (Loop_Item) = 1,
              "Graph.Add_Edge: a loop counts as one edge");

      Free (Directed);
      Free (Duplicate);
      Free (Missing);
      Free (Loop_Item);
   end Test_Add_Edge;

   --  Casos: «Etiquetas no consecutivas y arista dirigida», «Consulta de
   --  arista ausente» y «Bucle y duplicado».
   procedure Test_Has_Edge (Self : in out Test) is
      pragma Unreferenced (Self);
      Item  : Graph;
      Loop_Item : Graph;
      Success   : Boolean;
   begin
      Make (Item);
      Add_Vertex (Item, 10);
      Add_Vertex (Item, 30);
      Assert (not Has_Edge (Item, 10, 30),
              "Graph.Has_Edge: a missing edge is absent");
      Assert (Vertex_Count (Item) = 2 and then Edge_Count (Item) = 0,
              "Graph.Has_Edge: the query does not create anything");
      Assert (not Is_Empty (Item),
              "Graph.Has_Edge: two vertices are not empty");

      Make (Loop_Item);
      Add_Vertex (Loop_Item, 10);
      Add_Edge (Loop_Item, 10, 10, Success);
      Assert (Has_Edge (Loop_Item, 10, 10),
              "Graph.Has_Edge: the loop is present");

      Free (Item);
      Free (Loop_Item);
   end Test_Has_Edge;

   --  Casos: «Vértice aislado», «Vecinos ordenados y contadores», «Vecinos de
   --  vértice inexistente» y «Aislamiento del resultado de vecinos».
   procedure Test_Get_Neighbors (Self : in out Test) is
      pragma Unreferenced (Self);
      Item     : Graph;
      Sorted   : Graph;
      Saved    : Neighbor_Array_Access;
      Other    : Neighbor_Array_Access;
      Neighbors : Neighbor_Array_Access;
      Success  : Boolean;
   begin
      Make (Item);
      Add_Vertex (Item, 10);
      Add_Vertex (Item, 30);
      Add_Vertex (Item, 50);
      Add_Edge (Item, 10, 30, Success);
      Neighbors := Get_Neighbors (Item, 10);
      Assert (Neighbors /= null and then Neighbors.all = (1 => 30),
              "Graph.Get_Neighbors: the saved result starts at 30");
      Free (Neighbors);

      Saved := Get_Neighbors (Item, 10);
      Other := Get_Neighbors (Item, 10);
      Assert (Other /= null, "Graph.Get_Neighbors: the second copy exists");
      Other.all (Other.all'First) := 999;
      Assert (not Has_Edge (Item, 10, 999),
              "Graph.Get_Neighbors: changing a copy leaves the graph");
      Add_Edge (Item, 10, 50, Success);
      Assert (Saved /= null and then Saved.all = (1 => 30),
              "Graph.Get_Neighbors: the saved result is unchanged");
      Neighbors := Get_Neighbors (Item, 10);
      Assert (Neighbors /= null and then Neighbors.all = (30, 50),
              "Graph.Get_Neighbors: a fresh query sees 30 and 50");
      Free (Neighbors);
      Free (Saved);
      Free (Other);

      Make (Sorted);
      Add_Vertex (Sorted, 10);
      Add_Vertex (Sorted, 30);
      Add_Vertex (Sorted, 50);
      Add_Vertex (Sorted, 70);
      Add_Edge (Sorted, 10, 70, Success);
      Add_Edge (Sorted, 10, 30, Success);
      Add_Edge (Sorted, 10, 50, Success);
      Add_Edge (Sorted, 30, 50, Success);
      Neighbors := Get_Neighbors (Sorted, 10);
      Assert (Neighbors /= null and then Neighbors.all = (30, 50, 70),
              "Graph.Get_Neighbors: 10 keeps 30, 50, 70 in order");
      Free (Neighbors);
      Neighbors := Get_Neighbors (Sorted, 30);
      Assert (Neighbors /= null and then Neighbors.all = (1 => 50),
              "Graph.Get_Neighbors: 30 keeps 50");
      Free (Neighbors);
      Neighbors := Get_Neighbors (Sorted, 50);
      Assert (Neighbors /= null and then Neighbors.all'Length = 0,
              "Graph.Get_Neighbors: 50 has no neighbours");
      Free (Neighbors);

      Assert (Get_Neighbors (Item, 99) = null,
              "Graph.Get_Neighbors: a missing vertex fails, not empty");

      Free (Item);
      Free (Sorted);
   end Test_Get_Neighbors;

   --  Casos: «Crear vacío» y «Vértice aislado».
   procedure Test_Is_Empty (Self : in out Test) is
      pragma Unreferenced (Self);
      Item : Graph;
   begin
      Make (Item);
      Assert (Is_Empty (Item), "Graph.Is_Empty: a new graph is empty");
      Add_Vertex (Item, 10);
      Assert (not Is_Empty (Item),
              "Graph.Is_Empty: one vertex is not empty");
      Free (Item);
   end Test_Is_Empty;

   --  Casos: «Vértice aislado», «Vértice duplicado conserva adyacencia» y
   --  «Vecinos ordenados y contadores».
   procedure Test_Vertex_Count (Self : in out Test) is
      pragma Unreferenced (Self);
      Item   : Graph;
      Sorted : Graph;
      Success : Boolean;
   begin
      Make (Item);
      Assert (Vertex_Count (Item) = 0,
              "Graph.Vertex_Count: a new graph has no vertices");
      Add_Vertex (Item, 10);
      Assert (Vertex_Count (Item) = 1,
              "Graph.Vertex_Count: one vertex is counted once");
      Add_Vertex (Item, 30);
      Add_Edge (Item, 10, 30, Success);
      Add_Vertex (Item, 10);
      Assert (Vertex_Count (Item) = 2,
              "Graph.Vertex_Count: a duplicate vertex is not counted twice");

      Make (Sorted);
      Add_Vertex (Sorted, 10);
      Add_Vertex (Sorted, 30);
      Add_Vertex (Sorted, 50);
      Add_Vertex (Sorted, 70);
      Assert (Vertex_Count (Sorted) = 4,
              "Graph.Vertex_Count: four labels give four vertices");

      Free (Item);
      Free (Sorted);
   end Test_Vertex_Count;

   --  Casos: «Vecinos ordenados y contadores», «Arista duplicada» y «Bucle y
   --  duplicado».
   procedure Test_Edge_Count (Self : in out Test) is
      pragma Unreferenced (Self);
      Item   : Graph;
      Sorted : Graph;
      Loop_Item : Graph;
      Success : Boolean;
   begin
      Make (Item);
      Assert (Edge_Count (Item) = 0,
              "Graph.Edge_Count: a new graph has no edges");
      Add_Vertex (Item, 10);
      Add_Vertex (Item, 30);
      Add_Edge (Item, 10, 30, Success);
      Assert (Edge_Count (Item) = 1,
              "Graph.Edge_Count: one edge is counted once");
      Add_Edge (Item, 10, 30, Success);
      Assert (Edge_Count (Item) = 1,
              "Graph.Edge_Count: a duplicate edge counts once");

      Make (Sorted);
      Add_Vertex (Sorted, 10);
      Add_Vertex (Sorted, 30);
      Add_Vertex (Sorted, 50);
      Add_Vertex (Sorted, 70);
      Add_Edge (Sorted, 10, 70, Success);
      Add_Edge (Sorted, 10, 30, Success);
      Add_Edge (Sorted, 10, 50, Success);
      Add_Edge (Sorted, 30, 50, Success);
      Assert (Edge_Count (Sorted) = 4,
              "Graph.Edge_Count: four edges give four");

      Make (Loop_Item);
      Add_Vertex (Loop_Item, 10);
      Add_Edge (Loop_Item, 10, 10, Success);
      Add_Edge (Loop_Item, 10, 10, Success);
      Assert (Edge_Count (Loop_Item) = 1,
              "Graph.Edge_Count: a loop counts as one edge");

      Free (Item);
      Free (Sorted);
      Free (Loop_Item);
   end Test_Edge_Count;
end Data_Structures_Advanced_Graph_Tests;
