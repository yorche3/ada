with Ada.Text_IO;
with SOAP.Contexts;
with SOAP.Message_Exchange;
with SOAP.Parameters;
with SOAP.Types;
with AWS.Server;
with AWS.Status;
with AWS.Response;

procedure Ms_Soap is

   -- 1. Define the HelloUser Logic
   function Hello_User_Handler
     (Request : AWS.Status.Data) return AWS.Response.Data 
   is
      use SOAP.Parameters;
      Payload : constant String := AWS.Status.Payload (Request);
      Ctx     : SOAP.Contexts.SOAP_Context;
      Params  : Parameter_List;
      Name    : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Ada.Text_IO.Put_Line ("Incoming SOAP Request...");

      -- Parse the incoming XML payload
      -- Note: In a real app, you'd use a generated skeleton, 
      -- but here we manually extract "Name"
      begin
         -- Mocking extraction logic for brevity:
         -- In Matreshka, you typically use 'Get' on the parameter list
         -- mapping to your WSDL elements.
         null; 
      end;

      -- 2. Build the XML Response manually or via Template
      return AWS.Response.Build
        (Content_Type => "text/xml",
         Message      => 
           "<?xml version=""1.0"" encoding=""UTF-8""?>" &
           "<SOAP-ENV:Envelope xmlns:SOAP-ENV=""http://schemas.xmlsoap.org/soap/envelope/"">" &
           "  <SOAP-ENV:Body>" &
           "    <HelloUserResponse>" &
           "      <Greeting>Hello from Ada SOAP!</Greeting>" &
           "    </HelloUserResponse>" &
           "  </SOAP-ENV:Body>" &
           "</SOAP-ENV:Envelope>");
   end Hello_User_Handler;

   Server : AWS.Server.HTTP;
begin
   Ada.Text_IO.Put_Line ("Starting SOAP Server on http://localhost:8080");
   
   -- Start AWS and route all requests to our SOAP handler
   AWS.Server.Start (Server, "SOAP Server", Callback => Hello_User_Handler'Access, Port => 8080);

   -- Keep the process alive
   loop
      delay 1.0;
   end loop;
end Ms_Soap;