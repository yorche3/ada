with AWS.Messages;
with AWS.Translator;
with GNATCOLL.JSON;

package body Hellouser is

   function Greetings (Request : AWS.Status.Data) return AWS.Response.Data is
      Content : constant String := AWS.Translator.To_String (AWS.Status.Binary_Data (Request));
      JSON : GNATCOLL.JSON.JSON_Value;
   begin
      if Content = "" then
         return AWS.Response.Build
           (Content_Type => "application/json",
            Message_Body => "{""error"": ""Empty Body""}",
            Status_Code  => AWS.Messages.S400);
      end if;

      JSON := GNATCOLL.JSON.Read (Content);

      if JSON.Has_Field ("name") then
         return AWS.Response.Build
           (Content_Type => "application/json",
            Message_Body => "{""message"": ""Hello, " &
                            GNATCOLL.JSON.Get (GNATCOLL.JSON.Get (JSON, "name")) & "!""}");
      else
         return AWS.Response.Build
           (Content_Type => "application/json",
            Message_Body => "{""error"": ""Missing 'name' field""}",
            Status_Code  => AWS.Messages.S400);
      end if;
   exception
      when others =>
         return AWS.Response.Build
           (Content_Type => "application/json",
            Message_Body => "{""error"": ""Invalid JSON""}",
            Status_Code  => AWS.Messages.S400);
   end Greetings;

   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data is
      URI : constant String := AWS.Status.URI (Request);
   begin
      if URI = "/hellouser/hello" then
         return Greetings (Request);
      else
         return AWS.Response.Build
           (Content_Type => "text/plain",
            Message_Body => "Not Found",
            Status_Code  => AWS.Messages.S404);
      end if;
   end Dispatch;

end Hellouser;
