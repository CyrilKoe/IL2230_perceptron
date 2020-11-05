LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

ENTITY layer_tb IS
END layer_tb;

ARCHITECTURE tb OF layer_tb IS
    -- Interfaces
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL enable, n_rst : STD_LOGIC;
    SIGNAL datas_in, datas_out, sums_in, sums_out : K_BUS;
    SIGNAL weights : K_BUS;
    SIGNAL rom_content : N_BUS;

    -- Simulation constants and variables
    CONSTANT half_period : TIME := 10 ns;
    CONSTANT period : TIME := 2 * half_period;
    SHARED VARIABLE simulation_ended : BOOLEAN := false;

BEGIN
    -- Instantiations
    layer_0 : ENTITY work.layer PORT MAP (clk, enable, n_rst, weights, datas_in, sums_in, datas_out, sums_out);
    rom : ENTITY work.rom PORT MAP (rom_content);

    -- Weights routing
    weights_routing :
    FOR k IN N_PARALL - 1 DOWNTO 0 GENERATE
        weights(k) <= rom_content(k);
    END GENERATE;

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

        -- Fill datas and partial sums with zeros
        FOR j IN 0 TO N_PARALL - 1 LOOP
            datas_in(j) <= STD_LOGIC_VECTOR(to_signed(0, N_BITS));
            sums_in(j) <= STD_LOGIC_VECTOR(to_signed(0, N_BITS));
        END LOOP;

        WAIT FOR 2 * period;
        n_rst <= '1';

        -- Fill with x(j) = j
        FOR j IN 0 TO N_PARALL - 1 LOOP
            datas_in(j) <= STD_LOGIC_VECTOR(to_signed(j, N_BITS));
            sums_in(j) <= STD_LOGIC_VECTOR(to_signed(0, N_BITS));
        END LOOP;
        enable <= '1';

        -- FIll with x(j) = 2j and c(j) = j
        WAIT FOR period;
        enable <= '0';
        FOR j IN 0 TO N_PARALL - 1 LOOP
            datas_in(j) <= STD_LOGIC_VECTOR(to_signed(2 * j, N_BITS));
            sums_in(j) <= STD_LOGIC_VECTOR(to_signed(j, N_BITS));
        END LOOP;

        WAIT FOR 4 * period;

        simulation_ended := true;
        WAIT;

    END PROCESS test_process;

END tb;