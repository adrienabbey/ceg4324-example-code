ARCHITECTURE parity_dataflow OF parity IS

    SIGNAL xor_out : STD_LOGIC_VECTOR(6 DOWNTO 1);

BEGIN
    G2 : FOR i IN 1 TO 7 GENERATE

        left_xor : IF i = 1 GENERATE
            xor_out(i) <= parity_in(i - 1) XOR parity_in(i);
        END GENERATE;

        middle_xor : IF (i > 1) AND (i < 7) GENERATE
            xor_out(i) <= xor_out(i - 1) XOR parity_in(i);
        END GENERATE;

        right_xor : IF i = 7 GENERATE
            parity_out <= xor_out(i - 1) XOR parity_in(i);
        END GENERATE;

    END GENERATE;
END parity_dataflow;