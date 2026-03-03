with AWS.Status;
with AWS.Response;

package Hello_User is
   function Handler (Request : AWS.Status.Data) return AWS.Response.Data;
end Hello_User;
