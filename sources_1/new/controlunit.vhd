library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controlunit is
  Port (
  op : in std_logic_vector(5 downto 0);
  funct : in std_logic_vector(5 downto 0);
  
  Jump       : out std_logic;
  MemtoReg   : out std_logic_vector(1 downto 0); -- Upgraded to 2 bits
  MemWrite   : out std_logic;
  Branch     : out std_logic;
  ALUControl : out std_logic_vector(2 downto 0);
  ALUSrc     : out std_logic;
  RegDst     : out std_logic_vector(1 downto 0); -- Upgraded to 2 bits
  RegWrite   : out std_logic 
  );
end controlunit;

architecture Behavioral of controlunit is

begin
process(op, funct)
begin
-- Default values to prevent latches
MemtoReg <= "00";
MemWrite <= '0';
Branch <= '0';
ALUSrc <= '0';
RegDst <= "00";
RegWrite <= '0';
ALUControl <= "000";
Jump <= '0'; 

case op is
    when "000000" => --R-type
        RegWrite <= '1';
        RegDst <= "01"; -- 01 targets rd
        ALUSrc <= '0';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= "00"; -- 00 selects ALU result
        
        case Funct is
            when "100000" => ALUControl <= "010"; --add
            when "100010" => ALUControl <= "110"; --sub
            when "100100" => ALUControl <= "000"; --and
            when "100101" => ALUControl <= "001"; --or
            when "101010" => ALUControl <= "111"; --slt
            when others => ALUControl <= "XXX";
        end case;

    when "100011" => --lw
        RegWrite <= '1';
        RegDst <= "00"; -- 00 targets rt
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= "01"; -- 01 selects Data Memory
        ALUControl <= "010";

    when "101011" => --sw
        RegWrite <= '0';
        RegDst <= "--"; -- dont care
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '1';
        MemtoReg <= "--"; -- dont care
        ALUControl <= "010";

    when "000100" => --beq
        RegWrite <= '0';
        RegDst <= "--"; -- dont care
        ALUSrc <= '0';
        Branch <= '1';
        MemWrite <= '0';
        MemtoReg <= "--"; -- dont care
        ALUControl <= "110";

    when "001000" => --addi
        RegWrite <= '1';
        RegDst <= "00";
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= "00";
        ALUControl <= "010";

    when "000101" => --bne
        RegWrite <= '0';
        RegDst <= "--"; -- dont care
        ALUSrc <= '0';
        Branch <= '1';
        MemWrite <= '0';
        MemtoReg <= "--"; -- dont care
        ALUControl <= "110";

    when "001100" => --andi
        RegWrite <= '1';
        RegDst <= "00";
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= "00";
        ALUControl <= "000";

    when "001101" => --ori
        RegWrite <= '1';
        RegDst <= "00";
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= "00";
        ALUControl <= "001";

    when "001010" => --slti
        RegWrite <= '1';
        RegDst <= "00";
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= "00";
        ALUControl <= "111";

    when "001111" => --LUI (Load Upper Immediate)
        RegWrite <= '1';
        RegDst <= "00";
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= "00";
        ALUControl <= "100";

    when "001001" => --ADDIU (Add Immediate Unsigned)
        RegWrite <= '1';
        RegDst <= "00";
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= "00";
        ALUControl <= "010";

    when "000010" => --J (Jump)
        RegWrite <= '0';
        RegDst <= "--";
        ALUSrc <= '-'; 
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= "--";
        ALUControl <= "XXX";
        Jump <= '1'; -- FIRED

    when "000011" => --JAL (Jump and Link)
        RegWrite <= '1';
        RegDst <= "10";   -- 10 targets Register 31
        ALUSrc <= '-';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= "10"; -- 10 selects PC path
        ALUControl <= "XXX";
        Jump <= '1'; -- FIRED

    when others =>
        NULL;
    end case;
end process;

end Behavioral;
