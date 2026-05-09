library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
port (
    clk : in std_logic;
    ALUResult : in std_logic_vector(31 downto 0);
    WriteData : in std_logic_vector(31 downto 0);
    MemWrite : in std_logic;
    ReadData : out std_logic_vector(31 downto 0)
);
end data_memory;

architecture Behavioral of data_memory is
    constant NORMAL_WORDS : integer := 1024;
    type ram_type is array (0 to NORMAL_WORDS - 1) of std_logic_vector(31 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
    attribute ram_style : string;
    attribute ram_style of RAM : signal is "block";
begin

process(clk)
    variable normal_addr : integer range 0 to NORMAL_WORDS - 1;
begin
    if rising_edge(clk) then
        normal_addr := to_integer(unsigned(ALUResult(11 downto 2)));
        if MemWrite = '1' then
            RAM(normal_addr) <= WriteData;
        end if;
        ReadData <= RAM(normal_addr);
    end if;
end process;

end Behavioral;
