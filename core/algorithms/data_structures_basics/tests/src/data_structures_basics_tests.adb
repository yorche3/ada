with AUnit.Assertions; use AUnit.Assertions;

with Data_Structures_Basics; use Data_Structures_Basics;

--  The scenario for each ADT follows the sequence in the module
--  specification. Every object is explicitly initialized before use.
package body Data_Structures_Basics_Tests is
   Failure : constant Integer := Failure_Value;

   procedure Test_Node_Steps (Self : in out Test) is
      First  : constant Node_Access := new Node;
      Second : constant Node_Access := new Node;
   begin
      Make (First.all, 10);
      Make (Second.all, 20);
      Assert (Get_Value (First.all) = 10, "Node 1: value should be 10");
      Assert (Get_Next (First.all) = null,
              "Node 1: init should leave next absent");

      Set_Next (First.all, Second);
      Assert (Get_Value (Get_Next (First.all).all) = 20,
              "Node 2: traversal should reach 20");
      Assert (Get_Next (Second.all) = null,
              "Node 2: the second node's next should be absent");
   end Test_Node_Steps;

   procedure Test_Linked_List_Steps (Self : in out Test) is
      List    : Linked_List;
      Success : Boolean;
   begin
      Make (List);
      Assert (Is_Empty (List), "LinkedList 1: init should make it empty");
      Assert (Size (List) = 0, "LinkedList 1: init should set size to 0");
      Assert (Get_Head (List) = Failure,
              "LinkedList 1: get_head on empty should return Failure_Value");

      Insert_Tail (List, 10);
      Insert_Tail (List, 20);
      Insert_Head (List, 5);
      Insert_Tail (List, 10);
      Assert (Size (List) = 4, "LinkedList 2: size should be 4");
      Assert (Get_Head (List) = 5,
              "LinkedList 2: insertion at head should place 5 first");

      Delete (List, 10, Success);
      Assert (Success, "LinkedList 3: deleting a present value succeeds");
      Delete (List, 5, Success);
      Assert (Success, "LinkedList 3: deleting 5 succeeds");
      Assert (Get_Head (List) = 20,
              "LinkedList 3: first 10 occurrence was deleted");
      Delete (List, 20, Success);
      Assert (Success, "LinkedList 3: deleting 20 succeeds");
      Assert (Get_Head (List) = 10,
              "LinkedList 3: second 10 occurrence remains");
      Assert (Size (List) = 1, "LinkedList 3: size should be 1");

      Delete (List, 99, Success);
      Assert (not Success, "LinkedList 4: absent value deletion fails");
      Assert (Get_Head (List) = 10,
              "LinkedList 4: absent deletion should not change the list");
      Assert (Size (List) = 1,
              "LinkedList 4: absent deletion should not change size");

      Delete (List, 10, Success);
      Assert (Success, "LinkedList 5: deleting the final value succeeds");
      Assert (Is_Empty (List), "LinkedList 5: list should be empty");
      Assert (Size (List) = 0, "LinkedList 5: size should be 0");
      Assert (Get_Head (List) = Failure,
              "LinkedList 5: get_head should return Failure_Value again");
   end Test_Linked_List_Steps;

   --  One explicitly initialized stack, exercising LIFO and empty results.
   procedure Test_Stack_Steps (Self : in out Test) is
      S      : Stack;
      Popped : Integer;
   begin
      Make (S);
      Assert (Is_Empty (S), "Stack 1: init should make it empty");
      Assert (Size (S) = 0, "Stack 1: init should set size to 0");
      Assert (Peek (S) = Failure, "Stack 1: Peek on empty should fail");
      Pop (S, Popped);
      Assert (Popped = Failure, "Stack 1: Pop on empty should fail");
      Assert (Is_Empty (S), "Stack 1: failed Pop should preserve empty state");

      Push (S, 10);
      Push (S, 20);
      Push (S, 30);
      Assert (Peek (S) = 30, "Stack 2: Peek should return 30");
      Assert (Size (S) = 3, "Stack 2: size should be 3");

      Pop (S, Popped);
      Assert (Popped = 30, "Stack 3: first Pop should return 30");
      Push (S, 40);
      Pop (S, Popped);
      Assert (Popped = 40, "Stack 3: reused top should return 40");
      Pop (S, Popped);
      Assert (Popped = 20, "Stack 3: next Pop should return 20");
      Pop (S, Popped);
      Assert (Popped = 10, "Stack 3: final Pop should return 10");
      Assert (Is_Empty (S), "Stack 3: stack should be empty");
      Assert (Size (S) = 0, "Stack 3: size should be 0");

      Pop (S, Popped);
      Assert (Popped = Failure, "Stack 4: Pop on empty should fail");
      Assert (Is_Empty (S), "Stack 4: stack should stay empty");
   end Test_Stack_Steps;

   --  One explicitly initialized queue, exercising FIFO and empty results.
   procedure Test_Queue_Steps (Self : in out Test) is
      Q        : Queue;
      Dequeued : Integer;
   begin
      Make (Q);
      Assert (Is_Empty (Q), "Queue 1: init should make it empty");
      Assert (Size (Q) = 0, "Queue 1: init should set size to 0");
      Assert (Peek (Q) = Failure, "Queue 1: Peek on empty should fail");
      Dequeue (Q, Dequeued);
      Assert (Dequeued = Failure, "Queue 1: Dequeue on empty should fail");
      Assert (Is_Empty (Q), "Queue 1: failed Dequeue preserves empty state");

      Enqueue (Q, 10);
      Enqueue (Q, 20);
      Enqueue (Q, 30);
      Assert (Peek (Q) = 10, "Queue 2: Peek should return 10");
      Assert (Size (Q) = 3, "Queue 2: size should be 3");

      Dequeue (Q, Dequeued);
      Assert (Dequeued = 10, "Queue 3: first Dequeue should return 10");
      Enqueue (Q, 40);
      Dequeue (Q, Dequeued);
      Assert (Dequeued = 20, "Queue 3: next Dequeue should return 20");
      Dequeue (Q, Dequeued);
      Assert (Dequeued = 30, "Queue 3: next Dequeue should return 30");
      Dequeue (Q, Dequeued);
      Assert (Dequeued = 40, "Queue 3: final Dequeue should return 40");
      Assert (Is_Empty (Q), "Queue 3: queue should be empty");
      Assert (Size (Q) = 0, "Queue 3: size should be 0");

      Dequeue (Q, Dequeued);
      Assert (Dequeued = Failure, "Queue 4: Dequeue on empty should fail");
      Assert (Is_Empty (Q), "Queue 4: queue should stay empty");
   end Test_Queue_Steps;
end Data_Structures_Basics_Tests;