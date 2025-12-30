with AWS.Status;
with AWS.Response;

package Helloworld is

   function Greetings (Request : AWS.Status.Data) return AWS.Response.Data;
   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data;

end Helloworld;
