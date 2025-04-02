LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

ENTITY roulette IS
  PORT(
    CLOCK_50 : IN STD_LOGIC; -- the fast clock for spinning wheel
    KEY : IN STD_LOGIC_VECTOR(3 downto 0);  -- includes slow_clock and reset
    SW : IN STD_LOGIC_VECTOR(17 downto 0);
    LEDG : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- ledg
    HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 7
    HEX6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 6
    HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 5
    HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 4
    HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 3
    HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 2
    HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 1
    HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- digit 0
  );
END roulette;

ARCHITECTURE structural OF roulette IS
  -- Combinational blocks instantiation
  
  COMPONENT win IS
    PORT(
      spin_result_latched : in unsigned(5 downto 0);  -- result of the spin (the winning number)
      bet1_value : in unsigned(5 downto 0); -- value for bet 1
      bet2_colour : in std_logic;  -- colour for bet 2
      bet3_dozen : in unsigned(1 downto 0);  -- dozen for bet 3
      bet1_wins : out std_logic;  -- whether bet 1 is a winner
      bet2_wins : out std_logic;  -- whether bet 2 is a winner
      bet3_wins : out std_logic -- whether bet 3 is a winner
    );
  END COMPONENT;

  COMPONENT new_balance IS
    PORT(
      money : IN UNSIGNED(11 DOWNTO 0);  -- Current balance before this spin
      value1 : IN UNSIGNED(2 DOWNTO 0);   -- Value of bet 1
      value2 : IN UNSIGNED(2 DOWNTO 0);   -- Value of bet 2
      value3 : IN UNSIGNED(2 DOWNTO 0);   -- Value of bet 3
      bet1_wins : IN STD_LOGIC;               -- True if bet 1 is a winner
      bet2_wins : IN STD_LOGIC;               -- True if bet 2 is a winner
      bet3_wins : IN STD_LOGIC;               -- True if bet 3 is a winner
      new_money : OUT UNSIGNED(11 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT spinwheel IS
    PORT(
      fast_clock : IN STD_LOGIC;  -- This will be a 27 MHz Clock
      resetb : IN STD_LOGIC;      -- asynchronous reset
      spin_result : OUT UNSIGNED(5 downto 0)
    );
  END COMPONENT;
  
  COMPONENT digit7seg IS
    PORT(
      digit : IN UNSIGNED(3 DOWNTO 0);  -- number 0 to 0xF
      seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
  END COMPONENT;
  
  COMPONENT Register_6Bit IS
    PORT(
      clk : IN STD_LOGIC;         -- Clock input
      resetb : IN STD_LOGIC;         -- Reset input
      input_data : IN UNSIGNED(5 DOWNTO 0);  -- Input data
      output_data : OUT UNSIGNED(5 DOWNTO 0)  -- Output data
    );
  END COMPONENT;
  
  COMPONENT Register_1Bit_DFF IS
    PORT(
      clk : IN STD_LOGIC;         -- Clock input
      resetb : IN STD_LOGIC;         -- Reset input
      input_data : IN STD_LOGIC;  -- Input data
      output_data : OUT STD_LOGIC  -- Output data
    );
  END COMPONENT;
  
  COMPONENT Register_2Bit IS
    PORT(
      clk : IN STD_LOGIC;         -- Clock input
      resetb : IN STD_LOGIC;         -- Reset input
      input_data : IN UNSIGNED(1 DOWNTO 0);  -- Input data
      output_data : OUT UNSIGNED(1 DOWNTO 0)  -- Output data
    );
  END COMPONENT;
  
  COMPONENT Register_3Bit IS
    PORT(
      clk : IN STD_LOGIC;         -- Clock input
      resetb : IN STD_LOGIC;         -- Reset input
      input_data : IN UNSIGNED(2 DOWNTO 0);  -- Input data
      output_data : OUT UNSIGNED(2 DOWNTO 0)  -- Output data
    );
  END COMPONENT;
  
  COMPONENT debouncer IS
	    PORT(
        clk     : IN  std_logic;
        btn_in  : IN  std_logic;
        btn_out : OUT std_logic
    );
	END COMPONENT;
  
  COMPONENT Register_12Bit IS
    PORT(
      clk : IN STD_LOGIC;         -- Clock input
      resetb : IN STD_LOGIC;         -- Reset input
      input_data : IN UNSIGNED(11 DOWNTO 0);  -- Input data
      output_data : OUT UNSIGNED(11 DOWNTO 0)  -- Output data
    );
  END COMPONENT;
  
--  COMPONENT digit7seg_base10 IS
--	 PORT(
--		digit : IN  UNSIGNED(3 DOWNTO 0);  -- number 0 to 9
--      seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- one per segment
--	 );
--  END COMPONENT;
  
  SIGNAL slow_clock : STD_LOGIC;
  SIGNAL spin_result_s : UNSIGNED(5 downto 0);
  SIGNAL spin_result_latched_s : UNSIGNED(5 DOWNTO 0);
  SIGNAL bet1_value_s : UNSIGNED(5 DOWNTO 0);
  SIGNAL bet2_colour_s : STD_LOGIC;
  SIGNAL bet3_dozen_s : UNSIGNED(1 DOWNTO 0);
  SIGNAL bet1_wins_s : STD_LOGIC;
  SIGNAL bet2_wins_s : STD_LOGIC;
  SIGNAL bet3_wins_s : STD_LOGIC;
  SIGNAL bet1_amount_s : UNSIGNED(2 DOWNTO 0);
  SIGNAL bet2_amount_s : UNSIGNED(2 DOWNTO 0);
  SIGNAL bet3_amount_s : UNSIGNED(2 DOWNTO 0);
  SIGNAL money_s : UNSIGNED(11 DOWNTO 0);
  SIGNAL new_money_s : UNSIGNED(11 DOWNTO 0);
	

BEGIN

LEDG(0) <= bet1_Wins_s;
LEDG(1) <= bet2_wins_s;
LEDG(2) <= bet3_wins_s;

  U1 : spinwheel
    PORT MAP(
      fast_clock => CLOCK_50,
      resetb => KEY(1),
      spin_result => spin_result_s
    );
	 
  U2 : Register_6Bit
    PORT MAP(
      clk => slow_clock,
      resetb => KEY(1),
      input_data => spin_result_s,
      output_data => spin_result_latched_s
    );
	 
  U3 : digit7seg
    PORT MAP(
      digit => spin_result_latched_s(3 DOWNTO 0),
		seg7 => HEX6
    );

	
  U4 : digit7seg
    PORT MAP(
      digit(1 DOWNTO 0) => spin_result_latched_s(5 DOWNTO 4),
		seg7 => HEX7
    );
	 
  U5 : Register_6Bit
    PORT MAP(
      clk => slow_clock,
		resetb => KEY(1),
		input_data => UNSIGNED(SW(8 DOWNTO 3)),
		output_data => bet1_value_s
    );
	 
  U6 : Register_1Bit_DFF
    PORT MAP(
      clk => slow_clock,
		resetb => KEY(1),
		input_data => SW(12),
		output_data => bet2_colour_s
    );
	 
  U7 : Register_2Bit
    PORT MAP(
      clk => slow_clock,
		resetb => KEY(1),
		input_data => UNSIGNED(SW(17 DOWNTO 16)),
		output_data => bet3_dozen_s
    );
	
	 
  U8 : win
    PORT MAP(
		spin_result_latched => spin_result_latched_s,
      bet1_value => bet1_value_s,
      bet2_colour => bet2_colour_s,
      bet3_dozen => bet3_dozen_s,
      bet1_wins => bet1_wins_s,
      bet2_wins => bet2_wins_s,
      bet3_wins => bet3_wins_s
    );
	

	
  U9 : Register_3Bit
    PORT MAP(
      clk => slow_clock,
		resetb => KEY(1),
		input_data => UNSIGNED(SW(2 DOWNTO 0)),
		output_data => bet1_amount_s
    );
	 
  U10 : Register_3Bit
    PORT MAP(
      clk => slow_clock,
		resetb => KEY(1),
		input_data => UNSIGNED(SW(11 DOWNTO 9)),
		output_data => bet2_amount_s
    );
	 
  U11 : Register_3Bit
    PORT MAP(
      clk => slow_clock,
		resetb => KEY(1),
		input_data => UNSIGNED(SW(15 DOWNTO 13)),
		output_data => bet3_amount_s
    );
	 
  U12 : new_balance
    PORT MAP(
      money => money_s, 
      value1 => bet1_amount_s,
      value2 => bet2_amount_s,
      value3 => bet3_amount_s,
      bet1_wins => bet1_wins_s,
      bet2_wins => bet2_wins_s,
      bet3_wins => bet3_wins_s,             
      new_money => new_money_s
    );
	 
	
  U13 : Register_12Bit
    PORT MAP(
      clk => slow_clock,
		resetb => KEY(1),
		input_data => new_money_s,
		output_data => money_s
    );
	 
  U14 : digit7seg
    PORT MAP(
      digit => new_money_s(11 DOWNTO 8),
		seg7 => HEX2
    );

	 
  U15 : digit7seg
    PORT MAP(
      digit => new_money_s(7 DOWNTO 4),
		seg7 => HEX1
    );

	 
  U16 : digit7seg
    PORT MAP(
      digit => new_money_s(3 DOWNTO 0),
		seg7 => HEX0
    );

	U17 : debouncer
	  PORT MAP(
		clk => CLOCK_50,
		btn_in => NOT KEY(0),
		btn_out => slow_clock
	 );
END ARCHITECTURE structural;
