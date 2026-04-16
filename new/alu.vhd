library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
port (
    --make it 5 bits for julian
    SrcA : in std_logic_vector(31 downto 0);
    SrcB : in std_logic_vector(31 downto 0);
    Operand : in std_logic_vector(2 downto 0);
    Result : out std_logic_vector(31 downto 0);
    Flags : out std_logic_vector(3 downto 0)
);


end alu;

architecture Behavioral of alu is
signal s_result : std_logic_vector(31 downto 0);
signal carryon : std_logic_vector(32 downto 0);
begin

with operand select
carryon <= ('0' & SrcA) + ('0' & SrcB) when "000", -- Now 33 bits = 33 bits
           ('0' & SrcA) - ('0' & SrcB) when "001",
           '0' & (SrcA AND SrcB)       when "010",
           '0' & (SrcA OR SrcB)        when "011",  
           ('0' & SrcA) + ('0' & SrcB) when others;
          
s_result <= carryon (31 downto 0);
result <= s_result;
-- figure out how to set carryon value
-- "NZCV"
flags(3) <= s_result(31);

flags(2) <= '1' when s_result <= X"00000000" else '0';

flags(1) <= carryon(32);

process(SrcA, SrcB, s_result, operand)
    begin
        if (Operand = "000") then
            flags(0) <= (SrcA(31) xnor SrcB(31)) and (SrcA(31) xor s_result(31));
        elsif (Operand = "001") then
            flags(0) <= (SrcA(31) xor SrcB(31)) and (SrcA(31) xor s_result(31));
        else
            flags(0) <= '0';
        end if;
    end process;

end Behavioral;
