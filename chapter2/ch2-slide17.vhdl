ENTITY RedOr IS
    GENERIC (width : INTEGER := 8);
    PORT (
        A : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        Z : OUT STD_LOGIC);
END RedOr;

ARCHITECTURE Behavioral OF RedOr IS
BEGIN
    reduceOr : PROCESS (A)
        VARIABLE zv : STD_LOGIC;
    BEGIN
        zv := A(0);
        FOR i IN 1 TO width - 1 LOOP
            zv := zv OR A(i);
        END LOOP;
        Z <= zv;
    END PROCESS reduceOr;
END Behavioral;