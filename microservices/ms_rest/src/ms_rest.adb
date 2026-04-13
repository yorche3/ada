with AWS.Config.Set;
with AWS.Dispatchers.Callback;
with AWS.Server;
with Routes;
with Logging;

procedure Ms_Rest is
   WS   : AWS.Server.HTTP;
   Disp : AWS.Dispatchers.Callback.Handler;
   Cfg  : AWS.Config.Object;
begin
   --  Inicializa el sistema de logging (escribe en ms_rest.log)
   Logging.Initialize (Log_File => "ms_rest.log");
   Logging.Info ("ms_rest starting on port 8080");

   --  Configure the server port
   AWS.Config.Set.Server_Port (Cfg, 8080);

   --  Register the main dispatcher
   Disp := AWS.Dispatchers.Callback.Create (Routes.Dispatch'Access);

   --  Start the server
   AWS.Server.Start (WS, Dispatcher => Disp, Config => Cfg);
   Logging.Info ("ms_rest server started, waiting for requests");

   --  Keep the server running
   AWS.Server.Wait (AWS.Server.Forever);

   Logging.Info ("ms_rest shutting down");
   Logging.Finalize;
end Ms_Rest;
