# Chapter 3: Behavioral VHDL
Behavioral VHDL includes:
	- Process
	- Sensitivity List
	- Wait Statements
	- If Statements
	- Case Statements
	- Loop Statements
- VHDL has three styles:
	- Behavioral:
		- Boolean: `c = a v b`
		- VHDL: `c <= a OR b;`
	- Structural:
		- RTL level: (*logic gates*)
			- [Register-Transfer Level](https://en.wikipedia.org/wiki/Register-transfer_level)
			- 
		- VHDL: (*logic gate components, maps*)
	- Timing:
		- Schematic: (*timing schematic*)
		- VHDL: `c <= a OR b after 10 ns;`
- Modeling Styles:
	- One entity can have many different architectures, each offering different implementations of the same function.
	- Architecture body styles:
		- Behavioral (boolean)
		- Structural (logic gates)
		- Mixed structural/behavioral.

## PROCESS Syntax 2
```VHDL
ma : PROCESS (a, b, d, c_in)
    VARIABLE m_temp : bit_vector(7 DOWNTO 0) := "00000000";

BEGIN
    mult_tmp := a * b;
    sum <= mult_tmp + d + c_in;
END PROCESS;
```
- `ma`: process label
- `PROCESS`, `BEGIN`, `END PROCESS`: key words
- `a, b, d, c_in`: sensitivity list
- `VARIABLE m_tmp`: variable declaration
- Lines between `BEGIN` and `END PROCESS;`: process body

## Sensitivity Lists
- When defining a process, the sensitivity list declares which inputs to watch.
- This will define pre-synthesis simulation behavior, but **NOT** post-synthesis behavior!
	- Example: a process that involves an OR gate might define only one of the inputs on its sensitivity list.
	- The pre-synthesis simulation will *only* adjust the output when the input listed on the sensitivity list changes.
	- The compiler will use an OR gate when synthesizing the netlist.
	- The resulting post-synthesis waveform will thus have a *different* behavior, as the output will change regardless of what was or was not included in the sensitivity list!

## Wait Statements
- Suspends the execution of a `process`.
- Three basic kinds of `wait` statements:
	- `wait on sensitivity-list;`
		- Will wait `on` signals.
	- `wait until sensitivity-list;`
		- Will wait `until` conditions.
	- `wait for sensitivity-list;`
		- Will wait `for` signals.
	- Combinations of the above in a single wait statement are also possible.
		- `wait on sensitivity-list until boolean-expression for time-expression;`

### Wait On
- `wait on A, B, C;`
	- The `process` suspends and waits for `event` to occur on signals, `A`, `B`, or `C`
		- Upon `event` on `A`, `B`, or `C`, the `process` resumes execution from the next statement onwards.
		- When `wait` is the last instruction, the `process` resumes from the first statement.
			- *NOTE*: Does this turn a process into a loop???
				- Yes?  See **Clock Generation** example below.

### Wait Until
- `wait until A=B;`
	- The `process` suspends until the specified condition becomes true.
		- When any `event` occuring on `A` or `B` occurs, the `=` condition is evaluated.
		- If this condition is true, the process resumes from the next statement onwards.  Otherwise, it remains suspended.
			- *NOTE*: Does this logic become part of the final synthesized design?  Does this potentially lead to a circuit becoming "locked up"?

### Wait For
- `wait for 10 ns;`
	- Suspends the `process` for 10 ns.
		- *NOTE*: Does this also become part of the synthesized design?  Or is this only relevant for the pre-synthesis simulation?

### Wait On Sensitivity-List For Time-Expression
- `wait on CLOCK for 20 ns;`
	- Suspends the `process` until 20 ns after a `CLOCK` event.

### Example: Wait Statements
```VHDL
half_add : PROCESS IS
BEGIN
    sum <= a XOR b AFTER T_pd;
    carry <= a AND b AFTER T_pd;
    WAIT ON a, b;
END PROCESS;

half_add : PROCESS (a, b) IS
BEGIN
    sum <= a XOR b AFTER T_pd;
    carry <= a AND b AFTER T_pd;
    -- wait on a,b is NOT needed
END PROCESS;
```

- The first example's process does NOT have a sensitivity list!
	- Thus, the `WAIT ON` is required before ending the process.
- Because the second example's process *does* have a sensitivity list, the `WAIT ON` is *not* needed.

## Clock Generation
- One method of clock generation *for simulation purposes **ONLY*** involves the use of wait statements:

```VHDL
ENTITY clk IS
    PORT (clk : OUT STD_LOGIC);
END clk;

ARCHITECTURE cyk OF clk IS
BEGIN
    PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 10 ns;
        clk <= '1';
        WAIT FOR 10 ns;
    END PROCESS;
END cyk;
```

- `PROCESS` does *not* need a sensitivity list, as there's no inputs to process.
- The last line of the `PROCESS` is a `WAIT FOR` presumably causes the process to loop!
	- This matches with the above **Wait On** section notes.

## Process: Allowed Statements
- Only the following sequential statements are allowed inside of a `process`:
	- `if` statements
	- `case` statements
	- `wait` statements
	- `loop` statements (`for`, `while`)
- `signal` and `variable` assignments are also allowed.

## If Statement
- Used to select a sequence of statements for execution based on fulfilling some condition.
	- This condition can be any boolean expression.

```VHDL
IF boolean_expression THEN
    sequential_statements
    {ELSIF boolean_expression THEN
    sequential_statements}
    [ELSE
    sequential_statements]
END IF;
```

- *NOTE*: This syntax feels wrong.  It's mixing `{}` and `[]`, 
	- Below code is from my functional Lab 2 code:

```VHDL
IF (din = '1') THEN
	next_state <= st3;
ELSE
	next_state <= st2;
END IF;
```


## If/Else - Syntax
``` VHDL
IF k = 0 THEN
    var1 := a + 1;
ELSIF k = 1 THEN
    var2 := b + a;
ELSE
    var1 := '0';
    var2 := '0';
END IF;

IF ((clk'event) AND (clk = '1')) THEN
    q1 <= d1;
    q2 <= d2;
END IF;
```

- The last `IF` statement is a model for triggering on the *rising* clock edge.
	- Requiring `clk'event` triggers only when the clock's value changes, and requring `clk = '1'` causes it to only trigger on the rising edge.

## Case Statement
- Cases are concurrent statements.

```VHDL
CASE expression IS
    WHEN choices => sequential_statements
    WHEN choices => sequential_statements
        [WHEN OTHERS => sequential_statements]
END CASE;
```

- Only one branch with matching condition is selected for execution.
- *NOTE*: Again, I don't know why `[]` are included here.  My code autoformatter seems to treat it as a seqeuential statement (indenting it).

## If vs Case
- `IF`/`ELSE` statements are synthesized as cascaded MUXes.
	- If area is critical for design, use `IF`/`ELSE` statements.
		- Result: small but slow design (thus power efficient?)
	- If time is critical for design, use `CASE` statements.
		- Result: fast, but bigger designs (thus more expensive?)

## Loop Statements
- Used to iterate through a set of sequential statements.
- *NOTE*: I'm not even going to bother including the example code.  It's even more confusing than the previous and should just be ignored.

## Loop - Three Forms
```VHDL
sum := 0;

L1 : FOR i IN 1 TO N LOOP
    sum := sum + 1;
END LOOP;
```

```VHDL
j := 0;
sum := 10;

WHILE j < 20 LOOP
    sum := sum * 2;
    j := j + 1;
END LOOP;
```

```VHDL
j := 0;
sum := 1;

L2 : LOOP
    sum := sum * 10;
    j := j + 1;
    EXIT L2 WHEN sum > 100;
END LOOP;
```

- *NOTE*: I'm not sure why these numerical values have no single-quotes or double-quotes around them.
	- Do they have no type, and thus not need to clarify?

## Loop For
- Example: calculation of $Y^N,N>2$

```VHDL
power_N := y;
FOR i IN 2 TO N LOOP
    power_N := power_N * y;
END LOOP;
```

- The body of the loop is executed `N-1` times.