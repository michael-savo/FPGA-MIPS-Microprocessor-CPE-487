library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPSmicroprocessor is
  Port (
  clk : in std_logic;
  Reg1 : out std_logic_vector(31 downto 0);
  Reg2 : out std_logic_vector(31 downto 0)
  );
end MIPSmicroprocessor;

architecture Behavioral of MIPSmicroprocessor is

component alu
port (
    --make it 5 bits for julian
    SrcA : in std_logic_vector(31 downto 0);
    SrcB : in std_logic_vector(31 downto 0);
    Operand : in std_logic_vector(2 downto 0);
    Result : out std_logic_vector(31 downto 0);
    Flags : out std_logic_vector(3 downto 0)
    );
end component;

component regfile
port(
    A1 : in std_logic_vector(4 downto 0);
    A2 : in std_logic_vector(4 downto 0);
    A3 : in std_logic_vector(4 downto 0);
    WD3 : in std_logic_vector(31 downto 0);
    WE3 : in std_logic;
    clk : in std_logic;
    
    RD1: out std_logic_vector(31 downto 0);
    RD2 : out std_logic_vector(31 downto 0);
    
    R0 : out std_logic_vector(31 downto 0);
    R1 : out std_logic_vector(31 downto 0);
    R2 : out std_logic_vector(31 downto 0);
    R3 : out std_logic_vector(31 downto 0);
    R4 : out std_logic_vector(31 downto 0);
    R5 : out std_logic_vector(31 downto 0);
    R6 : out std_logic_vector(31 downto 0);
    R7 : out std_logic_vector(31 downto 0);
    R8 : out std_logic_vector(31 downto 0);
    R9 : out std_logic_vector(31 downto 0);
    R10 : out std_logic_vector(31 downto 0);
    R11 : out std_logic_vector(31 downto 0);
    R12 : out std_logic_vector(31 downto 0);
    R13 : out std_logic_vector(31 downto 0);
    R14 : out std_logic_vector(31 downto 0);
    R15 : out std_logic_vector(31 downto 0);
    R16 : out std_logic_vector(31 downto 0);
    R17 : out std_logic_vector(31 downto 0);
    R18 : out std_logic_vector(31 downto 0);
    R19 : out std_logic_vector(31 downto 0);
    R20 : out std_logic_vector(31 downto 0);
    R21 : out std_logic_vector(31 downto 0);
    R22 : out std_logic_vector(31 downto 0);
    R23 : out std_logic_vector(31 downto 0);
    R24 : out std_logic_vector(31 downto 0);
    R25 : out std_logic_vector(31 downto 0);
    R26 : out std_logic_vector(31 downto 0);
    R27 : out std_logic_vector(31 downto 0);
    R28 : out std_logic_vector(31 downto 0);
    R29 : out std_logic_vector(31 downto 0);
    R30 : out std_logic_vector(31 downto 0);
    R31 : out std_logic_vector(31 downto 0)
);
end component;

component controlunit
Port (
  op : in std_logic_vector(5 downto 0);
  funct : in std_logic_vector(5 downto 0);
  
  MemtoReg : out std_logic;
  MemWrite : out std_logic;
  Branch : out std_logic;
  ALUControl : out std_logic_vector(2 downto 0);
  ALUSrc : out std_logic;
  RegDst : out std_logic;
  RegWrite : out std_logic 
  );
end component;

component signext
port(
    a : in std_logic_vector(15 downto 0);
    y : out std_logic_vector(31 downto 0)
);
end component;

component data_memory
port (
    clk : in std_logic;
    ALUResult : in std_logic_vector(31 downto 0); --ALU
    WriteData : in std_logic_vector(31 downto 0); --Register File
    MemWrite : in std_logic; --Control Unit
    ReadData : out std_logic_vector(31 downto 0)
);
end component;

component instructionmemory
Port ( 
    addr : in std_logic_vector(31 downto 0);
    instr : out std_logic_vector(31 downto 0)
);
end component;

component pc
port(
    clk : in std_logic;
    reset : in std_logic; 
    din: in std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    dout : out std_logic_vector(31 downto 0)
);
end component;

component mux
port (
    A : in std_logic;
    B : in std_logic;
    S : in std_logic;
    Z : out std_logic
);
end component;
-- signals
signal RD1out, RD2out: std_logic_vector(31 downto 0);
signal SignImmOut: std_logic_vector(31 downto 0);
signal ALUresultOut: std_logic_vector(31 downto 0);
signal PCmuxOut: std_logic_vector(31 downto 0);
signal instrIN: std_logic_vector(31 downto 0);
signal instrOUT: std_logic_vector(31 downto 0);
signal result: std_logic_vector(31 downto 0);

begin

end Behavioral;
