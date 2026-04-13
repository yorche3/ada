with Ada.Strings.Unbounded;        use Ada.Strings.Unbounded;
with Ada.Strings;                   use Ada.Strings;

with AWS.Messages;
with AWS.Parameters;
with AWS.Translator;
with Ada.Strings.Fixed;
with Ada.Exceptions;               use Ada.Exceptions;

with User_Protocols;               use User_Protocols;
with Error_Response;               use Error_Response;
with Logging;                      use Logging;

package body Hello_User is

   ---------------------------------------------------------------------------
   -- Greetings - Procesa operación SOAP de saludo
   ---------------------------------------------------------------------------
   function Greetings (Request : AWS.Status.Data) return AWS.Response.Data is
      Content   : constant String := AWS.Translator.To_String (AWS.Status.Binary_Data (Request));
      Client_IP : constant String := AWS.Status.Peername (Request);
      
      User       : User_Request;
      Validation : Validation_Result;
   begin
      -- Log de inicio de procesamiento SOAP
      Log_SOAP_Request (SOAP_Logger, Request, "greetings", Client_IP, 
                        "Processing SOAP greetings request");
      
      -- Verificar contenido vacío
      if Content'Length = 0 then
         Logging.Error ("Empty SOAP body received", SOAP_Logger);
         return AWS.Response.Build
           (Content_Type => "text/xml; charset=utf-8",
            Message_Body => Validation_To_SOAP_Fault (Missing_XML_Element),
            Status_Code  => AWS.Messages.S400);
      end if;
      
      -- Log del contenido XML (solo para depuración)
      Logging.Debug ("SOAP XML Content (first 100 chars): " & 
                     (if Content'Length > 100 then Content (1 .. 100) else Content), XML_Logger);
      
      -- Parsear XML SOAP usando User_Protocols
      Validation := Create_From_SOAP_XML (Content, User);
      
      -- Procesar resultado de validación
      case Validation is
         when Valid =>
            -- Validar contenido del usuario
            if not Is_Valid_User (User) then
               Logging.Error ("Invalid user data after parsing", SOAP_Logger);
               return AWS.Response.Build
                 (Content_Type => "application/soap+xml",
                  Message_Body => Validation_To_SOAP_Fault (Invalid_Content_Length),
                  Status_Code  => AWS.Messages.S400);
            end if;

            -- Obtener nombre y generar respuesta exitosa
            declare
               User_Name : constant String := Get_Name (User);
            begin
               Logging.Info ("Valid request for user: " & User_Name, SOAP_Logger);
               
               return AWS.Response.Build
                 (Content_Type => "application/soap+xml",
                  Message_Body => Build_SOAP_Success_Response (User_Name),
                  Status_Code  => AWS.Messages.S200);
            end;
            
         when others =>
            -- Error de validación
            Logging.Warning ("Validation error: " & Validation'Image, SOAP_Logger);
            
            return AWS.Response.Build
              (Content_Type => "application/soap+xml",
               Message_Body => Validation_To_SOAP_Fault (Validation),
               Status_Code  => AWS.Messages.S400);
      end case;
      
   exception
      when E : others =>
         -- Error inesperado - Server Fault
         declare
            Error_Msg : constant String := Ada.Strings.Fixed.Trim (Ada.Exceptions.Exception_Message (E), Ada.Strings.Both);
         begin
            Logging.Error ("Unexpected error in Greetings: " & Error_Msg, SOAP_Logger);
            
            return AWS.Response.Build
              (Content_Type => "application/soap+xml",
               Message_Body => Build_SOAP_Response (SOAP_Server_Fault,
                                                   "Internal server error",
                                                   "Server",
                                                   "Internal processing error"),
               Status_Code  => AWS.Messages.S500);
         end;
   end Greetings;

   ---------------------------------------------------------------------------
   -- WSDL - Genera documento WSDL del servicio
   ---------------------------------------------------------------------------
   function WSDL (Request : AWS.Status.Data) return AWS.Response.Data is
      Client_IP : constant String := AWS.Status.Peername (Request);
   begin
      -- Log de solicitud WSDL
      Log_SOAP_Request (SOAP_Logger, Request, "WSDL",
                        Client_IP, "Generating WSDL document");
      
      Logging.Info ("Generating WSDL for SOAP service", SOAP_Logger);
      
      return AWS.Response.Build
        (Content_Type => "text/xml",
         Message_Body => Build_WSDL_Response);
   end WSDL;

   ---------------------------------------------------------------------------
   -- Dispatch - Dispatcher principal para rutas /hellouser
   ---------------------------------------------------------------------------
   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data is
   begin
      -- Log del dispatch
      Logging.Debug ("Dispatching to SOAP service", HelloUser_Logger);
      
      if AWS.Parameters.Exist (AWS.Status.Parameters (Request), "wsdl") then
         return WSDL (Request);
      else
         return Greetings (Request);
      end if;
   end Dispatch;

end Hello_User;
