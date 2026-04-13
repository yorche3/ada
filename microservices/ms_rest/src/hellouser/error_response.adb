with AWS.Messages;

package body Error_Response is

   JSON_Content_Type : constant String := "application/json";

   function Build_Error_Response (Error_Type : Client_Error_Type) return AWS.Response.Data is
   begin
      return AWS.Response.Build
        (Content_Type => JSON_Content_Type,
         Message_Body => Get_Error_Message (Error_Type),
         Status_Code  => Get_HTTP_Status (Error_Type));
   end Build_Error_Response;

   function Validation_To_Error_Response (Validation : User_Protocols.Validation_Result) 
                                         return AWS.Response.Data is
   begin
      case Validation is
         when User_Protocols.Invalid_Format =>
            return Build_Error_Response (Bad_Request);
         when User_Protocols.Missing_Field =>
            return Build_Error_Response (Missing_Data);
         when User_Protocols.Empty_Value | User_Protocols.Invalid_Length =>
            return Build_Error_Response (Invalid_Input);
         when User_Protocols.Valid =>
            return Build_Error_Response (Server_Error);
      end case;
   end Validation_To_Error_Response;

   function Build_Success_Response (User_Name : String) return AWS.Response.Data is
      Message_Body : constant String := 
        "{""message"": ""Hello, " & User_Name & "!""}";
   begin
      return AWS.Response.Build
        (Content_Type => JSON_Content_Type,
         Message_Body => Message_Body);
   end Build_Success_Response;

   function Get_Error_Message (Error_Type : Client_Error_Type) return String is
   begin
      case Error_Type is
         when Bad_Request =>
            return "{""error"": ""Invalid request format""}";
         when Invalid_Input =>
            return "{""error"": ""Invalid input provided""}";
         when Missing_Data =>
            return "{""error"": ""Required data is missing""}";
         when Server_Error =>
            return "{""error"": ""Internal server error""}";
      end case;
   end Get_Error_Message;

   function Get_HTTP_Status (Error_Type : Client_Error_Type) return AWS.Messages.Status_Code is
   begin
      case Error_Type is
         when Bad_Request | Invalid_Input | Missing_Data =>
            return AWS.Messages.S400;
         when Server_Error =>
            return AWS.Messages.S500;
      end case;
   end Get_HTTP_Status;

end Error_Response;