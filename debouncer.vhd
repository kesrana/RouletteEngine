LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY debouncer IS
    PORT(
        clk     : IN  std_logic;
        btn_in  : IN  std_logic;
        btn_out : OUT std_logic
    );
END debouncer;

ARCHITECTURE Behavioral OF debouncer IS
    SIGNAL buttonReg : STD_LOGIC := '0';
    SIGNAL debounceCounter : INTEGER := 0;
    CONSTANT debounceThreshold : INTEGER := 300;
BEGIN

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            -- Shift in the current button input
            buttonReg <= btn_in;

            -- Debouncing logic
            IF buttonReg = btn_in THEN
                IF debounceCounter < debounceThreshold THEN
                    debounceCounter <= debounceCounter + 1;
                ELSE
                    btn_out <= buttonReg;
                    debounceCounter <= 0;
                END IF;
            ELSE
                debounceCounter <= 0;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;
