with GNATCOLL.Traces;
with AWS.Status;
with Ada.Directories;
with Ada.Text_IO; use Ada.Text_IO;

package body Logging is
   use GNATCOLL.Traces;

   procedure Initialize(Log_File : String := "ms_soap.log") is
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

   procedure Log_SOAP_Request(
      Logger      : GNATCOLL.Traces.Trace_Handle;
      Request     : AWS.Status.Data;
      Operation   : String;
      Client_IP   : String;
      Message     : String := ""
   ) is
      URI_Str  : constant String := AWS.Status.URI(Request);
      Method   : constant String := AWS.Status.Method(Request);
   begin
      Trace (Logger, 
           Method & " " & URI_Str & 
           " - SOAP Operation: " & Operation &
           " from " & Client_IP &
           (if Message /= "" then " - " & Message else ""));
   end Log_SOAP_Request;

   procedure Log_XML_Processing(
      Logger    : GNATCOLL.Traces.Trace_Handle;
      Operation : String;
      Status    : String;
      Details   : String := ""
   ) is
   begin
      if Status = "OK" then
         Trace (Logger, "XML Processing " & Operation & ": " & Status &
              (if Details /= "" then " - " & Details else ""));
      else
         Trace (Logger, "XML Processing " & Operation & ": " & Status &
               (if Details /= "" then " - " & Details else ""));
      end if;
   end Log_XML_Processing;

end Logging;