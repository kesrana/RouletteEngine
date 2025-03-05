LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Register_1Bit_DFF IS
  PORT (
    clk : IN STD_LOGIC;         -- Clock input
    resetb : IN STD_LOGIC;         -- Reset input
    input_data : IN STD_LOGIC;  -- Input data
    output_data : OUT STD_LOGIC  -- Output data
  );
END ENTITY Register_1Bit_DFF;

ARCHITECTURE behavior OF Register_1Bit_DFF IS
  SIGNAL internal_register : STD_LOGIC := '0';
BEGIN
  PROCESS (clk, resetb)
  BEGIN
    IF resetb = '0' THEN
      internal_register <= '0';  -- Reset the register to 0
    ELSIF rising_edge(clk) THEN
      internal_register <= input_data;  -- Update the register with input data on the rising edge of the clock
    END IF;
  END PROCESS;

  output_data <= internal_register;  -- Output the contents of the register
END ARCHITECTURE behavior;
