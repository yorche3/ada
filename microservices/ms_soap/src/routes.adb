with AWS.Messages;
with AWS.Status;
with Ada.Exceptions;

with Hello_World;
with Hello_User;
with Logging;

package body Routes is

   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data is
      use AWS.Status;
      use Ada.Exceptions;
      
      URI_Req       : constant String := URI (Request);
      Method_Req    : constant String := Method (Request);
      Client_IP : constant String := Peername (Request);
   begin
      -- Log incoming SOAP request with structured logging
      Logging.Log_SOAP_Request (Logging.Routes_Logger, Request, 
                               "route_dispatch", 
                               Client_IP, 
                               "Routing request to service");
      
      if URI_Req'Length >= 11 and then URI_Req (1 .. 11) = "/helloworld" then
         Logging.Info ("Routing to HelloWorld service", Logging.Routes_Logger);
         return Hello_World.Dispatch (Request);
      
      elsif URI_Req'Length >= 10 and then URI_Req (1 .. 10) = "/hellouser" then
         Logging.Info ("Routing to HelloUser SOAP service", Logging.Routes_Logger);
         return Hello_User.Dispatch (Request);
      
      else
         Logging.Warning ("Route not found: " & URI_Req, Logging.Routes_Logger);
         
         -- Return SOAP-compatible fault response for SOAP services
         if Method_Req = "POST" then
            -- SOAP services use POST with XML
            return AWS.Response.Build
              (Content_Type => "application/soap+xml",
               Message_Body => 
                 "<?xml version=""1.0"" encoding=""UTF-8""?>" &
                 "<soap:Envelope xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">" &
                 "  <soap:Body>" &
                 "    <soap:Fault>" &
                 "      <faultcode>soap:Client</faultcode>" &
                 "      <faultstring>Endpoint not found: " & URI_Req & "</faultstring>" &
                 "    </soap:Fault>" &
                 "  </soap:Body>" &
                 "</soap:Envelope>",
               Status_Code => AWS.Messages.S404);
         else
            -- Non-SOAP request (WSDL, etc.)
            return AWS.Response.Build
              (Content_Type => "text/plain",
               Message_Body => "Not Found: " & URI_Req,
               Status_Code => AWS.Messages.S404);
         end if;
      end if;
   
   exception
      when E : others =>
         -- Log unexpected routing error
         Logging.Error ("Unexpected routing error: " & 
                       Ada.Exceptions.Exception_Message (E), Logging.Routes_Logger);
         
         -- Return SOAP fault for internal errors
         return AWS.Response.Build
           (Content_Type => "application/soap+xml",
            Message_Body => 
              "<?xml version=""1.0"" encoding=""UTF-8""?>" &
              "<soap:Envelope xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">" &
              "  <soap:Body>" &
              "    <soap:Fault>" &
              "      <faultcode>soap:Server</faultcode>" &
              "      <faultstring>Internal routing error</faultstring>" &
              "    </soap:Fault>" &
              "  </soap:Body>" &
              "</soap:Envelope>",
            Status_Code => AWS.Messages.S500);
   end Dispatch;

end Routes;
