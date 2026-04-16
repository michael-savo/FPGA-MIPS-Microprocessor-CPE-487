library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity instructionmemory is
Port ( 
addr : in std_logic_vector(31 downto 0);
instr : out std_logic_vector(31 downto 0)
);
end instructionmemory;

architecture Behavioral of instructionmemory is
   type rom_type is array (0 to 1023) of std_logic_vector(31 downto 0); -- 4kb so 1024 words
    signal ROM : rom_type := (
        0 => "00100001100011100000000001100111", --machine code of addi r14 r12 0x67
        others => (others => '0'));
begin
instr <= ROM(to_integer(unsigned(ALUResult(9 downto 2)))); -- pc divided by 4
end Behavioral;
