LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY sequential_1 IS
    PORT (
        a, b, c, clk : IN STD_LOGIC;
        out1 : OUT STD_LOGIC);
END ENTITY sequential_1;

ARCHITECTURE sequential_structure OF sequential_1 IS

    -- Component declarations

    COMPONENT INV1
        PORT (
            a : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT OR2
        PORT (
            a, b : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT MUX2
        PORT (
            a, b, sel : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT DFF1
        PORT (
            d, clk : IN STD_LOGIC;
            q : OUT STD_LOGIC);
    END COMPONENT;

    -- signal declarations

    SIGNAL s1, s2, s3 : STD_LOGIC;

    -- component instantiation statements

BEGIN

    u1 : INV1
    PORT MAP(a => b, z => s1);

    u2 : OR2
    PORT MAP(a => b, b => c, z => s2);

    u3 : MUX2
    PORT MAP(a => s1, b => s2, sel => a, z => s3);

    u4 : DFF1
    PORT MAP(d => s3, clk => clk, q => out1);

END sequential_structure;