with AWS.Config.Set;
with AWS.Dispatchers.Callback;
with AWS.Server;
with Routes;

procedure Ms_Rest is
   WS   : AWS.Server.HTTP;
   Disp : AWS.Dispatchers.Callback.Handler;
   Cfg  : AWS.Config.Object;
begin
   --  Configure the server port
   AWS.Config.Set.Server_Port (Cfg, 8080);

   --  Register the main dispatcher
   Disp := AWS.Dispatchers.Callback.Create (Routes.Dispatch'Access);

   --  Start the server
   AWS.Server.Start (WS, Dispatcher => Disp, Config => Cfg);

   --  Keep the server running
   AWS.Server.Wait (AWS.Server.Forever);
end Ms_Rest;
