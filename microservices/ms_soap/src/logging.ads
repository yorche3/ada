with GNATCOLL.Traces;
with AWS.Status;

package Logging is

   -- Inicialización con archivo de log
   procedure Initialize(Log_File : String := "ms_soap.log");

   -- Logger para diferentes componentes
   Server_Logger    : constant GNATCOLL.Traces.Trace_Handle := 
     GNATCOLL.Traces.Create("MS_SOAP.SERVER");
   Routes_Logger    : constant GNATCOLL.Traces.Trace_Handle := 
     GNATCOLL.Traces.Create("MS_SOAP.ROUTES");
   HelloUser_Logger : constant GNATCOLL.Traces.Trace_Handle := 
     GNATCOLL.Traces.Create("MS_SOAP.HELLOUSER");
   HelloWorld_Logger: constant GNATCOLL.Traces.Trace_Handle := 
     GNATCOLL.Traces.Create("MS_SOAP.HELLOWORLD");
   SOAP_Logger      : constant GNATCOLL.Traces.Trace_Handle := 
     GNATCOLL.Traces.Create("MS_SOAP.SOAP");
   XML_Logger       : constant GNATCOLL.Traces.Trace_Handle := 
     GNATCOLL.Traces.Create("MS_SOAP.XML");

   -- Envolturas simplificadas para logging
   procedure Info  (Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger);
   procedure Error (Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger);
   procedure Debug (Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger);
   procedure Warning (Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger);

   -- Logging especializado para peticiones SOAP
   procedure Log_SOAP_Request
     (Logger      : GNATCOLL.Traces.Trace_Handle;
      Request     : AWS.Status.Data;
      Operation   : String;
      Client_IP   : String;
      Message     : String := "");

   -- Logging de procesamiento XML
   procedure Log_XML_Processing
     (Logger    : GNATCOLL.Traces.Trace_Handle;
      Operation : String;
      Status    : String;
      Details   : String := "");

   procedure Finalize;

end Logging;