LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY dff IS
    PORT (
        clk : IN BIT;
        d : IN STD_LOGIC;
        q : OUT STD_LOGIC);
END dff;

ARCHITECTURE behavioral OF dff IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN -- infers rising clock edge
            q <= d;
        END IF;
    END PROCESS;
END behavioral;