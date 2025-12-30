with Gtk.Main;
with Gtk.Window;
with Gtk.Label;
with Gtk.Widget;

procedure GUIApp is
   Win : Gtk.Window.Gtk_Window;
   Lbl : Gtk.Label.Gtk_Label;

   procedure Quit (Widget : access Gtk.Widget.Gtk_Widget_Record'Class) is
   begin
      Gtk.Main.Main_Quit;
   end Quit;

begin
   Gtk.Main.Init;

   Gtk.Window.Gtk_New (Win);
   Win.Set_Default_Size (400, 200);
   Win.Set_Title ("GUIApp");

   Gtk.Label.Gtk_New (Lbl, "Hello, World!");
   Win.Add (Lbl);

   Win.On_Destroy (Quit'Unrestricted_Access);

   Win.Show_All;
   Gtk.Main.Main;
end GUIApp;
