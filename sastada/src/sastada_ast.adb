with Ada.Text_IO;                use Ada.Text_IO;
with Ada.Strings.Fixed;          use Ada.Strings.Fixed;
with Ada.Exceptions;             use Ada.Exceptions;

with Libadalang.Analysis;        use Libadalang.Analysis;
with Libadalang.Common;          use Libadalang.Common;
with Langkit_Support.Slocs;      use Langkit_Support.Slocs;
with Langkit_Support.Text;       use Langkit_Support.Text;

package body SastAda_AST is

   ---------------
   -- Conversión --
   ---------------

   function Ada_Text_To_String (T : Text_Type) return String is
      R : String (1 .. T'Length);
   begin
      for I in T'Range loop
         R (R'First + (I - T'First)) :=
           Character'Val (Wide_Wide_Character'Pos (T (I)));
      end loop;
      return R;
   end Ada_Text_To_String;

   -----------------------------
   -- Package_Name_To_String --
   -----------------------------

   function Package_Name_To_String (N : Ada_Node'Class) return String is
   begin
      return Ada_Text_To_String (Text (N));
   exception
      when others =>
         return "";
   end Package_Name_To_String;

   --------------------------
   -- Recorrido genérico --
   --------------------------

   procedure Visit_Descendants
     (Node    : Ada_Node'Class;
      Process : access procedure (N : Ada_Node'Class))
   is
   begin
      if Node.Is_Null then
         return;
      end if;
      Process (Node);
      for I in 1 .. Children_Count (Node) loop
         Visit_Descendants (Child (Node, I), Process);
      end loop;
   end Visit_Descendants;

   --------------------------
   -- Check_Loop_Statement --
   --------------------------

   procedure Check_Loop_Statement
     (Node      : Ada_Node'Class;
      File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
      Has_Exit : Boolean := False;

      procedure Search_Exit (N : Ada_Node'Class) is
      begin
         if N.Kind = Ada_Exit_Stmt then
            Has_Exit := True;
         end if;
      end Search_Exit;
   begin
      Visit_Descendants (Node, Search_Exit'Access);

      if not Has_Exit then
         Findings.Append
           (Finding_Record'
              (Rule_Id   => To_Unbounded_String ("SAST-005"),
               File_Path => To_Unbounded_String (File_Path),
               Line      => Natural (Sloc_Range (Node).Start_Line),
               Column    => Natural (Sloc_Range (Node).Start_Column),
               Message   => To_Unbounded_String
                 ("Infinite loop risk: no 'exit' statement found " &
                  "within the loop body."),
               Severity  => CRITICAL,
               Kind      => Reliability));
      end if;
   exception
      when E : others =>
         Put_Line ("    [AST] Error en Check_Loop_Statement: " &
                    Exception_Message (E));
   end Check_Loop_Statement;

   ------------------------------
   -- Check_Address_Attribute --
   ------------------------------

   procedure Check_Address_Attribute
     (Node      : Ada_Node'Class;
      File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
   begin
      if Node.Kind = Ada_Attribute_Ref then
         declare
            Ref    : constant Attribute_Ref := Node.As_Attribute_Ref;
            A_Name : constant String :=
              Ada_Text_To_String (Text (Ref.F_Attribute));
         begin
            if A_Name = "Address" then
               Findings.Append
                 (Finding_Record'
                    (Rule_Id   => To_Unbounded_String ("SAST-003"),
                     File_Path => To_Unbounded_String (File_Path),
                     Line      => Natural (Sloc_Range (Node).Start_Line),
                     Column    => Natural (Sloc_Range (Node).Start_Column),
                     Message   => To_Unbounded_String
                       ("Usage of 'Address attribute detected. " &
                        "Consider using access types instead."),
                     Severity  => CRITICAL,
                     Kind      => Security));
            end if;
         end;
      end if;
   end Check_Address_Attribute;

   ---------------------------
   -- Check_Nesting_AST --
   ---------------------------

   procedure Check_Nesting_AST
     (Root      : Ada_Node'Class;
      File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
      Max_Depth : Natural := 0;
      Depth     : Natural := 0;

      procedure Walk (N : Ada_Node'Class) is
      begin
         case N.Kind is
            when Ada_If_Stmt
               | Ada_Elsif_Stmt_Part
               | Ada_Loop_Stmt
               | Ada_While_Loop_Stmt
               | Ada_For_Loop_Stmt
               | Ada_Case_Stmt
               | Ada_Case_Stmt_Alternative
               | Ada_Block_Stmt
            =>
               Depth := Depth + 1;
               if Depth > Max_Depth then
                  Max_Depth := Depth;
               end if;
            when others =>
               null;
         end case;
      end Walk;

      procedure Walk_With_Depth (N : Ada_Node'Class) is
      begin
         if N.Is_Null then
            return;
         end if;

         Walk (N);
         for I in 1 .. Children_Count (N) loop
            Walk_With_Depth (Child (N, I));
         end loop;

         case N.Kind is
            when Ada_If_Stmt
               | Ada_Elsif_Stmt_Part
               | Ada_Loop_Stmt
               | Ada_While_Loop_Stmt
               | Ada_For_Loop_Stmt
               | Ada_Case_Stmt
               | Ada_Case_Stmt_Alternative
               | Ada_Block_Stmt
            =>
               if Depth > 0 then
                  Depth := Depth - 1;
               end if;
            when others =>
               null;
         end case;
      end Walk_With_Depth;
   begin
      Walk_With_Depth (Root);

      if Max_Depth > 4 then
         Findings.Append
           (Finding_Record'
              (Rule_Id   => To_Unbounded_String ("SAST-007"),
               File_Path => To_Unbounded_String (File_Path),
               Line      => 1,
               Column    => 1,
               Message   => To_Unbounded_String
                 ("Deep nesting detected (" &
                  Trim (Natural'Image (Max_Depth), Ada.Strings.Left) &
                  " levels). Maximum allowed is 4."),
               Severity  => MAJOR,
               Kind      => Maintainability));
      end if;
   exception
      when E : others =>
         Put_Line ("    [AST] Error en Check_Nesting_AST: " &
                    Exception_Message (E));
   end Check_Nesting_AST;

   -------------------------
   -- Check_Goto_Statement --
   -------------------------

   procedure Check_Goto_Statement
     (Node      : Ada_Node'Class;
      File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
   begin
      if Node.Kind = Ada_Goto_Stmt then
         Findings.Append
           (Finding_Record'
              (Rule_Id   => To_Unbounded_String ("SAST-006"),
               File_Path => To_Unbounded_String (File_Path),
               Line      => Natural (Sloc_Range (Node).Start_Line),
               Column    => Natural (Sloc_Range (Node).Start_Column),
               Message   => To_Unbounded_String
                 ("GOTO statement detected. " &
                  "Use structured control flow instead."),
               Severity  => CRITICAL,
               Kind      => Code_Style));
      end if;
   end Check_Goto_Statement;

   --------------------------
   -- Check_Null_Statement --
   --------------------------

   procedure Check_Null_Statement
     (Node      : Ada_Node'Class;
      File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
   begin
      if Node.Kind = Ada_Null_Stmt then
         declare
            Parent : constant Ada_Node := Node.Parent;
            Is_Idiomatic : Boolean := False;
         begin
            if not Parent.Is_Null then
               case Parent.Kind is
                  when Ada_Exception_Handler
                     | Ada_Case_Stmt_Alternative
                     | Ada_Elsif_Stmt_Part
                  =>
                     Is_Idiomatic := True;
                  when others =>
                     null;
               end case;
            end if;

            if not Is_Idiomatic then
               Findings.Append
                 (Finding_Record'
                    (Rule_Id   => To_Unbounded_String ("SAST-012"),
                     File_Path => To_Unbounded_String (File_Path),
                     Line      => Natural (Sloc_Range (Node).Start_Line),
                     Column    => Natural (Sloc_Range (Node).Start_Column),
                     Message   => To_Unbounded_String
                       ("Strict null statement outside of cases/" &
                        "exception handlers."),
                     Severity  => MINOR,
                     Kind      => Code_Style));
            end if;
         end;
      end if;
   end Check_Null_Statement;

   --------------------------
   -- Check_Unchecked_With --
   --------------------------

   procedure Check_Unchecked_With
     (Node      : Ada_Node'Class;
      File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
   begin
      if Node.Kind = Ada_With_Clause then
         declare
            Clause : constant With_Clause := Node.As_With_Clause;
         begin
            for I in 1 .. Children_Count (Node) loop
               declare
                  Child_Node : constant Ada_Node := Child (Node, I);
                  Pkg_Name : constant String :=
                    Package_Name_To_String (Child_Node);
               begin
                  if Pkg_Name = "Ada.Unchecked_Deallocation" then
                     Findings.Append
                       (Finding_Record'
                          (Rule_Id   => To_Unbounded_String ("SAST-001"),
                           File_Path => To_Unbounded_String (File_Path),
                           Line      => Natural (Sloc_Range (Node).Start_Line),
                           Column    => Natural (Sloc_Range (Node).Start_Column),
                           Message   => To_Unbounded_String
                             ("Unchecked_Deallocation usage detected. " &
                              "Consider using controlled types."),
                           Severity  => CRITICAL,
                           Kind      => Security));
                  end if;

                  if Pkg_Name = "Ada.Unchecked_Conversion" then
                     Findings.Append
                       (Finding_Record'
                          (Rule_Id   => To_Unbounded_String ("SAST-002"),
                           File_Path => To_Unbounded_String (File_Path),
                           Line      => Natural (Sloc_Range (Node).Start_Line),
                           Column    => Natural (Sloc_Range (Node).Start_Column),
                           Message   => To_Unbounded_String
                             ("Unchecked_Conversion usage detected. " &
                              "Use safe type conversions instead."),
                           Severity  => MAJOR,
                           Kind      => Reliability));
                  end if;
               end;
            end loop;
         end;
      end if;
   end Check_Unchecked_With;

   ------------------------------
   -- Check_Long_Identifier --
   ------------------------------

   procedure Check_Long_Identifier
     (Node      : Ada_Node'Class;
      File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
   begin
      if Node.Kind = Ada_Defining_Name then
         declare
            Name_Text : constant String :=
              Ada_Text_To_String (Text (Node));
         begin
            if Name_Text'Length > 40 then
               Findings.Append
                 (Finding_Record'
                    (Rule_Id   => To_Unbounded_String ("SAST-011"),
                     File_Path => To_Unbounded_String (File_Path),
                     Line      => Natural (Sloc_Range (Node).Start_Line),
                     Column    => Natural (Sloc_Range (Node).Start_Column),
                     Message   => To_Unbounded_String
                       ("Long identifier detected (exceeds 40 characters). " &
                        "Consider using shorter names."),
                     Severity  => MINOR,
                     Kind      => Maintainability));
            end if;
         exception
            when others =>
               null;
         end;
      end if;
   end Check_Long_Identifier;

   -----------------------------
   -- Check_Exception_Handling --
   -----------------------------

   procedure Check_Exception_Handling
     (Root      : Ada_Node'Class;
      File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
      Has_Handler : Boolean := False;
      Has_Call    : Boolean := False;
      Subp_Length : Natural := 0;

      procedure Find_Handler (N : Ada_Node'Class) is
      begin
         if N.Kind = Ada_Exception_Handler then
            Has_Handler := True;
         end if;
      end Find_Handler;

      procedure Find_Calls (N : Ada_Node'Class) is
      begin
         if N.Kind = Ada_Call_Stmt or else N.Kind = Ada_Call_Expr then
            Has_Call := True;
         end if;
      end Find_Calls;

      procedure Check_Subp (N : Ada_Node'Class) is
         SR : constant Source_Location_Range := Sloc_Range (N);
      begin
         if N.Kind = Ada_Subp_Body then
            Subp_Length := Natural (SR.End_Line - SR.Start_Line + 1);

            if Subp_Length > 5 then
               Has_Handler := False;
               Visit_Descendants (N, Find_Handler'Access);

               if not Has_Handler then
                  Has_Call := False;
                  Visit_Descendants (N, Find_Calls'Access);

                  if Has_Call then
                     Findings.Append
                       (Finding_Record'
                          (Rule_Id   => To_Unbounded_String ("SAST-010"),
                           File_Path => To_Unbounded_String (File_Path),
                           Line      => Natural (SR.Start_Line),
                           Column    => Natural (SR.Start_Column),
                           Message   => To_Unbounded_String
                             ("Subprogram >5 lines without exception " &
                              "handler. Consider adding 'exception' " &
                              "block for safety."),
                           Severity  => MAJOR,
                           Kind      => Reliability));
                  end if;
               end if;
            end if;
         end if;
      end Check_Subp;
   begin
      Visit_Descendants (Root, Check_Subp'Access);
   exception
      when E : others =>
         Put_Line ("    [AST] Error en Check_Exception_Handling: " &
                    Exception_Message (E));
   end Check_Exception_Handling;

   -------------------------
   -- Check_Function_Length --
   -------------------------

   procedure Check_Function_Length
     (Root      : Ada_Node'Class;
      File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
      procedure Check_Subp (N : Ada_Node'Class) is
         SR   : constant Source_Location_Range := Sloc_Range (N);
         Len  : constant Natural :=
           Natural (SR.End_Line - SR.Start_Line + 1);
      begin
         if N.Kind = Ada_Subp_Body and then Len > 100 then
            Findings.Append
              (Finding_Record'
                 (Rule_Id   => To_Unbounded_String ("SAST-004"),
                  File_Path => To_Unbounded_String (File_Path),
                  Line      => Natural (SR.Start_Line),
                  Column    => Natural (SR.Start_Column),
                  Message   => To_Unbounded_String
                    ("Function/procedure exceeds 100 lines (" &
                     Trim (Natural'Image (Len), Ada.Strings.Left) &
                     " lines). Consider refactoring."),
                  Severity  => MAJOR,
                  Kind      => Maintainability));
         end if;
      end Check_Subp;
   begin
      Visit_Descendants (Root, Check_Subp'Access);
   exception
      when E : others =>
         Put_Line ("    [AST] Error en Check_Function_Length: " &
                    Exception_Message (E));
   end Check_Function_Length;

   ----------------------------------
   -- Check_Uninitialized_Variable --
   ----------------------------------

   procedure Check_Uninitialized_Variable
     (Root      : Ada_Node'Class;
      File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
      procedure Check_Decl (N : Ada_Node'Class) is
      begin
         if N.Kind = Ada_Object_Decl then
            declare
               Obj      : constant Object_Decl := N.As_Object_Decl;
               Has_Init : Boolean := True;
            begin
               begin
                  Has_Init := not F_Default_Expr  (Obj).Is_Null;
               exception
                  when others =>
                     Has_Init := False;
               end;
               if not Has_Init then
                  Findings.Append
                    (Finding_Record'
                       (Rule_Id   => To_Unbounded_String ("SAST-013"),
                        File_Path => To_Unbounded_String (File_Path),
                        Line      => Natural (Sloc_Range (N).Start_Line),
                        Column    => Natural (Sloc_Range (N).Start_Column),
                        Message   => To_Unbounded_String
                          ("Variable declared without initialization. " &
                           "Always initialize variables to avoid " &
                           "indeterminate values."),
                        Severity  => MAJOR,
                        Kind      => Reliability));
               end if;
            end;
         end if;
      end Check_Decl;
   begin
      Visit_Descendants (Root, Check_Decl'Access);
   exception
      when E : others =>
         Put_Line ("    [AST] Error en Check_Uninitialized_Variable: " &
                    Exception_Message (E));
   end Check_Uninitialized_Variable;

   -------------------------------------
   -- Check_Unvalidated_System_APIs --
   -------------------------------------

   procedure Check_Unvalidated_System_APIs
     (Root      : Ada_Node'Class;
      File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
      procedure Check_With (N : Ada_Node'Class) is
      begin
         if N.Kind = Ada_With_Clause then
            declare
               Clause : constant With_Clause := N.As_With_Clause;
            begin
               for I in 1 .. Children_Count (N) loop
                  declare
                     Child_Node   : constant Ada_Node := Child (N, I);
                     Pkg_Name : constant String :=
                       Package_Name_To_String (Child_Node);
                  begin
                     if Pkg_Name = "Ada.Command_Line" then
                        Findings.Append
                          (Finding_Record'
                             (Rule_Id   => To_Unbounded_String ("SAST-014"),
                              File_Path => To_Unbounded_String (File_Path),
                              Line      => Natural (Sloc_Range (N).Start_Line),
                              Column    => Natural (Sloc_Range (N).Start_Column),
                              Message   => To_Unbounded_String
                                ("Potential unvalidated use: Ada.Command_Line. " &
                                 "Verify that Argument_Count is validated " &
                                 "before accessing arguments."),
                              Severity  => MAJOR,
                              Kind      => Security));
                     end if;

                     if Pkg_Name = "Ada.Directories" then
                        Findings.Append
                          (Finding_Record'
                             (Rule_Id   => To_Unbounded_String ("SAST-014"),
                              File_Path => To_Unbounded_String (File_Path),
                              Line      => Natural (Sloc_Range (N).Start_Line),
                              Column    => Natural (Sloc_Range (N).Start_Column),
                              Message   => To_Unbounded_String
                                ("Potential unvalidated use: Ada.Directories. " &
                                 "Verify that Exists() is called before " &
                                 "operating on files/directories."),
                              Severity  => MAJOR,
                              Kind      => Security));
                     end if;

                     if Pkg_Name = "Ada.Environment_Variables" then
                        Findings.Append
                          (Finding_Record'
                             (Rule_Id   => To_Unbounded_String ("SAST-014"),
                              File_Path => To_Unbounded_String (File_Path),
                              Line      => Natural (Sloc_Range (N).Start_Line),
                              Column    => Natural (Sloc_Range (N).Start_Column),
                              Message   => To_Unbounded_String
                                ("Potential unvalidated use: Ada.Environment_Variables. " &
                                 "Verify that Exists() is called before Value()."),
                              Severity  => MAJOR,
                              Kind      => Security));
                     end if;
                  end;
               end loop;
            end;
         end if;
      end Check_With;
   begin
      Visit_Descendants (Root, Check_With'Access);
   exception
      when E : others =>
         Put_Line ("    [AST] Error en Check_Unvalidated_System_APIs: " &
                    Exception_Message (E));
   end Check_Unvalidated_System_APIs;

   ----------------------
   -- Analyze_File_AST --
   ----------------------

   procedure Analyze_File_AST
     (File_Path : String;
      Findings  : in out Finding_Vectors.Vector)
   is
      Ctx  : Analysis_Context;
      Unit : Analysis_Unit;
      Root : Ada_Node;
      Has_Pure_Pragma : Boolean := False;
      Has_State : Boolean := False;
      Is_Package_Spec : Boolean :=
        Ada.Strings.Fixed.Index (File_Path, ".ads") > 0;

      procedure Find_Stmts (N : Ada_Node'Class) is
      begin
         if N.Kind = Ada_Loop_Stmt then
            Check_Loop_Statement (N, File_Path, Findings);
         end if;
         if N.Kind = Ada_Attribute_Ref then
            Check_Address_Attribute (N, File_Path, Findings);
         end if;
         if N.Kind = Ada_Goto_Stmt then
            Check_Goto_Statement (N, File_Path, Findings);
         end if;
         if N.Kind = Ada_Null_Stmt then
            Check_Null_Statement (N, File_Path, Findings);
         end if;
         if N.Kind = Ada_With_Clause then
            Check_Unchecked_With (N, File_Path, Findings);
         end if;
         if N.Kind = Ada_Defining_Name then
            Check_Long_Identifier (N, File_Path, Findings);
         end if;

         --  SAST-009: Detectar pragmas Pure/Preelaborate
         if N.Kind = Ada_Pragma_Node then
            declare
               Pragma_N : constant Pragma_Node := N.As_Pragma_Node;
               P_Name   : constant String := Ada_Text_To_String (Text (Pragma_N.F_Id));
            begin
               if P_Name = "Pure" or else
                 P_Name = "Preelaborate" or else
                 P_Name = "Preelaborable_Initialization"
               then
                  Has_Pure_Pragma := True;
               end if;
            end;
         end if;

         --  Detectar estado (variables globales) que impidan Pure
         if Is_Package_Spec and then N.Kind = Ada_Object_Decl then
            Has_State := True;
         end if;
      end Find_Stmts;
   begin
      Ctx := Create_Context;
      Unit := Ctx.Get_From_File (File_Path);

      if Unit.Has_Diagnostics then
         Put_Line ("    [AST] Parse errors in " & File_Path);
         return;
      end if;

      Root := Unit.Root;

      if Root.Is_Null then
         Put_Line ("    [AST] Empty AST for " & File_Path);
         return;
      end if;

      Put_Line ("    [AST] Analizando árbol sintáctico...");

      Visit_Descendants (Root, Find_Stmts'Access);

      Check_Nesting_AST (Root, File_Path, Findings);

      if Is_Package_Spec and then not Has_Pure_Pragma and then not Has_State then
         Findings.Append
           (Finding_Record'
              (Rule_Id   => To_Unbounded_String ("SAST-009"),
               File_Path => To_Unbounded_String (File_Path),
               Line      => 1,
               Column    => 1,
               Message   => To_Unbounded_String
                 ("Library-level package should be Pure or Preelaborate " &
                  "when possible to improve safety."),
               Severity  => MINOR,
               Kind      => Code_Style));
      end if;

      Check_Exception_Handling (Root, File_Path, Findings);
      Check_Function_Length (Root, File_Path, Findings);
      Check_Uninitialized_Variable (Root, File_Path, Findings);
      Check_Unvalidated_System_APIs (Root, File_Path, Findings);

   exception
      when E : others =>
         Put_Line ("    [AST] Error: " & Exception_Message (E));
   end Analyze_File_AST;

   -----------------------------
   -- Is_Libadalang_Available --
   -----------------------------

   function Is_Libadalang_Available return Boolean is
      Ctx : Analysis_Context;
   begin
      Ctx := Create_Context;
      return True;
   exception
      when others =>
         return False;
   end Is_Libadalang_Available;

   ------------------------
   -- AST_Engine_Version --
   ------------------------

   function AST_Engine_Version return String is
   begin
      return "Libadalang Ada API";
   end AST_Engine_Version;

end SastAda_AST;