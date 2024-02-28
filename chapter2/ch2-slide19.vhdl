ENTITY RedXor IS
    GENERIC (width : INTEGER := 8);
    PORT (
        A : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        Z : OUT STD_LOGIC);
END RedXor;

ARCHITECTURE Behavioral OF RedXor IS
BEGIN
    reduceXor : PROCESS (A)
        VARIABLE zv : STD_LOGIC;
    BEGIN
        zv := A(0);
        FOR i IN 1 TO width - 1 LOOP
            zv := zv XOR A(i);
        END LOOP;
        Z <= zv;
    END PROCESS reduceXor;
END Behavioral;