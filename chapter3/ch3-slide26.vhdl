LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY dff_alt IS
    PORT (
        clk : IN BIT;
        d : IN STD_LOGIC;
        q : OUT STD_LOGIC);
END dff_alt;

ARCHITECTURE behavioral OF dff_alt IS
BEGIN
    PROCESS
    BEGIN
        WAIT UNTIL clk = '1'; -- infers rising clock edge
        q <= d;
    END PROCESS;
END behavioral;