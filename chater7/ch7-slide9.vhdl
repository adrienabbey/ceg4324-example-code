LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY byte_adder IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        CIN : IN STD_LOGIC;
        S : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        CO : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE arch_byt OF byte_adder IS

    COMPONENT fa IS
        PORT (
            a, b, cin : IN STD_LOGIC;
            sum, cout : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT xor2 IS
        PORT (
            a, b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL SIG, CAR : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    CAR(0) <= CIN;
    GK : FOR k IN 31 DOWNTO 0 GENERATE
        X1 : xor2 PORT MAP(CIN, B(k), SIG(k));
        F1 : fa PORT MAP(A(k), SIG(k), CAR(k), S(k), CAR(k + 1));
    END GENERATE GK;

    COUT <= CAR(32);

END ARCHITECTURE arch_byt;