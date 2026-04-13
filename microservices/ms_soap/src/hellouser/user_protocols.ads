with Ada.Strings.Unbounded;

package User_Protocols is

   use Ada.Strings.Unbounded;

   -- Tipo para solicitud de usuario vía SOAP
   type User_Request is record
      Name : Unbounded_String;
   end record;

   -- Resultados de validación específicos para SOAP
   type Validation_Result is (Valid, Invalid_XML_Format, Missing_XML_Element, 
                             Empty_Content, Invalid_Content_Length, 
                             Malformed_XML, Unsupported_Operation);

   -- Crear User_Request desde contenido XML SOAP
   function Create_From_SOAP_XML (XML_Content : String; 
                                 Result      : out User_Request) 
                                return Validation_Result;
   
   -- Validar si los datos del usuario son aceptables
   function Is_Valid_User (User_Data : User_Request) return Boolean;
   
   -- Obtener el nombre como String
   function Get_Name (User_Data : User_Request) return String;
   
   -- Generar respuesta SOAP XML para éxito
   function Create_SOAP_Success_Response (User_Name : String) return String;
   
   -- Generar fault SOAP para errores
   function Create_SOAP_Fault_Response (Validation : Validation_Result) return String;

private
   
   -- Validar contenido del nombre
   function Validate_Name_Content (Name_Value : String) return Boolean;
   
   -- Parsear XML específico de SOAP
   function Parse_SOAP_XML_To_User (XML_Data : String; 
                                   Result   : out User_Request) 
                                  return Validation_Result;
   
   -- Constantes para namespaces SOAP
   SOAP_Namespace : constant String := "http://schemas.xmlsoap.org/soap/envelope/";
   Service_Namespace : constant String := "http://example.com/hellouser/";
   
   -- Etiquetas XML esperadas
   Envelope_Tag : constant String := "Envelope";
   Body_Tag     : constant String := "Body";
   Greetings_Tag : constant String := "greetings";
   Name_Tag      : constant String := "name";

end User_Protocols;