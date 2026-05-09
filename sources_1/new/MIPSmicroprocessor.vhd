library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Added for PC arithmetic

entity MIPSmicroprocessor is
  Port (
  clk : in std_logic;
  reset : in std_logic;
  program_select : in std_logic_vector(2 downto 0);
  ALUresult: out std_logic_vector(31 downto 0);
  Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7, Reg8, Reg9, Reg10, Reg11, Reg12, Reg13, Reg14, Reg15, Reg16, Reg17, Reg18, Reg19, Reg20, Reg21, Reg22, Reg23, Reg24, Reg25, Reg26, Reg27, Reg28, Reg29, Reg30, Reg31 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end MIPSmicroprocessor;

architecture Behavioral of MIPSmicroprocessor is

component alu
port (
    SrcA : in std_logic_vector(31 downto 0);
    SrcB : in std_logic_vector(31 downto 0);
    Shamt : in std_logic_vector(4 downto 0);
    Operand : in std_logic_vector(3 downto 0);
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
  
  Jump       : out std_logic;
  JumpReg    : out std_logic;
  MemtoReg   : out std_logic_vector(1 downto 0); -- CHANGED TO 2 BITS
  MemWrite   : out std_logic;
  Branch     : out std_logic;
  BranchNE   : out std_logic;
  ALUControl : out std_logic_vector(3 downto 0);
  ALUSrc     : out std_logic;
  RegDst     : out std_logic_vector(1 downto 0); -- CHANGED TO 2 BITS
  RegWrite   : out std_logic 
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
    ALUResult : in std_logic_vector(31 downto 0); 
    WriteData : in std_logic_vector(31 downto 0); 
    MemWrite : in std_logic; 
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

component instructionfetch
Port ( 
clk, rst, jump, jump_reg, branch : in std_logic;
branch_target : in std_logic_vector(15 downto 0);
jump_target : in std_logic_vector(25 downto 0);
jump_reg_target : in std_logic_vector(31 downto 0);
program_select : in std_logic_vector(2 downto 0);
instr, programcounter : out std_logic_vector(31 downto 0)
);
end component;

-- Datapath signals --
signal RD1out, RD2out: std_logic_vector(31 downto 0);
signal SignImmOut: std_logic_vector(31 downto 0);
signal ALUresultOut: std_logic_vector(31 downto 0);
signal PCOut: std_logic_vector(31 downto 0);
signal instrOUT: std_logic_vector(31 downto 0);
signal WriteReg: std_logic_vector(4 downto 0);
signal WriteData: std_logic_vector(31 downto 0);
signal ReadData: std_logic_vector(31 downto 0);
signal ALUSrcMuxOut: std_logic_vector(31 downto 0);
signal ALUFlags: std_logic_vector(3 downto 0);
signal pc_clk: std_logic;

-- Control signals --
signal ALUControlSignal: STD_LOGIC_VECTOR(3 downto 0);
signal MemWriteSignal : STD_LOGIC;
signal MemtoRegSignal: std_logic_vector(1 downto 0); -- CHANGED TO 2 BITS
signal ALUSrcSignal: std_logic;
signal RegDstSignal: std_logic_vector(1 downto 0);   -- CHANGED TO 2 BITS
signal RegWriteSignal: std_logic;
signal BranchSignal: std_logic;
signal BranchNESignal: std_logic;

-- IF stage control --
signal jump: std_logic := '0';
signal jump_target: std_logic_vector(25 downto 0);
signal jump_signal : std_logic;
signal jump_reg_signal : std_logic;
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

begin
-- Assigning the top level outputs to observe registers
Reg1 <= R1;
Reg2 <= R2;
Reg3 <= R3;
Reg4 <= R4;
Reg5 <= R5;
Reg6 <= R6;
Reg7 <= R7;
Reg8 <= R8;
Reg9 <= R9;
Reg10 <= R10;
Reg11 <= R11;
Reg12 <= R12;
Reg13 <= R13;
Reg14 <= R14;
Reg15 <= R15;
Reg16 <= R16;
Reg17 <= R17;
Reg18 <= R18;
Reg19 <= R19;
Reg20 <= R20;
Reg21 <= R21;
Reg22 <= R22;
Reg23 <= R23;
Reg24 <= R24;
Reg25 <= R25;
Reg26 <= R26;
Reg27 <= R27;
Reg28 <= R28;
Reg29 <= R29;
Reg30 <= R30;
Reg31 <= R31;
ALUresult <= ALUresultOut;

-- Instruction fetch --
jump_target <= instrOUT(25 downto 0);
branch_target <= instrOUT(15 downto 0);

InstrF: instructionfetch 
PORT MAP (
    clk => pc_clk,
    rst => reset,
    jump => jump_signal,
    jump_reg => jump_reg_signal,
    branch => branch_taken,
    branch_target => branch_target,
    jump_target => jump_target, 
    jump_reg_target => RD1out,
    program_select => program_select,
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

    R0   => R0, R1   => R1, R2   => R2, R3   => R3,
    R4   => R4, R5   => R5, R6   => R6, R7   => R7,
    R8   => R8, R9   => R9, R10  => R10, R11  => R11,
    R12  => R12, R13  => R13, R14  => R14, R15  => R15,
    R16  => R16, R17  => R17, R18  => R18, R19  => R19,
    R20  => R20, R21  => R21, R22  => R22, R23  => R23,
    R24  => R24, R25  => R25, R26  => R26, R27  => R27,
    R28  => R28, R29  => R29, R30  => R30, R31  => R31
); 

-- Control unit --
CU: controlunit
port map (
    op         => instrOUT(31 downto 26),
    funct      => instrOUT(5 downto 0),
    MemtoReg   => MemtoRegSignal,
    MemWrite   => MemWriteSignal,
    Branch     => BranchSignal,
    BranchNE   => BranchNESignal,
    ALUControl => ALUControlSignal,
    ALUSrc     => ALUSrcSignal,
    RegDst     => RegDstSignal,
    RegWrite   => RegWriteSignal,
    Jump       => jump_signal,
    JumpReg    => jump_reg_signal
);

-- Sign Extension --
SE: signext
port map (
    a => instrOUT(15 downto 0),
    y => SignImmOut
);

-- Multiplexer for RegDst (UPGRADED)
with RegDstSignal select
    WriteReg <= instrOut(20 downto 16)  when "00", -- rt (Default/I-types)
                instrOUT(15 downto 11)  when "01", -- rd (R-types)
                "11111"                 when "10", -- Register 31 (JAL)
                "00000"                 when others;

-- Multiplexer for ALUSrc
with ALUSrcSignal select
    ALUSrcMuxOut <= RD2out when '0',
                    SignImmOut when others;

-- ALU --
ALU1: alu
port map (
    SrcA    => RD1out,
    SrcB    => ALUSrcMuxOut,
    Shamt   => instrOUT(10 downto 6),
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
--CW: clk_wiz_0
--port map (
--    clk_in1 => clk,
--    clk_out1 => pc_clk
--);
pc_clk <= clk;

-- Multiplexer for MemtoReg (UPGRADED)
with MemtoRegSignal select
    WriteData <= ALUresultOut                          when "00", -- ALU output
                 ReadData                              when "01", -- Memory output
                 std_logic_vector(unsigned(PCOut) + 1) when "10", -- PC+1 output for JAL
                 (others => '0')                       when others;

-- Branch decision --
branch_taken <= (BranchSignal and ALUFlags(2)) or (BranchNESignal and (not ALUFlags(2)));

end Behavioral;
