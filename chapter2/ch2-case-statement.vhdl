ENTITY function_F IS
    PORT (
        A, B, C : IN STD_LOGIC;
        F : OUT STD_LOGIC);
END function_F;

ARCHITECTURE behavior_2 OF function_F IS

    SIGNAL ABC : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

    ABC <= (A, B, C); -- Group signals for the case statement

    my_proc : PROCESS (ABC)
    BEGIN
        CASE (ABC) IS
            WHEN "000" => F <= '1';
            WHEN "010" => F <= '1';
            WHEN "101" => F <= '-';
            WHEN "110" => F <= '-';
            WHEN OTHERS => F <= '0';
        END CASE;
    END PROCESS my_proc;
END behavior_2;