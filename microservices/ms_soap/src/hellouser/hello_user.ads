with AWS.Status;
with AWS.Response;

package Hello_User is

   -- Procesa operación SOAP de saludo
   function Greetings (Request : AWS.Status.Data) return AWS.Response.Data;
   
   -- Genera documento WSDL del servicio
   function WSDL (Request : AWS.Status.Data) return AWS.Response.Data;
   
   -- Dispatcher principal para rutas /hellouser
   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data;

end Hello_User;
