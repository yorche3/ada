--  Implementación del generador de reportes SonarQube

with Ada.Text_IO;                 use Ada.Text_IO;
with Ada.Strings.Unbounded;       use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;           use Ada.Strings.Fixed;

package body SastAda_SonarQube is

   ----------------------
   -- Generate_Report --
   ----------------------

   function Generate_Report
     (Findings    : Finding_Vectors.Vector;
      Project_Key : String := "ada-project")
      return String
   is
      Result : Unbounded_String;
      First  : Boolean := True;
   begin
      Append (Result, "{");
      Append (Result, ASCII.LF);
      Append (Result, "  ""issues"": [");
      Append (Result, ASCII.LF);

      for F of Findings loop
         if not First then
            Append (Result, ",");
            Append (Result, ASCII.LF);
         end if;
         First := False;

         Append (Result, "    {");
         Append (Result, ASCII.LF);

         Append (Result, "      ""ruleId"": """);
         Append (Result, To_String (F.Rule_Id));
         Append (Result, """,");
         Append (Result, ASCII.LF);

         Append (Result, "      ""engineId"": ""SastAda"",");
         Append (Result, ASCII.LF);

         Append (Result, "      ""severity"": """);
         Append (Result, Severity_To_SonarQube (F.Severity));
         Append (Result, """,");
         Append (Result, ASCII.LF);

         Append (Result, "      ""type"": ""CODE_SMELL"",");
         Append (Result, ASCII.LF);

         Append (Result, "      ""primaryLocation"": {");
         Append (Result, ASCII.LF);

         Append (Result, "        ""message"": """);
         --  Escapamos comillas y caracteres especiales
         declare
            Msg : constant String := To_String (F.Message);
         begin
            for C of Msg loop
               case C is
                  when '"' =>
                     Append (Result, "\""");
                  when '\' =>
                     Append (Result, "\\");
                  when ASCII.LF =>
                     Append (Result, "\n");
                  when ASCII.CR =>
                     Append (Result, "\r");
                  when ASCII.HT =>
                     Append (Result, "\t");
                  when others =>
                     Append (Result, C);
               end case;
            end loop;
         end;
         Append (Result, """,");
         Append (Result, ASCII.LF);

         Append (Result, "        ""filePath"": """);
         Append (Result, To_String (F.File_Path));
         Append (Result, """,");
         Append (Result, ASCII.LF);

         declare
            Line_Str : constant String := Trim (Natural'Image (F.Line), Ada.Strings.Left);
         begin
            Append (Result, "        ""textRange"": {");
            Append (Result, ASCII.LF);
            Append (Result, "          ""startLine"": ");
            Append (Result, Line_Str);
            Append (Result, ",");
            Append (Result, ASCII.LF);

            declare
               Col_Str : constant String := Trim (Natural'Image (F.Column), Ada.Strings.Left);
            begin
               Append (Result, "          ""endLine"": ");
               Append (Result, Line_Str);
               Append (Result, ",");
               Append (Result, ASCII.LF);
               Append (Result, "          ""startColumn"": ");
               Append (Result, Col_Str);
               Append (Result, ",");
               Append (Result, ASCII.LF);
               Append (Result, "          ""endColumn"": ");
               Append (Result, Col_Str);
               Append (Result, ASCII.LF);
            end;
            Append (Result, "        }");
            Append (Result, ASCII.LF);
         end;
         Append (Result, "      }");
         Append (Result, ASCII.LF);

         Append (Result, "    }");
      end loop;

      Append (Result, ASCII.LF);
      Append (Result, "  ]");
      Append (Result, ASCII.LF);
      Append (Result, "}");

      return To_String (Result);
   end Generate_Report;

   ------------------------
   -- Write_Report_File --
   ------------------------

   procedure Write_Report_File
     (Findings    : Finding_Vectors.Vector;
      Output_Path : String;
      Project_Key : String := "ada-project")
   is
      F : File_Type;
   begin
      Create (F, Out_File, Output_Path);
      Put_Line (F, Generate_Report (Findings, Project_Key));
      Close (F);
   end Write_Report_File;

   ----------------------
   -- Should_Pass_PR --
   ----------------------

   function Should_Pass_PR (Findings : Finding_Vectors.Vector) return Boolean is
   begin
      for F of Findings loop
         if F.Severity = BLOCKER or else F.Severity = CRITICAL then
            return False;
         end if;
      end loop;
      return True;
   end Should_Pass_PR;

   -----------------
   -- Summary_Text --
   -----------------

   function Summary_Text (Findings : Finding_Vectors.Vector) return String is
      Result  : Unbounded_String;
      Count_B : Natural := 0;
      Count_C : Natural := 0;
      Count_M : Natural := 0;
      Count_N : Natural := 0;
      Count_I : Natural := 0;
   begin
      for F of Findings loop
         case F.Severity is
            when BLOCKER  => Count_B := Count_B + 1;
            when CRITICAL => Count_C := Count_C + 1;
            when MAJOR    => Count_M := Count_M + 1;
            when MINOR    => Count_N := Count_N + 1;
            when INFO     => Count_I := Count_I + 1;
         end case;
      end loop;

      Append (Result, "=== SAST Report Summary ===");
      Append (Result, ASCII.LF);
      Append (Result, "Total issues found: ");
      Append (Result, Trim (Integer'Image (Integer (Findings.Length)), Ada.Strings.Left));
      Append (Result, ASCII.LF);
      Append (Result, "  BLOCKER: ");
      Append (Result, Trim (Natural'Image (Count_B), Ada.Strings.Left));
      Append (Result, ASCII.LF);
      Append (Result, "  CRITICAL: ");
      Append (Result, Trim (Natural'Image (Count_C), Ada.Strings.Left));
      Append (Result, ASCII.LF);
      Append (Result, "  MAJOR: ");
      Append (Result, Trim (Natural'Image (Count_M), Ada.Strings.Left));
      Append (Result, ASCII.LF);
      Append (Result, "  MINOR: ");
      Append (Result, Trim (Natural'Image (Count_N), Ada.Strings.Left));
      Append (Result, ASCII.LF);
      Append (Result, "  INFO: ");
      Append (Result, Trim (Natural'Image (Count_I), Ada.Strings.Left));
      Append (Result, ASCII.LF);

      if Should_Pass_PR (Findings) then
         Append (Result, "RESULT: PR PASSES - No blocker or critical issues found.");
         Append (Result, ASCII.LF);
         Append (Result, "The pull request can be merged.");
      else
         Append (Result, "RESULT: PR REJECTED - Blocker or critical issues found.");
         Append (Result, ASCII.LF);
         Append (Result, "The pull request must be fixed before merging.");
      end if;

      return To_String (Result);
   end Summary_Text;

end SastAda_SonarQube;
