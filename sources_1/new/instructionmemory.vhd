library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity instructionmemory is
Port ( 
    addr : in std_logic_vector(31 downto 0);
    program_select : in std_logic_vector(2 downto 0);  -- Program selection input
    instr : out std_logic_vector(31 downto 0)
);
end instructionmemory;

architecture Behavioral of instructionmemory is
    type rom_type is array (0 to 1023) of std_logic_vector(31 downto 0);
    
    -- ========================================================
    -- PROGRAM 0: FIBONACCI SEQUENCE (Original)
    -- ========================================================
    signal ROM_FIBONACCI : rom_type := (
        -- PHASE 1: SEEDING THE REGISTERS
        -- We initialize registers $1 through $10 with the Fibonacci 
        -- sequence to give the art generator diverse starting data.
        0  => "00100000000000010000000000000001", -- addi $1,  $0, 1
        1  => "00100000000000100000000000000010", -- addi $2,  $0, 2
        2  => "00100000000000110000000000000011", -- addi $3,  $0, 3
        3  => "00100000000001000000000000000101", -- addi $4,  $0, 5
        4  => "00100000000001010000000000001000", -- addi $5,  $0, 8
        5  => "00100000000001100000000000001101", -- addi $6,  $0, 13
        6  => "00100000000001110000000000010101", -- addi $7,  $0, 21
        7  => "00100000000010000000000000100010", -- addi $8,  $0, 34
        8  => "00100000000010010000000000110111", -- addi $9,  $0, 55
        9  => "00100000000010100000000001011001", -- addi $10, $0, 89

        -- PHASE 2: CHAOS CASCADE LOOP (Starts at index 10)
        -- We cascade arithmetic through $11 to $15, then feed the 
        -- results back into the seed registers. This creates a deeply 
        -- nested calculation loop that takes longer to repeat, ensuring 
        -- the on-screen art remains highly dynamic.
        10 => "00000000001000100101100000100000", -- add $11, $1, $2
        11 => "00000000011001000110000000100010", -- sub $12, $3, $4
        12 => "00000000101001100110100000100000", -- add $13, $5, $6
        13 => "00000000111010000111000000100010", -- sub $14, $7, $8
        14 => "00000001001010100111100000100000", -- add $15, $9, $10
        
        -- Feed the chaos back into the base registers
        15 => "00000001011011110000100000100010", -- sub $1, $11, $15
        16 => "00000001100011100001000000100000", -- add $2, $12, $14
        17 => "00000001101000010001100000100010", -- sub $3, $13, $1
        18 => "00000001110000100010000000100000", -- add $4, $14, $2
        19 => "00000001111000110010100000100010", -- sub $5, $15, $3
        
        -- Further mixing
        20 => "00000000001001000011000000100000", -- add $6, $1, $4
        21 => "00000000010001010011100000100010", -- sub $7, $2, $5
        22 => "00000000011001100100000000100000", -- add $8, $3, $6
        23 => "00000000100001110100100000100010", -- sub $9, $4, $7
        24 => "00000000101010000101000000100000", -- add $10, $5, $8
        
        -- PHASE 3: THE JUMP
        -- Loops back to index 10 to continue the endless cascade
        25 => "00001000000000000000000000001010", -- j 10

        others => (others => '0')
    );

    -- ========================================================
    -- PROGRAM 1: COUNTING SEQUENCE (1, 2, 3, 4, ...)
    -- ========================================================
    signal ROM_COUNTING : rom_type := (
        -- Initialize registers with counting sequence
        0  => "00100000000000010000000000000001", -- addi $1,  $0, 1
        1  => "00100000000000100000000000000010", -- addi $2,  $0, 2
        2  => "00100000000000110000000000000011", -- addi $3,  $0, 3
        3  => "00100000000001000000000000000100", -- addi $4,  $0, 4
        4  => "00100000000001010000000000000101", -- addi $5,  $0, 5
        5  => "00100000000001100000000000000110", -- addi $6,  $0, 6
        6  => "00100000000001110000000000000111", -- addi $7,  $0, 7
        7  => "00100000000010000000000000001000", -- addi $8,  $0, 8
        8  => "00100000000010010000000000001001", -- addi $9,  $0, 9
        9  => "00100000000010100000000000001010", -- addi $10, $0, 10

        -- Increment all registers in sequence
        10 => "00000000001000010101100000100000", -- add $11, $1, $1 (double)
        11 => "00000000010000100110000000100000", -- add $12, $2, $2
        12 => "00000000011000110110100000100000", -- add $13, $3, $3
        13 => "00000000100001000111000000100000", -- add $14, $4, $4
        14 => "00000000101001010111100000100000", -- add $15, $5, $5
        
        -- Move back to base registers (creating a progressive increment)
        15 => "00000001011000010000100000100000", -- add $1, $11, $1
        16 => "00000001100000100001000000100000", -- add $2, $12, $2
        17 => "00000001101000110001100000100000", -- add $3, $13, $3
        18 => "00000001110001000010000000100000", -- add $4, $14, $4
        19 => "00000001111001010010100000100000", -- add $5, $15, $5
        
        -- Loop back
        20 => "00001000000000000000000000001010", -- j 10

        others => (others => '0')
    );

    -- ========================================================
    -- PROGRAM 2: ALTERNATING PATTERN (Powers of 2)
    -- ========================================================
    signal ROM_POWERS : rom_type := (
        -- Initialize with powers of 2
        0  => "00100000000000010000000000000001", -- addi $1,  $0, 1    (2^0)
        1  => "00100000000000100000000000000010", -- addi $2,  $0, 2    (2^1)
        2  => "00100000000000110000000000000100", -- addi $3,  $0, 4    (2^2)
        3  => "00100000000001000000000000001000", -- addi $4,  $0, 8    (2^3)
        4  => "00100000000001010000000000010000", -- addi $5,  $0, 16   (2^4)
        5  => "00100000000001100000000000100000", -- addi $6,  $0, 32   (2^5)
        6  => "00100000000001110000000001000000", -- addi $7,  $0, 64   (2^6)
        7  => "00100000000010000000000010000000", -- addi $8,  $0, 128  (2^7)
        8  => "00100000000010010000000100000000", -- addi $9,  $0, 256  (2^8)
        9  => "00100000000010100000001000000000", -- addi $10, $0, 512  (2^9)

        -- Multiply by 2 (shift pattern)
        10 => "00000000001000010101100000100000", -- add $11, $1, $1
        11 => "00000000010000100110000000100000", -- add $12, $2, $2
        12 => "00000000011000110110100000100000", -- add $13, $3, $3
        13 => "00000000100001000111000000100000", -- add $14, $4, $4
        14 => "00000000101001010111100000100000", -- add $15, $5, $5
        
        -- Feedback doubled values
        15 => "00000001011000010000100000100000", -- add $1, $11, $1
        16 => "00000001100000100001000000100000", -- add $2, $12, $2
        17 => "00000001101000110001100000100000", -- add $3, $13, $3
        18 => "00000001110001000010000000100000", -- add $4, $14, $4
        19 => "00000001111001010010100000100000", -- add $5, $15, $5
        
        -- Loop back
        20 => "00001000000000000000000000001010", -- j 10

        others => (others => '0')
    );

begin
    -- Multiplex between programs based on program_select input
    process(addr, program_select)
    begin
        case program_select is
            when "000" =>  -- FIBONACCI
                instr <= ROM_FIBONACCI(to_integer(unsigned(addr(31 downto 0))));
            when "001" =>  -- COUNTING
                instr <= ROM_COUNTING(to_integer(unsigned(addr(31 downto 0))));
            when "010" =>  -- POWERS OF 2
                instr <= ROM_POWERS(to_integer(unsigned(addr(31 downto 0))));
            when others =>  -- Default to FIBONACCI
                instr <= ROM_FIBONACCI(to_integer(unsigned(addr(31 downto 0))));
        end case;
    end process;
    
end Behavioral;
