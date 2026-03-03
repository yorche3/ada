with Ada.Text_IO;

with AWS.Config.Set;
with AWS.Server;

with App_Dispatchers;

procedure Ms_Soap is

   WS   : AWS.Server.HTTP;
   Cfg  : AWS.Config.Object;

begin
   --  Configure the server port
   AWS.Config.Set.Server_Port (Cfg, 8161);

   --  Start the server
   AWS.Server.Start (WS, Dispatcher => App_Dispatchers.Create, Config => Cfg);

   Ada.Text_IO.Put_Line ("SOAP Server started on port 8161...");
   AWS.Server.Wait (AWS.Server.Forever);
end Ms_Soap;