with AWS.Response;

with AWS.Messages;
with User_Protocols;

package Error_Response is

   -- Tipos de errores para el cliente
   type Client_Error_Type is (
      Bad_Request,
      Invalid_Input,
      Missing_Data,
      Server_Error
   );

   -- Genera respuestas de error apropiadas sin filtrar lógica interna
   function Build_Error_Response (Error_Type : Client_Error_Type) return AWS.Response.Data;
   
   -- Convierte resultado de validación a respuesta de error
   function Validation_To_Error_Response (Validation : User_Protocols.Validation_Result) 
                                         return AWS.Response.Data;

   -- Genera respuesta de éxito con saludo
   function Build_Success_Response (User_Name : String) return AWS.Response.Data;

private

   -- Mensajes genéricos que no revelan lógica interna
   function Get_Error_Message (Error_Type : Client_Error_Type) return String;
   function Get_HTTP_Status (Error_Type : Client_Error_Type) return AWS.Messages.Status_Code;

end Error_Response;