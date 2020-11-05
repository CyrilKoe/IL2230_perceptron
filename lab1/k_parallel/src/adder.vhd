LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

-- SIMPLE ADDER
ENTITY adder IS
    PORT (
        a, b : IN STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);
        c : OUT STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavior OF adder IS
    SIGNAL t : signed(N_BITS - 1 DOWNTO 0);
BEGIN
    t <= signed(a) + signed(b);
    c <= STD_LOGIC_VECTOR(t);
END behavior;