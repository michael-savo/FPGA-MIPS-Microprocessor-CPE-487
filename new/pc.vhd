library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc is
port(
clk : in std_logic;
reset : in std_logic; 
din: in std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
dout : out std_logic_vector(31 downto 0)
);
end pc;

architecture Behavioral of pc is
begin
process(reset, clk)
begin
if clk'event AND clk = '1' THEN
if reset = '1' THEN
dout <= x"00000000";
else 
dout <= din; 
end if;
end if;
end process;
end Behavioral;
