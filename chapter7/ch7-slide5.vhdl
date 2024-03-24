ENTITY SHIFT24 IS
    PORT (
        RSTn, CLK, SI : IN BIT;
        SO : OUT BIT);
END SHIFT24;

ARCHITECTURE RTL5 OF SHIFT24
    COMPONENT SHIFT
        PORT (
            RSTn, CLK, SI : IN BIT;
            SO : OUT BIT);
    END COMPONENT;

    SIGNAL T1, T2 : BIT;

BEGIN
    stage2 : SHIFT PORT MAP(
        RSTn => RSTn, CLK => CLK, SI => SI, SO => T1);
    stage1 : SHIFT PORT MAP(
        RSTn => RSTn, CLK => CLK, SI => T1, SO => T2);
    stage0 : shift PORT MAP(
        RSTn => RSTn, CLK => CLK, SI => T2, SO => SO);
END RTL5;