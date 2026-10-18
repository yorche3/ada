package Data_Structures_Advanced is
   type Node is abstract tagged private;

   procedure Make (New_Node : out Node; Value : Integer);
   function Get_Value (Item : Node) return Integer;

   type Tree_Node is tagged;
   type Tree_Node_Access is access all Tree_Node;
   type Tree_Node is new Node with private;

   overriding
   procedure Make (New_Node : out Tree_Node; Value : Integer);
   overriding
   function Get_Value (Item : Tree_Node) return Integer;
   function Get_Left (Item : Tree_Node) return Tree_Node_Access;
   function Get_Right (Item : Tree_Node) return Tree_Node_Access;
   procedure Set_Left
     (Item : in out Tree_Node; Left : Tree_Node_Access);
   procedure Set_Right
     (Item : in out Tree_Node; Right : Tree_Node_Access);

   type Binary_Tree is private;

   procedure Make (New_Tree : out Binary_Tree; Capacity : Integer);
   procedure Insert
     (Tree : in out Binary_Tree; Value : Integer; Success : out Boolean);
   function Contains (Tree : Binary_Tree; Value : Integer) return Boolean;
   function Is_Empty (Tree : Binary_Tree) return Boolean;
   function Size (Tree : Binary_Tree) return Natural;

   type Neighbor_Array is array (Natural range <>) of Natural;
   --  Null means failure; a successful empty copy has a null array range.
   type Neighbor_Array_Access is access Neighbor_Array;

   type Graph is private;

   procedure Make (New_Graph : out Graph; Capacity : Integer);
   procedure Add_Edge
     (Item : in out Graph; U, V : Integer; Success : out Boolean);
   function Has_Edge (Item : Graph; U, V : Integer) return Boolean;
   function Get_Neighbors
     (Item : Graph; U : Integer) return Neighbor_Array_Access;
   function Is_Empty (Item : Graph) return Boolean;
   function Size (Item : Graph) return Natural;

   procedure Free (Tree : in out Binary_Tree);
   procedure Free (Item : in out Graph);

private
   type Node is abstract tagged record
      Value : Integer := 0;
   end record;

   type Tree_Node is new Node with record
      Left  : Tree_Node_Access := null;
      Right : Tree_Node_Access := null;
   end record;

   type Binary_Tree is record
      Root     : Tree_Node_Access := null;
      Count    : Natural := 0;
      Capacity : Natural := 0;
      Usable   : Boolean := False;
   end record;

   type Neighbor_Node;
   type Neighbor_Node_Access is access Neighbor_Node;
   type Neighbor_Node is record
      Label : Natural := 0;
      Next  : Neighbor_Node_Access := null;
   end record;

   type Graph_Node is new Node with record
      Neighbors : Neighbor_Node_Access := null;
   end record;

   overriding
   procedure Make (New_Node : out Graph_Node; Value : Integer);

   type Graph_Node_Access is access all Graph_Node;
   type Graph_Node_Array is array (Natural range <>) of Graph_Node_Access;
   type Graph_Node_Array_Access is access Graph_Node_Array;

   type Graph is record
      Nodes    : Graph_Node_Array_Access := null;
      Edges    : Natural := 0;
      Capacity : Natural := 0;
      Usable   : Boolean := False;
   end record;
end Data_Structures_Advanced;
