library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPSmicroprocessor is
  Port (
  clk : in std_logic;
  ALUresult: out std_logic_vector(31 downto 0);
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

component clk_wiz_0
port
 (-- Clock in ports
  clk_in1           : in     std_logic;
  -- Clock out ports
  clk_out1          : out    std_logic
 );
end component;

--component instructionmemory
--Port ( 
--    addr : in std_logic_vector(31 downto 0);
--    instr : out std_logic_vector(31 downto 0)
--);
--end component;

--component pc
--port(
--    clk : in std_logic;
--    reset : in std_logic; 
--    din: in std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
--    dout : out std_logic_vector(31 downto 0)
--);
--end component;

--component mux
--port (
--    A : in std_logic;
--    B : in std_logic;
--    S : in std_logic;
--    Z : out std_logic
--);
--end component;

component instructionfetch
Port ( 
clk, rst, jump, branch : in std_logic;
branch_target : in std_logic_vector(15 downto 0);
jump_target : in std_logic_vector(25 downto 0);
instr, programcounter : out std_logic_vector(31 downto 0)
);
end component;

-- Datapath signals --
signal RD1out, RD2out: std_logic_vector(31 downto 0);
signal SignImmOut: std_logic_vector(31 downto 0);
signal ALUresultOut: std_logic_vector(31 downto 0);
--signal PCmuxOut: std_logic_vector(31 downto 0);
--signal instrIN: std_logic_vector(31 downto 0);
signal PCOut: std_logic_vector(31 downto 0);
signal instrOUT: std_logic_vector(31 downto 0);
signal WriteReg: std_logic_vector(4 downto 0);
signal WriteData: std_logic_vector(31 downto 0);
signal ReadData: std_logic_vector(31 downto 0);
signal ALUSrcMuxOut: std_logic_vector(31 downto 0);
signal ALUFlags: std_logic_vector(3 downto 0);
--signal PCPlus1: std_logic_vector(31 downto 0);
--signal result: std_logic_vector(31 downto 0);
signal pc_clk: std_logic;

-- Control signals --
signal ALUControlSignal: STD_LOGIC_VECTOR(2 downto 0);
--signal ZeroSignal : STD_LOGIC;
--signal GreatThanSignal : STD_LOGIC;
--signal LessThanSignal : STD_LOGIC;
signal MemWriteSignal : STD_LOGIC;
--signal ReadDataOut : STD_LOGIC_VECTOR(31 downto 0);
--signal JumpSignal : STD_LOGIC;
signal MemtoRegSignal: std_logic;
signal ALUSrcSignal: std_logic;
signal RegDstSignal: std_logic;
signal RegWriteSignal: std_logic;
signal BranchSignal: std_logic;

-- IF stage control --
signal rst: std_logic := '0';
signal jump: std_logic := '0'; -- jump instructions don't happen yet
signal jump_target: std_logic_vector(25 downto 0);
signal branch_target: std_logic_vector(15 downto 0);
signal branch_taken: std_logic;

-- Signals from reg file (register outputs)
signal R0: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R1: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R2: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R3: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R4: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R5: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R6: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R7: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R8: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R9: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R10: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R11: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R12: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R13: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R14: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R15: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R16: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R17: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R18: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R19: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R20: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R21: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R22: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R23: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R24: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R25: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R26: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R27: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R28: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R29: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R30: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal R31: STD_LOGIC_VECTOR(31 DOWNTO 0);

--alias jump_target : std_logic_vector(25 downto 0) is instrOUT(25 downto 0);
--alias branch_target : std_logic_vector(15 downto 0) is instrOUT(15 downto 0);
begin
-- Assigning the top level outputs to observe registers
Reg1 <= R1;
Reg2 <= R2;
ALUresult <= ALUresultOut;
-- Instruction fetch --
jump_target <= instrOUT(25 downto 0);
branch_target <= instrOUT(15 downto 0);

InstrF: instructionfetch 
PORT MAP (
    clk => pc_clk, 
    rst => rst, 
    jump => jump, 
    branch => branch_taken, 
    branch_target => branch_target,
    jump_target => jump_target, 
    instr => instrOUT, 
    programcounter => PCOut
);

-- Register file --
RF: regfile 
PORT MAP (
    A1   => instrOUT(25 downto 21),
    A2   => instrOUT(20 downto 16),
    A3   => WriteReg,
    WD3  => WriteData,
    WE3  => RegWriteSignal,
    clk  => clk,
    RD1  => RD1out,
    RD2  => RD2out,

    R0   => R0,
    R1   => R1,
    R2   => R2,
    R3   => R3,
    R4   => R4,
    R5   => R5,
    R6   => R6,
    R7   => R7,
    R8   => R8,
    R9   => R9,
    R10  => R10,
    R11  => R11,
    R12  => R12,
    R13  => R13,
    R14  => R14,
    R15  => R15,
    R16  => R16,
    R17  => R17,
    R18  => R18,
    R19  => R19,
    R20  => R20,
    R21  => R21,
    R22  => R22,
    R23  => R23,
    R24  => R24,
    R25  => R25,
    R26  => R26,
    R27  => R27,
    R28  => R28,
    R29  => R29,
    R30  => R30,
    R31  => R31
); 

-- Control unit --
CU: controlunit
port map (
    op         => instrOUT(31 downto 26),
    funct      => instrOUT(5 downto 0),
    MemtoReg   => MemtoRegSignal,
    MemWrite   => MemWriteSignal,
    Branch     => BranchSignal,
    ALUControl => ALUControlSignal,
    ALUSrc     => ALUSrcSignal,
    RegDst     => RegDstSignal,
    RegWrite   => RegWriteSignal
);

-- Sign Extension --
SE: signext
port map (
    a => instrOUT(15 downto 0),
    y => SignImmOut
);

-- Multiplexer for RegDst
with RegDstSignal select
    WriteReg <= instrOUT(15 downto 11) when '1',
                instrOut(20 downto 16) when others;
                
-- Multiplexer for ALUSrc
with ALUSrcSignal select
    ALUSrcMuxOut <= RD2out when '0',
                    SignImmOut when others;
                    
-- ALU --
ALU1: alu
port map (
    SrcA    => RD1out,
    SrcB    => ALUSrcMuxOut,
    Operand => ALUControlSignal,
    Result  => ALUresultOut,
    Flags   => ALUFlags
);

-- Data memory --
DM: data_memory
port map (
    clk       => clk,
    ALUResult => ALUresultOut,
    WriteData => RD2out,
    MemWrite  => MemWriteSignal,
    ReadData  => ReadData
);
-- Adding clk wiz
CW: clk_wiz_0
port map (
    clk_in1 => clk,
    clk_out1 => pc_clk
);

-- Multiplexer for MemtoReg
with MemtoRegSignal select
    WriteData <= ALUresultOut when '0',
                 ReadData when others;
                 
-- Branch decision --
branch_taken <= BranchSignal and ALUFlags(0);

end Behavioral;
