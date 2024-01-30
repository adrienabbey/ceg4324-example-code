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