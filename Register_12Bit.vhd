LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Register_12Bit IS
  PORT (
    clk : IN STD_LOGIC;         -- Clock input
    resetb : IN STD_LOGIC;         -- Reset input
    input_data : IN UNSIGNED(11 DOWNTO 0);  -- Input data
    output_data : OUT UNSIGNED(11 DOWNTO 0)  -- Output data
  );
END ENTITY Register_12Bit;

ARCHITECTURE behavior OF Register_12Bit IS
  SIGNAL internal_register : UNSIGNED(11 DOWNTO 0);
BEGIN
  PROCESS (clk, resetb)
  BEGIN
    IF resetb = '0' THEN
      internal_register <= "000000100000";  -- Reset the register to 32
    ELSIF rising_edge(clk) THEN
      internal_register <= input_data;        -- Update the register with input data
    END IF;
  END PROCESS;

  output_data <= internal_register;  -- Output the contents of the register
END ARCHITECTURE behavior;
