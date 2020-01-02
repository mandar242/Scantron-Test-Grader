with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;       
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;  

procedure scada is

   package SU renames Ada.Strings.Unbounded;

   ran: constant positive := 100;
   subtype Index is positive range 1 .. ran;
   type My_Int_Array is array(Index) of integer;

   Max : constant Integer := 50;
   Input : File_Type;
   no_ques: SU.unbounded_string;
   correct_answers : SU.unbounded_string;
   stud_answers : SU.unbounded_string;
   stud_score : integer;
   line: SU.unbounded_string;
   sum: Integer;
   average: Integer;


-- READ FILE FUNCTION STARTS HERE -------------------------------------------------------------------   
procedure reading (File: out File_Type) is
  
   filename : String(1 .. Max);
   length : Integer range 0 .. Max;
   no_ques_int : Integer;
   correct_answers_int : My_Int_Array;
   stud_answers_int : My_Int_Array;
   buffer : SU.unbounded_string;
   stud_buffer : SU.unbounded_string;
   k:integer;
   no_studs:integer;
   score_track : My_Int_Array;


-----function to parse correct answers line and get integer array------------------------------------
function parse(str1 : SU.unbounded_string) return My_Int_Array is
      s : string := SU.To_String(str1);
      x: Integer;
      i: Integer;
      str: string:=" ";
   begin
   x := 1;
   i := 1;
   while  i < (no_ques_int)*2 loop
      if(s(i) /= ' ') then
         str(1) := s(i);
         correct_answers_int(x) := Integer'value(str);
 --      put(correct_answers_int(x));
         x:= x+1;
      end if;
      i:= i+1;
   end loop;
   return correct_answers_int;
   end parse;

-----function to parse correct answers line and get integer array------------------------------------
function parse_stud(str1 : SU.unbounded_string) return My_Int_Array is
      s : string := SU.To_String(str1);
      x: Integer;
      i: Integer;
      str: string:=" ";
   begin
   x := 1;
   i := 6;
   while  i < (no_ques_int*2)+6 loop
      if(s(i) /= ' ') then
         str(1) := s(i);
         stud_answers_int(x) := Integer'value(str);
         x:= x+1;
      end if;
      i:= i+1;
   end loop;
   return stud_answers_int;
   end parse_stud;   


-----function to parse correct answers line and get Student ID------------------------------------
   procedure parse_stud_id(str2 : SU.unbounded_string) is
      s : string := SU.To_String(str2);   
   begin
      put("       ");put(s(1..5));put("       ");
   end parse_stud_id;   

--Procedure to Sort the score_track to find frequency of each score----------------------------------------
procedure BSort(A : in out My_Int_Array) is
   temp : Integer;
   i : integer;
   j : integer;
   begin
   i:=1;
   j:=1;

    for i in 1..no_studs-1 loop
         for j in 1..no_studs-i loop    
          if(A(j)<A(j+1))then
                temp:=A(j);
                A(j):=A(j+1);
                A(j+1):=temp;
          end if;
       end loop;
    end loop;

end BSort;

----function to calculate Score--------------------------------------
   function calculate_score(ca : My_Int_Array; sa : My_Int_Array) return integer is
      i: Integer;
      j: Integer;
      k: integer;
      count : Integer;

   begin
   i := 1;
   j := 1;
   k := 1;
   count := 0;
   for k in 1..20 loop
   if(ca(k) = sa(k)) then
   count := count + 1;
   end if;
   end loop;
   return count;
   end calculate_score;   

----function for frequency calculation--------------------------------------
   procedure freq_counter(st : My_Int_Array)  is
      i: Integer;
      j: Integer;
      k: Integer;
      count : Integer;

      begin
      j := 1;
      k := 1;
      count := 1;

      while k < no_studs+1 loop
         for j in 1..no_studs loop

            if(st(k) = st(j)) then 
               count := count+1;
            end if;
         end loop;
          i:=k;
          k:=k+count-1;
          put(st(i));put("       ");put(count-1);new_line;
          count:=1;
         end loop;     

      end freq_counter;      
----------------------------------------------------------------------------------------
   begin
   get_line(Item => filename, Last => length);
   if length = Max then
      skip_line;
   end if;


   -- reading number of students----------------------------------------------------

   Open(File => File ,Name => filename(1..length), Mode => In_File);
   no_studs := 0;
    while not End_of_File(File) loop
        line:= SU.to_unbounded_string(get_line(File));
        no_studs := no_studs +1;
    end loop;
    no_studs:= no_studs-2;
    Close(File => File);

   -- reading number of questions ------------------------------------------------------
   Open(File => File ,Name => filename(1..length), Mode => In_File);
   no_ques := get_line(File => File);
   no_ques_int := Integer'value(SU.To_String(no_ques));

   -- reading correct answers-----------------------------------------------------------
   buffer := get_line(File => File);
   correct_answers_int := parse(buffer);

   -- reading student answers and printing score----------------------------------------
   put_line("     Student ID           Score");
   put_line("============================================");
   
   k:=1;
   while k<=no_studs loop
   
   stud_buffer := get_line(File => File);
   parse_stud_id(stud_buffer);
   stud_answers_int := parse_stud(stud_buffer);

   stud_score := calculate_score(correct_answers_int,stud_answers_int); 
   put(stud_score*(100/no_ques_int));
   for i in 1..20 loop
      stud_answers_int(i) := 0;
   end loop;
   new_line;
   score_track(k):=stud_score*(100/no_ques_int);
   k:=k+1;
   end loop;

   put_line("============================================");
   put("Tests Graded =     ");put(no_studs);New_Line;

-- Calculating average score--------------   
   sum :=0;
   for i in 1..no_studs loop
      sum := sum + score_track(i);
   end loop;
   average:= sum/no_studs;
------------------------------------------
   Bsort(score_track);
   put_line("============================================");
   put_line("       Score           Frequency");
   put_line("============================================");
   freq_counter(score_track);
   put_line("============================================");
   put("Class Average  =   ");put(average);
   end reading;
-------------End procedure Reading----------------------------------------------------------------

   begin 
   put_line("Enter name of file to read ");
   reading(File=>Input);
   
end scada;