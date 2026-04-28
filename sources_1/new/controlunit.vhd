
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controlunit is
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
end controlunit;

architecture Behavioral of controlunit is

begin
--ALUControl -- ALUop
process(op, funct)
begin
--default values
MemtoReg <= '0';
MemWrite <= '0';
Branch <= '0';
ALUSrc <= '0';
RegDst <= '0';
RegWrite <= '0';
ALUControl <= "000";

case op is
    when "000000" => --R-type
        RegWrite <= '1';
        RegDst <= '1';
        ALUSrc <= '0';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        
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
        RegDst <= '0';
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '1';
        ALUControl <= "010";
    
    when "101011" => --sw
        RegWrite <= '0';
        RegDst <= '-'; -- dont care
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '1';
        MemtoReg <= '-'; -- dont care
        ALUControl <= "010";
    
    when "000100" => --beq
        RegWrite <= '0';
        RegDst <= '-'; -- dont care
        ALUSrc <= '0';
        Branch <= '1';
        MemWrite <= '0';
        MemtoReg <= '-'; -- dont care
        ALUControl <= "110";
        
    when "001000" => --addi
        RegWrite <= '1';
        RegDst <= '0';
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ALUControl <= "010";
    
    when "000101" => --bne
        RegWrite <= '0';
        RegDst <= '-'; -- dont care
        ALUSrc <= '0';
        Branch <= '1';
        MemWrite <= '0';
        MemtoReg <= '-'; -- dont care
        ALUControl <= "110";
        
    when "001100" => --andi
        RegWrite <= '1';
        RegDst <= '0';
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ALUControl <= "000";
        
    when "001101" => --ori
        RegWrite <= '1';
        RegDst <= '0';
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ALUControl <= "001";
    
    when "001010" => --slti
        RegWrite <= '1';
        RegDst <= '0';
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ALUControl <= "111";
    
    when others =>
        NULL;
    end case;
end process;

end Behavioral;
