package Data_Structures_Advanced is
   --  Base del módulo: **solo** el valor. Sin enlaces, sin validaciones y sin
   --  instancias propias; los hijos la reutilizan por herencia y validan sus
   --  enlaces.
   type Node is abstract tagged private;

   function Get_Value (Item : Node) return Integer;

   type Tree_Node is tagged;
   type Tree_Node_Access is access all Tree_Node;
   type Tree_Node is new Node with private;

   procedure Make (New_Node : out Tree_Node; Value : Integer);
   overriding
   function Get_Value (Item : Tree_Node) return Integer;
   function Get_Left (Item : Tree_Node) return Tree_Node_Access;
   function Get_Right (Item : Tree_Node) return Tree_Node_Access;
   procedure Set_Left
     (Item : in out Tree_Node; Left : Tree_Node_Access);
   procedure Set_Right
     (Item : in out Tree_Node; Right : Tree_Node_Access);

   --  ABB sin capacidad contractual: `Make` deja un árbol vacío utilizable.
   type Binary_Tree is private;

   procedure Make (New_Tree : out Binary_Tree);
   procedure Insert (Tree : in out Binary_Tree; Value : Integer);
   function Contains (Tree : Binary_Tree; Value : Integer) return Boolean;
   function Is_Empty (Tree : Binary_Tree) return Boolean;
   function Size (Tree : Binary_Tree) return Natural;

   --  `null` es el fallo de una consulta a un vértice inexistente; un vértice
   --  aislado devuelve una secuencia vacía, no `null`. El primer vecino ocupa
   --  el índice 1: el índice es `Positive`, no `Natural`, para que un agregado
   --  posicional (`(30, 50)`) tenga el mismo rango que la copia que devuelve
   --  `Get_Neighbors` (`new Neighbor_Array (1 .. 2)`).
   type Neighbor_Array is array (Positive range <>) of Integer;
   type Neighbor_Array_Access is access Neighbor_Array;

   type Graph is private;

   procedure Make (New_Graph : out Graph);
   procedure Add_Vertex (Item : in out Graph; Label : Integer);
   procedure Add_Edge
     (Item : in out Graph; U, V : Integer; Success : out Boolean);
   function Has_Edge (Item : Graph; U, V : Integer) return Boolean;
   function Get_Neighbors
     (Item : Graph; U : Integer) return Neighbor_Array_Access;
   function Is_Empty (Item : Graph) return Boolean;
   function Vertex_Count (Item : Graph) return Natural;
   function Edge_Count (Item : Graph) return Natural;

   --  Un nodo enlazado en un árbol es del árbol: lo libera `Free (Tree)`.
   --  Este `Free` es para el nodo suelto que el cliente reserva y enlaza él.
   procedure Free (Item : in out Tree_Node_Access);

   procedure Free (Tree : in out Binary_Tree);
   procedure Free (Item : in out Graph);
   procedure Free (Neighbors : in out Neighbor_Array_Access);

private
   type Node is abstract tagged record
      Value : Integer := 0;
   end record;

   type Tree_Node is new Node with record
      Left  : Tree_Node_Access := null;
      Right : Tree_Node_Access := null;
   end record;

   type Binary_Tree is record
      Root  : Tree_Node_Access := null;
      Count : Natural := 0;
   end record;

   type Neighbor_Node;
   type Neighbor_Node_Access is access Neighbor_Node;
   type Neighbor_Node is record
      Label : Integer := 0;
      Next  : Neighbor_Node_Access := null;
   end record;

   --  Vértice del registro canónico: la etiqueta es heredada, la adyacencia es
   --  propia y `Next_Vertex` enlaza el registro. Sin índices ni capacidad.
   type Graph_Node;
   type Graph_Node_Access is access Graph_Node;
   type Graph_Node is new Node with record
      Neighbors   : Neighbor_Node_Access := null;
      Next_Vertex : Graph_Node_Access := null;
   end record;

   type Graph is record
      Registry : Graph_Node_Access := null;
      Vertices : Natural := 0;
      Edges    : Natural := 0;
   end record;
end Data_Structures_Advanced;
