ARCHITECTURE structural OF full_adder IS
    COMPONENT generic_or
        GENERIC (n : POSITIVE);
        PORT (
            in1 : IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
            z : OUT STD_LOGIC);
    END COMPONENT;

    ---
    --- -- remainder of the declarative region from earlier example
    ---

BEGIN
    H1 : half_adder PORT MAP(a => In1, b => In2, sum => s1, carry => s3);
    H2 : half_adder PORT MAP(a => s1, b => c_in, sum => sum, carry => s2);

    O1 : generic_or GENERIC MAP(n => 2)
    PORT MAP(a => s2, b => s3, c => c_out);

END structural;