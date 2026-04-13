with User_Protocols;
with Logging;

package Error_Response is

   -- Tipo para respuestas SOAP
   type SOAP_Response_Type is (
      SOAP_Success,      -- Respuesta exitosa
      SOAP_Client_Fault, -- Error del cliente (4xx)
      SOAP_Server_Fault  -- Error del servidor (5xx)
   );

   -- Genera respuesta SOAP XML completa
   function Build_SOAP_Response (Response_Type : SOAP_Response_Type;
                                Content       : String;
                                Fault_Code    : String := "";
                                Fault_String  : String := "") 
                               return String;
   
   -- Convierte resultado de validación a fault SOAP
   function Validation_To_SOAP_Fault (Validation : User_Protocols.Validation_Result) 
                                   return String;

   -- Genera respuesta SOAP de éxito con saludo
   function Build_SOAP_Success_Response (User_Name : String) return String;
   
   -- Genera respuesta WSDL
   function Build_WSDL_Response return String;

private

   -- Constantes para SOAP
   SOAP_Env_Namespace : constant String := "http://schemas.xmlsoap.org/soap/envelope/";
   Service_Namespace  : constant String := "http://example.com/hellouser/";
   
   -- Obtener detalles del fault basado en validación
   function Get_Fault_Details (Validation : User_Protocols.Validation_Result) 
                             return String;
   
   -- Obtener fault code apropiado
   function Get_Fault_Code (Validation : User_Protocols.Validation_Result) 
                          return String;
   
   -- Obtener fault string legible
   function Get_Fault_String (Validation : User_Protocols.Validation_Result) 
                            return String;

end Error_Response;