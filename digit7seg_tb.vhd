LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY WORK;
USE WORK.ALL;

ENTITY digit7seg_tb IS
  -- no inputs or outputs
END digit7seg_tb;

ARCHITECTURE behavioural OF digit7seg_tb IS

   TYPE test_case_record IS RECORD
      digit : UNSIGNED(3 DOWNTO 0);  -- number 0 to 0xF
      expected_seg7 : STD_LOGIC_VECTOR(6 DOWNTO 0);  -- one per segment
   END RECORD;

   TYPE test_case_array_type IS ARRAY (0 to 15) OF test_case_record;

      SIGNAL test_case_array : test_case_array_type := (
      ("0000", "1000000"),   -- 0
      ("0001", "1111001"),   -- 1
      ("0010", "0100100"),   -- 2
      ("0011", "0110000"),   -- 3
      ("0100", "0011001"),   -- 4
      ("0101", "0010010"),   -- 5
      ("0110", "0000010"),   -- 6
      ("0111", "1111000"),   -- 7
      ("1000", "0000000"),   -- 8
      ("1001", "0010000"),   -- 9
      ("1010", "0001000"),   -- A
      ("1011", "0000011"),   -- B
      ("1100", "0100111"),   -- C
      ("1101", "0100001"),   -- D
      ("1110", "0000110"),   -- E
      ("1111", "0001110")    -- F
   );

   COMPONENT digit7seg IS
      PORT(
         digit : IN  UNSIGNED(3 DOWNTO 0);  -- number 0 to 0xF
         seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- one per segment
      );
   END COMPONENT;

   SIGNAL digit : UNSIGNED(3 DOWNTO 0);
   SIGNAL seg7 : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

   dut : digit7seg PORT MAP(
      digit => digit,   
      seg7 => seg7
   );      

   PROCESS
   BEGIN   
      FOR i IN test_case_array'LOW TO test_case_array'HIGH LOOP

        REPORT "-------------------------------------------";
        REPORT "Test case " & INTEGER'IMAGE(i) & ":" &
          " digit=" & INTEGER'IMAGE(TO_INTEGER(test_case_array(i).digit)) &
          " seg7=" & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(test_case_array(i).expected_seg7)));

        digit <= test_case_array(i).digit;
        WAIT FOR 1 NS;

        REPORT "Expected result: seg7 " & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(test_case_array(i).expected_seg7)));
        REPORT "Observed result: seg7=" & INTEGER'IMAGE(TO_INTEGER(UNSIGNED(seg7)));

        ASSERT (seg7 = test_case_array(i).expected_seg7)
          REPORT "MISMATCH. THERE IS A PROBLEM IN YOUR DESIGN THAT YOU NEED TO FIX"
          SEVERITY FAILURE;
      END LOOP;
                                           
      REPORT "================== ALL TESTS PASSED =============================";
                                                                              
      WAIT; -- Wait forever
   END PROCESS;

END behavioural;
