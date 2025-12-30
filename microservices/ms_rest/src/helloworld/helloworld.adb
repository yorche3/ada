with AWS.Messages;

package body Helloworld is

   function Greetings (Request : AWS.Status.Data) return AWS.Response.Data is
      pragma Unreferenced (Request);
   begin
      return AWS.Response.Build
        (Content_Type => "application/json",
         Message_Body => "{""message"": ""Hello, World!""}");
   end Greetings;

   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data is
      URI : constant String := AWS.Status.URI (Request);
   begin
      if URI = "/helloworld/hello" then
         return Greetings (Request);
      else
         return AWS.Response.Build
           (Content_Type => "text/plain",
            Message_Body => "Not Found",
            Status_Code  => AWS.Messages.S404);
      end if;
   end Dispatch;

end Helloworld;
