ENTITY AllZeroDet IS
    GENERIC (width : INTEGER := 8);
    PORT (
        A : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        Z : OUT STD_LOGIC);
END AllZeroDet;

ARCHITECTURE Structural OF AllZeroDet IS
    COMPONENT RedOr
        GENERIC (width : INTEGER);
        PORT (
            A : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
            Z : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL ZT : STD_LOGIC;

BEGIN
    zeroFlag : RedOr
    GENERIC MAP(width)
    PORT MAP(A, ZT);
    Z <= NOT ZT;
END Structural;