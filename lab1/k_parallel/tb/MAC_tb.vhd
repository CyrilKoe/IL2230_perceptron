LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

ENTITY MAC_tb IS
END MAC_tb;

ARCHITECTURE tb OF MAC_tb IS
    -- Interfaces
    SIGNAL data, weight, load_in, load_out : STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);

    -- Simulation constants and variables
    CONSTANT half_period : TIME := 10 ns;
    CONSTANT period : TIME := 2 * half_period;
    SHARED VARIABLE simulation_ended : BOOLEAN := false;

BEGIN
    -- Instantiations
    MAC : ENTITY work.MAC PORT MAP
        (data, weight, load_in, load_out);

    -- Testbench process
    test_process : PROCESS
    BEGIN

        data <= STD_LOGIC_VECTOR(to_signed(5, N_BITS));
        weight <= STD_LOGIC_VECTOR(to_signed(2, N_BITS));
        load_in <= STD_LOGIC_VECTOR(to_signed(0, N_BITS));

        WAIT FOR 4 * period;

        simulation_ended := true;
        WAIT;

    END PROCESS test_process;

END tb;