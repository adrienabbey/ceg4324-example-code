ARCHITECTURE structural OF half_adder IS
    COMPONENT xor2 IS
        PORT (
            a, b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT xor2;
    COMPONENT and2 IS
        PORT (
            a, b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT and2;
BEGIN
    EX1 : xor2 PORT MAP(a => a, b => b, c => sum);
    AND1 : and2 PORT MAP(a => a, b => b, c => carry);
END ARCHITECTURE;