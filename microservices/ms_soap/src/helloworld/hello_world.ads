with AWS.Status;
with AWS.Response;

package Hello_World is
   function Greetings (Request : AWS.Status.Data) return AWS.Response.Data;
   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data;
end Hello_World;
