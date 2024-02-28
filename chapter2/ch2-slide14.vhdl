ENTITY generic_or IS
    GENERIC (n : POSITIVE := 2);
    PORT (
        in1 : IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
        z : OUT STD_LOGIC);
END ENTITY generic_or;

ARCHITECTURE behavioral OF generic_or IS
BEGIN
    PROCESS (in1)
        VARIABLE sum : STD_LOGIC := '0';
    BEGIN
        sum := '0';
        FOR i IN 0 TO (n - 1) LOOP
            sum := sum OR in1(i);
        END LOOP;
        z <= sum;
    END PROCESS;
END ARCHITECTURE behavioral;