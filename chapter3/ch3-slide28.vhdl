USE IEE.std_logic_1164.ALL;

ENTITY dff_async IS
    PORT (
        clk, reset : IN BIT;
        d : IN STD_LOGIC;
        q : OUT STD_LOGIC);
END dff_async;

ARCHITECTURE behavioral OF dff_async IS
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN -- asynchronous reset
            q <= '0';
        ELSIF (clk'event AND clk = '1') THEN -- inferring rising clk edge
            q <= d;
        END IF;
    END PROCESS;
END behavioral;