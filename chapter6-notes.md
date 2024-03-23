# Pipeline
- It took *far too long* to put 1 + 1 together from the slides and understand what pipelining is.  The slides explain the *benefits* of pipelines without explaining *why and how* they work (besides having a series of pictures and code with random splotches of colors that don't immediately make sense).
	- It's been over a year since I took Digital System Design.  This might have made more sense if I had taken that class last semester and remembered what a pipeline was.
- Pipelines allow for a simple circuit to do *multiple* actions *simultaneously*.
	- The Full Adder example can run multiple sums.
	- New inputs can be taken every clock.
	- Since this is similar to a Ripple Carry Adder, it takes multiple clocks to add binary values together.
	- Registers hold inputs and sums, designed such that it properly handles the *ripple* sequence necessary to properly sum the values.
- Pipeline benefits:
	- Improves the throughput of the system when processing a series of tasks.
	- Allows for increasing the clock speed, or reducing power consumption (at the same speed).
	- Downsides: more complex design, slower than simpler designs when not processing a stream of inputs.

## Implementing a Pipeline for a Ripple Carry Adder
- Remember the Ripple Carry Adder: Using a series of Full Adders, the RCA sums two binary numbers, starting with the least-significant bit.
- Because each successive bit sum depends on the previous' carry out, this can only happen in series, which means it takes time.
- Adding a pipeline to an RCA allows for a significant performance increase when summing a stream of inputs together.
- This works for the RCA because we can stagger inputs using registers.
	- The least significant bit FA immediately processes the first sum.
	- The sum of the first FA goes into a series of registers.  Each clock cycle has the result saved into the next register in series.
	- Each additional FA has one additional register on the input, and one less register on the output.
- The input values can change each clock cycle, using registers to remember previous inputs and the final sum in sequence.
	- Think of the registers as a way to "stagger" inputs.  By staggering inputs, we can layer inputs on top of each other, allowing to keep every FA active so long as we have enough inputs to sum together.
	- Outputs are likewise staggered with registers.  The final sum is only available after the most significant bit's FA finishes.
- **This allows for the RCA to "ripple" through *multiple* input values without having to wait for the entire sum to finish before starting the next.**

## Pipeline VHDL Example Code
```VHDL
---
-- Define a simple 1-bit FA:
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
SIGNAL tmp_S0 : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Carries multiple copies of the 1-bit sum of the first FA
SIGNAL tmp_S1 : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Like above, but needing one less:
SIGNAL tmp_S2 : STD_LOGIC_VECTOR(1 DOWNTO 0); -- Because this acts like a Ripple Carry Adder
SIGNAL tmp_S3 : STD_LOGIC;
SIGNAL tmp_A1 : STD_LOGIC; -- Used to connect the inputs with registers.
SIGNAL tmp_B1 : STD_LOGIC;
SIGNAL tmp_A2 : STD_LOGIC_VECTOR(1 DOWNTO 0); -- Each successive FA input needs more registers.
SIGNAL tmp_B2 : STD_LOGIC_VECTOR(1 DOWNTO 0); -- This keeps the pipeline synchronized.
SIGNAL tmp_A3 : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Note: reflect back on the Ripple Carry Adder.
SIGNAL tmp_B3 : STD_LOGIC_VECTOR(2 DOWNTO 0); -- This is why the number of registers changes for each FA.

---
-- Instantiation
---

-- These are registers tying each FA Cout/Cin together.
reg_cout0 : reg PORT MAP(tmp_cout(0), CLK, RSTn, tmp_cin(0));
reg_cout1 : reg PORT MAP(tmp_cout(1), CLK, RSTn, tmp_cin(1));
reg_cout2 : reg PORT MAP(tmp_cout(2), CLK, RSTn, tmp_cin(2));
reg_cout3 : reg PORT MAP(tmp_cout(3), CLK, RSTn, Cout);
-- We don't want the carry to change except on the clock.

-- These are the FAs.
FA_0 : FA PORT MAP(
    Cin => Cin, A => A(0), B => B(0),
    S => tmp_S0(0), Cout => tmp_cout(0));
FA_1 : FA PORT MAP(
    Cin => tmp_cin(0), A => tmp_A1, B => tmp_B1, -- Note that the inputs are from signals tied to registers
    S => tmp_S1(0), Cout => tmp_cout(1));
FA_2 : FA PORT MAP(
    Cin => tmp_cin(1), A => tmp_A2(1), B => tmp_B2(1),
    S => tmp_S2(0), Cout => tmp_cout(2));
FA_3 : FA PORT MAP(
    Cin => tmp_cin(2), A => tmp_A3(2), B => tmp_B3(2),
    S => tmp_S3, Cout => tmp_cout(3));

-- These are registers tying the 1-bit FA sums to the pipeline:
-- Output registers for the first FA:
reg_s0_0 : reg PORT MAP(tmp_S0(0), CLK, RSTn, tmp_S0(1)); -- tmp_S0(0) carries the sum of the FA
reg_s0_1 : reg PORT MAP(tmp_S0(1), CLK, RSTn, tmp_S0(2));
reg_s0_2 : reg PORT MAP(tmp_S0(2), CLK, RSTn, tmp_S0(3));
reg_s0_3 : reg PORT MAP(tmp_S0(3), CLK, RSTn, S(0));
-- Note how the sum ripples through the registers in sequence based on clock.

-- Output registers for the second FA:
reg_s1_0 : reg PORT MAP(tmp_S1(0), CLK, RSTn, tmp_S1(1));
reg_s1_1 : reg PORT MAP(tmp_S1(1), CLK, RSTn, tmp_S1(2));
reg_s1_2 : reg PORT MAP(tmp_S1(2), CLK, RSTn, S(1));

-- Output registers for the third FA:
reg_s2_0 : reg PORT MAP(tmp_S2(0), CLK, RSTn, tmp_S2(1));
reg_S2_1 : reg PORT MAP(tmp_S2(1), CLK, RSTn, S(2));
-- Note how each successive FA requires one less register.

-- Output registers for the final FA:
reg_s3_1 : reg PORT MAP(tmp_S3, CLK, RSTn, S(3));

-- Input registers for the *second* FA:
reg_A1 : reg PORT MAP(A(1), CLK, RSTn, tmp_A1);
reg_B1 : reg PORT MAP(B(1), CLK, RSTn, tmp_B1);

-- Input registers for the *third* FA:
reg_A2_0 : reg PORT MAP(A(2), CLK, RSTn, tmp_A2(0));
reg_B2_0 : reg PORT MAP(B(2), CLK, RSTn, tmp_B2(0));
reg_A2_1 : reg PORT MAP(tmp_A2(0), CLK, RSTn, tmp_A2(1));
reg_B2_1 : reg PORT MAP(tmp_B2(0), CLK, RSTn, tmp_B2(0));
-- Note that the third FA needs a pair of registers, 
-- as it is two clock cycles behind the first.

-- Input registers for the final FA:
reg_A3_0 : reg PORT MAP(A(3), CLK, RSTn, tmp_A3(0));
reg_B3_0 : reg PORT MAP(B(3), CLK, RSTn, tmp_B3(0));
reg_A3_1 : reg PORT MAP(tmp_A3(0), CLK, RSTn, tmp_A3(1));
reg_B3_1 : reg PORT MAP(tmp_B3(0), CLK, RSTn, tmp_B3(1));
reg_A3_2 : reg PORT MAP(tmp_A3(1), CLK, RSTn, tmp_A3(2));
reg_B3_2 : reg PORT MAP(tmp_B3(1), CLK, RSTn, tmp_B3(2));
-- The pattern repeats, adding another set of registers.

---
-- NOTE: The entity/architecture of the above piped adder is never mentioned in 
-- the slides.  We seem to be expected to fill in the blanks ourselves.
---
```