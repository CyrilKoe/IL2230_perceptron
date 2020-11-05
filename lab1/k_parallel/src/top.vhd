LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

ENTITY top IS
    PORT (
        SIGNAL clk, enable, n_rst : IN STD_LOGIC;
        SIGNAL datas_in : IN K_BUS;
        SIGNAL result : OUT STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0)
    );
END top;

ARCHITECTURE behavior OF top IS
    SIGNAL loads_out, datas_out : K_BUS;
BEGIN
    -- Instanciate all the layers (MACs matrix)
    parallel : ENTITY work.parallel PORT MAP (clk, enable, n_rst, datas_in, loads_out, datas_out);

    -- Instanciate a tree adder for last layer
    tree_adder : ENTITY work.tree_adder PORT MAP (loads_out, result);

END behavior;