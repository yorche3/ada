with AUnit.Assertions; use AUnit.Assertions;

with Words; use Words;

package body Words_Test is

   procedure Test_Reverse_String (Self : in out Test) is
   begin
      Assert (Reverse_String ("hello") = "olleh", "should be ""olleh""");
      Assert (Reverse_String ("a") = "a", "should be ""a""");
      Assert (Reverse_String ("") = "", "should be """"");
   end Test_Reverse_String;

   procedure Test_Is_Palindrome (Self : in out Test) is
   begin
      Assert (Is_Palindrome ("race car") = True, "should be True");
      Assert (Is_Palindrome ("level") = True, "should be True");
      Assert (Is_Palindrome ("olleh") = False, "should be False");
      Assert (Is_Palindrome ("a") = True, "should be True");
      Assert (Is_Palindrome ("") = True, "should be True");
   end Test_Is_Palindrome;

   procedure Test_Is_Substring (Self : in out Test) is
   begin
      Assert (KMP_Search ("test", "this is a test") = True, "should be True");
      Assert (KMP_Search ("note", "is a test") = False, "should be False");
      Assert (KMP_Search ("", "any string") = True, "should be True");
      Assert (KMP_Search ("abc", "abc") = True, "should be True");
      Assert (KMP_Search ("abc", "ab") = False, "should be False");
   end Test_Is_Substring;

   procedure Test_LCS (Self : in out Test) is
   begin
      Assert (LCS ("AGGTAB", "GXTXAYB") = 4, "should be 4");
      Assert (LCS ("ABC", "DABC") = 3, "should be 3");
      Assert (LCS ("ABC", "DEF") = 0, "should be 0");
      Assert (LCS ("", "ABC") = 0, "should be 0");
      Assert (LCS ("ABC", "") = 0, "should be 0");
   end Test_LCS;

end Words_Test;