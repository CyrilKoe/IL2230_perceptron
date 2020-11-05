LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

USE ieee.math_real.ceil;
USE ieee.math_real.floor;
USE ieee.math_real.log2;

-- ADDER TREE
ENTITY tree_adder IS
    PORT (
        datas_in : IN K_BUS; -- K datas to sum
        results : OUT STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0)
    );

END ENTITY;

ARCHITECTURE behavior OF tree_adder IS
    -- Adder depth is sum log_2 of the nb of data to sum
    CONSTANT ADDER_DEPTH : INTEGER := (INTEGER(ceil(log2(real(N_PARALL)))) + 1);

    -- Matrix containing all the partial sums (squared matrix, not fully optimized)
    TYPE temp_loads IS ARRAY (N_PARALL * DEPTH - 1 DOWNTO 0) OF STD_LOGIC_VECTOR (N_BITS - 1 DOWNTO 0);
    SIGNAL partial_sums : temp_loads;
BEGIN

    -- Filling first layer of the partial_sums with input datas
    FIRST_LAYER :
    FOR k IN N_PARALL - 1 DOWNTO 0 GENERATE
        partial_sums(N_PARALL * ADDER_DEPTH - 1 - k) <= datas_in(N_PARALL - 1 - k);
    END GENERATE;

    -- Generate the adder tree
    GEN_ADDERS_I :
    FOR i IN ADDER_DEPTH - 1 DOWNTO 1 GENERATE
        GEN_ADDERS_J :
        FOR j IN 2 ** i - 1 DOWNTO 0 GENERATE
            -- Must generate just one adder for two signals
            PARITY :
            IF (j MOD 2 = 0) GENERATE
                ADDX : ENTITY work.adder PORT MAP
                    (partial_sums(i * N_PARALL + j), partial_sums(i * N_PARALL + j + 1), partial_sums((i - 1) * N_PARALL + INTEGER(floor(real(j/2)))));
            END GENERATE;
        END GENERATE;
    END GENERATE;

    LAST_LAYER :
    results <= partial_sums(0);
END behavior;