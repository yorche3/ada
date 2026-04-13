with GNATCOLL.Traces;
with AWS.Status;

package body Logging is
   use GNATCOLL.Traces;

   procedure Initialize(Log_File : String := "ms_rest.log") is
   begin
      -- Configuración simple usando el archivo .gnatdebug si existe
      declare
      begin
         Parse_Config_File (Filename => ".gnatdebug");
      exception
         when others =>
            -- Si falla, configurar manualmente
            -- Los loggers ya están configurados como on en la especificación
            null;
      end;
      
      Trace (Server_Logger, "Logger initialized");
   end Initialize;

   procedure Info(Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger) is
   begin
      Trace (Logger, Message);
   end Info;

   procedure Error(Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger) is
   begin
      Trace (Logger, Message);
   end Error;

   procedure Debug(Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger) is
   begin
      Trace (Logger, Message);
   end Debug;

   procedure Warning(Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger) is
   begin
      Trace (Logger, Message);
   end Warning;

   procedure Finalize is
   begin
      GNATCOLL.Traces.Finalize;
   end Finalize;

   procedure Log_Request(
      Logger  : GNATCOLL.Traces.Trace_Handle;
      Request : AWS.Status.Data;
      Message : String := ""
   ) is
      use AWS.Status;
      URI_Str  : constant String := AWS.Status.URI(Request);
      Method   : constant String := AWS.Status.Method(Request);
      Client_IP : constant String := AWS.Status.Peername(Request);
   begin
      Trace (Logger, 
             Method & " " & URI_Str & 
             " from " & Client_IP &
             (if Message /= "" then " - " & Message else ""));
   end Log_Request;

end Logging;