ARCHITECTURE Behavior OF simple IS
    TYPE State_type IS (A, B, C);
    SIGNAL y_present, y_next : State_type;
BEGIN
    PROCESS (w, y_present)
    BEGIN
        CASE y_present IS
            WHEN A =>
                IF w = '0' THEN
                    y_next <= A;
                ELSE
                    y_next <= B;
                END IF;
            WHEN B =>
                IF w = '0' THEN
                    y_next <= A;
                ELSE
                    y_next <= C;
                END IF;
            WHEN C =>
                IF w = '0' THEN
                    y_next <= A;
                ELSE
                    y_next <= C;
                END IF;
        END CASE;
    END PROCESS;

    PROCESS (clock, resetn)
    BEGIN
        IF resetn = '0' THEN -- this is a NEGATIVE reset
            y_present <= A;
        ELSIF (clock'event AND clock = '1') THEN
            y_present <= y_next;
        END IF;
    END PROCESS;

    z <= '1' WHEN y_present = C ELSE
        '0';
END Behavior;