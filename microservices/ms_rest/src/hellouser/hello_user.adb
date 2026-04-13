with AWS.Messages;
with AWS.Translator;
with User_Protocols;
with Error_Response;
with Logging;
with Ada.Exceptions;

package body Hello_User is

   function Greetings (Request : AWS.Status.Data) return AWS.Response.Data is
      use User_Protocols;
      
      Content : constant String := AWS.Translator.To_String (AWS.Status.Binary_Data (Request));
      User_Data : User_Request;
      Validated_Result : Validation_Result;
   begin
      if Content = "" then
         Logging.Warning ("Empty request body received");
         return Error_Response.Build_Error_Response (Error_Response.Bad_Request);
      end if;

      Validated_Result := Create_From_JSON (Content, User_Data);
      
      if Validated_Result = Valid then
         Logging.Info ("Valid request for user: " & Get_Name (User_Data));
         return Error_Response.Build_Success_Response (Get_Name (User_Data));
      else
         Logging.Warning ("Validation error: " & Validated_Result'Image);
         return Error_Response.Validation_To_Error_Response (Validated_Result);
      end if;

   exception
      when E : others =>
         Logging.Error ("Unhandled exception: " & Ada.Exceptions.Exception_Information (E));
         return Error_Response.Build_Error_Response (Error_Response.Server_Error);
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

end Hello_User;