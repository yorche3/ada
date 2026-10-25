with AUnit.Test_Fixtures; use AUnit.Test_Fixtures;

--  Un test por operación del contrato, como en `numbers/`.
package Data_Structures_Advanced_Binary_Tree_Tests is
   type Test is new Test_Fixture with null record;

   procedure Test_Make (Self : in out Test);
   procedure Test_Insert (Self : in out Test);
   procedure Test_Contains (Self : in out Test);
   procedure Test_Is_Empty (Self : in out Test);
   procedure Test_Size (Self : in out Test);
end Data_Structures_Advanced_Binary_Tree_Tests;
