package body Naive_Sort is
   -- Selection_Sort : sorts an array of integers using the selection sort algorithm
   -- Input: Arr - an array of integers to be sorted
   -- Output: a new array containing the sorted integers from Arr
   function Selection_Sort (Arr : Integer_Array) return Integer_Array is
      Result : Integer_Array (Arr'Range) := Arr;
      N : constant Natural := Arr'Length;
   begin
      -- verify if arr is null or empty and returns empty array
      if Arr'Length = 0 then
         return Result;
      end if;
      -- if n <= 1, the array is already sorted
      if N <= 1 then
         return Result;
      end if;

      -- perform selection sort
      for I in Result'First .. N - 2 loop
         declare
            Min_Index : Natural := I;
         begin
            for J in I + 1 .. N - 1 loop
               if Result(J) < Result(Min_Index) then
                  Min_Index := J;
               end if;
            end loop;
            if Min_Index /= I then
               declare
                  Temp : Integer := Result(I);
               begin
                  Result(I) := Result(Min_Index);
                  Result(Min_Index) := Temp;
               end;
            end if;
         end;
      end loop;
      return Result;
   end Selection_Sort;
end Naive_Sort;