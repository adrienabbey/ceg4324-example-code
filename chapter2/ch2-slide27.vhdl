LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY fa IS
    PORT (
        x, y, cin : IN BIT;
        s, cout : OUT BIT);
END fa;

ARCHITECTURE struc OF fa IS
    -- component declaration
    COMPONENT ha
        PORT (
            a, b : IN BIT;
            sum, c_out : OUT BIT);
    END COMPONENT;

    -- component specification
    FOR U0 : ha USE ENTITY work.ha(struct);
    FOR U1 : ha USE ENTITY work.ha(struct);

    -- signal declaration
    SIGNAL s_tmp : BIT;
    SIGNAL c_tmp1, c_tmp2 : BIT;

BEGIN
    -- component instantiation
    U0 : ha PORT MAP(x, y, s_tmp, c_tmp1);
    U1 : ha PORT MAP(
        b => s_tmp,
        a => cin,
        c_out => c_tmp2,
        sum => s);

    -- generation of cout through signal assig.
    cout <= c_tmp1 OR c_tmp2;
END struc;