with Ada.Text_IO;                use Ada.Text_IO;
with Ada.Strings.Fixed;          use Ada.Strings.Fixed;
with Ada.Strings.Unbounded;      use Ada.Strings.Unbounded;
with Ada.Exceptions;             use Ada.Exceptions;

with Libadalang.Analysis;        use Libadalang.Analysis;
with Libadalang.Common;          use Libadalang.Common;
with Langkit_Support.Slocs;      use Langkit_Support.Slocs;

package body SastAda_AST is

   --------------------------
   -- Recorrido manual genérico --
   --------------------------

   procedure Visit_Descendants
     (Node    : Ada_Node'Class;
      Process : access procedure (N : Ada_Node'Class))
   is
   begin
      if Node.Is_Null then return; end if;
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
               Severity  => CRITICAL));
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
      Attr_Image : constant String := Image (Node);
   begin
      if Node.Kind = Ada_Attribute_Ref then
         --  Image returns algo como "{Ada_Attribute_Ref, Address, ...}"
         if Ada.Strings.Fixed.Index (Attr_Image, "Address") > 0 then
            Findings.Append
              (Finding_Record'
                 (Rule_Id   => To_Unbounded_String ("SAST-003"),
                  File_Path => To_Unbounded_String (File_Path),
                  Line      => Natural (Sloc_Range (Node).Start_Line),
                  Column    => Natural (Sloc_Range (Node).Start_Column),
                  Message   => To_Unbounded_String
                    ("Usage of 'Address attribute detected. " &
                     "Consider using access types instead."),
                  Severity  => CRITICAL));
         end if;
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
               | Ada_Subp_Body
               | Ada_Subp_Decl
            =>
               Depth := Depth + 1;
               if Depth > Max_Depth then
                  Max_Depth := Depth;
               end if;
            when others =>
               null;
         end case;
      end Walk;

      --  Recorrido pre-order / post-order con manejo de null nodes
      procedure Walk_With_Depth (N : Ada_Node'Class) is
      begin
         if N.Is_Null then
            return;
         end if;

         Walk (N);
         for I in 1 .. Children_Count (N) loop
            Walk_With_Depth (Child (N, I));
         end loop;
         --  Restaurar profundidad (post-order)
         case N.Kind is
            when Ada_If_Stmt
               | Ada_Elsif_Stmt_Part
               | Ada_Loop_Stmt
               | Ada_While_Loop_Stmt
               | Ada_For_Loop_Stmt
               | Ada_Case_Stmt
               | Ada_Case_Stmt_Alternative
               | Ada_Block_Stmt
               | Ada_Subp_Body
               | Ada_Subp_Decl
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
               Severity  => MAJOR));
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
               Severity  => CRITICAL));
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
         Findings.Append
           (Finding_Record'
              (Rule_Id   => To_Unbounded_String ("SAST-012"),
               File_Path => To_Unbounded_String (File_Path),
               Line      => Natural (Sloc_Range (Node).Start_Line),
               Column    => Natural (Sloc_Range (Node).Start_Column),
               Message   => To_Unbounded_String
                 ("Sentencia null estricta detectada."),
               Severity  => MINOR));
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
      Node_Image : constant String := Image (Node);
   begin
      if Node.Kind = Ada_With_Clause then
         if Ada.Strings.Fixed.Index (Node_Image, "Unchecked_Deallocation") > 0 then
            Findings.Append
              (Finding_Record'
                 (Rule_Id   => To_Unbounded_String ("SAST-001"),
                  File_Path => To_Unbounded_String (File_Path),
                  Line      => Natural (Sloc_Range (Node).Start_Line),
                  Column    => Natural (Sloc_Range (Node).Start_Column),
                  Message   => To_Unbounded_String
                    ("Unchecked_Deallocation usage detected. " &
                     "Consider using controlled types."),
                  Severity  => CRITICAL));
         end if;
         if Ada.Strings.Fixed.Index (Node_Image, "Unchecked_Conversion") > 0 then
            Findings.Append
              (Finding_Record'
                 (Rule_Id   => To_Unbounded_String ("SAST-002"),
                  File_Path => To_Unbounded_String (File_Path),
                  Line      => Natural (Sloc_Range (Node).Start_Line),
                  Column    => Natural (Sloc_Range (Node).Start_Column),
                  Message   => To_Unbounded_String
                    ("Unchecked_Conversion usage detected. " &
                     "Use safe type conversions instead."),
                  Severity  => MAJOR));
         end if;
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
      Node_Image : constant String := Image (Node);
   begin
      if Node.Kind = Ada_Defining_Name then
         --  Image para Defining_Name devuelve algo como
         --  "{Defining_Name, My_Identifier}"
         --  Extraemos solo el nombre limpiando el Image
         if Node_Image'Length > 50 and then
           Ada.Strings.Fixed.Index (Node_Image, "Defining_Name") > 0
         then
            Findings.Append
              (Finding_Record'
                 (Rule_Id   => To_Unbounded_String ("SAST-011"),
                  File_Path => To_Unbounded_String (File_Path),
                  Line      => Natural (Sloc_Range (Node).Start_Line),
                  Column    => Natural (Sloc_Range (Node).Start_Column),
                  Message   => To_Unbounded_String
                    ("Long identifier detected (exceeds 40 characters). " &
                     "Consider using shorter names."),
                  Severity  => MINOR));
         end if;
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

      procedure Find_Handler (N : Ada_Node'Class) is
      begin
         if N.Kind = Ada_Exception_Handler then
            Has_Handler := True;
         end if;
      end Find_Handler;

      procedure Check_Subp (N : Ada_Node'Class) is
      begin
         if N.Kind = Ada_Subp_Body then
            --  Verificar si este subprograma tiene exception handlers
            Has_Handler := False;
            Visit_Descendants (N, Find_Handler'Access);

            if not Has_Handler then
               Findings.Append
                 (Finding_Record'
                    (Rule_Id   => To_Unbounded_String ("SAST-010"),
                     File_Path => To_Unbounded_String (File_Path),
                     Line      => Natural (Sloc_Range (N).Start_Line),
                     Column    => Natural (Sloc_Range (N).Start_Column),
                     Message   => To_Unbounded_String
                       ("Subprogram has no exception handler. " &
                        "Consider adding 'exception' block for safety."),
                     Severity  => MAJOR));
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
                  Severity  => MAJOR));
         end if;
      end Check_Subp;
   begin
      Visit_Descendants (Root, Check_Subp'Access);
   exception
      when E : others =>
         Put_Line ("    [AST] Error en Check_Function_Length: " &
                    Exception_Message (E));
   end Check_Function_Length;

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
               P_Img : constant String := Image (N);
            begin
               if Ada.Strings.Fixed.Index (P_Img, "Pure") > 0 or else
                 Ada.Strings.Fixed.Index (P_Img, "Preelaborate") > 0 or else
                 Ada.Strings.Fixed.Index (P_Img, "Preelaborable") > 0
               then
                  Has_Pure_Pragma := True;
               end if;
            end;
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

      --  SAST-005: Buscar loops sin exit
      --  SAST-003: Buscar 'Address
      --  SAST-001/002: Unchecked_*
      --  SAST-006: GOTO
      --  SAST-012: null;
      --  SAST-011: Identificadores largos
      Visit_Descendants (Root, Find_Stmts'Access);

      --  SAST-007: Anidamiento profundo
      Check_Nesting_AST (Root, File_Path, Findings);

      --  SAST-009: Pure/Preelaborate (solo para .ads)
      if Is_Package_Spec and then not Has_Pure_Pragma then
         Findings.Append
           (Finding_Record'
              (Rule_Id   => To_Unbounded_String ("SAST-009"),
               File_Path => To_Unbounded_String (File_Path),
               Line      => 1,
               Column    => 1,
               Message   => To_Unbounded_String
                 ("Library-level package should be Pure or Preelaborate " &
                  "when possible to improve safety."),
               Severity  => MINOR));
      end if;

      --  SAST-010: Exception handling
      Check_Exception_Handling (Root, File_Path, Findings);

      --  SAST-004: Función/procedure demasiado larga
      Check_Function_Length (Root, File_Path, Findings);

   exception
      when E : others =>
         Put_Line ("    [AST] Error: " & Exception_Message (E));
   end Analyze_File_AST;

   -----------------------------
   -- Is_Libadalang_Available --
   -----------------------------

   function Is_Libadalang_Available return Boolean is
   begin
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