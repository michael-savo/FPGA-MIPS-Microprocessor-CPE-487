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
        red_in    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        green_in  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        blue_in   : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        red_out   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        green_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        blue_out  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        hsync     : OUT STD_LOGIC;
        vsync     : OUT STD_LOGIC;
        pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
        pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
    );
END COMPONENT;

COMPONENT display_generator
    PORT (
        clk       : IN STD_LOGIC;
        v_sync    : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        mem_data  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        mem_addr  : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
        red       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        green     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        blue      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END COMPONENT;

COMPONENT data_memory
    PORT (
        clk : IN STD_LOGIC;
        ALUResult : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        WriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemWrite : IN STD_LOGIC;
        ReadData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        disp_addr : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
        disp_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END COMPONENT;

COMPONENT clk_wiz_0
    PORT (
        clk_in1  : IN STD_LOGIC;
        clk_out1 : OUT STD_LOGIC
    );
END COMPONENT;

SIGNAL pxl_clk : STD_LOGIC;
SIGNAL S_red, S_green : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL S_blue : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL S_vsync : STD_LOGIC;
SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL mem_addr : STD_LOGIC_VECTOR(17 DOWNTO 0);
SIGNAL mem_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ALUresult : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Reg1_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Reg2_out : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    -- Instantiate MIPS Processor
    MP : MIPSmicroprocessor
    PORT MAP (
        clk => clk_100MHz,
        ALUresult => ALUresult,
        Reg1 => Reg1_out,
        Reg2 => Reg2_out
    );

    -- Instantiate Data Memory (Framebuffer)
    DM : data_memory
    PORT MAP (
        clk => clk_100MHz,
        ALUResult => ALUresult,
        WriteData => Reg1_out,  -- Write from register file
        MemWrite => '0',         -- TODO: Connect control signal from CPU
        ReadData => open,        -- Not used in display mode
        disp_addr => mem_addr,   -- Address from display generator
        disp_data => mem_data    -- Pixel data to display generator
    );

    -- Instantiate Display Generator
    DG : display_generator
    PORT MAP (
        clk => clk_100MHz,
        v_sync => S_vsync,
        pixel_row => S_pixel_row,
        pixel_col => S_pixel_col,
        mem_data => mem_data,
        mem_addr => mem_addr,
        red => S_red,
        green => S_green,
        blue => S_blue
    );

    -- Instantiate VGA Sync Controller
    VGA_SYNC_INST : vga_sync
    PORT MAP (
        pixel_clk => pxl_clk,
        red_in => S_red,
        green_in => S_green,
        blue_in => S_blue,
        red_out => vga_red,
        green_out => vga_green,
        blue_out => vga_blue,
        hsync => vga_hsync,
        vsync => S_vsync,
        pixel_row => S_pixel_row,
        pixel_col => S_pixel_col
    );
    vga_vsync <= S_vsync;

    -- Instantiate Clock Wizard for pixel clock
    CLK_WIZ_INST : clk_wiz_0
    PORT MAP (
        clk_in1 => clk_100MHz,
        clk_out1 => pxl_clk
    );

END Behavioral;
