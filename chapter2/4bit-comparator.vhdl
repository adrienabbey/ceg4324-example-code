LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY comp4 IS
    PORT (
        a, b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        aeqb, agtb, altb : OUT STD_LOGIC);
END comp4;

ARCHITECTURE struc OF comp4 IS

    -- signal declaration

    i3, i2, i1, i0 : STD_LOGIC;
    t3, t2, t1, t0 : STD_LOGIC;
    aeqb_t, agtb_t : STD_LOGIC;

    -- component declaration

    COMPONENT xnor2
        PORT (
            a, b : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT and4
        PORT (
            a, b : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT and4
        PORT (
            a, b : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT andn2
        PORT (
            a, b : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT andn3
        PORT (
            a, b, c : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT andn4
        PORT (
            a, b, c, d : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT andn5
        PORT (
            a, b, c, d, e : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT or4
        PORT (
            a, b, c, d : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT nor2
        PORT (
            a, b : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    -- component specification

    FOR U0 : xnor2 USE ENTITY work.xnor2(struct);
    FOR U1 : xnor2 USE ENTITY work.xnor2(struct);
    FOR U2 : xnor2 USE ENTITY work.xnor2(struct);
    FOR U3 : xnor2 USE ENTITY work.xnor2(struct);
    FOR U4 : andn2 USE ENTITY work.andn2(struct);
    FOR U5 : andn3 USE ENTITY work.andn3(struct);
    FOR U6 : andn4 USE ENTITY work.andn4(struct);
    FOR U7 : andn5 USE ENTITY work.andn5(struct);
    FOR U8 : and4 USE ENTITY work.and4(struct);
    FOR U9 : or4 USE ENTITY work.or4(struct);
    FOR U10 : nor2 USE ENTITY work.nor2(struct);

BEGIN
    U0 : xnor2 PORT MAP(a(3), b(3), i3);
    U1 : xnor2 PORT MAP(
        a => a(2),
        b => b(2),
        z => i2);
    U2 : xnor2 PORT MAP(a(1), b(1), i1);
    U3 : xnor2 PORT MAP(a(0), b(0), i0);
    U4 : andn2 PORT MAP(b(3), b(2), t3);
    U5 : andn3 PORT MAP(i3, b(2), a(2), t2);
    U6 : andn4 PORT MAP(
        i3, i2, b(1),
        a(1), t1);
    U7 : andn5 PORT MAP(
        i3, i2, i1, b(0),
        a(0), t0);
    U8 : and4 PORT MAP(
        i3, i2, i1, i0,
        aeqb_t);
    U9 : or4 PORT MAP(t3, t2, t1, t0, agtb_t);
    U10 : nor2 PORT MAP(
        aeqb_t, agtb_t,
        altb);
    aeqb <= aeqb_t;
    agtb <= agtb_t;
END struc;

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY xnor2 IS
    PORT (
        a, b : IN STD_LOGIC;
        z : OUT STD_LOGIC);
END xnor2;

ARCHITECTURE struc OF xnor2 IS
BEGIN
    z <= a XNOR b;
END struc;

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY nor2 IS
    PORT (
        a, b : IN STD_LOGIC;
        z : OUT STD_LOGIC);
END nor2;

ARCHITECTURE struc OF nor2 IS
BEGIN
    z <= a NOR b;
END struc;

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY or4 IS
    PORT (
        a, b, c, d : IN STD_LOGIC;
        z : OUT STD_LOGIC);
END or4;

ARCHITECTURE struc OF or4 IS
BEGIN
    z <= a OR b OR c OR d;
END struc;

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY andn2 IS
    PORT (
        a, b : IN STD_LOGIC;
        z : OUT STD_LOGIC);
END andn2;

ARCHITECTURE struc OF andn2 IS
BEGIN
    z <= (NOT a) AND b;
END struc;

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY andn3 IS
    PORT (
        a, b, c : IN st_logic;
        z : OUT STD_LOGIC);
END andn3;

ARCHITECTURE struc OF andn3 IS
BEGIN
    z <= a AND (NOT b)
        AND c;
END struc;

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY andn4 IS
    PORT (
        a, b, c, d : IN st_logic;
        z : OUT STD_LOGIC);
END andn4;

ARCHITECTURE struc OF andn4 IS
BEGIN
    z <= a AND b
        AND (NOT c) AND d;
END struc;

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY andn5 IS
    PORT (
        a, b, c, d, e : IN st_logic;
        z : OUT STD_LOGIC);
END andn5;

ARCHITECTURE struc OF andn5 IS
BEGIN
    z <= a AND b
        AND c AND (NOT d)
        AND e;
END struc;