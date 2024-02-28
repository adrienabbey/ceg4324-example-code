LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY adder4 IS
    PORT (
        x4, y4 : IN bit_vector(3 DOWNTO 0);
        cin4 : IN BIT;
        s4 : OUT bit_vector(3 DOWNTO 0);
        cout4 : OUT BIT);
END adder4;

ARCHITECTURE struc OF adder4 IS
    --component declaration
    COMPONENT fa
        PORT (
            x, y, cin : IN BIT;
            s, cout : OUT BIT);
    END COMPONENT;

    -- component specification
    FOR U0 : fa USE ENTITY work.fa(struc);
    FOR U1 : fa USE ENTITY work.fa(struc);
    FOR U2 : fa USE ENTITY work.fa(struc);
    FOR U3 : fa USE ENTITY work.fa(struc);

    -- signal declaration
    SIGNAL c1, c2, c3 : BIT;

BEGIN
    U0 : fa PORT MAP(x4(0), y4(0), cin4, s4(0), c1);
    U1 : fa PORT MAP(x4(1), y4(1), c1, s4(1), c2);
    U2 : fa PORT MAP(x4(2), y4(2), c2, s4(2), c3);
    U3 : fa PORT MAP(x4(3), y4(3), c3, s4(3), cout4);
END struc;