COMPONENT DFF
    PORT (
        RSTn, CLK, D : IN BIT;
        Q : OUT BIT);
END COMPONENT;

SIGNAL T : bit_vector(6 DOWNTO 0);

BEGIN
g0 : FOR i IN 7 DOWNTO 0 GENERATE
    g1 : IF (i = 7) GENERATE
        bit7 : DFF PORT MAP(RSTn => RSTn, CLK => CLK, D => SI, Q = T(6));
    END GENERATE;
    g2 : IF (i > 0) AND (i < 7) GENERATE
        bitm : DFF
        PORT MAP(RSTn, CLK, T(i), T(i - 1));
    END GENERATE;
    g3 : IF (i = 0) GENERATE
        bit0 : DFF PORT MAP(RSTn, CLK, T(0), S0);
    END GENERATE;
END GENERATE;
END RTL2;