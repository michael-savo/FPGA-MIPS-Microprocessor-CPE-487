library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
port (
    SrcA : in std_logic_vector(31 downto 0);
    SrcB : in std_logic_vector(31 downto 0);
    Shamt : in std_logic_vector(4 downto 0);
    Operand : in std_logic_vector(3 downto 0);
    Result : out std_logic_vector(31 downto 0);
    Flags : out std_logic_vector(3 downto 0)
    );


end alu;

architecture Behavioral of alu is
signal s_result : std_logic_vector(31 downto 0);
signal carryon : unsigned(32 downto 0);
signal shift_amount : integer range 0 to 31;
begin

shift_amount <= to_integer(unsigned(SrcA(4 downto 0))) when Operand = "1010" or Operand = "1011" or Operand = "1100" else
                to_integer(unsigned(Shamt));

process(SrcA, SrcB, Operand, Shamt, shift_amount)
    variable product : signed(63 downto 0);
begin
    carryon <= (others => '0');
    case Operand is
        when "0000" => -- and
            s_result <= SrcA and SrcB;
        when "0001" => -- or
            s_result <= SrcA or SrcB;
        when "0010" => -- add
            carryon <= ('0' & unsigned(SrcA)) + ('0' & unsigned(SrcB));
            s_result <= std_logic_vector(unsigned(SrcA) + unsigned(SrcB));
        when "0011" => -- xor
            s_result <= SrcA xor SrcB;
        when "0100" => -- lui
            s_result <= SrcB(15 downto 0) & X"0000";
        when "0101" => -- signed set less than
            if signed(SrcA) < signed(SrcB) then
                s_result <= X"00000001";
            else
                s_result <= X"00000000";
            end if;
        when "0110" => -- sub
            carryon <= ('0' & unsigned(SrcA)) - ('0' & unsigned(SrcB));
            s_result <= std_logic_vector(unsigned(SrcA) - unsigned(SrcB));
        when "0111" => -- sll
            s_result <= std_logic_vector(shift_left(unsigned(SrcB), shift_amount));
        when "1000" => -- srl
            s_result <= std_logic_vector(shift_right(unsigned(SrcB), shift_amount));
        when "1001" => -- sra
            s_result <= std_logic_vector(shift_right(signed(SrcB), shift_amount));
        when "1010" => -- sllv
            s_result <= std_logic_vector(shift_left(unsigned(SrcB), shift_amount));
        when "1011" => -- srlv
            s_result <= std_logic_vector(shift_right(unsigned(SrcB), shift_amount));
        when "1100" => -- srav
            s_result <= std_logic_vector(shift_right(signed(SrcB), shift_amount));
        when "1101" => -- signed multiply, low 32 bits
            product := signed(SrcA) * signed(SrcB);
            s_result <= std_logic_vector(product(31 downto 0));
        when others =>
            s_result <= (others => '0');
    end case;
end process;

result <= s_result;
-- "NZCV"
flags(3) <= s_result(31);

flags(2) <= '1' when s_result = X"00000000" else '0';

flags(1) <= carryon(32);

process(SrcA, SrcB, s_result, operand)
    begin
        if (Operand = "0010") then
            flags(0) <= (SrcA(31) xnor SrcB(31)) and (SrcA(31) xor s_result(31));
        elsif (Operand = "0110") then
            flags(0) <= (SrcA(31) xor SrcB(31)) and (SrcA(31) xor s_result(31));
        else
            flags(0) <= '0';
        end if;
    end process;

end Behavioral;
