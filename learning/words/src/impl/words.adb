package body Words is
   function Reverse_String (Str : String) return String is
      Index_I : Natural := 1; -- Index from position 1
      Index_J : Natural := Str'Length; -- Index from las position on string
      Aux : Character; -- Auxiliar for swap characters
      Str_Local : String := Str;
   begin
      while Index_I < Index_J loop
         Aux := Str_Local (Index_I);
         Str_Local (Index_I) := Str_Local (Index_J);
         Str_Local (Index_J) := Aux;
         Index_I := Index_I + 1;
         Index_J := Index_J - 1;
      end loop;
      return Str_Local;
   end Reverse_String;

   function Remove_Spaces (Str : String) return String is
      Str_Local : constant String := Str;
      Result : String (1 .. Str'Length);
      Count  : Integer := 0;

      WS  : constant Character := Character'Val (32);    -- whitespace
      Tab : constant Character := Character'Val (9);     -- tab
      LF  : constant Character := Character'Val (10);    -- line feed
      CR  : constant Character := Character'Val (13);    -- carriage return

      Whitespaces : constant String := WS & LF & CR & Tab;
      CharIsWhite : Boolean := False;
   begin
      for I in Str_Local'Range loop
         for J in Whitespaces'Range loop
            if Whitespaces (J) = Str_Local (I) then
               CharIsWhite := True;
            end if;
         end loop;
         if not CharIsWhite then
            Result (Count + 1) := Str_Local (I);
            Count := Count + 1;
         end if;
         CharIsWhite := False;
      end loop;

      --  Resize the string to actual length
      return Result (1 .. Count);
   end Remove_Spaces;

   function Is_Palindrome (Str : String) return Boolean is
      Str_Local : constant String := Remove_Spaces (Str);
      Index_I : Natural := 1;
      --  Index from las position on string
      Index_J : Natural := Str_Local'Length;
   begin
      while Index_I < Index_J loop
         if Str_Local (Index_I) /= Str_Local (Index_J) then
            return False;
         end if;
         Index_I := Index_I + 1;
         Index_J := Index_J - 1;
      end loop;
      return True;
   end Is_Palindrome;

   function Compute_LPS_Array (Pattern : String) return Natural_Array is
      --  Define the array type for LPS
      P_Len : constant Natural := Pattern'Length;
      LPS : Natural_Array (1 .. P_Len) := (others => 0);
      Len : Natural := 0;
      Index_I : Natural := 2;
   begin
      while Index_I <= P_Len loop
         if Pattern (Index_I) = Pattern (Len + 1) then
            Len := Len + 1;
            LPS (Index_I) := Len;
            Index_I := Index_I + 1;
         else
            if Len /= 0 then
               Len := LPS (Len - 1);
            else
               LPS (Index_I) := 0;
               Index_I := Index_I + 1;
            end if;
         end if;
      end loop;
      return LPS;
   end Compute_LPS_Array;

   function KMP_Search (Pattern : String; Text : String) return Boolean is
      LPS : Natural_Array (1 .. Pattern'Length);
      Index_P : Natural := 1;
      Index_T : Natural := 1;
      Text_Len  : constant Natural := Text'Length;
      Pattern_Len : constant Natural := Pattern'Length;
   begin
      --  Handle empty pattern: matches any string
      if Pattern_Len = 0 then
         return True;
      elsif Pattern_Len > Text_Len then
         return False;
      end if;

      LPS := Compute_LPS_Array (Pattern);
      while Index_T <= Text_Len loop
         if Text (Index_T) = Pattern (Index_P) then
            Index_T := Index_T + 1;
            Index_P := Index_P + 1;
            --  Check if entire pattern matched
            if Index_P > Pattern_Len then
               return True;
            end if;
         else
            if Index_P > 1 then
               Index_P := LPS (Index_P - 1) + 1;
            else
               Index_T := Index_T + 1;
            end if;
         end if;
      end loop;

      return False; -- Not found
   end KMP_Search;


   function LCS (Str1, Str2 : String) return Natural is
      Len1 : constant Natural := Str1'Length;
      Len2 : constant Natural := Str2'Length;

      --  Define a 2D array type for DP table
      type Matrix is array (0 .. Len1, 0 .. Len2) of Natural;
      DP : Matrix := (others => (others => 0));
   begin
      for i in 1 .. Len1 loop
         for j in 1 .. Len2 loop
            if Str1 (i) = Str2 (j) then
               DP (i, j) := DP (i - 1, j - 1) + 1;
            else
               if DP (i - 1, j) > DP (i, j - 1) then
                  DP (i, j) := DP (i - 1, j);
               else
                  DP (i, j) := DP (i, j - 1);
               end if;
            end if;
         end loop;
      end loop;
      return DP (Len1, Len2);
   end LCS;
end Words;