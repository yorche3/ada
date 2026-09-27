package body Data_Structures_Basics is
   --  Initialize a Node with a given value and set its Next pointer to null
   --  New_Node : out Node - the Node to be initialized
   --  Value : Integer - the value to be stored in the Node
   procedure Make (New_Node : out Node; Value : Integer) is
   begin
      New_Node.Value := Value;
      New_Node.Next  := null;
   end Make;

   --  Get the value stored in a Node
   --  Item : Node - the Node whose value is to be retrieved
   --  Returns the value stored in the given Node
   function Get_Value (Item : Node) return Integer is
   begin
      return Item.Value;
   end Get_Value;

   --  Get the next Node accessible from the current Node
   --  Item : Node - the Node whose next pointer is to be retrieved
   --  Returns the Node_Access pointing to the next Node, or null if there is no next Node
   function Get_Next (Item : Node) return Node_Access is
   begin
      return Item.Next;
   end Get_Next;

   --  Set the next Node accessible from the current Node
   --  Item : in out Node - the current Node whose next pointer is to be set
   --  Next : Node_Access - the Node_Access to be set as the next Node
   procedure Set_Next (Item : in out Node; Next : Node_Access) is
   begin
      Item.Next := Next;
   end Set_Next;

   --  Linked List operations

   --  Initialize a Linked List with head and tail set to null and count set to 0
   --  New_Linked_List : out Linked_List - the Linked List to be initialized
   procedure Make (New_Linked_List : out Linked_List) is
   begin
      New_Linked_List.Head  := null;
      New_Linked_List.Tail  := null;
      New_Linked_List.Count := 0;
   end Make;

   --  Check if the Linked List is empty
   --  List : Linked_List - the Linked List to be checked
   --  Returns True if the Linked List has no elements, False otherwise
   function Is_Empty (List : Linked_List) return Boolean is
   begin
      return List.Count = 0;
   end Is_Empty;

   --  Get the number of elements in the Linked List
   --  List : Linked_List - the Linked List whose size is to be retrieved
   --  Returns the number of elements in the Linked List
   function Size (List : Linked_List) return Natural is
   begin
      return List.Count;
   end Size;

   --  Get the head value of the Linked List
   --  List : Linked_List - the Linked List from which to get the head value
   --  Returns the value stored in the head Node of the Linked List
   function Get_Head (List : Linked_List) return Integer is
   begin
      if Is_Empty (List) then
         return Failure_Value;
      else
         return List.Head.all.Value;
      end if;
   end Get_Head;

   --  Insert a new Node at the head of the Linked List
   --  List : in out Linked_List - the Linked List in which to insert the new Node
   --  Value : Integer - the value to be stored in the new head Node
   --  Modifies the Linked List by adding a new Node at the head
   procedure Insert_Head (List : in out Linked_List; Value : Integer) is
      New_Node : Node_Access := new Node;
   begin
      Make (New_Node.all, Value);
      Set_Next (New_Node.all, List.Head);
      List.Head := New_Node;
      if Is_Empty (List) then
         List.Tail := New_Node;
      end if;
      List.Count := List.Count + 1;
   end Insert_Head;

   --  Insert a new Node at the tail of the Linked List
   --  List : in out Linked_List - the Linked List in which to insert the new Node
   --  Value : Integer - the value to be stored in the new tail Node
   --  Modifies the Linked List by adding a new Node at the tail
   procedure Insert_Tail (List : in out Linked_List; Value : Integer) is
      New_Node : Node_Access := new Node;
   begin
      Make (New_Node.all, Value);
      Set_Next (New_Node.all, null);
      if Is_Empty (List) then
         List.Head := New_Node;
         List.Tail := New_Node;
      else
         Set_Next (List.Tail.all, New_Node);
         List.Tail := New_Node;
      end if;
      List.Count := List.Count + 1;
   end Insert_Tail;

   --  Remove a Node
   --  List : in out Linked_List - the Linked List from which to remove the Node
   --  Deleted : out Integer - the value stored in the removed Node, or Failure_Value if the list is empty
   procedure Delete (List : in out Linked_List; Value : Integer; Success : out Boolean) is
      Removed_Value : Integer := Failure_Value;
      Previous : Node_Access := null;
      Current : Node_Access := null;
   begin
      Current := List.Head;
      while Current /= null loop
         if Current.Value = Value then
            Removed_Value := Current.Value;
            if Previous = null then
               List.Head := Current.Next;
            else
               Set_Next (Previous.all, Current.Next);
            end if;
            if Current.Next = null then
               List.Tail := Previous;
            end if;
            List.Count := List.Count - 1;
            Success := True;
            exit;
         end if;
         Previous := Current;
         Current := Current.Next;
      end loop;
      if Current = null then
         Success := False;
      end if;
   end Delete;

   --  Stack operations

   --  Initialize a Stack with top set to null and count set to 0
   --  New_Stack : out Stack - the Stack to be initialized
   procedure Make (New_Stack : out Stack) is
   begin
      New_Stack.Top   := null;
      New_Stack.Count := 0;
   end Make;

   --  S : Stack - the Stack to be checked
   --  Returns True if the Stack has no elements, False otherwise
   function Is_Empty (S : Stack) return Boolean is
   begin
      return S.Count = 0;
   end Is_Empty;

   --  Return the number of elements in the Stack
   --  S : Stack - the Stack whose size is to be determined
   --  Returns the number of elements in the Stack
   function Size (S : Stack) return Natural is
   begin
      return S.Count;
   end Size;

   --  Push a value onto the Stack
   --  S : in out Stack - the Stack onto which the value is to be pushed
   --  Value : Integer - the value to be pushed onto the Stack
   procedure Push (S : in out Stack; Value : Integer) is
      New_Node : Node_Access := new Node;
   begin
      Make (New_Node.all, Value);
      Set_Next (New_Node.all, S.Top);
      S.Top := New_Node;
      S.Count := S.Count + 1;
   end Push;

   --  Peek at the top value of the Stack without removing it
   --  S : Stack - the Stack whose top value is to be retrieved
   --  Returns the top value of the Stack
   function Peek (S : Stack) return Integer is
      Failure : Integer := Failure_Value;
   begin
      if Is_Empty (S) then
         return Failure_Value;
      else
         return S.Top.all.Value;
      end if;
   end Peek;

   --  Pop the top value from the Stack
   --  S : in out Stack - the Stack from which the top value is to be removed
   --  Returns the top value of the Stack
   procedure Pop (S : in out Stack; Popped : out Integer) is
      Result : Integer := Failure_Value;
   begin
      if not Is_Empty (S) then
         Popped := S.Top.all.Value;
         S.Top := S.Top.all.Next;
         S.Count := S.Count - 1;
      else
         Popped := Failure_Value;
      end if;
   end Pop;

   --  Queue operations

   --  Initialize a Queue with front and rear set to null and count set to 0
   procedure Make (New_Queue : out Queue) is
   begin
      New_Queue.Front := null;
      New_Queue.Rear  := null;
      New_Queue.Count := 0;
   end Make;

   --  Check if the Queue is empty
   --  Q : Queue - the Queue to be checked
   --  Returns True if the Queue has no elements, False otherwise
   function Is_Empty (Q : Queue) return Boolean is
   begin
      return Q.Count = 0;
   end Is_Empty;

   --  Return the number of elements in the Queue
   --  Q : Queue - the Queue whose size is to be determined
   --  Returns the number of elements in the Queue
   function Size (Q : Queue) return Natural is
   begin
      return Q.Count;
   end Size;

   --  Enqueue a value into the Queue
   --  Q : in out Queue - the Queue into which the value is to be enqueued
   --  Value : Integer - the value to be enqueued
   procedure Enqueue (Q : in out Queue; Value : Integer) is
      New_Node : Node_Access := new Node;
   begin
      Make (New_Node.all, Value);
      if Is_Empty (Q) then
         Q.Front := New_Node;
      else
         Q.Rear.all.Next := New_Node;
      end if;
      Q.Rear := New_Node;
      Q.Count := Q.Count + 1;
   end Enqueue;

   --  Peek at the front value of the Queue without removing it
   --  Q : Queue - the Queue whose front value is to be retrieved
   --  Returns the front value of the Queue
   function Peek (Q : Queue) return Integer is
   begin
      if Is_Empty (Q) then
         return Failure_Value;
      else
         return Q.Front.all.Value;
      end if;
   end Peek;

   --  Dequeue a value from the Queue
   --  Q : in out Queue - the Queue from which the value is to be dequeued
   --  Dequeued : out Integer - the value dequeued from the Queue
   procedure Dequeue (Q : in out Queue; Dequeued : out Integer) is
   begin
      if not Is_Empty (Q) then
         Dequeued := Q.Front.all.Value;
         Q.Front := Q.Front.all.Next;
         Q.Count := Q.Count - 1;
         if Is_Empty (Q) then
            Q.Rear := null;
         end if;
      else
         Dequeued := Failure_Value;
      end if;
   end Dequeue;
end Data_Structures_Basics;