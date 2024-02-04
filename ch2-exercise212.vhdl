--
-- 1a: concurrent VHDL code (Boolean expression)
--

ENTITY function_F IS
    PORT (
        A, B, C : IN STD_LOGIC;
        F : OUT STD_LOGIC);
END function_F;

ARCHITECTURE concurrent OF function_F IS
BEGIN
    F <= (NOT A AND NOT B AND NOT C) OR (NOT A AND B AND NOT C)
        OR (A AND NOT B AND C) OR (A AND B AND NOT C);
END concurrent;

--
-- 1b: use IF statement
--

ENTITY function_F IS
    PORT (
        A, B, C : IN STD_LOGIC;
        F : OUT STD_LOGIC);
END function_F;

ARCHITECTURE behavior_1 OF function_F IS
BEGIN
    proc1 : PROCESS (A, B, C)
    BEGIN
        IF (A = '0' AND C = '0') THEN
            F <= '1';
        ELSIF (A = '1' AND B = '0' AND C = '1') THEN
            F <= '1';
        ELSIF (B = '1' AND C = '0') THEN
            F <= '1';
        ELSE
            F <= '0';
        END IF;
    END PROCESS proc1;
END behavior_1;