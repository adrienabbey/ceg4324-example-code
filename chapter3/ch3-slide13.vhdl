ENTITY clk IS
    PORT (clk : OUT STD_LOGIC);
END clk;

ARCHITECTURE cyk OF clk IS
BEGIN
    PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 10 ns;
        clk <= '1';
        WAIT FOR 10 ns;
    END PROCESS;
END cyk;