with Ada.Strings.Fixed;            use Ada.Strings.Fixed;
with Ada.Strings.Unbounded;        use Ada.Strings.Unbounded;

with Logging;                      use Logging;

package body User_Protocols is

   ---------------------------------------------------------------------------
   -- Create_From_SOAP_XML
   ---------------------------------------------------------------------------
   function Create_From_SOAP_XML (XML_Content : String; 
                                 Result      : out User_Request) 
                                return Validation_Result is
   begin
      return Parse_SOAP_XML_To_User (XML_Content, Result);
   end Create_From_SOAP_XML;

   ---------------------------------------------------------------------------
   -- Is_Valid_User
   ---------------------------------------------------------------------------
   function Is_Valid_User (User_Data : User_Request) return Boolean is
   begin
      if Length(User_Data.Name) = 0 then
         return False;
      end if;
      
      return Validate_Name_Content (To_String(User_Data.Name));
   end Is_Valid_User;

   ---------------------------------------------------------------------------
   -- Get_Name
   ---------------------------------------------------------------------------
   function Get_Name (User_Data : User_Request) return String is
   begin
      return To_String(User_Data.Name);
   end Get_Name;

   ---------------------------------------------------------------------------
   -- Create_SOAP_Success_Response
   ---------------------------------------------------------------------------
   function Create_SOAP_Success_Response (User_Name : String) return String is
      Response : Unbounded_String;
   begin
      Append (Response, "<?xml version=""1.0"" encoding=""UTF-8""?>" & ASCII.LF);
      Append (Response, "<soap:Envelope xmlns:soap=""" & SOAP_Namespace & """>" & ASCII.LF);
      Append (Response, "  <soap:Body>" & ASCII.LF);
      Append (Response, "    <ns:greetingsResponse xmlns:ns=""" & Service_Namespace & """>" & ASCII.LF);
      Append (Response, "      <ns:greeting>Hello, " & User_Name & "!</ns:greeting>" & ASCII.LF);
      Append (Response, "      <ns:status>SUCCESS</ns:status>" & ASCII.LF);
      Append (Response, "    </ns:greetingsResponse>" & ASCII.LF);
      Append (Response, "  </soap:Body>" & ASCII.LF);
      Append (Response, "</soap:Envelope>");
      
      return To_String(Response);
   end Create_SOAP_Success_Response;

   ---------------------------------------------------------------------------
   -- Create_SOAP_Fault_Response
   ---------------------------------------------------------------------------
   function Create_SOAP_Fault_Response (Validation : Validation_Result) return String is
      Fault_Code, Fault_String, Detail : Unbounded_String;
      Response : Unbounded_String;
   begin
      case Validation is
         when Valid =>
            Fault_Code := To_Unbounded_String("Server");
            Fault_String := To_Unbounded_String("Unexpected valid state in fault");
            Detail := To_Unbounded_String("");
            
         when Invalid_XML_Format =>
            Fault_Code := To_Unbounded_String("Client");
            Fault_String := To_Unbounded_String("Invalid XML format");
            Detail := To_Unbounded_String("SOAP message format is not valid XML");
            
         when Missing_XML_Element =>
            Fault_Code := To_Unbounded_String("Client");
            Fault_String := To_Unbounded_String("Missing required element");
            Detail := To_Unbounded_String("Required XML element not found in SOAP message");
            
         when Empty_Content =>
            Fault_Code := To_Unbounded_String("Client");
            Fault_String := To_Unbounded_String("Empty content");
            Detail := To_Unbounded_String("Name element cannot be empty");
            
         when Invalid_Content_Length =>
            Fault_Code := To_Unbounded_String("Client");
            Fault_String := To_Unbounded_String("Invalid content length");
            Detail := To_Unbounded_String("Name must be between 1 and 50 characters");
            
         when Malformed_XML =>
            Fault_Code := To_Unbounded_String("Client");
            Fault_String := To_Unbounded_String("Malformed XML");
            Detail := To_Unbounded_String("XML is not well-formed");
            
         when Unsupported_Operation =>
            Fault_Code := To_Unbounded_String("Client");
            Fault_String := To_Unbounded_String("Unsupported operation");
            Detail := To_Unbounded_String("Requested operation is not supported");
      end case;
      
      Append (Response, "<?xml version=""1.0"" encoding=""UTF-8""?>" & ASCII.LF);
      Append (Response, "<soap:Envelope xmlns:soap=""" & SOAP_Namespace & """>" & ASCII.LF);
      Append (Response, "  <soap:Body>" & ASCII.LF);
      Append (Response, "    <soap:Fault>" & ASCII.LF);
      Append (Response, "      <faultcode>soap:Client</faultcode>" & ASCII.LF);
      Append (Response, "      <faultstring>" & To_String(Fault_String) & "</faultstring>" & ASCII.LF);
      
      if Length(Detail) > 0 then
         Append (Response, "      <detail>" & ASCII.LF);
         Append (Response, "        <ValidationError>" & ASCII.LF);
         Append (Response, "          <message>" & To_String(Detail) & "</message>" & ASCII.LF);
         Append (Response, "        </ValidationError>" & ASCII.LF);
         Append (Response, "      </detail>" & ASCII.LF);
      end if;
      
      Append (Response, "    </soap:Fault>" & ASCII.LF);
      Append (Response, "  </soap:Body>" & ASCII.LF);
      Append (Response, "</soap:Envelope>");
      
      return To_String(Response);
   end Create_SOAP_Fault_Response;

   ---------------------------------------------------------------------------
   -- PRIVATE FUNCTIONS
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Validate_Name_Content
   ---------------------------------------------------------------------------
   function Validate_Name_Content (Name_Value : String) return Boolean is
   begin
      -- Basic validation: name should not be empty
      if Name_Value'Length = 0 then
         return False;
      end if;
      
      -- Check length constraints (max 50 characters)
      if Name_Value'Length > 50 then
         return False;
      end if;
      
      -- Basic character validation (allow letters, spaces, hyphens, apostrophes)
      for I in Name_Value'Range loop
         declare
            C : constant Character := Name_Value(I);
         begin
            case C is
               when 'a' .. 'z' | 'A' .. 'Z' | ' ' | '-' | ''' | '.' =>
                  null; -- Valid character
               when others =>
                  -- For now, accept other characters
                  null;
            end case;
         end;
      end loop;
      
      return True;
   end Validate_Name_Content;

   ---------------------------------------------------------------------------
   -- Parse_SOAP_XML_To_User
   -- Parsing manual con Ada.Strings.Fixed (sin dependencias externas XML)
   ---------------------------------------------------------------------------
   function Parse_SOAP_XML_To_User (XML_Data : String;
                                   Result   : out User_Request)
                                  return Validation_Result is
      
      Found_Name : Boolean := False;
      Name_Value : Unbounded_String;

   begin
      Result.Name := Null_Unbounded_String;
      Name_Value  := Null_Unbounded_String;

      -- Verificar presencia del Envelope SOAP (prefijo-agnóstico)
      if Index (XML_Data, "Envelope") = 0 then
         Logging.Error ("Missing SOAP Envelope", XML_Logger);
         return Invalid_XML_Format;
      end if;

      -- Verificar presencia del Body SOAP (prefijo-agnóstico)
      if Index (XML_Data, "Body") = 0 then
         Logging.Error ("Missing SOAP Body", XML_Logger);
         return Missing_XML_Element;
      end if;

      -- Verificar operación greetings
      if Index (XML_Data, "greetings") = 0 then
         Logging.Error ("Missing greetings operation", XML_Logger);
         return Unsupported_Operation;
      end if;

      -- Extraer el valor del elemento <name>
      declare
         Open_Tag  : constant String := "<name>";
         Close_Tag : constant String := "</name>";
         Start_Pos : Natural := Index (XML_Data, Open_Tag);
         End_Pos   : Natural;
      begin
         if Start_Pos = 0 then
            Logging.Error ("Missing name element", XML_Logger);
            return Missing_XML_Element;
         end if;

         Start_Pos := Start_Pos + Open_Tag'Length;
         End_Pos   := Index (XML_Data (Start_Pos .. XML_Data'Last), Close_Tag);

         if End_Pos = 0 or else End_Pos < Start_Pos then
            Logging.Error ("Malformed name tag", XML_Logger);
            return Malformed_XML;
         end if;
         
         if End_Pos - Start_Pos > 50 then
            Logging.Error ("Name content exceeds 50 characters", XML_Logger);
            return Invalid_Content_Length;
         end if;

         Name_Value := To_Unbounded_String (XML_Data (Start_Pos .. End_Pos - 1));
         Found_Name := True;
      end;

      if not Found_Name or else Length (Name_Value) = 0 then
         Logging.Error ("Empty or missing name value", XML_Logger);
         return Empty_Content;
      end if;

      if not Validate_Name_Content (To_String (Name_Value)) then
         Logging.Error ("Invalid name content: " & To_String (Name_Value), XML_Logger);
         return Invalid_Content_Length;
      end if;

      Result.Name := Name_Value;
      Logging.Info ("Successfully parsed user name: " & To_String (Name_Value), XML_Logger);
      return Valid;
      
   exception
      when others =>
         Logging.Error ("XML parsing exception", XML_Logger);
         return Malformed_XML;
   end Parse_SOAP_XML_To_User;

end User_Protocols;