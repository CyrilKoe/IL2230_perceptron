LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

ENTITY top_tb IS
END top_tb;

ARCHITECTURE tb OF top_tb IS
    -- Interfaces
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL enable, n_rst : STD_LOGIC;
    SIGNAL datas_in : K_BUS;
    SIGNAL result : STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);

    -- Simulation constants and variables
    CONSTANT half_period : TIME := 10 ns;
    CONSTANT period : TIME := 2 * half_period;
    SHARED VARIABLE simulation_ended : BOOLEAN := false;

BEGIN
    -- Instantiation
    top : ENTITY work.top PORT MAP (clk, enable, n_rst, datas_in, result);

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
        -- Begin with null datas
        FOR j IN 0 TO N_PARALL - 1 LOOP
            datas_in(j) <= STD_LOGIC_VECTOR(to_signed(0, N_BITS));
        END LOOP;

        WAIT FOR 2 * period;
        -- Start filling input datas
        n_rst <= '1';
        enable <= '1';

        -- Filling so as y_i = w_i * i
        -- Filling layer by layer
        FOR i IN 0 TO DEPTH - 1 LOOP
            -- Filling one layer, column by column
            FOR j IN 0 TO N_PARALL - 1 LOOP
                datas_in(j) <= STD_LOGIC_VECTOR(to_signed(j + i * N_PARALL, N_BITS));
            END LOOP;
            WAIT FOR period;
        END LOOP;

        -- Stop filling input datas
        enable <= '0';

        WAIT FOR 4 * period;

        simulation_ended := true;
        WAIT;

    END PROCESS test_process;

END tb;