# Chapter 2 Notes
> **These are just personal notes based on slides from my CEG-4324 class.  I make NO guarantees that any of the following is accurate, nor do I claim any ownership of the code below.**

## Entity Declaration

```VHDL
ENTITY fulladder IS
    PORT (
        A, B, CIN : IN BIT;
        SUM, COUT : OUT BIT);
END fulladder;
```

- Entities are described from an *external view*.  Think of these as defining a function stub, which declares the function's required inputs and what it returns.  The entity does NOT define *how* it functions.
- In the above example:
	- Red words are *reserved words*.
	- Grey words are *names*.
	- Gold words are *types*.

## Architecture Body

```VHDL
ARCHITECTURE structure OF fulladder IS
    COMPONENT xor2 PORT (A, B : IN BIT;
        C : OUT BIT);
    END COMPONENT;
    COMPONENT or2 PORT (A, B : IN BIT;
        C : OUT BIT);
    END COMPONENT;
    COMPONENT and2 PORT (A, B : IN BIT;
        C : OUT BIT);
    END COMPONENT;
    SIGNAL s1, s2, s3, s4, s5 : BIT;
BEGIN
    x1 : xor2 PORT MAP(A, B, s1);
    x2 : xor2 PORT MAP(s1, CIN, SUM);
    a1 : and2 PORT MAP(A, B, s2);
    a2 : and2 PORT MAP(B, CIN, s3);
    a3 : and2 PORT MAP(A, CIN, s4);
    o1 : or2 PORT MAP(s2, s3, s5);
    o2 : or2 PORT MAP(s4, s5, COUT);
END structure;
```

- The architecture defines *how* an already declared entity functions.  This is similar to all the code within a function.
- The first part is the **component declaration**.  This defines component names, their port names, and types.
- At the end of the component declaration, **signal** names and types are defined.  Signals are used to connect components *internally*.
- Last, **instances** of components are defined, along with how they all map together.  Instances are copies of components with unique names, as well as how their ports map to different inputs, signals, and outputs.
- **NOTE**: This example maps ports *by position*.  This means the order of ports for each instance align with the ports declared in the component declaration.

### Example

```VHDL
ARCHITECTURE structure OF fulladder IS
    COMPONENT halfadder
        PORT (
            A, B : IN BIT;
            S, C : OUT BIT);
    END COMPONENT;
    COMPONENT or2
        PORT (
            A, B : IN BIT;
            C : OUT BIT);
    END COMPONENT;
    SIGNAL s1, s2, s3 : BIT;
BEGIN
    ha1 : halfadder PORT MAP(A, B, s1, s2);
    o1 : or2 PORT MAP(s2, s3, COUT);
    ha2 : halfadder PORT MAP(CIN, s1, SUM, s3);
END structure;
```

### Port Mapping by Name
```VHDL
ARCHITECTURE structure OF fulladder IS
    COMPONENT halfadder
        PORT (
            A, B : IN BIT;
            S, C : OUT BIT);
    END COMPONENT;
    COMPONENT or2
        PORT (
            A, B : IN BIT;
            C : OUT BIT);
    END COMPONENT;
    SIGNAL s1, s2, s3 : BIT;
BEGIN
    ha1 : halfadder PORT MAP(A, B, s1, s2);
    o1 : or2 PORT MAP(s2, s3, COUT);
    ha2 : halfadder PORT MAP(S => SUM, A => CIN, C => s3, B => s1);
END structure;
```
- Take note of the final line of code: this is port mapping *by name*.
	- The port order does *not* matter.  The *direction* of the mapping *does* matter.
		- `componentPortName => entityPortName`  or  `componentPortName => signalName` 
		- In this example, `SUM => S` would *not* work!
	- Port mapping by name is easier to debug, especially if entities or components get changed.

## Hierarchy and Abstraction

```VHDL
ARCHITECTURE structural OF half_adder IS
    COMPONENT xor2 IS
        PORT (
            a, b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT xor2;
    COMPONENT and2 IS
        PORT (
            a, b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT and2;
BEGIN
    EX1 : xor2 PORT MAP(a => a, b => b, c => sum);
    AND1 : and2 PORT MAP(a => a, b => b, c => carry);
END ARCHITECTURE;
```

- Entity and architectural files can be used in a hierarchy.
- In the above example, it's implied that `full_adder.vhd` uses `or2.vhd` and `half-adder.vhd` as components.  It can be assumed that `half-adder.vhd` uses `and2.vhd` and `xor2.vhd`.
	- Here, `full_adder.vhd` would be the top level, while `and2.vhd` and `xor2.vhd` are at the bottom level.
- This helps abstract the design, breaking a complex design up into smaller pieces.

## Generics
```VHDL
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY xor2 IS
    GENERIC (gate_delay : TIME := 2 ns);
    PORT (
        In1, In2 : IN STD_LOGIC;
        z : OUT STD_LOGIC);
END ENTITY xor2;

ARCHITECTURE behavioral OF xor2 IS
BEGIN
    z <= (In1 XOR In2) AFTER gate_delay;
END ARCHITECTURE behavioral;
```

- A **generic** can be thought of as a variable.
	- In this example, `gate_delay` has the `Time` type, with a value of `2 ns` (nanoseconds).
	- *NOTE*: When setting generics *as part of entity definitions*, use `:=`.
	-  `gate_delay` is used in the architecture section to define the delay between input and output changes.

### Generic Mapping
```VHDL
ARCHITECTURE generic_delay OF half_adder IS
    COMPONENT xor2
        GENERIC (gate_delay : TIME);
        PORT (
            a, b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT and2
        GENERIC (gate_delay : TIME);
        PORT (
            a, b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT;

BEGIN
    EX1 : xor2 GENERIC MAP(gate_delay => 6 ns)
    PORT MAP(a => a, b => b, c => sum);
    A1 : and2 GENERIC MAP(gate_delay => 3 ns)
    PORT MAP(a => a, b => b, c => carry);
END generic_delay;
```

- Here generics are defined as part of components.  
	- In this example, two components each have their own `gate_delay` generic of the `TIME` type.
- When defining instances of components, one can *map generics*, which allows defining values for those generics.
	- *NOTE*: When mapping generics, use standard mapping `=>` syntax!  This is NOT the same when defining generics in the component declaration!
	- In this example, each instance of a component has a unique `gate_delay` value.

### Generic Precedence
```VHDL
ARCHITECTURE generic_delay2 OF half_adder IS
    COMPONENT xor2
        GENERIC (gate_delay : TIME);
        PORT (
            a, b : IN STD_LOGIC :
            c : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT and2
        GENERIC (gate_delay : TIME := 6 ns);
        PORT (
            a, b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT;

BEGIN
    EX1 : xor2 GENERIC MAP(gate_delay => gate_delay)
    PORT MAP(a => a, b => b, c => sum);
    A1 : and2 GENERIC MAP(gate_delay => 4 ns)
    PORT MAP(a => a, b => b, c => carry);
END generic_delay2;
```

- **Generic mapping takes precedence** over component declarations.
	- In this example, the `and2` component has a specified `gate_delay` value of `6 ns`, but a generic map value of `4 ns`.  The `4 ns` value takes precedence here.

## Processing when Input Changes, For Loops
```VHDL
ENTITY generic_or IS
    GENERIC (n : POSITIVE := 2);
    PORT (
        in1 : IN STD_LOGIC_VECTOR((n - 1) DOWNTO 0);
        z : OUT STD_LOGIC);
END ENTITY generic_or;

ARCHITECTURE behavioral OF generic_or IS
BEGIN
    PROCESS (in1)
        VARIABLE sum : STD_LOGIC := '0';
    BEGIN
        sum := '0';
        FOR i IN 0 TO (n - 1) LOOP
            sum := sum OR in1(i);
        END LOOP;
        z <= sum;
    END PROCESS;
END ARCHITECTURE behavioral;
```

- In this example, `n` is a `POSITIVE` type (aka integer) with the initial value of `2`.
- `STD_LOGIC_VECTOR` have a fixed number of boolean values.
	- In this example, we use `n` to define the size of the `STD_LOGIC_VECTOR`.
		- `DOWNTO` allows us to set the index range of the `STD_LOGIC_VECTOR`.
- `PROCESS` is used to trigger events when a value changes in the specified port.
	- In this example, any time `in1` changes in value, it begins to *process* actions as a result.
	- Inside the process block the boolean variable `sum` is defined, starting with a bit value of `'0'` (appearing in green).  Note that single-quotes are used to define a bit value, similarly to  `char` values.
		- This declaration is *before* the process `BEGIN` statement!  Declaring variables inside a loop is usually a *very bad idea*, at least in C++.
		- VHDL appears to be able to recognize types here.  `sum` has no explicit type stated, but because its value is set as a boolean, it likely inherits that.
	- Everything between `BEGIN` and `END PROCESS` is processed whenever `in1` changes.
		- `sum` is set to `0` every time.
		- A `FOR` `LOOP` is then defined.
			- Note that `i` does NOT have a declared type!
				- It likely has some sort of integer type, possibly `POSITIVE`, as it includes `n` when defining the range.
			- `n` is used to determine how many loops are necessary, much like when used to define the `STD_LOGIC_VECTOR`.
			- `i` is used to specify the index of `in1`
			- `sum` is set using a standard `OR` statement in each loop.
		- After the loop ends, `z` is set to the value of `sum`.

## Examples
### Generic N-Input OR Gate
```VHDL
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
```

- In this example, a `generic_or` component of unspecified size is declared.
	- The generic `n` is declared inside the component in order to specify the input size.
- When defining an instance of the `generic_or` component, the `n` generic is mapped to a value of `2`
	- *NOTE*: I do *not* know why the component has the port `in1` declared as a `STD_LOGIC_VECTOR` , while the instance of that component maps to `a`, `b`, and `c`.  I'm guessing this is a typo or error in the slides.

### Reduced AND Example
```VHDL
ENTITY RedAnd IS
    GENERIC (width : INTEGER := 8);
    PORT (
        A : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        Z : OUT STD_LOGIC);
END RedAnd;

ARCHITECTURE Behavioral OF RedAnd IS
BEGIN
    reduceAnd : PROCESS (A)
        VARIABLE zv : STD_LOGIC;
    BEGIN
        zv := A(0);
        FOR i IN 1 TO width - 1 LOOP
            zv := zv AND A(i);
        END LOOP;
        Z <= zv;
    END PROCESS reduceAnd;
END Behavioral;
```

- Note that `ENTITY` and `ARCHITECTURE` are both defined here.
- This code will result in several 2-input `AND` gates linked together sequentially.

### Reduced OR Example
```VHDL
ENTITY RedOr IS
    GENERIC (width : INTEGER := 8);
    PORT (
        A : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        Z : OUT STD_LOGIC);
END RedOr;

ARCHITECTURE Behavioral OF RedOr IS
BEGIN
    reduceOr : PROCESS (A)
        VARIABLE zv : STD_LOGIC;
    BEGIN
        zv := A(0);
        FOR i IN 1 TO width - 1 LOOP
            zv := zv OR A(i);
        END LOOP;
        Z <= zv;
    END PROCESS reduceOr;
END Behavioral;
```

- Like the previous example, this creates a series of 2-input AND gates linked sequentially.

### All Zeroes Detection Example
```VHDL
ENTITY AllZeroDet IS
    GENERIC (width : INTEGER := 8);
    PORT (
        A : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        Z : OUT STD_LOGIC);
END AllZeroDet;

ARCHITECTURE Structural OF AllZeroDet IS
    COMPONENT RedOr
        GENERIC (width : INTEGER);
        PORT (
            A : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
            Z : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL ZT : STD_LOGIC;

BEGIN
    zeroFlag : RedOr
    GENERIC MAP(width)
    PORT MAP(A, ZT);
    Z <= NOT ZT;
END Structural;
```

- *NOTE*: This appears to make use of the above Reduced OR code.
- This code looks and feels *wrong* to me.  Some of it starts to make sense after thinking about more.
	- `width` is defined in the `AllZeroDet` entity as `8`, while the component `width` is undefined.
	- The `zeroFlag` instance of `RedOr` maps the generic `width`, which I assume means it uses the value set in the entity above.
	- The initial value of `A(0)` is never used to *start* the chain of OR instances, unlike previous examples.
		- In class today (a week after this lecture), it was made rather clear that any undefined state is replaced by a memory device that remembers its previous state.  This suggests at `A(0)` is ORed with an unchanging zero.
			- If all my assumptions are correct, this code is probably functional.  However, the diagram in the slides does not show this.
	- There is supposedly some form of recursion going on here, but I'm not sure how that happens.
- The example image suggests this creates a chain of reduced OR gates connected sequentially, like in the previous examples.  However, the very first reduced OR gate compares `A(0)` with `A(1)`.
- **I really dislike this example.  Too many unknowns.**

### Reduced XOR Example

```VHDL
ENTITY RedXor IS
    GENERIC (width : INTEGER := 8);
    PORT (
        A : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        Z : OUT STD_LOGIC);
END RedXor;

ARCHITECTURE Behavioral OF RedXor IS
BEGIN
    reduceXor : PROCESS (A)
        VARIABLE zv : STD_LOGIC;
    BEGIN
        zv := A(0);
        FOR i IN 1 TO width - 1 LOOP
            zv := zv XOR A(i);
        END LOOP;
        Z <= zv;
    END PROCESS reduceXor;
END Behavioral;
```

- This feels much better than the previous example.
- Creates a chain of XORs that are sequentially connected.

## Component Specification Syntax
```VHDL
FOR U0 : fa USE ENTITY work.fa(struct);
```

- This is used when declaring components in an architecture.
	- This allows specifying specific architecture variations of the same entity.
	- Example: a full-adder that has high-performance and low-power variants.
- Label: `U0`
	- *NOTE*: no, I don't know what this label is used for.
- Component name: `fa`
	- This name is used when specifying instances.
- Working directory: `work`
- Entity name: `fa`
	- Presumably a file within the working directory
- Architecture name: `struc`

### Example: Component Instant
```VHDL
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
```

- I feel like there is *far too much* information and context missing in these last few slides.

## 4-bit Ripple Adder
- A half adder performs addition of two bits, resulting in a sum bit and a carry out.

### Half Adder VHDL Code
```VHDL
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY ha IS
    PORT (
        a, b : IN BIT;
        sum, c_out : OUT BIT);
END ha;

ARCHITECTURE behav OF ha IS
BEGIN
    sum <= a XOR b;
    c_out <= a AND b;
END behav;
```

### Full Adder VHDL Code
```VHDL
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY fa IS
    PORT (
        x, y, cin : IN BIT;
        s, cout : OUT BIT);
END fa;

ARCHITECTURE struc OF fa IS
    -- component declaration
    COMPONENT ha
        PORT (
            a, b : IN BIT;
            sum, c_out : OUT BIT);
    END COMPONENT;

    -- component specification
    FOR U0 : ha USE ENTITY work.ha(struct);
    FOR U1 : ha USE ENTITY work.ha(struct);

    -- signal declaration
    SIGNAL s_tmp : BIT;
    SIGNAL c_tmp1, c_tmp2 : BIT;

BEGIN
    -- component instantiation
    U0 : ha PORT MAP(x, y, s_tmp, c_tmp1);
    U1 : ha PORT MAP(
        b => s_tmp,
        a => cin,
        c_out => c_tmp2,
        sum => s);

    -- generation of cout through signal assig.
    cout <= c_tmp1 OR c_tmp2;
END struc;
```

- This finally clarifies how component specification works.  Kinda.
	- `U0` and `U1` are instances.
	- `ha` is a component.
	- Presumably, if there were multiple architectures for each `ha` file, the component specification would determine which architecture is used?
- **We really, really should NOT be learning how to code from slides.  This is terrible.  I learn by *doing*, and I'm not *doing* anything more than typing this out from slides as I try to process what is being displayed, and forced to make a *lot* of assumptions due to lack of context.**

### 4-bit Ripple Adder VHDL Code
```VHDL
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY adder4 IS
    PORT (
        x4, y4 : IN bit_vector(3 DOWNTO 0);
        cin4 : IN BIT;
        s4 : OUT bit_vector(3 DOWNTO 0);
        cout4 : OUT BIT);
END adder4;

ARCHITECTURE struc OF adder4 IS
    --component declaration
    COMPONENT fa
        PORT (
            x, y, cin : IN BIT;
            s, cout : OUT BIT);
    END COMPONENT;

    -- component specification
    FOR U0 : fa USE ENTITY work.fa(struc);
    FOR U1 : fa USE ENTITY work.fa(struc);
    FOR U2 : fa USE ENTITY work.fa(struc);
    FOR U3 : fa USE ENTITY work.fa(struc);

    -- signal declaration
    SIGNAL c1, c2, c3 : BIT;

BEGIN
    U0 : fa PORT MAP(x4(0), y4(0), cin4, s4(0), c1);
    U1 : fa PORT MAP(x4(1), y4(1), c1, s4(1), c2);
    U2 : fa PORT MAP(x4(2), y4(2), c2, s4(2), c3);
    U3 : fa PORT MAP(x4(3), y4(3), c3, s4(3), cout4);
END struc;
```

## 4-bit Comparator
- Two 4-bit inputs, `A` and `B`, representing unsigned binary numbers.
- Three outputs:
	- `AeqB`: `1` when `A = B`, otherwise `0`
	- `AgtB`: `1` when `A > B`, otherwise `0`
	- `AltB`: `1` when `A < B`, otherwise `0`

### 4-bit Comparator VHDL Code
```VHDL
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
```

## Exercise Examples
### Exercise 2.1.1
```VHDL
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY sequential_1 IS
    PORT (
        a, b, c, clk : IN STD_LOGIC;
        out1 : OUT STD_LOGIC);
END ENTITY sequential_1;

ARCHITECTURE sequential_structure OF sequential_1 IS

    -- Component declarations

    COMPONENT INV1
        PORT (
            a : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT OR2
        PORT (
            a, b : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT MUX2
        PORT (
            a, b, sel : IN STD_LOGIC;
            z : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT DFF1
        PORT (
            d, clk : IN STD_LOGIC;
            q : OUT STD_LOGIC);
    END COMPONENT;

    -- signal declarations

    SIGNAL s1, s2, s3 : STD_LOGIC;

    -- component instantiation statements

BEGIN

    u1 : INV1
    PORT MAP(a => b, z => s1);

    u2 : OR2
    PORT MAP(a => b, b => c, z => s2);

    u3 : MUX2
    PORT MAP(a => s1, b => s2, sel => a, z => s3);

    u4 : DFF1
    PORT MAP(d => s3, clk => clk, q => out1);

END sequential_structure;
```

- The top entity is declared as `sequential_1` but the ending statement refers to `buzzer`.  Fixed.

### Exercise 2.1.2: Concurrent Boolean vs. Sequential IF Statements
```VHDL
--
-- 1a: concurrent VHDL code (Boolean expression)
--

ENTITY function_F IS
    PORT (
        A, B, C : IN STD_LOGIC;
        F : OUT STD_LOGIC);
END function_F;

ARCHITECTURE concurrent OF function_F IS
BEGIN
    F <= (NOT A AND NOT B AND NOT C) OR (NOT A AND B AND NOT C)
        OR (A AND NOT B AND C) OR (A AND B AND NOT C);
END concurrent;

--
-- 1b: use IF statement
--

ENTITY function_F IS
    PORT (
        A, B, C : IN STD_LOGIC;
        F : OUT STD_LOGIC);
END function_F;

ARCHITECTURE behavior_1 OF function_F IS
BEGIN
    proc1 : PROCESS (A, B, C)
    BEGIN
        IF (A = '0' AND C = '0') THEN
            F <= '1';
        ELSIF (A = '1' AND B = '0' AND C = '1') THEN
            F <= '1';
        ELSIF (B = '1' AND C = '0') THEN
            F <= '1';
        ELSE
            F <= '0';
        END IF;
    END PROCESS proc1;
END behavior_1;
```

- Using Boolean expressions (as the first example) allows for *concurrent execution*.
	- In other words, the compiler will optimize the resulting circuit to minimize the worst propagation delay.  Each AND group is computed individually, with an OR connecting to each.
- Using IF statements is less efficient, both from execution time and from difficulty writing.
	- This is because it checks each IF statement sequentially.  The resulting circuit is sequential rather than concurrent.

### Case Statements
```VHDL
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
```

- Note that signals can be used to combine inputs.
	- Also note the different uses of double quotes for vectors and single quotes for bits (or in this case, `STD_LOGIC`).
- Reminder: processes exist to do things whenever the specified input changes.
- The CASE statement is processed any time the input changes.
- Note that there are two "dont' care" states.  These are `'-'` values.
	- Presumably, the compiler will optimize with these.