with Ada.Text_IO;                use Ada.Text_IO;
with Ada.Strings.Fixed;          use Ada.Strings.Fixed;
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
      --  Saltar nodos nulos (elementos opcionales del AST)
      if Node.Is_Null then
         return;
      end if;

      --  Aplicar acción al nodo actual
      Process (Node);

      --  Recorrer todos los hijos
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
      --  Recorrer todos los descendientes del nodo loop
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

            procedure Find_Loops (N : Ada_Node'Class) is
         begin
            --  Solo verificamos Ada_Loop_Stmt (loop básico sin for/while).
            --  Ada_For_Loop_Stmt es inherentemente acotado, no necesita exit.
            --  Ada_While_Loop_Stmt tiene condición de salida explícita.
            if N.Kind = Ada_Loop_Stmt then
               Check_Loop_Statement (N, File_Path, Findings);
            end if;
         end Find_Loops;
   begin
      Ctx := Create_Context;
      Unit := Ctx.Get_From_File (File_Path);

      if Unit.Has_Diagnostics then
         Put_Line ("    [AST] Parse errors in " & File_Path &
                    " - falling back to pattern matching");
         return;
      end if;

      Root := Unit.Root;

      if Root.Is_Null then
         Put_Line ("    [AST] Empty AST for " & File_Path);
         return;
      end if;

      Put_Line ("    [AST] Analizando árbol sintáctico...");
      Visit_Descendants (Root, Find_Loops'Access);

   exception
      when E : others =>
         Put_Line ("    [AST] Error: " & Exception_Message (E));
         Put_Line ("    [AST] Fallback a pattern matching.");
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