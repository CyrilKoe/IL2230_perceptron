LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

ENTITY parallel_tb IS
END parallel_tb;

ARCHITECTURE tb OF parallel_tb IS
    -- Interfaces
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL enable, n_rst : STD_LOGIC;
    SIGNAL datas_in, loads_out, datas_out : K_BUS;

    -- Simulation constants and variables
    CONSTANT half_period : TIME := 10 ns;
    CONSTANT period : TIME := 2 * half_period;
    SHARED VARIABLE simulation_ended : BOOLEAN := false;

BEGIN
    -- Instantiations
    parallel_0 : ENTITY work.parallel PORT MAP (clk, enable, n_rst, datas_in, loads_out, datas_out);

    -- Process for clock
    clk_process : PROCESS
    BEGIN
        WHILE simulation_ended = false LOOP
            clk <= NOT clk;
            WAIT FOR half_period;
        END LOOP;
        WAIT;
    END PROCESS clk_process;

    -- Testbench process
    test_process : PROCESS
    BEGIN
        n_rst <= '0';
        enable <= '0';

        FOR j IN 0 TO N_PARALL - 1 LOOP
            datas_in(j) <= STD_LOGIC_VECTOR(to_signed(0, N_BITS));
        END LOOP;

        WAIT FOR 2 * period;
        n_rst <= '1';
        enable <= '1';

        FOR i IN 0 TO N_PARALL - 1 LOOP
            FOR j IN 0 TO N_PARALL - 1 LOOP
                datas_in(j) <= STD_LOGIC_VECTOR(to_signed(j + i * 4, N_BITS));
            END LOOP;
            WAIT FOR period;
        END LOOP;

        enable <= '0';

        WAIT FOR 4 * period;

        simulation_ended := true;
        WAIT;

    END PROCESS test_process;

END tb;