with AWS.Status;
with AWS.Response;

package Routes is
   function Dispatch (Request : AWS.Status.Data) return AWS.Response.Data;
end Routes;
