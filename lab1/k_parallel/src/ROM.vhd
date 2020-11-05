LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.general_package.ALL;

ENTITY ROM IS
    PORT (
        content : OUT N_BUS
    );

END ENTITY;

ARCHITECTURE behavior OF ROM IS
BEGIN

    -- Hardcode ROM with w(i) = i
    MEMORY :
    FOR w IN N_UNITS - 1 DOWNTO 0 GENERATE
        --content(w) <= STD_LOGIC_VECTOR(to_signed(w, N_BITS));
        PLUS_ONE :
        IF (w MOD 2 = 0) GENERATE
            content(w) <= STD_LOGIC_VECTOR(to_signed(1, N_BITS));
        END GENERATE;

        MINUS_ONE :
        IF (w MOD 2 = 1) GENERATE
            content(w) <= STD_LOGIC_VECTOR(to_signed(-1, N_BITS));
        END GENERATE;
    END GENERATE;

END behavior;