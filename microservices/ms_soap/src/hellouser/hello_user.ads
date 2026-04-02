with AWS.Status;
with AWS.Response;

package Hello_User is
   function Greetings (Request : AWS.Status.Data) return AWS.Response.Data;
   function Wdsls (Request : AWS.Status.Data) return AWS.Response.Data;
   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data;
end Hello_User;
