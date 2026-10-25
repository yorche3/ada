with Ada.Unchecked_Deallocation;

--  Contrato en esqueletos: toda operación devuelve el valor centinela. Las
--  únicas implementaciones reales son las cuatro `Free`, que liberan lo que
--  reservan las representaciones.
package body Data_Structures_Advanced is

   function Get_Value (Item : Node) return Integer is
      pragma Unreferenced (Item);
   begin
      return 0;
   end Get_Value;

   procedure Make (New_Node : out Tree_Node; Value : Integer) is
      pragma Unreferenced (Value);
   begin
      New_Node.Value := 0;
      New_Node.Left := null;
      New_Node.Right := null;
   end Make;

   overriding
   function Get_Value (Item : Tree_Node) return Integer is
      pragma Unreferenced (Item);
   begin
      return 0;
   end Get_Value;

   function Get_Left (Item : Tree_Node) return Tree_Node_Access is
      pragma Unreferenced (Item);
   begin
      return null;
   end Get_Left;

   function Get_Right (Item : Tree_Node) return Tree_Node_Access is
      pragma Unreferenced (Item);
   begin
      return null;
   end Get_Right;

   procedure Set_Left
     (Item : in out Tree_Node; Left : Tree_Node_Access)
   is
      pragma Unreferenced (Item, Left);
   begin
      null;
   end Set_Left;

   procedure Set_Right
     (Item : in out Tree_Node; Right : Tree_Node_Access)
   is
      pragma Unreferenced (Item, Right);
   begin
      null;
   end Set_Right;

   procedure Make (New_Tree : out Binary_Tree) is
   begin
      New_Tree := (others => <>);
   end Make;

   procedure Insert (Tree : in out Binary_Tree; Value : Integer) is
      pragma Unreferenced (Tree, Value);
   begin
      null;
   end Insert;

   function Contains (Tree : Binary_Tree; Value : Integer) return Boolean is
      pragma Unreferenced (Tree, Value);
   begin
      return False;
   end Contains;

   function Is_Empty (Tree : Binary_Tree) return Boolean is
      pragma Unreferenced (Tree);
   begin
      return True;
   end Is_Empty;

   function Size (Tree : Binary_Tree) return Natural is
      pragma Unreferenced (Tree);
   begin
      return 0;
   end Size;

   procedure Make (New_Graph : out Graph) is
   begin
      New_Graph := (others => <>);
   end Make;

   procedure Add_Vertex (Item : in out Graph; Label : Integer) is
      pragma Unreferenced (Item, Label);
   begin
      null;
   end Add_Vertex;

   procedure Add_Edge
     (Item : in out Graph; U, V : Integer; Success : out Boolean)
   is
      pragma Unreferenced (Item, U, V);
   begin
      Success := False;
   end Add_Edge;

   function Has_Edge (Item : Graph; U, V : Integer) return Boolean is
      pragma Unreferenced (Item, U, V);
   begin
      return False;
   end Has_Edge;

   function Get_Neighbors
     (Item : Graph; U : Integer) return Neighbor_Array_Access
   is
      pragma Unreferenced (Item, U);
   begin
      return null;
   end Get_Neighbors;

   function Is_Empty (Item : Graph) return Boolean is
      pragma Unreferenced (Item);
   begin
      return True;
   end Is_Empty;

   function Vertex_Count (Item : Graph) return Natural is
      pragma Unreferenced (Item);
   begin
      return 0;
   end Vertex_Count;

   function Edge_Count (Item : Graph) return Natural is
      pragma Unreferenced (Item);
   begin
      return 0;
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
