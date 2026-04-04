with Gtk.Window;
with Gtk.Label;
with Gtk.Main;
with Gtk.Box;
with Gtk.Button;
with Gtk.Widget;
with Ada.Strings.Fixed;
with Gtk.GEntry;

package body HelloUser is

   Window      : Gtk.Window.Gtk_Window;
   Main_Box    : Gtk.Box.Gtk_Box;
   Instruction : Gtk.Label.Gtk_Label;
   Name_Input  : Gtk.GEntry.Gtk_Entry;
   Greet_Btn   : Gtk.Button.Gtk_Button;
   Result_Lbl  : Gtk.Label.Gtk_Label;

   procedure Quit (Widget : access Gtk.Widget.Gtk_Widget_Record'Class) is
      pragma Unreferenced (Widget);
   begin
      Gtk.Main.Main_Quit;
      Gtk.Main.Main_Quit;
   end Quit;

   -- Callback para procesar el nombre cuando se hace clic en el botón
   procedure On_Greet_Clicked (Widget : access Gtk.Button.Gtk_Button_Record'Class) is
      pragma Unreferenced (Widget);
      Input_Text : constant String := Gtk.GEntry.Get_Text (Name_Input);
   begin
      if Is_Valid_Name (To_Unbounded_String (Input_Text)) then
         Result_Lbl.Set_Text (Greetings (Input_Text));
      else
         Result_Lbl.Set_Text ("Invalid name. Please enter a valid name.");
      end if;
   end On_Greet_Clicked;

   procedure Run is
   begin
      Gtk.Window.Gtk_New (Window);
      Window.Set_Default_Size (400, 200);
      Window.Set_Title ("Hello User"); -- Set the window title

      -- Creamos un contenedor vertical para organizar los elementos
      Gtk.Box.Gtk_New_VBox (Main_Box, Homogeneous => False, Spacing => 10);
      
      Gtk.Label.Gtk_New (Instruction, "Enter your name:");
      Gtk.GEntry.Gtk_New (Name_Input);
      Gtk.Button.Gtk_New (Greet_Btn, "Greet Me!");
      Gtk.Label.Gtk_New (Result_Lbl, "");

      -- Añadimos los widgets al contenedor con un poco de padding
      Main_Box.Pack_Start (Instruction, Expand => False, Fill => False, Padding => 5);
      Main_Box.Pack_Start (Name_Input, Expand => False, Fill => False, Padding => 5);
      Main_Box.Pack_Start (Greet_Btn, Expand => False, Fill => False, Padding => 5);
      Main_Box.Pack_Start (Result_Lbl, Expand => False, Fill => False, Padding => 5);

      Window.Add (Main_Box);

      -- Connect events
      Greet_Btn.On_Clicked (On_Greet_Clicked'Unrestricted_Access);
      Window.On_Destroy (Quit'Unrestricted_Access);
      
      Window.Show_All;
   end Run;

   function Greetings (Name : String) return String is
   begin
      return "Hello " & Ada.Strings.Fixed.Trim (Name, Ada.Strings.Both) & "! from Ada GUI";
   end Greetings;

   function Is_Valid_Name (Name : Unbounded_String) return Boolean is
   begin
      return Length (Ada.Strings.Unbounded.Trim (Name, Ada.Strings.Both)) > 0;
   end Is_Valid_Name;
end HelloUser;