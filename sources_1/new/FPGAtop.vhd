LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY FPGAtop IS
    PORT (
        clk_100MHz : IN STD_LOGIC;
        vga_red    : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_green  : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_blue   : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        vga_hsync  : OUT STD_LOGIC;
        vga_vsync  : OUT STD_LOGIC
    );
END FPGAtop;

ARCHITECTURE Behavioral OF FPGAtop IS

COMPONENT MIPSmicroprocessor
    PORT (
        clk : IN STD_LOGIC;
        ALUresult : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END COMPONENT;

COMPONENT vga_sync
    PORT (
        pixel_clk : IN STD_LOGIC;
        red_in    : IN STD_LOGIC;
        green_in  : IN STD_LOGIC;
        blue_in   : IN STD_LOGIC;
        red_out   : OUT STD_LOGIC;
        green_out : OUT STD_LOGIC;
        blue_out  : OUT STD_LOGIC;
        hsync     : OUT STD_LOGIC;
        vsync     : OUT STD_LOGIC;
        pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
        pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
    );
END COMPONENT;

COMPONENT display_generator
    PORT (
        v_sync     : IN STD_LOGIC;
        pixel_row  : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col  : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        ALUresult  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7, Reg8, Reg9, Reg10 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        red        : OUT STD_LOGIC;
        green      : OUT STD_LOGIC;
        blue       : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT clk_wiz_0
    PORT (
        clk_in1  : IN STD_LOGIC;
        clk_out1 : OUT STD_LOGIC
    );
END COMPONENT;

SIGNAL pxl_clk : STD_LOGIC;
SIGNAL S_red, S_green, S_blue : STD_LOGIC;
SIGNAL S_vsync : STD_LOGIC;
SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL ALUresult : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Reg1_out, Reg2_out, Reg3_out, Reg4_out, Reg5_out, Reg6_out, Reg7_out, Reg8_out, Reg9_out, Reg10_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL mips_clk_div : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');
SIGNAL mips_clk     : STD_LOGIC;
BEGIN
-- Hardware Clock Divider for MIPS
    PROCESS(clk_100MHz)
    BEGIN
        IF RISING_EDGE(clk_100MHz) THEN
            mips_clk_div <= mips_clk_div + 1;
        END IF;
    END PROCESS;
    
    -- Extract the slower clock. 
    -- Bit 23 gives roughly 6 Hz. 
    -- Change to bit 22 for ~12Hz, or bit 21 for ~24Hz if you want the art faster!
    -- mips_clk <= mips_clk_div(23);
    -- Change to clk_100 MHz to bypass slow clock and run at native speed.
     mips_clk <= clk_100MHz;
    
    -- Instantiate MIPS Processor
    MP : MIPSmicroprocessor
    PORT MAP (
        clk => mips_clk,
        ALUresult => ALUresult,
        Reg1 => Reg1_out,
        Reg2 => Reg2_out
    );

    -- Instantiate Display Generator
    DG : display_generator
    PORT MAP (
        v_sync => S_vsync,
        pixel_row => S_pixel_row,
        pixel_col => S_pixel_col,
        ALUresult => ALUresult,
        Reg1 => Reg1_out, Reg2 => Reg2_out, Reg3 => Reg3_out,
        Reg4 => Reg4_out, Reg5 => Reg5_out, Reg6 => Reg6_out,
        Reg7 => Reg7_out, Reg8 => Reg8_out, Reg9 => Reg9_out,
        Reg10 => Reg10_out,
        red => S_red, green => S_green, blue => S_blue
    );

    -- Instantiate VGA Sync Controller
    VGA_SYNC_INST : vga_sync
    PORT MAP (
        pixel_clk => pxl_clk,
        red_in => S_red,
        green_in => S_green,
        blue_in => S_blue,
        red_out => vga_red(2),
        green_out => vga_green(2),
        blue_out => vga_blue(1),
        hsync => vga_hsync,
        vsync => S_vsync,
        pixel_row => S_pixel_row,
        pixel_col => S_pixel_col
    );
    vga_vsync <= S_vsync;

    -- Set unused color bits to 0
    vga_red(1 DOWNTO 0) <= "00";
    vga_green(1 DOWNTO 0) <= "00";
    vga_blue(0) <= '0';

    -- Instantiate Clock Wizard for pixel clock
    CLK_WIZ_INST : clk_wiz_0
    PORT MAP (
        clk_in1 => clk_100MHz,
        clk_out1 => pxl_clk
    );
END Behavioral;
