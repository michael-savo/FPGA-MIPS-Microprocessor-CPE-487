library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
entity instructionfetch is
Port ( 
clk, rst, jump, branch : in std_logic;
branch_target, jump_target : in std_logic_vector(31 downto 0);
instr, programcounter : out std_logic_vector(31 downto 0)
);
end instructionfetch;

architecture Behavioral of instructionfetch is
signal programc, pc_next, pc_plus4 : std_logic_vector(31 downto 0);

component pc is
port(
clk : in std_logic;
reset : in std_logic; 
din: in std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
dout : out std_logic_vector(31 downto 0)
);
end component;

component instructionmemory is
Port ( 
addr : in std_logic_vector(31 downto 0);
instr : out std_logic_vector(31 downto 0)
);
end component; 
begin

p: pc
port map(clk => clk, reset => rst, din => pc_next, dout => programc);

i : instructionmemory
port map(addr => programc, instr => instr);

pc_plus4 <= std_logic_vector(unsigned(programc) + 4);

programcounter <= jump_target when jump = '1' else
                  branch_target when branch = '1' else
                  pc_plus4;
    
end Behavioral;
