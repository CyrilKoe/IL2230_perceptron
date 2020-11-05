LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

USE ieee.math_real.ceil;

-- Entity containing the layers of the perceptron
ENTITY parallel IS
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        n_rst : IN STD_LOGIC;
        datas_in : IN K_BUS; -- Datas coming in the first layer
        loads_out : OUT K_BUS; -- Output calculation, loads_out(i) = sum of the results of the ith column = x(i)w(i) + x(i+k)w(i+k) + x(i+2k)w(i+2k) + ...
        datas_out : OUT K_BUS -- Datas leaving the last layer
    );

END ENTITY;

ARCHITECTURE behavior OF parallel IS
    SIGNAL loads, datas, weights : NK_BUS; -- All the partial partial sums, input datas, and weights of the system
    SIGNAL rom_content : N_BUS;
BEGIN

    -- Instanciate ROM
    ROM : ENTITY work.rom PORT MAP (rom_content);

    -- Fill first layer
    FIRST_LAYER_DATAS :
    datas(DEPTH - 1) <= datas_in;
    -- Fill first layer of loads (partial sums) = 0
    FIRST_LAYER_LOADS :
    FOR i IN N_PARALL - 1 DOWNTO 0 GENERATE
        loads(DEPTH - 1)(i) <= STD_LOGIC_VECTOR(to_signed(0, N_BITS));
    END GENERATE;

    -- Route the ROM output to weights bus
    WEIGHTS_ROUTING_I :
    FOR i IN DEPTH - 1 DOWNTO 0 GENERATE
        WEIGHTS_ROUTING_J :
        FOR j IN N_PARALL - 1 DOWNTO 0 GENERATE
            weights(i)(j) <= rom_content(i * N_PARALL + j);
        END GENERATE;
    END GENERATE;

    -- Instanciate layers
    GEN_LAYERS :
    FOR i IN DEPTH - 1 DOWNTO 0 GENERATE
        -- The last layer (0) output goes to the outputs ports
        ID_LAYER_0 :
        IF (i = 0) GENERATE
            LAYERX : ENTITY work.layer PORT MAP
                (clk, enable, n_rst, weights(i), datas(i), loads(i), datas_out, loads_out);
        END GENERATE;
        -- The general layers output goes to the layer below (i-1)
        ID_LAYER_I :
        IF (i > 0) GENERATE
            LAYERX : ENTITY work.layer PORT MAP
                (clk, enable, n_rst, weights(i), datas(i), loads(i), datas(i - 1), loads(i - 1));
        END GENERATE;
    END GENERATE;

END behavior;