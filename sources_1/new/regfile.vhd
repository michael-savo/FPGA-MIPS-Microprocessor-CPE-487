library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity regfile is
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
end regfile;

architecture behavorial of regfile is 
type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
signal regfile : 
reg_array:=(x"00000000", x"00000000", x"00000000", x"00000000",
x"00000000", x"00000000", x"00000000", x"00000000",
x"00000000", x"00000000", x"00000000", x"00000000",
x"00000000", x"00000000", x"00000000", x"00000000",
x"00000000", x"00000000", x"00000000", x"00000000",
x"00000000", x"00000000", x"00000000", x"00000000",
x"00000000", x"00000000", x"00000000", x"00000000",
x"00000000", x"00000000", x"00000000", x"00000000");

begin

RD1<= regfile(to_integer(unsigned(A1)));
RD2<= regfile(to_integer(unsigned(A2)));

process(clk)
begin
if (clk'event and clk='1') then 
if (WE3 = '1') then
regfile(conv_integer((A3)))<= WD3;
end if;
end if;
end process;

R0<=regfile(0);
R1<=regfile(1);
R2<=regfile(2);
R3<=regfile(3);
R4<=regfile(4);
R5<=regfile(5);
R6<=regfile(6);
R7<=regfile(7);
R8<=regfile(8);
R9<=regfile(9);
R10<=regfile(10);
R11<=regfile(11);
R12<=regfile(12);
R13<=regfile(13);
R14<=regfile(14);
R15<=regfile(15);
R16<=regfile(16);
R17<=regfile(17);
R18<=regfile(18);
R19<=regfile(19);
R20<=regfile(20);
R21<=regfile(21);
R22<=regfile(22);
R23<=regfile(23);
R24<=regfile(24);
R25<=regfile(25);
R26<=regfile(26);
R27<=regfile(27);
R28<=regfile(28);
R29<=regfile(29);
R30<=regfile(30);
R31<=regfile(31);

end behavorial;