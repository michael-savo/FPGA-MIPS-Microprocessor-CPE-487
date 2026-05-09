library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity signext is
port(
    a : in std_logic_vector(15 downto 0);
    y : out std_logic_vector(31 downto 0)
);
end signext;

architecture Behavioral of signext is

begin
    y <= X"ffff" & a when a(15) = '1' else X"0000" & a;
end Behavioral;
