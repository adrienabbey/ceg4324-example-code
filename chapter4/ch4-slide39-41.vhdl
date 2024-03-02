LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Mealy IS
    PORT (
        clock : IN STD_LOGIC;
        resetn : IN STD_LOGIC;
        w : IN STD_LOGIC;
        z : OUT STD_LOGIC);
END Mealy;

ARCHITECTURE Behavior OF Mealy IS
    TYPE State_type IS (A, B);
    SIGNAL y : State_type;
BEGIN
    PROCESS (resetn, clock)
    BEGIN
        IF resetn = '0' THEN
            y <= A;
        ELSIF (clock'event AND clock = '1') THEN
            CASE y IS
                WHEN A =>
                    IF w = '0' THEN
                        y <= A;
                    ELSE
                        y <= B;
                    END IF;
                WHEN B =>
                    IF w = '0' THEN
                        y <= A;
                    ELSE
                        y <= B;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

    WITH y SELECT
        z <= w WHEN B,
        z <= '0' WHEN OTHERS;

END Behavior;