with AUnit.Test_Fixtures; use AUnit.Test_Fixtures;

package Data_Structures_Advanced_Tree_Node_Tests is
   type Test is new Test_Fixture with null record;

   procedure Test_Make (Self : in out Test);
   procedure Test_Get_Value (Self : in out Test);
   procedure Test_Get_Left (Self : in out Test);
   procedure Test_Get_Right (Self : in out Test);
   procedure Test_Set_Left (Self : in out Test);
   procedure Test_Set_Right (Self : in out Test);
end Data_Structures_Advanced_Tree_Node_Tests;
