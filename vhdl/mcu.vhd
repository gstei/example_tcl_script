library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library mcu_pkg_lib;
use mcu_pkg_lib.mcu_pkg.all;


entity mcu is
  Port ( 
    led : out std_logic_vector (3 downto 0);
    btn : in std_logic_vector (3 downto 0)
  );
end mcu;

architecture Behavioral of mcu is

begin
    led(0) <= btn(0);
    led(1) <= '0';
    led(2) <= '0';
    led(3) <= '0';

end Behavioral;
