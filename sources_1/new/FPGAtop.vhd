LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY FPGAtop IS
    PORT (
        clk_100MHz : IN STD_LOGIC;
        BTNU       : IN STD_LOGIC;
        BTND       : IN STD_LOGIC;
        BTNL       : IN STD_LOGIC;
        BTNR       : IN STD_LOGIC;
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
        program_select : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        vga_clk : IN STD_LOGIC;
        vga_pixel_x : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        vga_pixel_y : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        vga_pixel_on : OUT STD_LOGIC;
        ALUresult : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg1  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg2  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg3  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg4  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg5  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg6  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg7  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg8  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg9  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg10 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg11 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg12 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg13 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg14 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg15 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg16 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg17 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg18 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg19 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg20 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg21 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg22 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg23 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg24 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg25 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg26 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg27 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg28 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg29 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg30 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg31 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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
        -- Add these new button inputs
        BTNL           : IN STD_LOGIC;
        BTNU           : IN STD_LOGIC;
        BTND           : IN STD_LOGIC;
        
        v_sync         : IN STD_LOGIC;
        pixel_row      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        framebuffer_pixel : IN STD_LOGIC;
        ALUresult      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7, Reg8, Reg9, Reg10, Reg11, Reg12, Reg13, Reg14, Reg15, Reg16, Reg17, Reg18, Reg19, Reg20, Reg21, Reg22, Reg23, Reg24, Reg25, Reg26, Reg27, Reg28, Reg29, Reg30, Reg31 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        
        -- program_select and menu_enable have been REMOVED from here
        red            : OUT STD_LOGIC;
        green          : OUT STD_LOGIC;
        blue           : OUT STD_LOGIC
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
SIGNAL S_framebuffer_pixel : STD_LOGIC;
SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL ALUresult : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Reg1_out, Reg2_out, Reg3_out, Reg4_out, Reg5_out, Reg6_out, Reg7_out, Reg8_out, Reg9_out, Reg10_out, Reg11_out, Reg12_out, Reg13_out, Reg14_out, Reg15_out, Reg16_out, Reg17_out, Reg18_out, Reg19_out, Reg20_out, Reg21_out, Reg22_out, Reg23_out, Reg24_out, Reg25_out, Reg26_out, Reg27_out, Reg28_out, Reg29_out, Reg30_out, Reg31_out: STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL mips_clk_div : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');
SIGNAL mips_clk     : STD_LOGIC;

-- UI State and Button Debounce Signals
SIGNAL ui_tick_counter : STD_LOGIC_VECTOR(19 DOWNTO 0) := (OTHERS => '0');
SIGNAL btnu_last, btnd_last, btnl_last : STD_LOGIC := '0';
SIGNAL S_program_select : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
SIGNAL S_menu_enable    : STD_LOGIC := '0'; -- Hidden by default

BEGIN
    -- Hardware Clock Divider and UI Button Handler
    PROCESS(clk_100MHz)
    BEGIN
        IF RISING_EDGE(clk_100MHz) THEN
            -- MIPS Clock generation
            mips_clk_div <= mips_clk_div + 1;
            
            -- UI Tick Generator (~95Hz) to prevent button bouncing
            ui_tick_counter <= ui_tick_counter + 1;
            IF ui_tick_counter = x"FFFFF" THEN
                -- Edge Detection for Left Button (Toggle Menu)
                IF BTNL = '1' AND btnl_last = '0' THEN
                    S_menu_enable <= NOT S_menu_enable;
                END IF;
                
                -- Keep the cube ROM selected while debugging the VGA output.
                S_program_select <= "011";
                
                -- Save current state for next tick's edge detection
                btnu_last <= BTNU;
                btnd_last <= BTND;
                btnl_last <= BTNL;
            END IF;
        END IF;
    END PROCESS;
    
    -- Slow the CPU so VGA sees stable cube-coordinate updates instead of
    -- many geometry changes during one screen scan.
    mips_clk <= mips_clk_div(14);
    
    -- Instantiate MIPS Processor
    MP : MIPSmicroprocessor
    PORT MAP (
        clk => mips_clk,
        program_select => S_program_select,
        vga_clk => pxl_clk,
        vga_pixel_x => S_pixel_col,
        vga_pixel_y => S_pixel_row,
        vga_pixel_on => S_framebuffer_pixel,
        ALUresult => ALUresult,
        Reg1 => Reg1_out, 
        Reg2 => Reg2_out,
        Reg3 => Reg3_out,
        Reg4 => Reg4_out,
        Reg5 => Reg5_out,
        Reg6 => Reg6_out,
        Reg7 => Reg7_out,
        Reg8 => Reg8_out,
        Reg9 => Reg9_out,
        Reg10 => Reg10_out,
        Reg11 => Reg11_out,
        Reg12 => Reg12_out,
        Reg13 => Reg13_out,
        Reg14 => Reg14_out,
        Reg15 => Reg15_out,
        Reg16 => Reg16_out,
        Reg17 => Reg17_out,
        Reg18 => Reg18_out,
        Reg19 => Reg19_out,
        Reg20 => Reg20_out,
        Reg21 => Reg21_out,
        Reg22 => Reg22_out,
        Reg23 => Reg23_out,
        Reg24 => Reg24_out,
        Reg25 => Reg25_out,
        Reg26 => Reg26_out,
        Reg27 => Reg27_out,
        Reg28 => Reg28_out,
        Reg29 => Reg29_out,
        Reg30 => Reg30_out,
        Reg31 => Reg31_out
    );

    -- Instantiate Display Generator
    DG : display_generator
    PORT MAP (
        BTNL => BTNL, BTNU => BTNU, BTND => BTND, v_sync => S_vsync, pixel_row => S_pixel_row, pixel_col => S_pixel_col,
        framebuffer_pixel => S_framebuffer_pixel,
        ALUresult => ALUresult,
        Reg1 => Reg1_out, Reg2 => Reg2_out, Reg3 => Reg3_out, Reg4 => Reg4_out, Reg5 => Reg5_out, Reg6 => Reg6_out, Reg7 => Reg7_out, Reg8 => Reg8_out, Reg9 => Reg9_out, Reg10 => Reg10_out, Reg11 => Reg11_out, Reg12 => Reg12_out, Reg13 => Reg13_out, Reg14 => Reg14_out, Reg15 => Reg15_out, Reg16 => Reg16_out, Reg17 => Reg17_out, Reg18 => Reg18_out, Reg19 => Reg19_out, Reg20 => Reg20_out, Reg21 => Reg21_out, Reg22 => Reg22_out, Reg23 => Reg23_out, Reg24 => Reg24_out, Reg25 => Reg25_out, Reg26 => Reg26_out, Reg27 => Reg27_out, Reg28 => Reg28_out, Reg29 => Reg29_out, Reg30 => Reg30_out, Reg31 => Reg31_out,
        red => S_red, green => S_green, blue => S_blue
    );

    -- Instantiate VGA Sync Controller
    VGA_SYNC_INST : vga_sync
    PORT MAP (
        pixel_clk => pxl_clk, red_in => S_red, green_in => S_green, blue_in => S_blue,
        red_out => vga_red(2), green_out => vga_green(2), blue_out => vga_blue(1),
        hsync => vga_hsync, vsync => S_vsync, pixel_row => S_pixel_row, pixel_col => S_pixel_col
    );
    vga_vsync <= S_vsync;

    -- Set unused color bits to 0
    vga_red(1 DOWNTO 0) <= "00";
    vga_green(1 DOWNTO 0) <= "00";
    vga_blue(0) <= '0';

    -- Instantiate Clock Wizard
    CLK_WIZ_INST : clk_wiz_0
    PORT MAP ( clk_in1 => clk_100MHz, clk_out1 => pxl_clk );
END Behavioral;
