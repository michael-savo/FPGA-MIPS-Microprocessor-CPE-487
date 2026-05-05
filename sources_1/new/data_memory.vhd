library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity data_memory is
port (
    clk : in std_logic;
    ALUResult : in std_logic_vector(31 downto 0); --ALU
    WriteData : in std_logic_vector(31 downto 0); --Register File
    MemWrite : in std_logic; --Control Unit
    ReadData : out std_logic_vector(31 downto 0);
    disp_addr : in std_logic_vector(16 downto 0); --  0-120,000 is 17 bits of info for an 800x600 display
    disp_data : out std_logic_vector(31 downto 0)
);
end data_memory;

architecture Behavioral of data_memory is
    type ram_type is array (0 to 119999) of std_logic_vector(31 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
begin

process(clk)
begin
    if rising_edge(clk) then
        if MemWrite = '1' then
            RAM(to_integer(unsigned(ALUResult(16 downto 0)))) <= WriteData;
        end if;
        ReadData <= RAM(to_integer(unsigned(ALUResult(16 downto 0))));
    end if;        
end process;

disp_data <= RAM(to_integer(unsigned(disp_addr))); -- no clock needed because of vga sync

end Behavioral;

