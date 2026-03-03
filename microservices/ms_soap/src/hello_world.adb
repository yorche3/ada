with Ada.Exceptions;
with Ada.Streams;
with Ada.Text_IO;
with Ada.Strings.Unbounded;

with AWS.MIME;
with AWS.Parameters;
with AWS.Response;
with AWS.Status;

with DOM.Core;
with DOM.Readers;
with Input_Sources.Strings;
with Unicode.CES;
with Unicode.CES.Utf8;

package body Hello_World is

   use Ada.Strings.Unbounded;

   function Handler (Request : AWS.Status.Data) return AWS.Response.Data is
      use type AWS.Status.Request_Method;
      Input    : Input_Sources.Strings.String_Input;
      Reader   : DOM.Readers.Tree_Reader;
      Doc      : DOM.Core.Document;

      function Get_Payload (Req : AWS.Status.Data) return String is
         use Ada.Streams;
         Data : constant Stream_Element_Array := AWS.Status.Binary_Data (Req);
         Res  : String (1 .. Integer (Data'Length));
      begin
         for I in Data'Range loop
            Res (Integer (I - Data'First + 1)) := Character'Val (Integer (Data (I)));
         end loop;
         return Res;
      end Get_Payload;

      Payload  : constant String := Get_Payload (Request);
      Response : Unbounded_String;
   begin
      if AWS.Parameters.Exist (AWS.Status.Parameters (Request), "wsdl") then
         return AWS.Response.Build
           (Content_Type => "text/xml",
            Message_Body =>
               "<?xml version=""1.0"" encoding=""UTF-8""?>" &
               "<definitions xmlns=""http://schemas.xmlsoap.org/wsdl/"" " &
               "xmlns:soap12=""http://schemas.xmlsoap.org/wsdl/soap12/"" " &
               "xmlns:tns=""http://example.org/soap"" " &
               "xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" " &
               "targetNamespace=""http://example.org/soap"" " &
               "name=""HelloService"">" &
               "  <types>" &
               "    <xsd:schema targetNamespace=""http://example.org/soap"">" &
               "      <xsd:element name=""HelloRequest"">" &
               "        <xsd:complexType/>" &
               "      </xsd:element>" &
               "      <xsd:element name=""HelloResponse"">" &
               "        <xsd:complexType>" &
               "          <xsd:sequence>" &
               "            <xsd:element name=""Message"" type=""xsd:string""/>" &
               "          </xsd:sequence>" &
               "        </xsd:complexType>" &
               "      </xsd:element>" &
               "    </xsd:schema>" &
               "  </types>" &
               "  <message name=""HelloRequest"">" &
               "    <part name=""parameters"" element=""tns:HelloRequest""/>" &
               "  </message>" &
               "  <message name=""HelloResponse"">" &
               "    <part name=""parameters"" element=""tns:HelloResponse""/>" &
               "  </message>" &
               "  <portType name=""HelloPortType"">" &
               "    <operation name=""Hello"">" &
               "      <input message=""tns:HelloRequest""/>" &
               "      <output message=""tns:HelloResponse""/>" &
               "    </operation>" &
               "  </portType>" &
               "  <binding name=""HelloBinding"" type=""tns:HelloPortType"">" &
               "    <soap12:binding style=""document"" transport=""http://schemas.xmlsoap.org/soap/http""/>" &
               "    <operation name=""Hello"">" &
               "      <soap12:operation soapAction=""http://example.org/soap/Hello""/>" &
               "      <input>" &
               "        <soap12:body use=""literal""/>" &
               "      </input>" &
               "      <output>" &
               "        <soap12:body use=""literal""/>" &
               "      </output>" &
               "    </operation>" &
               "  </binding>" &
               "  <service name=""HelloService"">" &
               "    <port name=""HelloPort"" binding=""tns:HelloBinding"">" &
               "      <soap12:address location=""http://localhost:8161/helloworld""/>" &
               "    </port>" &
               "  </service>" &
               "</definitions>");
      end if;

      if AWS.Status.Method (Request) /= AWS.Status.POST then
         return AWS.Response.Build
           (Content_Type => "text/plain",
            Message_Body => "Service is running. Use POST for SOAP requests.");
      end if;

      if Payload'Length = 0 then
         Ada.Text_IO.Put_Line ("Error: Empty Payload. Content-Length: " & Integer'Image (Integer (AWS.Status.Content_Length (Request))));
         return AWS.Response.Build
           (Content_Type => "text/plain",
            Message_Body => "Error: Empty request body. Content-Length: " & Integer'Image (Integer (AWS.Status.Content_Length (Request))));
      end if;

      Ada.Text_IO.Put_Line ("Received SOAP Request...");

      --  Parse the incoming XML payload using XMLAda
      Input_Sources.Strings.Open (Payload, Unicode.CES.Utf8.Utf8_Encoding, Input);
      DOM.Readers.Parse (Reader, Input);
      Doc := DOM.Readers.Get_Tree (Reader);
      DOM.Readers.Free (Reader);

      --  Construct the SOAP Response
      Append (Response, "<?xml version=""1.0""?>");
      Append (Response, "<soap:Envelope xmlns:soap=""http://www.w3.org/2003/05/soap-envelope"">");
      Append (Response, "  <soap:Body>");
      Append (Response, "    <m:HelloResponse xmlns:m=""http://example.org/soap"">");
      Append (Response, "      <m:Message>Hello from XMLAda SOAP over AWS!</m:Message>");
      Append (Response, "    </m:HelloResponse>");
      Append (Response, "  </soap:Body>");
      Append (Response, "</soap:Envelope>");

      return AWS.Response.Build
        (Content_Type => "application/soap+xml",
         Message_Body => To_String (Response));
   exception
      when E : others =>
         return AWS.Response.Build
           (Content_Type => AWS.MIME.Text_Plain,
            Message_Body => "Error: " & Ada.Exceptions.Exception_Message (E));
   end Handler;

end Hello_World;
