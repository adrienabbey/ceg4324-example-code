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