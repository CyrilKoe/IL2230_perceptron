LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

ENTITY tree_adder_tb IS
END tree_adder_tb;

ARCHITECTURE tb OF tree_adder_tb IS
    -- Interfaces
    SIGNAL loads_in : K_BUS;
    SIGNAL load_out : STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);

    -- Simulation constants and variables
    CONSTANT half_period : TIME := 10 ns;
    CONSTANT period : TIME := 2 * half_period;
    SHARED VARIABLE simulation_ended : BOOLEAN := false;

BEGIN
    -- Instantiations
    tree_adder_0 : ENTITY work.tree_adder PORT MAP (loads_in, load_out);

    -- Testbench process
    test_process : PROCESS
    BEGIN
        FOR j IN 0 TO N_PARALL - 1 LOOP
            loads_in(j) <= STD_LOGIC_VECTOR(to_signed(0, N_BITS));
        END LOOP;

        WAIT FOR 2 * period;
        FOR j IN 0 TO N_PARALL - 1 LOOP
            loads_in(j) <= STD_LOGIC_VECTOR(to_signed(j, N_BITS));
        END LOOP;

        WAIT FOR period;
        FOR j IN 0 TO N_PARALL - 1 LOOP
            loads_in(j) <= STD_LOGIC_VECTOR(to_signed(j * j - j, N_BITS));
        END LOOP;
        WAIT FOR 4 * period;

        simulation_ended := true;
        WAIT;

    END PROCESS test_process;

END tb;