with Ada.Exceptions;
with Ada.Strings.Unbounded;

with AWS.Messages;
with AWS.Parameters;
with AWS.Translator;

with DOM.Core;
with DOM.Core.Nodes;
with DOM.Core.Documents;
with DOM.Readers;
with Input_Sources.Strings;
with Unicode.CES.Utf8;

package body Hello_User is

   use Ada.Strings.Unbounded;

   function Greetings (Request : AWS.Status.Data) return AWS.Response.Data is
      use type DOM.Core.Node;
      use type AWS.Status.Request_Method;
      Content  : constant String := AWS.Translator.To_String (AWS.Status.Binary_Data (Request));
      Input    : Input_Sources.Strings.String_Input;
      Reader   : DOM.Readers.Tree_Reader;
      Doc      : DOM.Core.Document;
      Nodes    : DOM.Core.Node_List;
      Name     : Unbounded_String;
      Response : Unbounded_String;
   begin
      --  1. Verificación de cuerpo vacío (equivalente a tu validación REST)
      if Content = "" then
         return AWS.Response.Build
           (Content_Type => "application/soap+xml",
            Message_Body => "<?xml version=""1.0""?><soap:Fault xmlns:soap=""http://www.w3.org/2003/05/soap-envelope"">" &
                            "<soap:Code><soap:Value>soap:Sender</soap:Value></soap:Code>" &
                            "<soap:Reason><soap:Text xml:lang=""en"">Empty Body</soap:Text></soap:Reason></soap:Fault>",
            Status_Code  => AWS.Messages.S400);
      end if;

      --  2. Parseo del XML
      Input_Sources.Strings.Open (Content, Unicode.CES.Utf8.Utf8_Encoding, Input);
      DOM.Readers.Parse (Reader, Input);
      Doc := DOM.Readers.Get_Tree (Reader);

      --  3. Lógica de negocio: Buscar el elemento <Name> (equivalente a JSON.Has_Field ("name"))
      Nodes := DOM.Core.Documents.Get_Elements_By_Tag_Name (Doc, "Name");
      
      if DOM.Core.Nodes.Length (Nodes) > 0 then
         declare
            -- Extraemos el valor del nodo de texto hijo de <Name>
            Val_Node : constant DOM.Core.Node := DOM.Core.Nodes.First_Child (DOM.Core.Nodes.Item (Nodes, 0));
         begin
            if Val_Node /= null and then DOM.Core.Nodes.Node_Value (Val_Node)'Length > 0 then
               Name := To_Unbounded_String (DOM.Core.Nodes.Node_Value (Val_Node));
            else
               -- Si el nodo existe pero está vacío (<Name></Name>)
               DOM.Readers.Free (Reader);
               return AWS.Response.Build
                 (Content_Type => "application/soap+xml",
                  Message_Body => "<?xml version=""1.0""?>" &
                                  "<soap:Envelope xmlns:soap=""http://www.w3.org/2003/05/soap-envelope"">" &
                                  "<soap:Body><soap:Fault><soap:Code><soap:Value>soap:Sender</soap:Value></soap:Code>" &
                                  "<soap:Reason><soap:Text xml:lang=""en"">The 'Name' field cannot be empty</soap:Text></soap:Reason>" &
                                  "</soap:Fault></soap:Body></soap:Envelope>",
                  Status_Code  => AWS.Messages.S400);
            end if;
         end;

         DOM.Readers.Free (Reader);

         --  Construcción de la respuesta SOAP
         Append (Response, "<?xml version=""1.0""?>");
         Append (Response, "<soap:Envelope xmlns:soap=""http://www.w3.org/2003/05/soap-envelope"">");
         Append (Response, "  <soap:Body>");
         Append (Response, "    <m:HelloUserResponse xmlns:m=""http://example.org/soap/user"">");
         Append (Response, "      <m:Message>Hello, " & To_String (Name) & "!</m:Message>");
         Append (Response, "    </m:HelloUserResponse>");
         Append (Response, "  </soap:Body>");
         Append (Response, "</soap:Envelope>");

         return AWS.Response.Build
           (Content_Type => "application/soap+xml",
            Message_Body => To_String (Response));
      else
         DOM.Readers.Free (Reader);
         return AWS.Response.Build
           (Content_Type => "application/soap+xml",
            Message_Body => "<?xml version=""1.0""?><error>Missing 'Name' element</error>",
            Status_Code  => AWS.Messages.S400);
      end if;

   exception
      when E : others =>
         return AWS.Response.Build
           (Content_Type => "application/soap+xml",
            Message_Body => "<?xml version=""1.0""?><error>Invalid XML: " & 
                            Ada.Exceptions.Exception_Message (E) & "</error>",
            Status_Code  => AWS.Messages.S400);
   end Greetings;

   function Wdsls (Request : AWS.Status.Data) return AWS.Response.Data is
   begin
      return AWS.Response.Build
        (Content_Type => "text/xml",
         Message_Body =>
            "<?xml version=""1.0"" encoding=""UTF-8""?>" &
            "<definitions xmlns=""http://schemas.xmlsoap.org/wsdl/"" " &
            "xmlns:soap12=""http://schemas.xmlsoap.org/wsdl/soap12/"" " &
            "xmlns:tns=""http://example.org/soap/user"" " &
            "xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" " &
            "targetNamespace=""http://example.org/soap/user"" " &
            "name=""HelloUserService"">" &
            "  <types>" &
            "    <xsd:schema targetNamespace=""http://example.org/soap/user"">" &
            "      <xsd:element name=""HelloUserRequest"">" &
            "        <xsd:complexType>" &
            "          <xsd:sequence>" &
            "            <xsd:element name=""Name"" type=""xsd:string""/>" &
            "          </xsd:sequence>" &
            "        </xsd:complexType>" &
            "      </xsd:element>" &
            "      <xsd:element name=""HelloUserResponse"">" &
            "        <xsd:complexType>" &
            "          <xsd:sequence>" &
            "            <xsd:element name=""Message"" type=""xsd:string""/>" &
            "          </xsd:sequence>" &
            "        </xsd:complexType>" &
            "      </xsd:element>" &
            "    </xsd:schema>" &
            "  </types>" &
            "  <message name=""HelloUserRequest"">" &
            "    <part name=""parameters"" element=""tns:HelloUserRequest""/>" &
            "  </message>" &
            "  <message name=""HelloUserResponse"">" &
            "    <part name=""parameters"" element=""tns:HelloUserResponse""/>" &
            "  </message>" &
            "  <portType name=""HelloUserPortType"">" &
            "    <operation name=""HelloUser"">" &
            "      <input message=""tns:HelloUserRequest""/>" &
            "      <output message=""tns:HelloUserResponse""/>" &
            "    </operation>" &
            "  </portType>" &
            "  <binding name=""HelloUserBinding"" type=""tns:HelloUserPortType"">" &
            "    <soap12:binding style=""document"" transport=""http://schemas.xmlsoap.org/soap/http""/>" &
            "    <operation name=""HelloUser"">" &
            "      <soap12:operation soapAction=""http://example.org/soap/HelloUser""/>" &
            "      <input><soap12:body use=""literal""/></input>" &
            "      <output><soap12:body use=""literal""/></output>" &
            "    </operation>" &
            "  </binding>" &
            "  <service name=""HelloUserService"">" &
            "    <port name=""HelloUserPort"" binding=""tns:HelloUserBinding"">" &
            "      <soap12:address location=""http://localhost:8081/hellouser""/>" &
            "    </port>" &
            "  </service>" &
            "</definitions>");
   end Wdsls;

   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data is
   begin
      if AWS.Parameters.Exist (AWS.Status.Parameters (Request), "wsdl") then
         return Wdsls (Request);
      else
         return Greetings (Request);
      end if;
   end Dispatch;

end Hello_User;
