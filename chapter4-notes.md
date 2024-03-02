# Chapter 4: Finite State Machines
## Structure of Typical Digital Systems
- Digital systems have two primary components:
	- The **Execution Unit** (datapath)
		- The execution unit takes data inputs, has bidirectional control signals with the control unit, and has data outputs.
	- The **Control Unit** (control)
		- The control unit has control inputs, bidirectional control signals with the execution unit, and control outputs.

### Execution Unit (Datapath)
- Provides all necessary *resources* and interconnects among those resources to perform the specified task.
- Examples of resources:
	- Adders
	- Multipliers
	- Registers
	- Memory
	- etc.

### Control Unit (Control)
- Controls data movements in an operational circuit by switching multiplexers and enabling or disabling resources.
- Follows some "program" or schedule
- Often implemented as a **Finite State Machine**, or a collection of Finite State Machines

## Finite State Machines (FSMs)
- Any circuit with memory (Flip Flops) is a Finite State Machine
	- Even computers can be viewed as huge FSMs.
- FSM design involves:
	- Defining states
	- Defining transitions between states
	- Optimization / minimization
- The above approach is practical for small FSMs only.

### Moore FSM
- Output is a function of the present state only.
	- In other words, the output function is only affected by the present state register.
	- Inputs can affect the next state function, but *do not directly* affect the output function.
- Moore FSMs are *faster* than Mealy FSMs.

### Mealy FSM
- Output is a function of the present state *and* inputs.
	- The output function looks at *both* the present state register *and* the inputs.
- Mealy FSMs require *less hardware* than Moore FSMs.

### Moore Machine
- The state transition graph of a Moore machine:
	- Has different states
		- The number of states determines the number of FFs required
	- Each state determines the output
	- Transition conditions between each state

### Mealy Machine
- The Mealy machine state transition graph has two big differences from a Moore machine:
	- Transition conditions determine the output.
		- This means states no longer determine the output.
	- Mealy machines typically require one less state than Moore machines.

### Moore vs. Mealy FSMs
- Moore and Mealy FSMs can be functionally equivalent.
	- Each can be derived from the other.
- Mealy FSMs have richer descriptions and usually require fewer states.
	- This leads to a smaller circuit area (less hardware, cheaper)
- Mealy FSMs compute outputs as soon as inputs change.
	- This means they respond one clock cycle sooner than an equivalent Moore FSM
- Moore FSMs have no combinational path between inputs and outputs.
	- Moore FSMs are more likely to have a shorter critical path (and thus be faster)

## FSMs in VHDL
- Finite State Machines can easily be described with processes.
- Synthesis tools understand FSM descriptions, so long as certan rules are followed:
	- *State transitions* should be described *in a process* sensitive to **clock** and **asynchronous reset** signals ***only***.
		- This includes the *Next State Function* and the *Present State Registers*.
	- *Outputs* should be described *as concurrent statements* outside the process.
		- This includes the *output function* only.

### Moore FSM - Example 1
- Moore FSM that recognizes the sequence `10`:

```VHDL
TYPE state IS (S0, S1, S2); -- User defined 'state' type
SIGNAL Moore_state : state; -- Uses the user defined 'state' type

U_Moore : PROCESS (clock, reset)
BEGIN
    IF (reset = '1') THEN -- Asynchronous Reset
        Moore_state <= S0;
    ELSIF (clock = '1' AND clock'event) THEN
        CASE Moore_state IS
            WHEN S0 =>
                IF input = '1' THEN
                    Moore_state <= S1;
                ELSE
                    Moore_state <= S0;
                END IF;
            WHEN S1 =>
                IF input = '0' THEN
                    Moore_state <= S2;
                ELSE
                    Moore_state <= S1;
                END IF;
            WHEN S2 =>
                IF input = '0' THEN
                    Moore_state <= S0;
                ELSE
                    Moore_state <= S1;
                END IF;
        END CASE;
    END IF;
END PROCESS;

Output <= '1' WHEN Moore_state = S2 ELSE
    '0';
```

### Mealy FSM - Example 1
- Mealy FSM that recognizes the sequence `10`:

```VHDL
TYPE state IS (S0, S1);
SIGNAL Mealy_state : state;

U_Mealy : PROCESS (clock, reset)
BEGIN
    IF (reset = '1') THEN
        Mealy_state <= S0;
    ELSIF (clock = '1' AND clock'event) THEN
        CASE Mealy_state IS
            WHEN S0 =>
                IF input = '1' THEN
                    Mealy_state <= S1;
                ELSE
                    Mealy_state <= S0;
                END IF;
            WHEN S1 =>
                IF input = '0' THEN
                    Mealy_state <= S0;
                ELSE
                    Mealy_state <= S1;
                END IF;
        END CASE;
    END IF;
END PROCESS;

Output <= '1' WHEN (Mealy_state = S1 AND input = '0') ELSE
    '0';
```

### Moore FSM - Example 2
- Detects a sequence of 2 or more consecutive `1`'s

```VHDL
USE ieee.std_logic_1164.ALL;

ENTITY simple IS
    PORT (
        clock : IN STD_LOGIC;
        resetn : IN STD_LOGIC;
        w : IN STD_LOGIC;
        z : OUT STD_LOGIC);
END simple;

ARCHITECTURE Behavior OF simple IS
    TYPE State_type IS (A, B, C);
    SIGNAL y : State_type;
BEGIN
    PROCESS (resetn, clock)
    BEGIN
        IF resetn = '0' THEN -- this is a NEGATIVE reset
            y <= A;
        ELSIF (clock'event AND clock = '1') THEN
            CASE y IS
                WHEN A =>
                    IF w = '0' THEN
                        y <= A;
                    ELSE
                        y <= B;
                    END IF;
                WHEN B =>
                    IF w = '0' THEN
                        y <= A;
                    ELSE
                        y <= C;
                    END IF;
                WHEN C =>
                    IF w = '0' THEN
                        y <= A;
                    ELSE
                        y <= C;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

    z <= '1' WHEN y = C ELSE
        '0';
END Behavior;
```

#### Alternative VHDL Code
```VHDL
ARCHITECTURE Behavior OF simple IS
    TYPE State_type IS (A, B, C);
    SIGNAL y_present, y_next : State_type;
BEGIN
    PROCESS (w, y_present)
    BEGIN
        CASE y_present IS
            WHEN A =>
                IF w = '0' THEN
                    y_next <= A;
                ELSE
                    y_next <= B;
                END IF;
            WHEN B =>
                IF w = '0' THEN
                    y_next <= A;
                ELSE
                    y_next <= C;
                END IF;
            WHEN C =>
                IF w = '0' THEN
                    y_next <= A;
                ELSE
                    y_next <= C;
                END IF;
        END CASE;
    END PROCESS;

    PROCESS (clock, resetn)
    BEGIN
        IF resetn = '0' THEN -- this is a NEGATIVE reset
            y_present <= A;
        ELSIF (clock'event AND clock = '1') THEN
            y_present <= y_next;
        END IF;
    END PROCESS;

    z <= '1' WHEN y_present = C ELSE
        '0';
END Behavior;
```

- Note that there are now *two* processes, and instead of directly adjusting the current state, there's now a 'next state' signal.
	- The first process only considers what the next state should be.
	- The second process considers the clock and reset values, and adjusts the present state as appropriate.

### Mealy FSM - Example 2
```VHDL
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Mealy IS
    PORT (
        clock : IN STD_LOGIC;
        resetn : IN STD_LOGIC;
        w : IN STD_LOGIC;
        z : OUT STD_LOGIC);
END Mealy;

ARCHITECTURE Behavior OF Mealy IS
    TYPE State_type IS (A, B);
    SIGNAL y : State_type;
BEGIN
    PROCESS (resetn, clock)
    BEGIN
        IF resetn = '0' THEN
            y <= A;
        ELSIF (clock'event AND clock = '1') THEN
            CASE y IS
                WHEN A =>
                    IF w = '0' THEN
                        y <= A;
                    ELSE
                        y <= B;
                    END IF;
                WHEN B =>
                    IF w = '0' THEN
                        y <= A;
                    ELSE
                        y <= B;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

    WITH y SELECT
        z <= w WHEN B,
        z <= '0' WHEN OTHERS;

END Behavior;
```

- Note the `WITH y SELECT` line:
	- This appears to be very similar to `CASE` logic.
	- By setting `z` to `w`, we can handle two possibilities with a single line of code.