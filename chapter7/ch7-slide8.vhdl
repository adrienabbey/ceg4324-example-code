ARCHITECTURE RTL3 OF SHIFT IS
    COMPONENT DFF
        PORT (
            RSTn, CLK, D : IN BIT;
            Q : OUT BIT);
    END COMPONENT;

    SIGNAL T : bit_vector(8 DOWNTO 0);

BEGIN
    T(8) <= SI;
    SO <= T(0);
    g0 : FOR i IN 7 DOWNTO 0 GENERATE
        allbit : DFF PORT MAP(RSTn => RSTn, CLK => CLK, D => T(i + 1), Q => (Ti));
    END GENERATE;
END RTL3;