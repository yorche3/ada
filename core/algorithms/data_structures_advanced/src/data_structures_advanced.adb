with Ada.Unchecked_Deallocation;

--  Contrato en esqueletos: toda operación devuelve el valor centinela. Las
--  únicas implementaciones reales son las cuatro `Free`, que liberan lo que
--  reservan las representaciones.
package body Data_Structures_Advanced is

   function Get_Value (Item : Node) return Integer is
   begin
      return Item.Value;
   end Get_Value;

   procedure Make (New_Node : out Tree_Node; Value : Integer) is
   begin
      New_Node.Value := Value;
      New_Node.Left := null;
      New_Node.Right := null;
   end Make;

   overriding
   function Get_Value (Item : Tree_Node) return Integer is
   begin
      return Item.Value;
   end Get_Value;

   function Get_Left (Item : Tree_Node) return Tree_Node_Access is
   begin
      return Item.Left;
   end Get_Left;

   function Get_Right (Item : Tree_Node) return Tree_Node_Access is
   begin
      return Item.Right;
   end Get_Right;

   procedure Set_Left
     (Item : in out Tree_Node; Left : Tree_Node_Access) is
   begin
      Item.Left := Left;
   end Set_Left;

   procedure Set_Right
     (Item : in out Tree_Node; Right : Tree_Node_Access) is
   begin
      Item.Right := Right;
   end Set_Right;

   procedure Make (New_Tree : out Binary_Tree) is
   begin
      New_Tree := (Root => null, Count => 0);
   end Make;

   procedure Insert (Tree : in out Binary_Tree; Value : Integer) is
      --  Uso de la función `New_Leaf` para crear nuevos nodos hoja.
      --  Reserva e inicialización en una sola expresión: el nodo nunca existe
      --  con hijos indefinidos, así que liberarlo siempre recorre `null` y no
      --  punteros basura. Centraliza las tres llamadas de `Insert`.
      function New_Leaf return Tree_Node_Access is
      begin
         return new Tree_Node'(Value => Value, others => null);
      end New_Leaf;

      Current : Tree_Node_Access;
   begin
      if Tree.Root = null then
         Tree.Root := New_Leaf;
         Tree.Count := 1;
         return;
      end if;
      Current := Tree.Root;
      loop
         if Value = Current.Value then
            return;
         elsif Value < Current.Value then
            if Current.Left = null then
               Current.Left := New_Leaf;
               Tree.Count := Tree.Count + 1;
               exit;
            else
               Current := Current.Left;
            end if;
         else
            if Current.Right = null then
               Current.Right := New_Leaf;
               Tree.Count := Tree.Count + 1;
               exit;
            else
               Current := Current.Right;
            end if;
         end if;
      end loop;
   end Insert;

   function Contains (Tree : Binary_Tree; Value : Integer) return Boolean is
      --  Se inicia el recorrido desde la raiz no importa si es nulo
      Current : Tree_Node_Access := Tree.Root;
   begin
      while Current /= null loop
         if Value = Current.Value then
            return True;
         elsif Value < Current.Value then
            Current := Current.Left;
         else
            Current := Current.Right;
         end if;
      end loop;
      return False;
   end Contains;

   function Is_Empty (Tree : Binary_Tree) return Boolean is
   begin
      return Tree.Count = 0;
   end Is_Empty;

   function Size (Tree : Binary_Tree) return Natural is
   begin
      return Tree.Count;
   end Size;

   procedure Make (New_Graph : out Graph) is
   begin
      New_Graph := (others => <>);
   end Make;

   function Find_Vertex (Item : Graph; Label : Integer) 
      return Graph_Node_Access
   is
      Current : Graph_Node_Access := Item.Registry;
   begin
      while Current /= null loop
         if Current.Value = Label then
            return Current;
         end if;
         Current := Current.Next_Vertex;
      end loop;
      return null;
   end Find_Vertex;

   procedure Add_Vertex (Item : in out Graph; Label : Integer) is
   begin
      if Find_Vertex (Item, Label) /= null then
         return;
      end if;
      declare
         New_Node : constant Graph_Node_Access := 
            new Graph_Node'(Value => Label, 
                            Next_Vertex => Item.Registry, 
                            others => <>);
      begin
         Item.Registry := New_Node;
         Item.Vertices := Item.Vertices + 1;
      end;
   end Add_Vertex;

   procedure Add_Edge
     (Item : in out Graph; U, V : Integer; Success : out Boolean)
   is
      Source : Graph_Node_Access := Find_Vertex (Item, U);
      Target : Graph_Node_Access := Find_Vertex (Item, V);
      Previous : Neighbor_Node_Access := null;
      Current  : Neighbor_Node_Access;
   begin
      if Source = null or else Target = null then
         Success := False;
         return;
      end if;
      --  La adyacencia se mantiene ordenada por etiqueta: se avanza mientras
      --  la etiqueta actual sea menor, y el nodo nuevo se inserta delante del
      --  primero que ya no lo es. Así el recorrido da orden creciente y un
      --  duplicado se detecta en el mismo paso.
      Current := Source.Neighbors;
      while Current /= null and then Current.Label < V loop
         Previous := Current;
         Current := Current.Next;
      end loop;
      if Current /= null and then Current.Label = V then
         Success := True;
         return;
      end if;
      declare
         New_Neighbor : Neighbor_Node_Access := 
            new Neighbor_Node'(Label => V, Next => Current, others => <>);
      begin
         if Previous = null then
            Source.Neighbors := New_Neighbor;
         else
            Previous.Next := New_Neighbor;
         end if;
         Item.Edges := Item.Edges + 1;
         Success := True;
      end;
   end Add_Edge;

   function Has_Edge (Item : Graph; U, V : Integer) return Boolean is
      Source : constant Graph_Node_Access := Find_Vertex (Item, U);
      Target : constant Graph_Node_Access := Find_Vertex (Item, V);
      Current : Neighbor_Node_Access := null;
   begin
      if Source = null or else Target = null then
         return False;
      end if;
      Current := Source.Neighbors;
      while Current /= null and then Current.Label /= V loop
         Current := Current.Next;
      end loop;
      return Current /= null and then Current.Label = V;
   end Has_Edge;

   function Get_Neighbors
     (Item : Graph; U : Integer) return Neighbor_Array_Access
   is
      Source : constant Graph_Node_Access := Find_Vertex (Item, U);
      Current : Neighbor_Node_Access := null;
      Count : Natural := 0;
   begin
      if Source = null then
         return null;
      end if;
      --  Contar el número de vecinos para dimensionar el arreglo.
      Current := Source.Neighbors;
      while Current /= null loop
         Count := Count + 1;
         Current := Current.Next;
      end loop;
      --  Crear el arreglo de vecinos y llenarlo.
      declare
         Result : Neighbor_Array_Access := new Neighbor_Array (1 .. Count);
         Cursor : Neighbor_Node_Access := Source.Neighbors;
      begin
         for Index in 1 .. Count loop
            Result (Index) := Cursor.Label;
            Cursor := Cursor.Next;
         end loop;
         return Result;
      end;
   end Get_Neighbors;

   function Is_Empty (Item : Graph) return Boolean is
   begin
      return Item.Vertices = 0;
   end Is_Empty;

   function Vertex_Count (Item : Graph) return Natural is
   begin
      return Item.Vertices;
   end Vertex_Count;

   function Edge_Count (Item : Graph) return Natural is
   begin
      return Item.Edges;
   end Edge_Count;

   --  Liberación del nodo suelto que reservó el cliente.
   procedure Free (Item : in out Tree_Node_Access) is
      procedure Free_Access is
         new Ada.Unchecked_Deallocation (Tree_Node, Tree_Node_Access);
   begin
      Free_Access (Item);
   end Free;

   --  Liberación del árbol completo: post-orden desde la raíz.
   procedure Free (Tree : in out Binary_Tree) is
      procedure Free_Access is
         new Ada.Unchecked_Deallocation (Tree_Node, Tree_Node_Access);

      procedure Free_Nodes (Node : in out Tree_Node_Access) is
      begin
         if Node /= null then
            Free_Nodes (Node.Left);
            Free_Nodes (Node.Right);
            Free_Access (Node);
         end if;
      end Free_Nodes;
   begin
      Free_Nodes (Tree.Root);
      Tree := (others => <>);
   end Free;

   --  Liberación del grafo: por cada vértice del registro, su adyacencia y el
   --  vértice; después el registro queda vacío.
   procedure Free (Item : in out Graph) is
      procedure Free_Neighbor is
         new Ada.Unchecked_Deallocation
               (Neighbor_Node, Neighbor_Node_Access);
      procedure Free_Vertex is
         new Ada.Unchecked_Deallocation (Graph_Node, Graph_Node_Access);

      procedure Free_Neighbors (Head : in out Neighbor_Node_Access) is
         Next : Neighbor_Node_Access;
      begin
         while Head /= null loop
            Next := Head.Next;
            Free_Neighbor (Head);
            Head := Next;
         end loop;
      end Free_Neighbors;

      Current : Graph_Node_Access := Item.Registry;
      Next    : Graph_Node_Access;
   begin
      while Current /= null loop
         Next := Current.Next_Vertex;
         Free_Neighbors (Current.Neighbors);
         Free_Vertex (Current);
         Current := Next;
      end loop;
      Item := (others => <>);
   end Free;

   --  Liberación de la copia de vecinos que devuelve `Get_Neighbors`.
   procedure Free (Neighbors : in out Neighbor_Array_Access) is
      procedure Free_Array is
         new Ada.Unchecked_Deallocation
               (Neighbor_Array, Neighbor_Array_Access);
   begin
      Free_Array (Neighbors);
   end Free;
end Data_Structures_Advanced;
