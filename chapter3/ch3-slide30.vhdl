ENTITY dff_sync IS
    PORT (
        clk, reset : IN BIT;
        d : IN STD_LOGIC;
        q : OUT STD_LOGIC);
END dff_sync;

ARCHITECTURE behavioral OF dff_sync IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            IF (reset = '1') THEN
                q <= '0';
            ELSE
                q <= d;
            END IF;
        END IF;
    END PROCESS;
END behavioral;