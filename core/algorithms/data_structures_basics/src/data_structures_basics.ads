package Data_Structures_Basics is
   Failure_Value : constant Integer := -1;

   --  Node type declaration
   type Node;
   --  Access type for Node
   type Node_Access is access all Node;

   --  Node record type declaration
   type Node is
      record
         Value : Integer;
         Next  : Node_Access := null;
      end record;

   --  Initialization procedure for Node
   procedure Make (New_Node : out Node; Value : Integer);
   --  Getter and setter procedures for Node
   function Get_Value (Item : Node) return Integer;
   function Get_Next (Item : Node) return Node_Access;
   procedure Set_Next (Item : in out Node; Next : Node_Access);

   --  Linked List type declaration
   type Linked_List is private;

   --  Linked List operations
   procedure Make (New_Linked_List : out Linked_List);
   function Is_Empty (List : Linked_List) return Boolean;
   function Size (List : Linked_List) return Natural;
   function Get_Head (List : Linked_List) return Integer;
   procedure Insert_Head (List : in out Linked_List; Value : Integer);
   procedure Insert_Tail (List : in out Linked_List; Value : Integer);
   procedure Delete (List : in out Linked_List; Value : Integer; Success : out Boolean);

   --  Stack type declaration
   type Stack is private;

   --  Stack operations
   procedure Make (New_Stack : out Stack);
   function Is_Empty (S : Stack) return Boolean;
   function Size (S : Stack) return Natural;
   procedure Push (S : in out Stack; Value : Integer);
   function Peek (S : Stack) return Integer;
   procedure Pop (S : in out Stack; Popped : out Integer);

   --  Queue type declaration
   type Queue is private;

   --  Queue operations
   procedure Make (New_Queue : out Queue);
   function Is_Empty (Q : Queue) return Boolean;
   function Size (Q : Queue) return Natural;
   procedure Enqueue (Q : in out Queue; Value : Integer);
   procedure Dequeue (Q : in out Queue; Dequeued : out Integer);
   function Peek (Q : Queue) return Integer;

private
   --  Linked List record type declaration
   type Linked_List is
      record
         Head     : Node_Access := null;
         Tail     : Node_Access := null;
         Count    : Natural := 0;
      end record;

   --  Stack record type declaration
   type Stack is
      record
         Top   : Node_Access := null;
         Count : Natural := 0;
      end record;

   --  Queue record type declaration
   type Queue is
      record
         Front : Node_Access := null;
         Rear  : Node_Access := null;
         Count : Natural := 0;
      end record;

end Data_Structures_Basics;
