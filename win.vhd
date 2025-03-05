LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

--------------------------------------------------------------
--
--  This is a skeleton you can use for the win subblock.  This block determines
--  whether each of the 3 bets is a winner.  As described in the lab
--  handout, the first bet is a "straight-up" bet, teh second bet is 
--  a colour bet, and the third bet is a "dozen" bet.
--
--  This should be a purely combinational block.  There is no clock.
--
---------------------------------------------------------------

ENTITY win IS
	PORT(spin_result_latched : in unsigned(5 downto 0);  -- result of the spin (the winning number)
             bet1_value : in unsigned(5 downto 0); -- value for bet 1
             bet2_colour : in std_logic;  -- colour for bet 2
             bet3_dozen : in unsigned(1 downto 0);  -- dozen for bet 3
             bet1_wins : out std_logic;  -- whether bet 1 is a winner
             bet2_wins : out std_logic;  -- whether bet 2 is a winner
             bet3_wins : out std_logic); -- whether bet 3 is a winner
END win;


ARCHITECTURE behavioural OF win IS
BEGIN
	process(spin_result_latched, bet1_value, bet2_colour, bet3_dozen)
	begin
	
		if(bet1_value = spin_result_latched) then
			bet1_wins <= '1';
		else
			bet1_wins <= '0';
		end if;
		
		if(spin_result_latched >= "000001" AND spin_result_latched <= "001010") OR (spin_result_latched >= "010011" AND spin_result_latched <= "011100") then
			if(spin_result_latched(0) = bet2_colour) then
				bet2_wins <= '1';
			else
				bet2_wins <= '0';
			end if;
		
		else
			if (spin_result_latched = "000000" OR spin_result_latched > "100100") then bet2_wins <= '0';
			else  
				if (spin_result_latched(0) = bet2_colour) then
					bet2_wins <= '0';
				else 
					bet2_wins <= '1';
				end if;
			end if;
		end if;
				
	if(bet3_dozen = "00" AND (spin_result_latched >= "000001" AND spin_result_latched <= "001100")) OR
   (bet3_dozen = "01" AND (spin_result_latched >= "001101" AND spin_result_latched <= "011000")) OR
   (bet3_dozen = "10" AND (spin_result_latched >= "011001" AND spin_result_latched <= "100100")) then
	
    bet3_wins <= '1';
	else
    bet3_wins <= '0';
	 end if;
	 
	end process;
	

END;
