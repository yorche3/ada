with AUnit.Test_Caller;

with Words_Test; use Words_Test;

package body Words_Suite is

   package Caller is new AUnit.Test_Caller (Words_Test.Test);

   function Suite_Words return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test
         (Caller.Create
            ("Reverse String", Test_Reverse_String'Access));
      Ret.Add_Test
         (Caller.Create
            ("Is Palindrome", Test_Is_Palindrome'Access));
      Ret.Add_Test
         (Caller.Create
            ("Is Substring", Test_Is_Substring'Access));
      Ret.Add_Test
         (Caller.Create
            ("Longest Common Subsequence", Test_LCS'Access));
      return Ret;
   end Suite_Words;
end Words_Suite;