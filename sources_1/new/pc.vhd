library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc is
port(
clk : in std_logic;
reset : in std_logic; 
din: in std_logic_vector(31 downto 0);
dout : out std_logic_vector(31 downto 0)
);
end pc;

architecture Behavioral of pc is
signal pc_reg : std_logic_vector(31 downto 0) := x"00000000";
begin
process(reset, clk)
begin
if clk'event AND clk = '1' THEN
if reset = '1' THEN
pc_reg <= x"00000000";
else 
pc_reg <= din; 
end if;
end if;
end process;
dout <= pc_reg;
end Behavioral;
