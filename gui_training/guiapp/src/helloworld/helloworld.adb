with Gtk.Window;
with Gtk.Label;
with Gtk.Widget;
with Gtk.Main;

package body HelloWorld is
   procedure Run is
      Window : Gtk.Window.Gtk_Window;
      Label : Gtk.Label.Gtk_Label;

      procedure Quit (Widget : access Gtk.Widget.Gtk_Widget_Record'Class) is
      begin
         Gtk.Main.Main_Quit;
      end Quit;
   begin
      Gtk.Window.Gtk_New (Window);
      Window.Set_Default_Size (400, 200);
      Window.Set_Title ("Hello World");

      Gtk.Label.Gtk_New (Label);
      Label.Set_Text ("Hello World");
      Window.Add (Label);

      Window.On_Destroy (Quit'Unrestricted_Access);
      Window.Show_All;
   end Run;
end HelloWorld;