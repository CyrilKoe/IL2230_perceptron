LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.general_package.ALL;

-- A LAYER OF K REGISTERS CONTAINING THE INPUT VALUES AND K MACS
ENTITY layer IS
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        n_rst : IN STD_LOGIC;
        weights : IN K_BUS; -- GIVEN BY ROM
        data_in : IN K_BUS;
        sum_in : IN K_BUS; -- PARTIAL SUM OF LAYERS ABOVE IN THE SAME COLUMN
        data_out : OUT K_BUS; -- PASSING THE DATA TO NEXT LAYER
        sum_out : OUT K_BUS -- PARTIAL SUM OF THE COLUMN
    );

END ENTITY;

ARCHITECTURE behavior OF layer IS
BEGIN

    -- Instanciatre MACs
    GEN_MACS :
    FOR k IN N_PARALL - 1 DOWNTO 0 GENERATE
        MACX : ENTITY work.MAC PORT MAP
            (data_in(k), weights(k), sum_in(k), sum_out(k));
    END GENERATE;

    -- Instanciate K registers
    PROCESS (clk, n_rst)
    BEGIN
        -- Reset registers
        IF (n_rst = '0') THEN
            data_out <= (OTHERS => STD_LOGIC_VECTOR(to_signed(0, N_BITS)));

        ELSIF (rising_edge(clk)) THEN
            -- Pass input data
            IF (enable = '1') THEN
                data_out <= data_in;
            END IF;
        END IF;
    END PROCESS;

END behavior;