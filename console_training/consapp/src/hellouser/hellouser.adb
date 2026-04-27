with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with GNATCOLL.Terminal; use GNATCOLL.Terminal;

package body HelloUser is
   Term_Info : Terminal_Info; -- Variable global para el terminal

   procedure Clear_Screen_If_Terminal is
   begin
      Beginning_Of_Line(Term_Info);
      Clear_To_End_Of_Line(Term_Info);
   end Clear_Screen_If_Terminal;

   procedure Clear_Screen is
   begin
      Put(Character'Val(27) & "[2J" & Character'Val(27) & "[H");
      Flush;
   end Clear_Screen;

   procedure Show_Header is
   begin
      if Has_Colors(Term_Info) then
         Set_Style(Term_Info, Bright);
         Set_Fg(Term_Info, Cyan);
      end if;
      
      Put_Line("+==================================================+");
      Put_Line("|                   WELCOME                        |");
      Put_Line("+==================================================+");
      New_Line;
      
      if Has_Colors(Term_Info) then
         Set_Style(Term_Info, Normal);
         Set_Fg(Term_Info, Unchanged);
      end if;
   end Show_Header;

   procedure Show_Prompt is
   begin
      if Has_Colors(Term_Info) then
         Set_Style(Term_Info, Bright);
         Set_Fg(Term_Info, Cyan);
      end if;
      
      Put("> Username: ");
      Flush;
      
      if Has_Colors(Term_Info) then
         Set_Fg(Term_Info, Unchanged);
         Set_Style(Term_Info, Normal);
      end if;
   end Show_Prompt;

   procedure Show_Error is
   begin
      if Has_Colors(Term_Info) then
         Set_Style(Term_Info, Bright);
         Set_Fg(Term_Info, Red);
      end if;
      
      Put_Line("Error: The field cannot be empty.");
      New_Line;
      
      if Has_Colors(Term_Info) then
         Set_Fg(Term_Info, Unchanged);
         Set_Style(Term_Info, Normal);
      end if;
   end Show_Error;

   procedure Show_Success (Name : String) is
      Box_Width : constant Integer := 45;
      Msg       : constant String := "Hello, " & Name & "! from Ada Console";
      Padding   : Integer;
   begin
      New_Line;
      
      if Has_Colors(Term_Info) then
         Set_Style(Term_Info, Bright);
         Set_Fg(Term_Info, Green);
      end if;
      
      Put_Line("+==================================================+");
      Put("| " & Msg);
      
      Padding := Box_Width - Msg'Length - 5;
      if Padding > 0 then
         for I in 1 .. Padding loop
            Put(" ");
         end loop;
      end if;
      
      Put_Line("|");
      Put_Line("+==================================================+");
      
      if Has_Colors(Term_Info) then
         Set_Fg(Term_Info, Unchanged);
         Set_Style(Term_Info, Normal);
      end if;
   end Show_Success;

   procedure Run is
      Input : Unbounded_String;
      First_Attempt : Boolean := True;
      Terminal_Width : Integer;
   begin
      Init_For_Stdout(Term_Info, Auto); -- Inicializar el terminal
      
      Terminal_Width := Get_Width(Term_Info);
      
      Clear_Screen;
      Show_Header;
      
      loop
         if not First_Attempt then
            Show_Error;
         end if;
         
         Show_Prompt;
         Input := To_Unbounded_String(Get_Line); -- Leer línea de entrada como Unbounded_String
         
         if Is_Valid_Name (Input) then
            declare
               Name_String : constant String := To_String (Trim(Input, Side => Both)); -- Utilizar Trim correctamente
            begin
               Show_Success (Name_String);
               exit;
            end;
         else
            First_Attempt := False;
         end if;
      end loop;
      
      New_Line;
      if Has_Colors(Term_Info) then
         Set_Style(Term_Info, Bright);
         Set_Fg(Term_Info, Magenta);
      end if;
      
      Put("Press Enter to exit...");
      Flush;
      
      if Has_Colors(Term_Info) then
         Set_Fg(Term_Info, Unchanged);
         Set_Style(Term_Info, Normal);
      end if;
      
      declare
         Dummy : String(1..256);
         Last  : Natural;
      begin
         Get_Line(Dummy, Last); -- Esperar entrada del usuario
      end;
      
   exception
      when others =>
         Set_Fg(Term_Info, Unchanged);
         Set_Style(Term_Info, Normal);
         raise;
   end Run;

   function Is_Valid_Name (Name : Unbounded_String) return Boolean is
   begin
      return Length(Trim(Name, Side => Both)) > 0; -- Utilizar Trim correctamente
   end Is_Valid_Name;
end HelloUser;