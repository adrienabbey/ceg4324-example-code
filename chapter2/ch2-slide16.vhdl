ENTITY RedAnd IS
    GENERIC (width : INTEGER := 8);
    PORT (
        A : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        Z : OUT STD_LOGIC);
END RedAnd;

ARCHITECTURE Behavioral OF RedAnd IS
BEGIN
    reduceAnd : PROCESS (A)
        VARIABLE zv : STD_LOGIC;
    BEGIN
        zv := A(0);
        FOR i IN 1 TO width - 1 LOOP
            zv := zv AND A(i);
        END LOOP;
        Z <= zv;
    END PROCESS reduceAnd;
END Behavioral;