with AWS.Messages;
with AWS.Translator;
with GNATCOLL.JSON;
with Ada.Strings.Fixed;
with Ada.Strings;

package body Hellouser is

   -- Constantes para evitar repetición
   JSON_Type : constant String := "application/json";

   function Greetings (Request : AWS.Status.Data) return AWS.Response.Data is
      use GNATCOLL.JSON;
      use Ada.Strings.Fixed;

      Content : constant String := AWS.Translator.To_String (AWS.Status.Binary_Data (Request));
      JSON    : JSON_Value;
      Name_Val : JSON_Value;
   begin
      -- 1. Validar cuerpo vacío
      if Content = "" then
         return AWS.Response.Build
           (Content_Type => JSON_Type,
            Message_Body => "{""error"": ""Empty Body""}",
            Status_Code  => AWS.Messages.S400);
      end if;

      JSON := GNATCOLL.JSON.Read (Content);

      -- 2. Validar existencia, tipo y valor no nulo
      if JSON.Has_Field ("name") then
         Name_Val := JSON.Get ("name");
         
         if Name_Val.Kind = JSON_String_Type then
            declare
               -- 3. Trim y validación de String vacío
               Raw_Name : constant String := Name_Val.Get;
               Clean_Name : constant String := Trim (Raw_Name, Ada.Strings.Both);
            begin
               if Clean_Name'Length > 0 then
                  return AWS.Response.Build
                    (Content_Type => JSON_Type,
                     Message_Body => "{""message"": ""Hello, " & Clean_Name & "!""}");
               end if;
            end;
         end if;
      end if;

      -- Respuesta por defecto para validación fallida
      return AWS.Response.Build
        (Content_Type => JSON_Type,
         Message_Body => "{""error"": ""Valid 'name' (string) is required""}",
         Status_Code  => AWS.Messages.S400);

   exception
      when others =>
         return AWS.Response.Build
           (Content_Type => JSON_Type,
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
