with AWS.MIME;
with AWS.Response;
with AWS.Status;

package body Hello_User is

   function Handler (Request : AWS.Status.Data) return AWS.Response.Data is
      URI : constant String := AWS.Status.URI (Request);
      --  URI is expected to be /hellouser or /hellouser/<id>
      --  Length of "/hellouser/" is 11.
      ID  : constant String := (if URI'Length > 11 then URI (12 .. URI'Last) else "");
   begin
      if ID /= "" then
         return AWS.Response.Build
           (Content_Type => AWS.MIME.Text_Plain,
            Message_Body => "Hello User! Your ID is: " & ID);
      else
         return AWS.Response.Build
           (Content_Type => AWS.MIME.Text_Plain,
            Message_Body => "Hello User!");
      end if;
   end Handler;

end Hello_User;
