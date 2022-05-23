library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library mcu_pkg_lib;
use mcu_pkg_lib.mcu_pkg.all;
library mcu_lib;
use mcu_lib.all;


entity tb_mcu is
--  Port ( );
end tb_mcu;

architecture Behavioral of tb_mcu is
    signal led : std_logic_vector (3 downto 0);
    signal btn : std_logic_vector (3 downto 0);
    component mcu
      Port ( 
        led : out std_logic_vector (3 downto 0);
        btn : in std_logic_vector (3 downto 0)
      );
    end component;
begin
    DUT : mcu
        port map(
            led => led,
            btn => btn
    );
    stimuli :process
    begin
        btn(0) <= '0';
        btn(1) <= '1';
        wait for 5 us;
        btn(0) <= '0';
        btn(1) <= '0';
        wait for 5 us;
        btn(0) <= '1';
        btn(1) <= '0';
        wait;
    end process;

end Behavioral;
