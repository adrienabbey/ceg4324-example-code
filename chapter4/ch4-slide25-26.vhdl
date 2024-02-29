TYPE state IS (S0, S1);
SIGNAL Mealy_state : state;

U_Mealy : PROCESS (clock, reset)
BEGIN
    IF (reset = '1') THEN
        Mealy_state <= S0;
    ELSIF (clock = '1' AND clock'event) THEN
        CASE Mealy_state IS
            WHEN S0 =>
                IF input = '1' THEN
                    Mealy_state <= S1;
                ELSE
                    Mealy_state <= S0;
                END IF;
            WHEN S1 =>
                IF input = '0' THEN
                    Mealy_state <= S0;
                ELSE
                    Mealy_state <= S1;
                END IF;
        END CASE;
    END IF;
END PROCESS;

Output <= '1' WHEN (Mealy_state = S1 AND input = '0') ELSE
    '0';