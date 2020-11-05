LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

-- Multplier and adder
ENTITY MAC IS
    PORT (
        data, weight, load_in : IN STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);
        load_out : OUT STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0)
    );

END ENTITY;

ARCHITECTURE behavior OF MAC IS
    SIGNAL t : signed(2 * N_BITS - 1 DOWNTO 0); -- Multiplying increases bit width

BEGIN
    t <= (signed(weight) * signed(data)) + signed(load_in);
    load_out <= STD_LOGIC_VECTOR(t(N_BITS - 1 + N_FLOAT DOWNTO N_FLOAT)); -- Multiplying increases the floatting part
END behavior;