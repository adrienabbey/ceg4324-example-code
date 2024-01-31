# Code Structure

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

## Generic N-Input OR Gate
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

## Reduced AND Example
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