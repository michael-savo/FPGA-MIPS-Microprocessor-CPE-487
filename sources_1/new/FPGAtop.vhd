library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity FPGAtop is
Port (
    clk_100MHz : IN STD_LOGIC;
	anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0));
end FPGAtop;

architecture Behavioral of FPGAtop is

component MIPSmicroprocessor
  Port (
  clk : in std_logic;
  ALUresult: out std_logic_vector(31 downto 0);
  Reg1 : out std_logic_vector(31 downto 0);
  Reg2 : out std_logic_vector(31 downto 0)
  );
end component;

component leddec
	PORT (
		dig : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
END component;

component counter
	PORT (
		clk : IN STD_LOGIC;
		count : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); 
		mpx : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)); 
END component;

	SIGNAL S : STD_LOGIC_VECTOR (15 DOWNTO 0); -- Connect C1 and L1 for values of 4 digits
	SIGNAL dig : STD_LOGIC_VECTOR (1 DOWNTO 0); -- dig selects displays
	SIGNAL display : STD_LOGIC_VECTOR (3 DOWNTO 0); -- Send digit for only one display to leddec
	signal ALUresult : std_logic_vector (31 downto 0);
	SIGNAL tempR1 : std_logic_vector (31 downto 0);
	SIGNAL tempR2 : std_logic_vector (31 downto 0);

BEGIN
    MP: MIPSmicroprocessor
    PORT MAP(clk => clk_100MHz, ALUresult => ALUresult, Reg1 => tempR1, Reg2 => tempR2);
	C1 : counter
	PORT MAP(clk => clk_100MHz, count => S, mpx => dig);
	L1 : leddec
	PORT MAP(dig => dig, data => display, anode => anode, seg => seg);
	--This represents our Multiplexer (aka MUX or mpx'r). We select different segments of 4 bits to be the value we display on a particular anode.
	display <= tempR1(3 DOWNTO 0) WHEN dig = "00" ELSE
	           tempR2(3 DOWNTO 0) WHEN dig = "01" else
	           ALUresult(3 DOWNTO 0) WHEN dig = "10" ELSE
	           S(15 DOWNTO 12);

END Behavioral;