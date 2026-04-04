with Gtk.Main;
--with HelloWorld;
with HelloUser;

procedure GUIApp is
begin
   Gtk.Main.Init;
   --HelloWorld.Run;
   HelloUser.Run;
   Gtk.Main.Main;
end GUIApp;
