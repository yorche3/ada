with AUnit.Test_Fixtures; use AUnit.Test_Fixtures;

package Data_Structures_Basics_Tests is
   type Test is new Test_Fixture with null record;

   procedure Test_Node_Steps (Self : in out Test);
   procedure Test_Linked_List_Steps (Self : in out Test);
   procedure Test_Stack_Steps (Self : in out Test);
   procedure Test_Queue_Steps (Self : in out Test);
end Data_Structures_Basics_Tests;
