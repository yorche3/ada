with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;
with AUnit.Assertions; use AUnit.Assertions;
with Data_Structures_Advanced; use Data_Structures_Advanced;

package body Data_Structures_Advanced_Tests is
   procedure Check
     (Errors : in out Unbounded_String; Actual, Expected : Boolean;
      Subject : String)
   is
   begin
      if Actual /= Expected then
         Append (Errors, Subject & " should be " & Boolean'Image (Expected)
                 & ", got " & Boolean'Image (Actual) & "; ");
      end if;
   end Check;

   function Image (Values : Neighbor_Array) return String is
      Result : Unbounded_String := To_Unbounded_String ("[");
   begin
      for I in Values'Range loop
         if I /= Values'First then
            Append (Result, ",");
         end if;
         Append (Result, Natural'Image (Values (I)));
      end loop;
      return To_String (Result) & " ]";
   end Image;

   procedure Check
     (Errors : in out Unbounded_String; Actual, Expected : Neighbor_Array;
      Subject : String)
   is
   begin
      if Actual /= Expected then
         Append (Errors, Subject & " should be " & Image (Expected)
                 & ", got " & Image (Actual) & "; ");
      end if;
   end Check;

   procedure Check
     (Errors : in out Unbounded_String; Actual, Expected : Integer;
      Subject : String)
   is
   begin
      if Actual /= Expected then
         Append (Errors, Subject & " should be" & Integer'Image (Expected)
                 & ", got" & Integer'Image (Actual) & "; ");
      end if;
   end Check;

   type Node_Input is record
      Value          : Integer;
      Left_Value     : Integer := 20;
      Right_Value    : Integer := 30;
      Link_Children  : Boolean := False;
      Traverse       : Boolean := False;
      Check_Value    : Boolean := False;
      Check_Absence  : Boolean := False;
   end record;

   type Node_Output is record
      Value       : Integer := 0;
      Left_Value  : Integer := 20;
      Right_Value : Integer := 30;
   end record;

   Create_Node_Input : constant Node_Input :=
     (Value => 10, Check_Value => True, others => <>);
   Create_Node_Output : constant Node_Output :=
     (Value => 10, others => <>);
   Absent_Links_Input : constant Node_Input :=
     (Value => 10, Check_Absence => True, others => <>);
   Absent_Links_Output : constant Node_Output := (others => <>);
   Link_Children_Input : constant Node_Input :=
     (Value => 10, Link_Children => True, others => <>);
   Link_Children_Output : constant Node_Output :=
     (Left_Value => 20, Right_Value => 30, others => <>);
   Traverse_Links_Input : constant Node_Input :=
     (Value => 10, Link_Children => True, Traverse => True, others => <>);
   Traverse_Links_Output : constant Node_Output :=
     (Left_Value => 20, Right_Value => 30, others => <>);

   procedure Run_Node
     (Errors : in out Unbounded_String; Input : Node_Input;
      Expected : Node_Output; Name : String)
   is
      procedure Release is new Ada.Unchecked_Deallocation
        (Tree_Node, Tree_Node_Access);
      Parent : Tree_Node;
      Left, Right : Tree_Node_Access;

      procedure Check_Child
        (Child : Tree_Node_Access; Value : Integer; Side : String)
      is
      begin
         Check (Errors, Child /= null, True, Name & ": " & Side & " link");
         if Child /= null then
            Check (Errors, Get_Value (Child.all), Value,
                   Name & ": " & Side & " value");
            if Input.Traverse then
               Check (Errors, Get_Left (Child.all) = null, True,
                      Name & ": " & Side & " child's left absence");
               Check (Errors, Get_Right (Child.all) = null, True,
                      Name & ": " & Side & " child's right absence");
            end if;
         end if;
      end Check_Child;
   begin
      Make (Parent, Input.Value);
      if Input.Check_Value then
         Check (Errors, Get_Value (Parent), Expected.Value, Name & ": value");
      end if;
      if Input.Check_Absence then
         Check (Errors, Get_Left (Parent) = null, True,
                Name & ": initial left absence");
         Check (Errors, Get_Right (Parent) = null, True,
                Name & ": initial right absence");
      end if;
      if Input.Link_Children then
         Left := new Tree_Node;
         Right := new Tree_Node;
         Make (Left.all, Input.Left_Value);
         Make (Right.all, Input.Right_Value);
         Set_Left (Parent, Left);
         Set_Right (Parent, Right);
         Check_Child (Get_Left (Parent), Expected.Left_Value, "left");
         Check_Child (Get_Right (Parent), Expected.Right_Value, "right");
         Release (Left);
         Release (Right);
      end if;
   end Run_Node;

   type Value_Array is array (Positive range <>) of Integer;
   type Success_Array is array (Positive range <>) of Boolean;

   type Tree_Input (Insert_Count, Query_Count : Natural) is record
      Capacity : Integer;
      Values   : Value_Array (1 .. Insert_Count);
      Queries  : Value_Array (1 .. Query_Count);
   end record;

   type Tree_Output (Insert_Count, Query_Count : Natural) is record
      Inserted    : Success_Array (1 .. Insert_Count);
      Found       : Success_Array (1 .. Query_Count);
      Check_Size  : Boolean := False;
      Count       : Natural := 0;
      Check_Empty : Boolean := False;
      Empty       : Boolean := True;
   end record;

   Create_Tree_Input : constant Tree_Input :=
     (0, 0, 5, (1 .. 0 => 0), (1 .. 0 => 0));
   Create_Tree_Output : constant Tree_Output :=
     (0, 0, (1 .. 0 => False), (1 .. 0 => False),
      Check_Size => True, Check_Empty => True, others => <>);
   Invalid_Tree_Input : constant Tree_Input :=
     (1, 0, 0, (1 => 50), (1 .. 0 => 0));
   Invalid_Tree_Output : constant Tree_Output :=
     (1, 0, (1 => False), (1 .. 0 => False),
      Check_Size => True, Check_Empty => True, others => <>);
   Insert_Root_Input : constant Tree_Input :=
     (1, 1, 5, (1 => 50), (1 => 50));
   Insert_Root_Output : constant Tree_Output :=
     (1, 1, (1 => True), (1 => True),
      Check_Size => True, Count => 1, others => <>);
   Insert_Lower_Higher_Input : constant Tree_Input :=
     (3, 2, 3, (50, 30, 70), (30, 70));
   Insert_Lower_Higher_Output : constant Tree_Output :=
     (3, 2, (True, True, True), (True, True),
      Check_Size => True, Count => 3, others => <>);
   BST_Property_Input : constant Tree_Input :=
     (5, 5, 5, (50, 30, 70, 20, 40), (50, 30, 70, 20, 40));
   BST_Property_Output : constant Tree_Output :=
     (5, 5, (1 .. 5 => True), (1 .. 5 => True),
      Check_Size => True, Count => 5, others => <>);
   Absent_Value_Input : constant Tree_Input :=
     (0, 1, 3, (1 .. 0 => 0), (1 => 99));
   Absent_Value_Output : constant Tree_Output :=
     (0, 1, (1 .. 0 => False), (1 => False), others => <>);
   Full_Duplicate_Input : constant Tree_Input :=
     (2, 1, 1, (50, 50), (1 => 50));
   Full_Duplicate_Output : constant Tree_Output :=
     (2, 1, (True, True), (1 => True),
      Check_Size => True, Count => 1, others => <>);
   Exhausted_Tree_Input : constant Tree_Input :=
     (4, 1, 3, (50, 30, 70, 20), (1 => 20));
   Exhausted_Tree_Output : constant Tree_Output :=
     (4, 1, (True, True, True, False), (1 => False),
      Check_Size => True, Count => 3, others => <>);
   Tree_Size_Empty_Input : constant Tree_Input :=
     (1, 0, 5, (1 => 50), (1 .. 0 => 0));
   Tree_Size_Empty_Output : constant Tree_Output :=
     (1, 0, (1 => True), (1 .. 0 => False),
      Check_Size => True, Count => 1,
      Check_Empty => True, Empty => False);

   procedure Run_Tree
     (Errors : in out Unbounded_String; Input : Tree_Input;
      Expected : Tree_Output; Name : String)
   is
      Tree : Binary_Tree;
      Success : Boolean;
   begin
      Make (Tree, Input.Capacity);
      for I in Input.Values'Range loop
         Insert (Tree, Input.Values (I), Success);
         Check (Errors, Success, Expected.Inserted (I),
                Name & ": insert" & Integer'Image (Input.Values (I)));
      end loop;
      for I in Input.Queries'Range loop
         Check (Errors, Contains (Tree, Input.Queries (I)), Expected.Found (I),
                Name & ": contains" & Integer'Image (Input.Queries (I)));
      end loop;
      if Expected.Check_Size then
         Check (Errors, Size (Tree), Expected.Count, Name & ": size");
      end if;
      if Expected.Check_Empty then
         Check (Errors, Is_Empty (Tree), Expected.Empty, Name & ": is_empty");
      end if;
      Free (Tree);
   end Run_Tree;

   type Edge is record
      U, V : Integer;
   end record;
   type Edge_Array is array (Positive range <>) of Edge;
   type Query_Kind is (No_Query, Edge_Query, Neighbor_Query);

   type Graph_Input (Edge_Count : Natural) is record
      Capacity    : Integer;
      Edges       : Edge_Array (1 .. Edge_Count);
      Query       : Query_Kind := No_Query;
      U, V        : Integer := 0;
      Check_Fresh : Boolean := False;
   end record;

   type Graph_Output (Edge_Count, Neighbor_Count : Natural) is record
      Added           : Success_Array (1 .. Edge_Count);
      Found           : Boolean := False;
      Neighbors_Valid : Boolean := False;
      Neighbors       : Neighbor_Array (1 .. Neighbor_Count);
      Check_Size      : Boolean := False;
      Count           : Natural := 0;
      Check_Empty     : Boolean := False;
      Empty           : Boolean := True;
   end record;

   Create_Graph_Input : constant Graph_Input :=
     (0, 4, (1 .. 0 => (0, 0)), others => <>);
   Create_Graph_Output : constant Graph_Output :=
     (0, 0, Added => (1 .. 0 => False), Neighbors => (1 .. 0 => 0),
      Check_Size => True, Check_Empty => True, others => <>);
   Invalid_Graph_Input : constant Graph_Input :=
     (1, 0, (1 => (0, 0)), others => <>);
   Invalid_Graph_Output : constant Graph_Output :=
     (1, 0, Added => (1 => False), Neighbors => (1 .. 0 => 0),
      Check_Size => True, Check_Empty => True, others => <>);
   Directed_Edge_Input : constant Graph_Input :=
     (1, 4, (1 => (0, 1)), Query => Edge_Query, U => 0, V => 1,
      others => <>);
   Directed_Edge_Output : constant Graph_Output :=
     (1, 0, Added => (1 => True), Neighbors => (1 .. 0 => 0),
      Found => True, Check_Size => True, Count => 1, others => <>);
   Reverse_Direction_Input : constant Graph_Input :=
     (1, 4, (1 => (0, 1)), Query => Edge_Query, U => 1, V => 0,
      others => <>);
   Reverse_Direction_Output : constant Graph_Output :=
     (1, 0, Added => (1 => True), Neighbors => (1 .. 0 => 0),
      Found => False, others => <>);
   Duplicate_Edge_Input : constant Graph_Input :=
     (2, 4, ((0, 1), (0, 1)), others => <>);
   Duplicate_Edge_Output : constant Graph_Output :=
     (2, 0, Added => (True, True), Neighbors => (1 .. 0 => 0),
      Check_Size => True, Count => 1, others => <>);
   Out_Of_Range_Node_Input : constant Graph_Input :=
     (1, 4, (1 => (0, 4)), others => <>);
   Out_Of_Range_Node_Output : constant Graph_Output :=
     (1, 0, Added => (1 => False), Neighbors => (1 .. 0 => 0),
      Check_Size => True, others => <>);
   Ordered_Neighbors_Input : constant Graph_Input :=
     (3, 4, ((0, 3), (0, 1), (0, 2)), Query => Neighbor_Query,
      others => <>);
   Ordered_Neighbors_Output : constant Graph_Output :=
     (3, 3, Added => (True, True, True), Neighbors => (1, 2, 3),
      Neighbors_Valid => True, Check_Size => True, Count => 3, others => <>);
   No_Edges_Input : constant Graph_Input :=
     (0, 4, (1 .. 0 => (0, 0)), Query => Neighbor_Query, others => <>);
   No_Edges_Output : constant Graph_Output :=
     (0, 0, Added => (1 .. 0 => False), Neighbors => (1 .. 0 => 0),
      Neighbors_Valid => True, others => <>);
   Out_Of_Range_Neighbors_Input : constant Graph_Input :=
     (0, 4, (1 .. 0 => (0, 0)), Query => Neighbor_Query, U => 4,
      others => <>);
   Out_Of_Range_Neighbors_Output : constant Graph_Output :=
     (0, 0, Added => (1 .. 0 => False), Neighbors => (1 .. 0 => 0),
      Neighbors_Valid => False, others => <>);
   Graph_Size_Empty_Input : constant Graph_Input :=
     (3, 4, ((0, 1), (0, 2), (1, 2)), Check_Fresh => True, others => <>);
   Graph_Size_Empty_Output : constant Graph_Output :=
     (3, 0, Added => (True, True, True), Neighbors => (1 .. 0 => 0),
      Check_Size => True, Count => 3, Check_Empty => True, Empty => False,
      others => <>);

   procedure Run_Graph
     (Errors : in out Unbounded_String; Input : Graph_Input;
      Expected : Graph_Output; Name : String)
   is
      procedure Release is new Ada.Unchecked_Deallocation
        (Neighbor_Array, Neighbor_Array_Access);
      Item : Graph;
      Success : Boolean;
      Neighbors : Neighbor_Array_Access;
   begin
      Make (Item, Input.Capacity);
      if Input.Check_Fresh then
         Check (Errors, Is_Empty (Item), True, Name & ": fresh is_empty");
      end if;
      for I in Input.Edges'Range loop
         Add_Edge (Item, Input.Edges (I).U, Input.Edges (I).V, Success);
         Check (Errors, Success, Expected.Added (I),
                Name & ": add_edge" & Integer'Image (Input.Edges (I).U)
                & " ->" & Integer'Image (Input.Edges (I).V));
      end loop;
      case Input.Query is
         when No_Query =>
            null;
         when Edge_Query =>
            Check (Errors, Has_Edge (Item, Input.U, Input.V), Expected.Found,
                   Name & ": has_edge");
         when Neighbor_Query =>
            Neighbors := Get_Neighbors (Item, Input.U);
            Check (Errors, Neighbors /= null, Expected.Neighbors_Valid,
                   Name & ": get_neighbors success");
            if Neighbors /= null and then Expected.Neighbors_Valid then
               Check (Errors, Neighbors.all, Expected.Neighbors,
                      Name & ": ordered neighbors");
            end if;
            Release (Neighbors);
      end case;
      if Expected.Check_Size then
         Check (Errors, Size (Item), Expected.Count, Name & ": size");
      end if;
      if Expected.Check_Empty then
         Check (Errors, Is_Empty (Item), Expected.Empty, Name & ": is_empty");
      end if;
      Free (Item);
   end Run_Graph;

   --  Los casos se agrupan por abstracción, en el orden de la especificación
   --  («primero TreeNode, después BinaryTree y Graph»). Cada grupo recorre sus
   --  casos, acumula las desviaciones y declara una sola vez: el reporte tiene
   --  tres entradas y el mensaje dice el caso que falla.
   procedure Test_Tree_Node_Steps (Self : in out Test) is
      pragma Unreferenced (Self);
      Errors : Unbounded_String;
   begin
      Run_Node (Errors, Create_Node_Input, Create_Node_Output,
                "Create a tree node");
      Run_Node (Errors, Absent_Links_Input, Absent_Links_Output,
                "Absent initial links");
      Run_Node (Errors, Link_Children_Input, Link_Children_Output,
                "Link two children");
      Run_Node (Errors, Traverse_Links_Input, Traverse_Links_Output,
                "Traverse each link");
      --  El quinto caso de la tabla —«adaptación inmutable, si aplica»— se
      --  omite: en Ada los setters mutan el nodo en vez de devolver uno nuevo.
      --  Queda declarado aquí y en la tabla de cobertura del README.
      Assert (Length (Errors) = 0, To_String (Errors));
   end Test_Tree_Node_Steps;

   procedure Test_Binary_Tree_Steps (Self : in out Test) is
      pragma Unreferenced (Self);
      Errors : Unbounded_String;
   begin
      Run_Tree (Errors, Create_Tree_Input, Create_Tree_Output,
                "Create with valid capacity");
      Run_Tree (Errors, Invalid_Tree_Input, Invalid_Tree_Output,
                "Invalid capacity");
      Run_Tree (Errors, Insert_Root_Input, Insert_Root_Output,
                "Insert the root");
      Run_Tree (Errors, Insert_Lower_Higher_Input, Insert_Lower_Higher_Output,
                "Insert lower and higher");
      Run_Tree (Errors, BST_Property_Input, BST_Property_Output,
                "BST property");
      Run_Tree (Errors, Absent_Value_Input, Absent_Value_Output,
                "Absent value");
      Run_Tree (Errors, Full_Duplicate_Input, Full_Duplicate_Output,
                "Duplicate at full capacity");
      Run_Tree (Errors, Exhausted_Tree_Input, Exhausted_Tree_Output,
                "Capacity exhausted");
      Run_Tree (Errors, Tree_Size_Empty_Input, Tree_Size_Empty_Output,
                "Size and emptiness");
      Assert (Length (Errors) = 0, To_String (Errors));
   end Test_Binary_Tree_Steps;

   procedure Test_Graph_Steps (Self : in out Test) is
      pragma Unreferenced (Self);
      Errors : Unbounded_String;
   begin
      Run_Graph (Errors, Create_Graph_Input, Create_Graph_Output,
                 "Create with valid capacity");
      Run_Graph (Errors, Invalid_Graph_Input, Invalid_Graph_Output,
                 "Invalid capacity");
      Run_Graph (Errors, Directed_Edge_Input, Directed_Edge_Output,
                 "Directed edge");
      Run_Graph (Errors, Reverse_Direction_Input, Reverse_Direction_Output,
                 "Reverse direction");
      Run_Graph (Errors, Duplicate_Edge_Input, Duplicate_Edge_Output,
                 "Duplicate edge");
      Run_Graph (Errors, Out_Of_Range_Node_Input, Out_Of_Range_Node_Output,
                 "Out-of-range node");
      Run_Graph (Errors, Ordered_Neighbors_Input, Ordered_Neighbors_Output,
                 "Neighbours in increasing order");
      Run_Graph (Errors, No_Edges_Input, No_Edges_Output,
                 "Node with no edges");
      Run_Graph (Errors, Out_Of_Range_Neighbors_Input,
                 Out_Of_Range_Neighbors_Output,
                 "Neighbours of an out-of-range node");
      Run_Graph (Errors, Graph_Size_Empty_Input, Graph_Size_Empty_Output,
                 "Count edges and emptiness");
      Assert (Length (Errors) = 0, To_String (Errors));
   end Test_Graph_Steps;
end Data_Structures_Advanced_Tests;
