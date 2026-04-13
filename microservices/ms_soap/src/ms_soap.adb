with Ada.Text_IO;

with AWS.Config.Set;
with AWS.Dispatchers.Callback;
with AWS.Server;

with Routes;
with Logging;

procedure Ms_Soap is
   WS   : AWS.Server.HTTP;
   Disp : AWS.Dispatchers.Callback.Handler;
   Cfg  : AWS.Config.Object;
begin
   -- Initialize structured logging according to best practices
   Logging.Initialize (Log_File => "ms_soap.log");
   Logging.Info ("SOAP Server initializing on port 8080...");

   -- Configure the server port
   AWS.Config.Set.Server_Port (Cfg, 8080);

   -- Register the main dispatcher
   Disp := AWS.Dispatchers.Callback.Create (Routes.Dispatch'Access);

   -- Start the server
   AWS.Server.Start (WS, Dispatcher => Disp, Config => Cfg);

   Logging.Info ("SOAP Server started and ready for requests");
   Ada.Text_IO.Put_Line ("SOAP Server started on port 8080...");
   
   -- Keep the server running
   AWS.Server.Wait (AWS.Server.Forever);
   
   -- Server is shutting down
   Logging.Info ("SOAP Server shutting down");
   Logging.Finalize;
   
exception
   when others =>
      Logging.Error ("Unexpected error in SOAP server, shutting down...");
      Logging.Finalize;
      raise;
end Ms_Soap;