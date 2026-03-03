with AWS.Dispatchers;
with AWS.Messages;
with AWS.Response;
with AWS.Status;
with Hello_World;
with Hello_User;

package body App_Dispatchers is

   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data is
      URI : constant String := AWS.Status.URI (Request);
   begin
      if URI'Length >= 11 and then URI (1 .. 11) = "/helloworld" then
         return Hello_World.Handler (Request);
      elsif URI'Length >= 10 and then URI (1 .. 10) = "/hellouser" then
         return Hello_User.Handler (Request);
      else
         return AWS.Response.Build
           (Content_Type => "text/plain",
            Message_Body => "Not Found",
            Status_Code  => AWS.Messages.S404);
      end if;
   end Dispatch;

   function Create return AWS.Dispatchers.Callback.Handler is
   begin
      return AWS.Dispatchers.Callback.Create (Dispatch'Access);
   end Create;

end App_Dispatchers;
