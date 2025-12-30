with AWS.Messages;
with Helloworld;
with Hellouser;

package body Routes is

   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data is
      URI : constant String := AWS.Status.URI (Request);
   begin
      if URI'Length >= 11 and then URI (1 .. 11) = "/helloworld" then
         return Helloworld.Dispatch (Request);
      elsif URI'Length >= 10 and then URI (1 .. 10) = "/hellouser" then
         return Hellouser.Dispatch (Request);
      else
         return AWS.Response.Build
           (Content_Type => "text/plain",
            Message_Body => "Not Found",
            Status_Code  => AWS.Messages.S404);
      end if;
   end Dispatch;

end Routes;
