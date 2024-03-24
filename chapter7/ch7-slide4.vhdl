ENTITY DFF IS
    PORT (
        RSTn, CLK, D : IN BIT;
        Q : OUT BIT);
END DFF;

ARCHITECTURE RTL OF DFF IS
BEGIN
    PROCESS (RSTn, CLK)
    BEGIN
        IF (RSTn = '0') THEN
            Q <= '0';
        ELSIF (CLK'event AND CLK = '1') THEN
            Q <= D;
        END IF;
    END PROCESS;
END RTL;

ENTITY SHIFT IS
    PORT (
        RSTn, CLK, SI : IN BIT;
        SO : OUT BIT);
END SHIFT;

ARCHITECTURE RTL1 OF SHIFT IS
    COMPONENT DFF
        PORT (
            RSTn, CLK, D : IN BIT;
            Q : OUT BIT);
    END COMPONENT;

    SIGNAL T : bit_vector(6 DOWNTO 0);

BEGIN
    bit7 : DFF PORT MAP(RSTn => RSTn, CLK => CLK, D => SI, Q => T(6));
    bit6 : DFF PORT MAP(RSTn, CLK, T(6), T(5));
    bit5 : DFF PORT MAP(RSTn, CLK, T(5), T(4));
    bit4 : DFF PORT MAP(RSTn => RSTn, CLK => CLK, D => T(4), Q => T(3));
    bit3 : DFF PORT MAP(RSTn, CLK, T(3), T(2));
    bit2 : DFF PORT MAP(RSTn, CLK, T(2), T(1));
    bit1 : DFF PORT MAP(RSTn, CLK, T(1), T(0));
    bit0 : DFF PORT MAP(RSTn, CLK, T(0), SO);
END RTL1;