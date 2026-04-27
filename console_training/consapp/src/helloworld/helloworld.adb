with Ada.Text_IO; use Ada.Text_IO;
with GNATCOLL.Terminal; use GNATCOLL.Terminal;

package body Helloworld is

   procedure Clear_Screen_If_Terminal (Info : in out Terminal_Info) is
   begin
      -- Solo limpiar la línea actual, no toda la pantalla
      -- (más seguro que intentar limpiar toda la pantalla)
      Beginning_Of_Line(Info);
      Clear_To_End_Of_Line(Info);
   end Clear_Screen_If_Terminal;

   procedure Run is
      Term_Info : Terminal_Info;
      Input_Line : String(1..100);
      Last : Natural;
      Terminal_Width : Integer;
   begin
      -- Inicializar terminal para salida estándar
      Init_For_Stdout(Term_Info, Auto);
      
      -- Obtener ancho del terminal para centrado opcional
      Terminal_Width := Get_Width(Term_Info);
      
      -- Limpiar línea actual
      Clear_Screen_If_Terminal(Term_Info);
      
      -- Mostrar título con estilo si hay colores
      if Has_Colors(Term_Info) then
         -- Estilo para el título
         Set_Style(Term_Info, Bright);
         Set_Fg(Term_Info, Cyan);
         Put_Line("+---------------------------------------------------+");
         Put_Line("|                                                   |");
         Put_Line("|         HELLO FROM ADA CLI WITH GNATCOLL!         |");
         Put_Line("|                                                   |");
         Put_Line("+---------------------------------------------------+");
         
         -- Resetear estilo para texto normal
         Set_Style(Term_Info, Normal);
         
         New_Line(2);
         
         -- Mensaje principal
         Put("  ");
         Set_Fg(Term_Info, Green);
         Put("> ");
         Set_Fg(Term_Info, Yellow);
         Put_Line("Hello world! from Ada CLI");
         
         -- Información del terminal
         Set_Fg(Term_Info, Magenta);
         Put("  Terminal width: ");
         Put_Line(Integer'Image(Terminal_Width));
         Put("  Supports colors: ");
         Put_Line(Boolean'Image(Has_Colors(Term_Info)));
         Put("  Supports ANSI: ");
         Put_Line(Boolean'Image(Has_ANSI_Colors(Term_Info)));
         
         -- Resetear colores
         Set_Fg(Term_Info, Unchanged);
      else
         -- Versión simple sin colores
         Put_Line("====================================================");
         Put_Line("      HELLO FROM ADA CLI WITH GNATCOLL!");
         Put_Line("====================================================");
         New_Line;
         Put("  > Hello world! from Ada CLI");
         New_Line(2);
      end if;
      
      New_Line;
      Put("  Press Enter to continue... ");
      Flush;
      
      -- Esperar entrada
      Get_Line(Input_Line, Last);
      
      -- Finalizar con mensaje de despedida
      if Has_Colors(Term_Info) then
         Set_Fg(Term_Info, Cyan);
         Set_Style(Term_Info, Bright);
         New_Line;
         Put_Line("  Thank you for using Ada!");
         Set_Fg(Term_Info, Unchanged);
         Set_Style(Term_Info, Unchanged);
      else
         New_Line;
         Put_Line("  Thank you for using Ada!");
      end if;
      
   exception
      when others =>
         -- Restaurar terminal en caso de error
         Set_Fg(Term_Info, Unchanged);
         Set_Style(Term_Info, Unchanged);
         raise;
   end Run;

end Helloworld;