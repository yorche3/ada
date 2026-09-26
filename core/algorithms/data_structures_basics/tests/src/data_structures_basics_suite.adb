with AUnit.Test_Caller;

with Data_Structures_Basics_Tests; use Data_Structures_Basics_Tests;

package body Data_Structures_Basics_Suite is
   --  One case per abstraction: Node, LinkedList, Stack and Queue, in the
   --  order the specification presents them.
   package Caller is new AUnit.Test_Caller
     (Data_Structures_Basics_Tests.Test);

   function Suite return Access_Test_Suite is
      Result : constant Access_Test_Suite := new Test_Suite;
   begin
      Result.Add_Test (Caller.Create ("Node", Test_Node_Steps'Access));
      Result.Add_Test
         (Caller.Create ("LinkedList", Test_Linked_List_Steps'Access));
      Result.Add_Test (Caller.Create ("Stack", Test_Stack_Steps'Access));
      Result.Add_Test (Caller.Create ("Queue", Test_Queue_Steps'Access));
      return Result;
   end Suite;
end Data_Structures_Basics_Suite;
