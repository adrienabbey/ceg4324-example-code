ARCHITECTURE generic_delay OF half_adder IS
    COMPONENT xor2
        GENERIC (gate_delay : TIME);
        PORT (
            a, b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT and2
        GENERIC (gate_delay : TIME);
        PORT (
            a, b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT;

BEGIN
    EX1 : xor2 GENERIC MAP(gate_delay => 6 ns)
    PORT MAP(a => a, b => b, c => sum);
    A1 : and2 GENERIC MAP(gate_delay => 3 ns)
    PORT MAP(a => a, b => b, c => carry);
END generic_delay;