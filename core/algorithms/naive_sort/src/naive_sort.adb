package body Naive_Sort is
   --  Selection_Sort : sorts an array of integers using the selection sort algorithm
   --  Input: Arr - an array of integers to be sorted
   --  Output: a new array containing the sorted integers from Arr
   function Selection_Sort (Arr : Integer_Array) return Integer_Array is
      Result : Integer_Array (Arr'Range) := Arr;
      N : constant Natural := Arr'Length;
   begin
      --  Arr is a value type and can never be null; only emptiness is
      --  representable and checked here (see Naive_Sort spec).
      if Arr'Length = 0 then
         return Result;
      end if;
      --  if n <= 1, the array is already sorted
      if N <= 1 then
         return Result;
      end if;

      --  perform selection sort
      for I in Result'First .. Result'Last loop
         declare
            Min_Index : Natural := I;
         begin
            for J in I + 1 .. Result'Last loop
               if Result (J) < Result (Min_Index) then
                  Min_Index := J;
               end if;
            end loop;
            if Min_Index /= I then
               declare
                  Temp : Integer := Result (I);
               begin
                  Result (I) := Result (Min_Index);
                  Result (Min_Index) := Temp;
               end;
            end if;
         end;
      end loop;
      return Result;
   end Selection_Sort;

   --  Bubble_Sort : sorts an array of integers using the bubble sort algorithm
   --  Input: Arr - an array of integers to be sorted
   --  Output: a new array containing the sorted integers from Arr
   function Bubble_Sort (Arr : Integer_Array) return Integer_Array is
      Result : Integer_Array (Arr'Range) := Arr;
      N : constant Natural := Arr'Length;
   begin
      --  Arr is a value type and can never be null; only emptiness is
      --  representable and checked here (see Naive_Sort spec).
      if Arr'Length = 0 then
         return Result;
      end if;
      --  if n <= 1, the array is already sorted
      if N <= 1 then
         return Result;
      end if;

      --  perform bubble sort
      for I in Result'First .. Result'Last - 1 loop
         declare
            Swapped : Boolean := False;
         begin
            for J in Result'First .. Result'Last - 1 - I loop
               if Result (J) > Result (J + 1) then
                  declare
                     Temp : Integer := Result (J);
                  begin
                     Result (J) := Result (J + 1);
                     Result (J + 1) := Temp;
                  end;
                  Swapped := True;
               end if;
            end loop;
            exit when not Swapped;
         end;
      end loop;
      return Result;
   end Bubble_Sort;

   --  Insertion_Sort : sorts an array of integers using the insertion sort algorithm
   --  Input: Arr - an array of integers to be sorted
   --  Output: a new array containing the sorted integers from Arr
   function Insertion_Sort (Arr : Integer_Array) return Integer_Array is
      Result : Integer_Array (Arr'Range) := Arr;
      N : constant Natural := Arr'Length;
   begin
      --  Arr is a value type and can never be null; only emptiness is
      --  representable and checked here (see Naive_Sort spec).
      if Arr'Length = 0 then
         return Result;
      end if;
      --  if n <= 1, the array is already sorted
      if N <= 1 then
         return Result;
      end if;

      --  perform insertion sort
      for I in Result'First + 1 .. Result'Last loop
         declare
            Key : constant Integer := Result (I);
            J : Integer := I - 1;
         begin
            while J >= Result'First and then Result (J) > Key loop
               Result (J + 1) := Result (J);
               J := J - 1;
            end loop;
            Result (J + 1) := Key;
         end;
      end loop;
      return Result;
   end Insertion_Sort;
end Naive_Sort;