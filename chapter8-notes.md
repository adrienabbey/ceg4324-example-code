[toc]

# VHDL Subprograms
- There are two types of subprograms:
	- **Functions**:
		- Called within an expression
		- Compute and return a *single* output value
	- **Procedures**:
		- Can be sequential or concurrent
		- Useful in partitioning large behavioral code
		- Compute and return *zero or more* output values

## `RETURN` Statement
- Operations in subprograms are executed by sequential statements.
- Subprograms are finished by a `RETURN` statement.
	- Terminates the subprogram
	- Returns control to the calling program
	- Functions require `RETURN` statements

## `FUNCTION` Format
```VHDL
FUNCTION identifier
    [parameter list] RETURN object TYPE IS
    subprogram declaritive items
BEGIN
    sequential statements
    RETURN expression
END [FUNCTION] identifier;
```


- `identifier` is the function name.
- For `[parameter list]`:
	- Not necessarily variables.  If no type is set, Constant is assumed.
	- Each parameter is of `IN` mode.  If not explicitly set, then `IN` is assumed.
- `object` is the type for the `RETURN` result.
- `subprogram declarative items` are declared items used locally.
- `RETURN` is used to pass the result to the function caller.

### Argument Class of Parameters for Subprograms
- Every parameter of a subprogram has an associated argument class.
- The argument class:
	- Determines what information is passed to the subprograms.
	- Determines whether the passed parameter is a constant, signal, or variable.

### Example: Clock Rising Edge Function 
```VHDL
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY dff IS
    PORT (
        d, clock : IN STD_LOGIC;
        q, qbar : OUT STD_LOGIC);
END ENTITY dff;

ARCHITECTURE beh OF dff IS
    FUNCTION rising_edge(SIGNAL clock : STD_LOGIC) RETURN BOOLEAN IS
        VARIABLE edge : BOOLEAN := FALSE;
    BEGIN
        edge := (clock = '1' AND clock'event);
        RETURN (edge);
    END FUNCTION rising_edge;
BEGIN
    output : PROCESS IS
    BEGIN
        WAIT UNTIL (rising_edge(clock));
        q <= d AFTER 5 ns;
        qbar <= NOT d AFTER 5 ns;
    END PROCESS output;
END ARCHITECTURE beh;
```

- This defines and uses the `rising_edge` function to detect and set a DFF's outputs on the rising edge of the clock.

### Example: `BIT_VECTOR` to `INTEGER` Function 

```VHDL
FUNCTION to_integer (bin : BIT_VECTOR) RETURN INTEGER IS
    VARIABLE result : INTEGER;
BEGIN
    result := 0;
    FOR i IN bin'RANGE LOOP
        IF bin(i) = '1' THEN
            result := result + 2 ** i;
        END IF;
    END LOOP;
    RETURN result;
END to_integer;
```

- `to_integer(x)` can be treated and used as an `INTEGER` anywhere an integer is expected.

## Procedures
- Procedures allow modularization of large architectural bodies.
- They can return *zero or more* output values.
	- `IN:` only readable by the procedure.
	- `OUT:` only writable by the procedure.
	- `INOUT:` both readable and writable.
- Returning parameters is achieved by using `OUT` and `INOUT` parameters.
- Procedures may change the value of one or more parameters passed to it.

### Example: Addition of Two Unsigned Numbers Procedure
```VHDL
PROCEDURE add_unsigned (
    in1, in2 : IN BIT_VECTOR(7 DOWNTO 0);
    sum : OUT BIT_VECTOR(7 DOWNTO 0);
    Cout : OUT BOOLEAN) IS

    VARIABLE sum_tmp : BIT_VECTOR(7 DOWNTO 0);
    VARIABLE carry : BIT := '0';

BEGIN
    FOR i IN sum_tmp'reverse_range LOOP -- This reverses the range (0 to 7)
        sum_tmp(i) := in1(i) XOR in2(i) XOR carry;
        carry := (in1(i) AND in2(i))
            OR (carry AND (in1(i)))
            OR (carry AND (in2(i)));
    END LOOP;

    sum := sum_tmp;
    Cout := carry = '1'; -- This is a TRUE/FALSE statement.
END PROCEDURE add_unsigned;
```

### Example: Addition of Two Unsigned Numbers Procedure
- Note: this is the same as above, except using `BIT` instead of `BOOLEAN` for `Cout`.

```VHDL
PROCEDURE add_unsigned (
    in1, in2 : IN BIT_VECTOR(7 DOWNTO 0);
    sum : OUT BIT_VECTOR(7 DOWNTO 0);
    Cout : OUT BIT) IS -- This is a BIT now

    VARIABLE sum_tmp : BIT_VECTOR(7 DOWNTO 0);
    VARIABLE carry : BIT := '0';

BEGIN
    FOR i IN sum_tmp'reverse_range LOOP
        sum_tmp(i) := in1(i) XOR in2(i) XOR carry;
        carry := (in1(i) AND in2(i))
            OR (carry AND (in1(i)))
            OR (carry AND (in2(i)));
    END LOOP;

    sum := sum_tmp;
    Cout := carry; -- Now just a BIT
END PROCEDURE add_unsigned;
```

### `WAIT` Statements in Procedures
- The `WAIT` statement is permitted in a procedure.
	- `WAIT` is *forbidden* in functions!
- Functions are used to compute values that need to be available instantaneously.
	- Thus, they cannot `WAIT`
	- Crucially, functions *cannot* call procedures with `WAIT` statements from within the function body.