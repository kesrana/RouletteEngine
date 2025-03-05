LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

ENTITY new_balance IS
  PORT(
    money      : IN  UNSIGNED(11 DOWNTO 0);  -- Current balance before this spin
    value1     : IN  UNSIGNED(2 DOWNTO 0);   -- Value of bet 1
    value2     : IN  UNSIGNED(2 DOWNTO 0);   -- Value of bet 2
    value3     : IN  UNSIGNED(2 DOWNTO 0);   -- Value of bet 3
    bet1_wins  : IN  STD_LOGIC;               -- True if bet 1 is a winner
    bet2_wins  : IN  STD_LOGIC;               -- True if bet 2 is a winner
    bet3_wins  : IN  STD_LOGIC;               -- True if bet 3 is a winner
    new_money  : OUT UNSIGNED(11 DOWNTO 0)    -- balance after adding winning
  );                                       -- bets and subtracting losing bets
END new_balance;


ARCHITECTURE behavioural OF new_balance IS
BEGIN
  PROCESS (money, value1, value2, value3, bet1_wins, bet2_wins, bet3_wins)
  VARIABLE temp_money : UNSIGNED(11 DOWNTO 0);
  BEGIN
    temp_money := money; 

    IF bet1_wins = '1' THEN
      temp_money := temp_money + to_unsigned(35, 9) * value1;
	 ELSE
		temp_money := temp_money - resize(value1, 12);
    END IF;

    IF bet2_wins = '1' THEN
      temp_money := temp_money + resize(value2, 12);
	 ELSE
		temp_money := temp_money - resize(value2, 12);
    END IF;

	 IF bet3_wins = '1' THEN
      temp_money := temp_money + to_unsigned(2, 9) * value3;
	 ELSE
		temp_money := temp_money - resize(value3, 12);
    END IF;

    -- Assign the final result to the output
    new_money <= temp_money;

  END PROCESS;
END behavioural;
