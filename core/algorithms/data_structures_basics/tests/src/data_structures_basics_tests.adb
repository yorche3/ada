with AUnit.Assertions; use AUnit.Assertions;

with Data_Structures_Basics; use Data_Structures_Basics;

--  Cases come from 06_Data_Structures_Basics.md, "Casos de prueba": one
--  scenario per ADT, walking its steps in order, as the specification
--  describes. Assertions are named per step so a failure points at it.
package body Data_Structures_Basics_Tests is
   --  The contract's natural failure indicator for an absent value: Pop,
   --  Peek and Dequeue return it when the structure is empty.
   Failure : constant Integer := Failure_Value;

   type Value_Array is array (Positive range <>) of Integer;

   --  Traverse the list the way the module teaches linking: from the head
   --  through Get_Next, comparing every node value with the expectation.
   procedure Assert_List
      (List : Linked_List; Expected : Value_Array; Step : String)
   is
      Current : Node_Access := Get_Head (List);
      Index   : Natural := Expected'First;
   begin
      Assert (Size (List) = Expected'Length,
              Step & ": size should be" & Natural'Image (Expected'Length));
      while Current /= null loop
         Assert (Index <= Expected'Last,
                 Step & ": the list has more nodes than expected");
         Assert (Get_Value (Current.all) = Expected (Index),
                 Step & ": node" & Natural'Image (Index - Expected'First + 1)
                 & " should be" & Integer'Image (Expected (Index)));
         Index := Index + 1;
         Current := Get_Next (Current.all);
      end loop;
      Assert (Index = Expected'Last + 1,
              Step & ": the list has fewer nodes than expected");
   end Assert_List;

   --  Node steps: a new node keeps its value and starts unlinked; Set_Next
   --  links two nodes and the chain can be traversed through Get_Next.
   procedure Test_Node_Steps (Self : in out Test) is
      First  : constant Node_Access := new Node'(Initialize_Node (10));
      Second : constant Node_Access := new Node'(Initialize_Node (20));
   begin
      Assert (Get_Value (First.all) = 10, "Node 1: value should be 10");
      Assert (Get_Next (First.all) = null,
              "Node 1: the link should start absent");

      Set_Next (First.all, Second);
      Assert (Get_Next (First.all) = Second,
              "Node 2: the link should point to the second node");
      Assert (Get_Value (Get_Next (First.all).all) = 20,
              "Node 2: traversal should reach 20");
      Assert (Get_Next (Second.all) = null,
              "Node 2: the second node's link should remain absent");
   end Test_Node_Steps;

   --  LinkedList steps: empty construction, insertion at both ends, deletion
   --  of the first occurrence, absent value, and emptying the list.
   procedure Test_Linked_List_Steps (Self : in out Test) is
      List : Linked_List;
   begin
      Assert (Is_Empty (List), "LinkedList 1: a new list should be empty");
      Assert (Size (List) = 0, "LinkedList 1: a new list should have size 0");
      Assert (Get_Head (List) = null,
              "LinkedList 1: a new list should have an absent head");

      Insert_Tail (List, 10);
      Insert_Tail (List, 20);
      Insert_Head (List, 5);
      Insert_Tail (List, 10);
      Assert_List (List, (5, 10, 20, 10),
                   "LinkedList 2: insert at both ends");

      Assert (Delete (List, 10),
              "LinkedList 3: deleting a present value should succeed");
      Assert_List (List, (5, 20, 10),
                   "LinkedList 3: the first occurrence is deleted");

      Assert (not Delete (List, 99),
              "LinkedList 4: deleting an absent value should fail");
      Assert_List (List, (5, 20, 10),
                   "LinkedList 4: the list should not change");

      Assert (Delete (List, 5), "LinkedList 5: deleting 5 should succeed");
      Assert (Delete (List, 20), "LinkedList 5: deleting 20 should succeed");
      Assert (Delete (List, 10), "LinkedList 5: deleting 10 should succeed");
      Assert (Is_Empty (List), "LinkedList 5: the list should be empty");
      Assert (Size (List) = 0, "LinkedList 5: size should be 0");
      Assert (Get_Head (List) = null,
              "LinkedList 5: the head should be absent again");
   end Test_Linked_List_Steps;

   --  Stack steps: empty state, LIFO order with a non-mutating Peek, removal
   --  and reuse of the freed top, and Pop on the emptied stack.
   procedure Test_Stack_Steps (Self : in out Test) is
      S : Stack;
   begin
      Assert (Is_Empty (S), "Stack 1: a new stack should be empty");
      Assert (Size (S) = 0, "Stack 1: a new stack should have size 0");
      Assert (Peek (S) = Failure, "Stack 1: Peek on empty should fail");
      Assert (Pop (S) = Failure, "Stack 1: Pop on empty should fail");
      Assert (Is_Empty (S), "Stack 1: a failed Pop should not change it");

      Push (S, 10);
      Push (S, 20);
      Push (S, 30);
      Assert (Peek (S) = 30, "Stack 2: Peek should return the last pushed");
      Assert (Size (S) = 3, "Stack 2: size should be 3 after three pushes");

      Assert (Pop (S) = 30, "Stack 3: the first Pop should return 30");
      Push (S, 40);
      Assert (Pop (S) = 40, "Stack 3: the reused top should return 40");
      Assert (Pop (S) = 20, "Stack 3: the third Pop should return 20");
      Assert (Pop (S) = 10, "Stack 3: the fourth Pop should return 10");
      Assert (Is_Empty (S), "Stack 3: the stack should be empty");
      Assert (Size (S) = 0, "Stack 3: size should be 0");

      Assert (Pop (S) = Failure, "Stack 4: Pop on the emptied stack fails");
      Assert (Is_Empty (S), "Stack 4: the stack should stay empty");
   end Test_Stack_Steps;

   --  Queue steps: empty state, FIFO order with a non-mutating Peek, removal
   --  and reuse of the freed front, and Dequeue on the emptied queue.
   procedure Test_Queue_Steps (Self : in out Test) is
      Q : Queue;
   begin
      Assert (Is_Empty (Q), "Queue 1: a new queue should be empty");
      Assert (Size (Q) = 0, "Queue 1: a new queue should have size 0");
      Assert (Peek (Q) = Failure, "Queue 1: Peek on empty should fail");
      Assert (Dequeue (Q) = Failure, "Queue 1: Dequeue on empty should fail");
      Assert (Is_Empty (Q), "Queue 1: a failed Dequeue should not change it");

      Enqueue (Q, 10);
      Enqueue (Q, 20);
      Enqueue (Q, 30);
      Assert (Peek (Q) = 10, "Queue 2: Peek should return the first in");
      Assert (Size (Q) = 3, "Queue 2: size should be 3 after three enqueues");

      Assert (Dequeue (Q) = 10, "Queue 3: the first Dequeue returns 10");
      Enqueue (Q, 40);
      Assert (Dequeue (Q) = 20, "Queue 3: the next Dequeue returns 20");
      Assert (Dequeue (Q) = 30, "Queue 3: the next Dequeue returns 30");
      Assert (Dequeue (Q) = 40, "Queue 3: the reused rear returns 40");
      Assert (Is_Empty (Q), "Queue 3: the queue should be empty");
      Assert (Size (Q) = 0, "Queue 3: size should be 0");

      Assert (Dequeue (Q) = Failure,
              "Queue 4: Dequeue on the emptied queue fails");
      Assert (Is_Empty (Q), "Queue 4: the queue should stay empty");
   end Test_Queue_Steps;
end Data_Structures_Basics_Tests;
