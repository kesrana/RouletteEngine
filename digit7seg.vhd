LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

ENTITY digit7seg IS
	PORT(
          digit : IN  UNSIGNED(3 DOWNTO 0);  -- number 0 to 0xF
          seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- one per segment
	);
END;

ARCHITECTURE behavioral OF digit7seg IS
BEGIN

-- Your code goes here
    process(digit)
    begin
        if digit = "0000" then 
            seg7 <= "1000000"; -- "0" 
        elsif digit = "0001" then 
            seg7 <= "1111001"; -- "1" 
        elsif digit = "0010" then 
            seg7 <= "0100100"; -- "2"
        elsif digit = "0011" then 
            seg7 <= "0110000"; -- "3" 
        elsif digit = "0100" then 
            seg7 <= "0011001"; -- "4" 
        elsif digit = "0101" then 
            seg7 <= "0010010"; -- "5"
        elsif digit = "0110" then 
            seg7 <= "0000010"; -- "6" 
        elsif digit = "0111" then 
            seg7 <= "1111000"; -- "7" 
        elsif digit = "1000" then 
            seg7 <= "0000000"; -- "8"     
        elsif digit = "1001" then 
            seg7 <= "0010000"; -- "9" 
        elsif digit = "1010" then 
            seg7 <= "0001000"; -- A
        elsif digit = "1011" then 
            seg7 <= "0000011"; -- b
        elsif digit = "1100" then 
            seg7 <= "0100111"; -- c
        elsif digit = "1101" then 
            seg7 <= "0100001"; -- d
        elsif digit = "1110" then 
            seg7 <= "0000110"; -- e
        elsif digit = "1111" then 
            seg7 <= "0001110"; -- f
        end if;
    end process;
    
END;
