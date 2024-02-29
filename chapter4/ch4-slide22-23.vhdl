TYPE state IS (S0, S1, S2); -- User defined 'state' type
SIGNAL Moore_state : state; -- Uses the user defined 'state' type

U_Moore : PROCESS (clock, reset)
BEGIN
    IF (reset = '1') THEN -- Asynchronous Reset
        Moore_state <= S0;
    ELSIF (clock = '1' AND clock'event) THEN
        CASE Moore_state IS
            WHEN S0 =>
                IF input = '1' THEN
                    Moore_state <= S1;
                ELSE
                    Moore_state <= S0;
                END IF;
            WHEN S1 =>
                IF input = '0' THEN
                    Moore_state <= S2;
                ELSE
                    Moore_state <= S1;
                END IF;
            WHEN S2 =>
                IF input = '0' THEN
                    Moore_state <= S0;
                ELSE
                    Moore_state <= S1;
                END IF;
        END CASE;
    END IF;
END PROCESS;

Output <= '1' WHEN Moore_state = S2 ELSE
    '0';