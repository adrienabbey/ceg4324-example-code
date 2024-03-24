ARCHITECTURE parity_dataflow OF parity IS

    SIGNAL xor_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    xor_out(0) <= parity_in(0);

    G2 : FOR i IN 1 TO 7 GENERATE
        xor_out(i) <= xor_out(i - 1) XOR parity_in(i);
    END GENERATE G2;

    parity_out <= xor_out(7);

END parity_dataflow;