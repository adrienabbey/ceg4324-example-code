ma : PROCESS (a, b, d, c_in)
    VARIABLE m_temp : bit_vector(7 DOWNTO 0) := "00000000";

BEGIN
    mult_tmp := a * b;
    sum <= mult_tmp + d + c_in;
END PROCESS;