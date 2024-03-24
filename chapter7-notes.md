# Component Instantiation Using `GENERATE`

- `GENERATE` is very useful when you need to instantiate *many* copies of the same component.

## The `GENERATE` Statement
- `GENERATE` is a concurrent statement.
- `IF` and `FOR` are sequential statements.
	- These two are directly related to `GENERATE`, and are NOT exactly the same as typical `IF` and `FOR` statements/loops.
	- The `IF` condition in a `GENERATE` loop does *not* have `ELSE` or `ELSIF` clauses.
- A label is required for a `GENERATE` statement.
	- This label is used to reference generated objects, much like an array.

### 8-Bit Shifter Register (without `GENERATE`)
```VHDL
ENTITY DFF IS
    PORT (
        RSTn, CLK, D : IN BIT;
        Q : OUT BIT);
END DFF;

ARCHITECTURE RTL OF DFF IS
BEGIN
    PROCESS (RSTn, CLK)
    BEGIN
        IF (RSTn = '0') THEN
            Q <= '0';
        ELSIF (CLK'event AND CLK = '1') THEN
            Q <= D;
        END IF;
    END PROCESS;
END RTL;

ENTITY SHIFT IS
    PORT (
        RSTn, CLK, SI : IN BIT;
        SO : OUT BIT);
END SHIFT;

ARCHITECTURE RTL1 OF SHIFT IS
    COMPONENT DFF
        PORT (
            RSTn, CLK, D : IN BIT;
            Q : OUT BIT);
    END COMPONENT;

    SIGNAL T : bit_vector(6 DOWNTO 0);

BEGIN
    bit7 : DFF PORT MAP(RSTn => RSTn, CLK => CLK, D => SI, Q => T(6));
    bit6 : DFF PORT MAP(RSTn, CLK, T(6), T(5));
    bit5 : DFF PORT MAP(RSTn, CLK, T(5), T(4));
    bit4 : DFF PORT MAP(RSTn => RSTn, CLK => CLK, D => T(4), Q => T(3));
    bit3 : DFF PORT MAP(RSTn, CLK, T(3), T(2));
    bit2 : DFF PORT MAP(RSTn, CLK, T(2), T(1));
    bit1 : DFF PORT MAP(RSTn, CLK, T(1), T(0));
    bit0 : DFF PORT MAP(RSTn, CLK, T(0), SO);
END RTL1;
```

### 24-bit Shifter Register (without `GENERATE`)
- Note: Includes the above 8-bit Shifter Register.

```VHDL
ENTITY SHIFT24 IS
    PORT (
        RSTn, CLK, SI : IN BIT;
        SO : OUT BIT);
END SHIFT24;

ARCHITECTURE RTL5 OF SHIFT24
    COMPONENT SHIFT
        PORT (
            RSTn, CLK, SI : IN BIT;
            SO : OUT BIT);
    END COMPONENT;

    SIGNAL T1, T2 : BIT;

BEGIN
    stage2 : SHIFT PORT MAP(
        RSTn => RSTn, CLK => CLK, SI => SI, SO => T1);
    stage1 : SHIFT PORT MAP(
        RSTn => RSTn, CLK => CLK, SI => T1, SO => T2);
    stage0 : shift PORT MAP(
        RSTn => RSTn, CLK => CLK, SI => T2, SO => SO);
END RTL5;
```

### 8-bit Shift Register using `IF` `GENERATE` Statements

- A Shift Register simply keeps shifting bits through itself every clock.  This is useful to delay an input a fixed number of clock cycles.
- This design use the `IF` statement as part of a `GENERATE` to specify different configurations of a generated instantiation.  
	- This is useful when the first/last of the list needs to handle inputs/outputs differently than those between, as seen below.

```VHDL
COMPONENT DFF
    PORT (
        RSTn, CLK, D : IN BIT;
        Q : OUT BIT);
END COMPONENT;

SIGNAL T : bit_vector(6 DOWNTO 0);

BEGIN
g0 : FOR i IN 7 DOWNTO 0 GENERATE
    g1 : IF (i = 7) GENERATE
        bit7 : DFF PORT MAP(RSTn => RSTn, CLK => CLK, D => SI, Q = T(6));
    END GENERATE;
    g2 : IF (i > 0) AND (i < 7) GENERATE
        bitm : DFF
        PORT MAP(RSTn, CLK, T(i), T(i - 1));
    END GENERATE;
    g3 : IF (i = 0) GENERATE
        bit0 : DFF PORT MAP(RSTn, CLK, T(0), S0);
    END GENERATE;
END GENERATE;
END RTL2;
```

### 8-bit Shift Register using `GENERATE` *without* `IF` Statements

- The same design as the above example can be generated without any `IF` statements, where every generated instantiation is the same.
	- This simplifies design, assigning unique inputs/outputs to signals instead.

```VHDL
ARCHITECTURE RTL3 OF SHIFT IS
    COMPONENT DFF
        PORT (
            RSTn, CLK, D : IN BIT;
            Q : OUT BIT);
    END COMPONENT;

    SIGNAL T : bit_vector(8 DOWNTO 0);

BEGIN
    T(8) <= SI;
    SO <= T(0);
    g0 : FOR i IN 7 DOWNTO 0 GENERATE
        allbit : DFF PORT MAP(RSTn => RSTn, CLK => CLK, D => T(i + 1), Q => (Ti));
    END GENERATE;
END RTL3;
```

### 32-bit binary Adder-Subtractor

- This byte adder design is very similar to a Ripple Carry Adder, with the addition of XOR gates.
- This was confusing at first, as it uses the label `add/sub`, but uses `CIN` exclusively in the code.
	- This is actually the input toggle for adding/subtracting.
	- When this input is `1`, it causes B to invert (1's complement).
	- Additionally, this is also the first `CIN` value, which is the same as adding 1, turning this into a 2's complement function.
- https://www.geeksforgeeks.org/4-bit-binary-adder-subtractor/

```VHDL
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY byte_adder IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        CIN : IN STD_LOGIC;
        S : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        CO : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE arch_byt OF byte_adder IS

    COMPONENT fa IS
        PORT (
            a, b, cin : IN STD_LOGIC;
            sum, cout : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT xor2 IS
        PORT (
            a, b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL SIG, CAR : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    CAR(0) <= CIN;
    GK : FOR k IN 31 DOWNTO 0 GENERATE
        X1 : xor2 PORT MAP(CIN, B(k), SIG(k));
        F1 : fa PORT MAP(A(k), SIG(k), CAR(k), S(k), CAR(k + 1));
    END GENERATE GK;

    COUT <= CAR(32);

END ARCHITECTURE arch_byt;
```

### Ripple Carry Adder using `GENERATE`
```VHDL
ENTITY FULL_ADD4 IS
    PORT (
        A, B : IN BIT_VECTOR(3 DOWNTO 0);
        CIN : IN BIT;
        SUM : OUT BIT_VECTOR(3 DOWNTO 0);
        COUT : OUT BIT);
END FULL_ADD4;

ARCHITECTURE FOR_GENERATE OF FULL_ADD4 IS

    COMPONENT FULL_ADDER
        PORT (
            A, B, C : IN BIT;
            COUT, SUM : OUT BIT);
    END COMPONENT;

    SIGNAL CAR : BIT_VECTOR(4 DOWNTO 0);

BEGIN
    CAR(0) <= CIN;
    GK : FOR K IN 3 DOWNTO 0 GENERATE
        FA : FULL_ADDER PORT MAP(CAR(K), A(K), B(K), CAR(K + 1), SUM(K));
    END GENERATE GK;
    COUT <= CAR(4);
END FOR_GENERATE;
```

### Parity Generator with `IF` `GENERATE`
- Transmitted or stored data can sometimes become corrupted.
- Parity is often used to detect when this happens.
- The parity generator below will create a single parity bit for every 8-bits of input.
	- This will enable detection of single bit changes.
	- This does NOT add error correction, however.

```VHDL
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
```

### Parity Generator without `IF` `GENERATE`
```VHDL
ARCHITECTURE parity_dataflow OF parity IS

    SIGNAL xor_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    xor_out(0) <= parity_in(0);

    G2 : FOR i IN 1 TO 7 GENERATE
        xor_out(i) <= xor_out(i - 1) XOR parity_in(i);
    END GENERATE G2;

    parity_out <= xor_out(7);

END parity_dataflow;
```