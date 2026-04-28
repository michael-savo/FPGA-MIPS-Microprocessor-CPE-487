library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instructionfetch is
Port ( 
    clk, rst, jump, branch : in std_logic;
    branch_target : in std_logic_vector(15 downto 0); -- might need to change this to be more MIPS like
    jump_target   : in std_logic_vector(25 downto 0);
    instr, programcounter : out std_logic_vector(31 downto 0)
);
end instructionfetch;

architecture Behavioral of instructionfetch is

    signal programc  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal pc_next   : std_logic_vector(31 downto 0);
    signal pc_plus1  : std_logic_vector(31 downto 0);
    signal b_target  : std_logic_vector(31 downto 0);
    signal j_target  : std_logic_vector(31 downto 0);

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
        instr => instr
    );

    pc_plus1 <= std_logic_vector(unsigned(programc) + 1);

    -- Expand 26-bit targets into 32-bit word-aligned addresses
    b_target(31 downto 18) <= "00000000000000";
    b_target(17 downto 2)  <= branch_target;
    b_target(1 downto 0)   <= "00";

    j_target(31 downto 28) <= programc(31 downto 28);
    j_target(27 downto 2)  <= jump_target;
    j_target(1 downto 0)   <= "00";

    -- Next PC logic
    pc_next <= pc_plus1;

    -- Output current PC
    programcounter <= programc;

end Behavioral;