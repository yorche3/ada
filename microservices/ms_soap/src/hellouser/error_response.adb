with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with User_Protocols;         use User_Protocols;
with Logging;                use Logging;

package body Error_Response is

   ---------------------------------------------------------------------------
   -- Build_SOAP_Response
   ---------------------------------------------------------------------------
   function Build_SOAP_Response (Response_Type : SOAP_Response_Type;
                                Content       : String;
                                Fault_Code    : String := "";
                                Fault_String  : String := "") 
                               return String is
      
      Response : Unbounded_String;
      
   begin
      case Response_Type is
         when SOAP_Success =>
            return Content; -- Content should already be a complete SOAP response
         
         when SOAP_Client_Fault =>
            Append (Response, "<?xml version=""1.0"" encoding=""UTF-8""?>" & ASCII.LF);
            Append (Response, "<soap:Envelope xmlns:soap=""" & SOAP_Env_Namespace & """>" & ASCII.LF);
            Append (Response, "  <soap:Body>" & ASCII.LF);
            Append (Response, "    <soap:Fault>" & ASCII.LF);
            Append (Response, "      <faultcode>soap:Client</faultcode>" & ASCII.LF);
            Append (Response, "      <faultstring>" & Fault_String & "</faultstring>" & ASCII.LF);
            Append (Response, "      <detail>" & ASCII.LF);
            Append (Response, "        <ValidationFault>" & ASCII.LF);
            Append (Response, "          <message>" & Content & "</message>" & ASCII.LF);
            Append (Response, "        </ValidationFault>" & ASCII.LF);
            Append (Response, "      </detail>" & ASCII.LF);
            Append (Response, "    </soap:Fault>" & ASCII.LF);
            Append (Response, "  </soap:Body>" & ASCII.LF);
            Append (Response, "</soap:Envelope>");
            return To_String(Response);
         
         when SOAP_Server_Fault =>
            Append (Response, "<?xml version=""1.0"" encoding=""UTF-8""?>" & ASCII.LF);
            Append (Response, "<soap:Envelope xmlns:soap=""" & SOAP_Env_Namespace & """>" & ASCII.LF);
            Append (Response, "  <soap:Body>" & ASCII.LF);
            Append (Response, "    <soap:Fault>" & ASCII.LF);
            Append (Response, "      <faultcode>soap:Server</faultcode>" & ASCII.LF);
            Append (Response, "      <faultstring>" & Fault_String & "</faultstring>" & ASCII.LF);
            Append (Response, "      <detail>" & ASCII.LF);
            Append (Response, "        <SystemFault>" & ASCII.LF);
            Append (Response, "          <message>" & Content & "</message>" & ASCII.LF);
            Append (Response, "        </SystemFault>" & ASCII.LF);
            Append (Response, "      </detail>" & ASCII.LF);
            Append (Response, "    </soap:Fault>" & ASCII.LF);
            Append (Response, "  </soap:Body>" & ASCII.LF);
            Append (Response, "</soap:Envelope>");
            return To_String(Response);
      end case;
   end Build_SOAP_Response;

   ---------------------------------------------------------------------------
   -- Validation_To_SOAP_Fault
   ---------------------------------------------------------------------------
   function Validation_To_SOAP_Fault (Validation : User_Protocols.Validation_Result) 
                                   return String is
   begin
      Logging.Debug ("Converting validation to SOAP fault: " & 
                    Validation'Image, SOAP_Logger);
      
      return User_Protocols.Create_SOAP_Fault_Response (Validation);
   end Validation_To_SOAP_Fault;

   ---------------------------------------------------------------------------
   -- Build_SOAP_Success_Response
   ---------------------------------------------------------------------------
   function Build_SOAP_Success_Response (User_Name : String) return String is
   begin
      Logging.Info ("Building SOAP success response for user: " & User_Name, SOAP_Logger);
      return User_Protocols.Create_SOAP_Success_Response (User_Name);
   end Build_SOAP_Success_Response;

   ---------------------------------------------------------------------------
   -- Build_WSDL_Response
   ---------------------------------------------------------------------------
   function Build_WSDL_Response return String is
      WSDL : Unbounded_String;
   begin
      Logging.Info ("Generating WSDL response", SOAP_Logger);
      
      Append (WSDL, "<?xml version=""1.0"" encoding=""UTF-8""?>" & ASCII.LF);
      Append (WSDL, "<wsdl:definitions" & ASCII.LF);
      Append (WSDL, "  xmlns:soap=""http://schemas.xmlsoap.org/wsdl/soap/""" & ASCII.LF);
      Append (WSDL, "  xmlns:wsdl=""http://schemas.xmlsoap.org/wsdl/""" & ASCII.LF);
      Append (WSDL, "  xmlns:xsd=""http://www.w3.org/2001/XMLSchema""" & ASCII.LF);
      Append (WSDL, "  xmlns:tns=""" & Service_Namespace & """" & ASCII.LF);
      Append (WSDL, "  targetNamespace=""" & Service_Namespace & """>" & ASCII.LF);
      
      Append (WSDL, "  <wsdl:types>" & ASCII.LF);
      Append (WSDL, "    <xsd:schema targetNamespace=""" & Service_Namespace & """>" & ASCII.LF);
      Append (WSDL, "      <xsd:element name=""greetingsRequest"">" & ASCII.LF);
      Append (WSDL, "        <xsd:complexType>" & ASCII.LF);
      Append (WSDL, "          <xsd:sequence>" & ASCII.LF);
      Append (WSDL, "            <xsd:element name=""name"" type=""xsd:string"" minOccurs=""1""/>" & ASCII.LF);
      Append (WSDL, "          </xsd:sequence>" & ASCII.LF);
      Append (WSDL, "        </xsd:complexType>" & ASCII.LF);
      Append (WSDL, "      </xsd:element>" & ASCII.LF);
      
      Append (WSDL, "      <xsd:element name=""greetingsResponse"">" & ASCII.LF);
      Append (WSDL, "        <xsd:complexType>" & ASCII.LF);
      Append (WSDL, "          <xsd:sequence>" & ASCII.LF);
      Append (WSDL, "            <xsd:element name=""greeting"" type=""xsd:string""/>" & ASCII.LF);
      Append (WSDL, "            <xsd:element name=""status"" type=""xsd:string""/>" & ASCII.LF);
      Append (WSDL, "          </xsd:sequence>" & ASCII.LF);
      Append (WSDL, "        </xsd:complexType>" & ASCII.LF);
      Append (WSDL, "      </xsd:element>" & ASCII.LF);
      Append (WSDL, "    </xsd:schema>" & ASCII.LF);
      Append (WSDL, "  </wsdl:types>" & ASCII.LF);
      
      Append (WSDL, "  <wsdl:message name=""greetingsInput"">" & ASCII.LF);
      Append (WSDL, "    <wsdl:part name=""parameters"" element=""tns:greetingsRequest""/>" & ASCII.LF);
      Append (WSDL, "  </wsdl:message>" & ASCII.LF);
      
      Append (WSDL, "  <wsdl:message name=""greetingsOutput"">" & ASCII.LF);
      Append (WSDL, "    <wsdl:part name=""parameters"" element=""tns:greetingsResponse""/>" & ASCII.LF);
      Append (WSDL, "  </wsdl:message>" & ASCII.LF);
      
      Append (WSDL, "  <wsdl:portType name=""HelloUserPortType"">" & ASCII.LF);
      Append (WSDL, "    <wsdl:operation name=""greetings"">" & ASCII.LF);
      Append (WSDL, "      <wsdl:input message=""tns:greetingsInput""/>" & ASCII.LF);
      Append (WSDL, "      <wsdl:output message=""tns:greetingsOutput""/>" & ASCII.LF);
      Append (WSDL, "    </wsdl:operation>" & ASCII.LF);
      Append (WSDL, "  </wsdl:portType>" & ASCII.LF);
      
      Append (WSDL, "  <wsdl:binding name=""HelloUserBinding"" type=""tns:HelloUserPortType"">" & ASCII.LF);
      Append (WSDL, "    <soap:binding style=""document"" transport=""http://schemas.xmlsoap.org/soap/http""/>" & ASCII.LF);
      Append (WSDL, "    <wsdl:operation name=""greetings"">" & ASCII.LF);
      Append (WSDL, "      <soap:operation soapAction=""greetings"" style=""document""/>" & ASCII.LF);
      Append (WSDL, "      <wsdl:input>" & ASCII.LF);
      Append (WSDL, "        <soap:body use=""literal""/>" & ASCII.LF);
      Append (WSDL, "      </wsdl:input>" & ASCII.LF);
      Append (WSDL, "      <wsdl:output>" & ASCII.LF);
      Append (WSDL, "        <soap:body use=""literal""/>" & ASCII.LF);
      Append (WSDL, "      </wsdl:output>" & ASCII.LF);
      Append (WSDL, "    </wsdl:operation>" & ASCII.LF);
      Append (WSDL, "  </wsdl:binding>" & ASCII.LF);
      
      Append (WSDL, "  <wsdl:service name=""HelloUserService"">" & ASCII.LF);
      Append (WSDL, "    <wsdl:port name=""HelloUserPort"" binding=""tns:HelloUserBinding"">" & ASCII.LF);
      Append (WSDL, "      <soap:address location=""http://localhost:8080/hellouser""/>" & ASCII.LF);
      Append (WSDL, "    </wsdl:port>" & ASCII.LF);
      Append (WSDL, "  </wsdl:service>" & ASCII.LF);
      
      Append (WSDL, "</wsdl:definitions>");
      
      return To_String (WSDL);
   end Build_WSDL_Response;

   ---------------------------------------------------------------------------
   -- PRIVATE FUNCTIONS
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Get_Fault_Details
   ---------------------------------------------------------------------------
   function Get_Fault_Details (Validation : User_Protocols.Validation_Result) 
                             return String is
   begin
      case Validation is
         when Valid =>
            return "Unexpected valid state in fault handler";
         when Invalid_XML_Format =>
            return "SOAP message is not valid XML";
         when Missing_XML_Element =>
            return "Required XML element is missing";
         when Empty_Content =>
            return "Required content is empty";
         when Invalid_Content_Length =>
            return "Content length is outside allowed range";
         when Malformed_XML =>
            return "XML is not well-formed";
         when Unsupported_Operation =>
            return "Requested operation is not supported by this service";
      end case;
   end Get_Fault_Details;

   ---------------------------------------------------------------------------
   -- Get_Fault_Code
   ---------------------------------------------------------------------------
   function Get_Fault_Code (Validation : User_Protocols.Validation_Result) 
                          return String is
   begin
      -- All our validations are client errors for this service
      return "Client";
   exception
      when others =>
         return "Server"; -- Fallback
   end Get_Fault_Code;

   ---------------------------------------------------------------------------
   -- Get_Fault_String
   ---------------------------------------------------------------------------
   function Get_Fault_String (Validation : User_Protocols.Validation_Result) 
                            return String is
   begin
      case Validation is
         when Valid =>
            return "Unexpected success";
         when Invalid_XML_Format =>
            return "Invalid XML Format";
         when Missing_XML_Element =>
            return "Missing Required Element";
         when Empty_Content =>
            return "Empty Content";
         when Invalid_Content_Length =>
            return "Invalid Content Length";
         when Malformed_XML =>
            return "Malformed XML";
         when Unsupported_Operation =>
            return "Unsupported Operation";
      end case;
   end Get_Fault_String;

end Error_Response;