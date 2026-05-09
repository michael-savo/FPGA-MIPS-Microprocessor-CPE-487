library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity data_memory is
port (
    clk : in std_logic;
    ALUResult : in std_logic_vector(31 downto 0); --ALU
    WriteData : in std_logic_vector(31 downto 0); --Register File
    MemWrite : in std_logic; --Control Unit
    ReadData : out std_logic_vector(31 downto 0)
);
end data_memory;

architecture Behavioral of data_memory is
    type ram_type is array (0 to 32767) of std_logic_vector(31 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
begin

process(clk)
begin
    if rising_edge(clk) then
        if MemWrite = '1' then
            RAM(to_integer(unsigned(ALUResult(9 downto 2)))) <= WriteData;
        end if;
        ReadData <= RAM(to_integer(unsigned(ALUResult(9 downto 2))));
    end if;        
end process;
end Behavioral;
