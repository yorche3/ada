package Data_Structures_Basics is
   Failure_Value : constant Integer := Integer'First;

   type Node;
   type Node_Access is access all Node;
   type Node is
      record
         Value : Integer;
         Next  : Node_Access := null;
      end record;

   function Initialize_Node (Value : Integer) return Node;
   function Get_Value (Item : Node) return Integer;
   function Get_Next (Item : Node) return Node_Access;
   procedure Set_Next (Item : in out Node; Next : Node_Access);

   type Linked_List is private;

   function Initialize_Linked_List
     (Capacity : Natural) return Linked_List;
   function Insert_Head
     (List : in out Linked_List; Value : Integer) return Boolean;
   function Insert_Tail
     (List : in out Linked_List; Value : Integer) return Boolean;
   function Delete (List : in out Linked_List; Value : Integer) return Boolean;
   function Is_Empty (List : Linked_List) return Boolean;
   function Size (List : Linked_List) return Natural;

   type Stack is private;

   function Initialize_Stack (Capacity : Natural) return Stack;
   function Push (Item : in out Stack; Value : Integer) return Boolean;
   function Pop (Item : in out Stack) return Integer;
   function Peek (Item : Stack) return Integer;
   function Is_Empty (Item : Stack) return Boolean;
   function Size (Item : Stack) return Natural;

   type Queue is private;

   function Initialize_Queue (Capacity : Natural) return Queue;
   function Enqueue (Item : in out Queue; Value : Integer) return Boolean;
   function Dequeue (Item : in out Queue) return Integer;
   function Peek (Item : Queue) return Integer;
   function Is_Empty (Item : Queue) return Boolean;
   function Size (Item : Queue) return Natural;

private
   type Linked_List is
      record
         Head     : Node_Access := null;
         Tail     : Node_Access := null;
         Count    : Natural := 0;
         Capacity : Natural := 0;
         Usable   : Boolean := False;
      end record;

   type Stack is
      record
         List : Linked_List;
      end record;

   type Queue is
      record
         List : Linked_List;
      end record;

end Data_Structures_Basics;
