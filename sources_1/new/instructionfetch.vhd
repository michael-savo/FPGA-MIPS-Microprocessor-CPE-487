library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instructionfetch is
Port (
clk, rst, jump, jump_reg, branch : in std_logic;
branch_target : in std_logic_vector(15 downto 0);
jump_target   : in std_logic_vector(25 downto 0);
jump_reg_target : in std_logic_vector(31 downto 0);
program_select : in std_logic_vector(2 downto 0);
instr, programcounter : out std_logic_vector(31 downto 0)
);
end instructionfetch;

architecture Behavioral of instructionfetch is

    signal programc  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal pc_next   : std_logic_vector(31 downto 0);
    signal pc_plus1  : std_logic_vector(31 downto 0);
    signal b_target  : std_logic_vector(31 downto 0);
    signal j_target  : std_logic_vector(31 downto 0);
    signal sign_ext_branch : std_logic_vector(31 downto 0);

    component pc is
    port(
        clk   : in std_logic;
        reset : in std_logic; 
        din   : in std_logic_vector(31 downto 0);
        dout  : out std_logic_vector(31 downto 0)
    );
    end component;

    component instructionmemory is
    Port ( 
        addr  : in std_logic_vector(31 downto 0);
        program_select : in std_logic_vector(2 downto 0);
        instr : out std_logic_vector(31 downto 0)
    );
    end component; 

begin

    p: pc
    port map(
        clk   => clk,
        reset => rst,
        din   => pc_next,
        dout  => programc
    );

    i: instructionmemory
    port map(
        addr  => programc,
        program_select => program_select,
        instr => instr
    );

    -- 1. Word Addressed PC: Increment by exactly 1, 4 for byte
    pc_plus1 <= std_logic_vector(unsigned(programc) + 1);

    -- 2. Sign extend the 16-bit branch target to 32 bits
    sign_ext_branch(15 downto 0)  <= branch_target;
    sign_ext_branch(31 downto 16) <= (others => branch_target(15));

    -- 3. Branch Target is (PC + 1) + offset
    b_target <= std_logic_vector(unsigned(pc_plus1) + unsigned(sign_ext_branch));

    -- 4. Jump target uses the exact index provided (No left shifting)
    j_target(31 downto 26) <= programc(31 downto 26);
    j_target(25 downto 0)  <= jump_target;

    -- Next PC routing logic
    pc_next <= jump_reg_target when jump_reg = '1' else
               j_target when jump = '1' else
               b_target when branch = '1' else
               pc_plus1;

    -- Output current PC
    programcounter <= programc;

end Behavioral;
