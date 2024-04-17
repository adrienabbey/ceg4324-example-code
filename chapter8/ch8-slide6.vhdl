LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY dff IS
    PORT (
        d, clock : IN STD_LOGIC;
        q, qbar : OUT STD_LOGIC);
END ENTITY dff;

ARCHITECTURE beh OF dff IS
    FUNCTION rising_edge(SIGNAL clock : STD_LOGIC) RETURN BOOLEAN IS
        VARIABLE edge : BOOLEAN := FALSE;
    BEGIN
        edge := (clock = '1' AND clock'event);
        RETURN (edge);
    END FUNCTION rising_edge;
BEGIN
    output : PROCESS IS
    BEGIN
        WAIT UNTIL (rising_edge(clock));
        q <= d AFTER 5 ns;
        qbar <= NOT d AFTER 5 ns;
    END PROCESS output;
END ARCHITECTURE beh;