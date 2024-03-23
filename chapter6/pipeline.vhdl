---
-- Simple 1-bit FA:
---

ENTITY FA IS
    PORT (
        Cin, A, B : IN STD_LOGIC;
        Cout, S : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behavior OF FA IS
BEGIN
    S <= A XOR B XOR Cin;
    Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B);
END ARCHITECTURE;

---
-- Simple register (DFF?)
---

ENTITY reg IS
    PORT (
        D, CLK, RSTn : IN STD_LOGIC;
        Q : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behavior OF reg IS
BEGIN
    PROCESS (CLK, RSTn)
    BEGIN
        IF RSTn = '0' THEN
            Q <= '0';
        ELSIF rising_edge(CLK) THEN
            Q <= D;
        END IF;
    END PROCESS;
END ARCHITECTURE;

---
-- Signals
---

-- Declaration of signals used to interconnect gates
SIGNAL tmp_cout : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Ties the FA Couts to registers
SIGNAL tmp_cin : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Ties the above registers to FA Cins
SIGNAL tmp_S0 : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Part of the pipeline, carrying the sum of the first FA
SIGNAL tmp_S1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL tmp_S2 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL tmp_S3 : STD_LOGIC;
SIGNAL tmp_A1 : STD_LOGIC;
SIGNAL tmp_B1 : STD_LOGIC;

---
-- Instantiation
---

-- These are registers tying the FA Couts together.
reg_cout0 : reg PORT MAP(tmp_cout(0), CLK, RSTn, tmp_cin(0));
reg_cout1 : reg PORT MAP(tmp_cout(1), CLK, RSTn, tmp_cin(1));
reg_cout2 : reg PORT MAP(tmp_cout(2), CLK, RSTn, tmp_cin(2));
reg_cout3 : reg PORT MAP(tmp_cout(3), CLK, RSTn, Cout);

-- These are the FAs.
FA_0 : FA PORT MAP(
    Cin => Cin, A => A(0), B => B(0),
    S => tmp_S0(0), Cout => tmp_cout(0));
FA_1 : FA PORT MAP(
    Cin => tmp_cin(0), A => tmp_A1, B => tmp_B1,
    S => tmp_S1(0), Cout => tmp_cout(1));
FA_2 : FA PORT MAP(
    Cin => tmp_cin(1), A => tmp_A2(1), B => tmp_B2(1),
    S => tmp_S2(0), Cout => tmp_cout(2));
FA_3 : FA PORT MAP(
    Cin => tmp_cin(2), A => tmp_A3(2), B => tmp_B3(2),
    S => tmp_S3, Cout => tmp_cout(3));

-- These are registers tying the 1-bit FA sums to the pipeline:
-- For the first FA:
reg_s0_0 : reg PORT MAP(tmp_S0(0), CLK, RSTn, tmp_S0(1)); -- tmp_S0(0) carries the sum of the FA
reg_s0_1 : reg PORT MAP(tmp_S0(1), CLK, RSTn, tmp_S0(2));
reg_s0_2 : reg PORT MAP(tmp_S0(2), CLK, RSTn, tmp_S0(3));
reg_s0_3 : reg PORT MAP(tmp_S0(3), CLK, RSTn, S(0));
-- Note how the sum ripples through the registers in sequence based on clock.

-- For the second FA:
reg_s1_0 : reg PORT MAP(tmp_S1(0), CLK, RSTn, tmp_S1(1));
reg_s1_1 : reg PORT MAP(tmp_S1(1), CLK, RSTn, tmp_S1(2));
reg_s1_2 : reg PORT MAP(tmp_S1(2), CLK, RSTn, S(1));

-- For the third FA:
reg_s2_0 : reg PORT MAP(tmp_S2(0), CLK, RSTn, tmp_S2(1));
reg_S2_1 : reg PORT MAP(tmp_S2(1), CLK, RSTn, S(2));
-- Note how each successive FA requires one less register.
-- This is because one of the previous sums is carried to an input of the next FA.

-- For the final FA:
reg_s3_1 : reg PORT MAP(tmp_S3, CLK, RSTn, S(3));