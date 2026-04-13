with GNATCOLL.Traces;
with AWS.Status;

package Logging is

   -- Inicialización con archivo de log
   procedure Initialize(Log_File : String := "ms_rest.log");

   -- Logger para diferentes componentes
   Server_Logger    : constant GNATCOLL.Traces.Trace_Handle := 
     GNATCOLL.Traces.Create("MS_REST.SERVER");
   Routes_Logger    : constant GNATCOLL.Traces.Trace_Handle := 
     GNATCOLL.Traces.Create("MS_REST.ROUTES");
   HelloUser_Logger : constant GNATCOLL.Traces.Trace_Handle := 
     GNATCOLL.Traces.Create("MS_REST.HELLOUSER");
   HelloWorld_Logger: constant GNATCOLL.Traces.Trace_Handle := 
     GNATCOLL.Traces.Create("MS_REST.HELLOWORLD");

   -- Envolturas simplificadas
   procedure Info  (Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger);
   procedure Error (Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger);
   procedure Debug (Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger);
   procedure Warning (Message : String; Logger : GNATCOLL.Traces.Trace_Handle := Server_Logger);

   -- Logging simplificado para peticiones HTTP
   procedure Log_Request
     (Logger  : GNATCOLL.Traces.Trace_Handle;
      Request : AWS.Status.Data;
      Message : String := "");

   procedure Finalize;

end Logging;