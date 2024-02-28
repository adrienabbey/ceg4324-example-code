ARCHITECTURE struct OF ripple4 IS
    COMPONENT fa
    PORT (
        a_in : IN BIT;
        b_in : IN BIT;
        c_in : IN BIT;
        s : OUT BIT;
        c_out : OUT BIT;
    );

    FOR U0 : fa USE ENTITY work.fa(struc);

    SIGNAL c : bit_vector(2 DOWNTO 0);

BEGIN

    FA0 : fa
    PORT MAP(
        a_in => a(0),
        b_in => b(0),
        c_in => c_in_f,
        s_out => s_out_f(0),
        c_out => c(0)
    );