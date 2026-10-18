with AUnit.Test_Fixtures; use AUnit.Test_Fixtures;

package Data_Structures_Advanced_Tests is
   type Test is new Test_Fixture with null record;

   --  Una entrada por abstracción, en el orden de la especificación.
   procedure Test_Tree_Node_Steps (Self : in out Test);
   procedure Test_Binary_Tree_Steps (Self : in out Test);
   procedure Test_Graph_Steps (Self : in out Test);
end Data_Structures_Advanced_Tests;
