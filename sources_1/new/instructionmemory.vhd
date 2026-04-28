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
    0  => "00100000000000010000000000001010", -- addi $1, $0, 10     ; R1 = A
    1  => "00100000000000100000000000001111", -- addi $2, $0, 15     ; R2 = F

    2  => "00000000001000100001100000100000", -- add  $3, $1, $2
    3  => "00000000010000010010000000100010", -- sub  $4, $2, $1
    4  => "00000000001000100010100000100100", -- and  $5, $1, $2
    5  => "00000000001000100011000000100101", -- or   $6, $1, $2
    6  => "00000000001000100011100000101010", -- slt  $7, $1, $2
    7  => "00000000010000010100000000101010", -- slt  $8, $2, $1

    8  => "00110000010000010000000000001010", -- andi $1, $2, 10     ; R1 = F & A = A
    9  => "00110100000000100000000000001111", -- ori  $2, $0, 15     ; R2 = F
    10 => "00101000001010010000000000001111", -- slti $9, $1, 15     ; R9 = 1

    11 => "10101100000000010000000000000000", -- sw   $1, 0($0)      ; mem[0] = A
    12 => "10001100000000100000000000000000", -- lw   $2, 0($0)      ; R2 = A

    13 => "00010000001000100000000000000001", -- beq  $1, $2, +1     ; should branch
    14 => "00100000000000010000000000000001", -- addi $1, $0, 1      ; should be skipped

    15 => "00100000000000100000000000001111", -- addi $2, $0, 15     ; R2 = F
    16 => "00010100001000100000000000000001", -- bne  $1, $2, +1     ; should branch
    17 => "00100000000000100000000000000010", -- addi $2, $0, 2      ; should be skipped

    18 => "00100000000000010000000000001010", -- addi $1, $0, 10     ; final R1 = A
    19 => "00100000000000100000000000001111", -- addi $2, $0, 15     ; final R2 = F

    others => (others => '0')
);
begin
instr <= ROM(to_integer(unsigned(addr(31 downto 0)))); -- pc divided by 1
end Behavioral;
