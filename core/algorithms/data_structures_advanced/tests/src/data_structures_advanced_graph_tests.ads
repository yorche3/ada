with AUnit.Test_Fixtures; use AUnit.Test_Fixtures;

--  Un test por operación del contrato, como en `numbers/`.
package Data_Structures_Advanced_Graph_Tests is
   type Test is new Test_Fixture with null record;

   procedure Test_Make (Self : in out Test);
   procedure Test_Add_Edge (Self : in out Test);
   procedure Test_Has_Edge (Self : in out Test);
   procedure Test_Get_Neighbors (Self : in out Test);
   procedure Test_Is_Empty (Self : in out Test);
   procedure Test_Size (Self : in out Test);
end Data_Structures_Advanced_Graph_Tests;
