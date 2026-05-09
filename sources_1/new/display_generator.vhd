LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY display_generator IS
    PORT (
        -- Added Buttons for internal FSM Menu Control
        BTNL           : IN STD_LOGIC;
        BTNU           : IN STD_LOGIC;
        BTND           : IN STD_LOGIC;
        
        v_sync         : IN STD_LOGIC;
        pixel_row      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        ALUresult      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7, Reg8, Reg9, Reg10, Reg11, Reg12, Reg13, Reg14, Reg15, Reg16, Reg17, Reg18, Reg19, Reg20, Reg21, Reg22, Reg23, Reg24, Reg25, Reg26, Reg27, Reg28, Reg29, Reg30, Reg31 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        
        red            : OUT STD_LOGIC;
        green          : OUT STD_LOGIC;
        blue           : OUT STD_LOGIC
    );
END display_generator;

ARCHITECTURE Behavioral OF display_generator IS

    TYPE font_array IS ARRAY (0 TO 15, 0 TO 7) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT FONT : font_array := (
        ("00111100","01000010","10000001","10000001","10000001","10000001","01000010","00111100"), -- 0
        ("00011000","00101000","00001000","00001000","00001000","00001000","00001000","00111110"), -- 1
        ("00111100","01000010","10000001","00000001","00000010","00000100","00001000","11111111"), -- 2
        ("00111100","01000010","10000001","00000110","00000001","10000001","01000010","00111100"), -- 3
        ("00001000","00011000","00101000","01001000","10001000","11111111","00001000","00001000"), -- 4
        ("11111111","10000000","10000000","11111100","00000010","10000001","01000010","00111100"), -- 5
        ("00111100","01000010","10000000","11111100","10000010","10000001","01000010","00111100"), -- 6
        ("11111111","00000001","00000010","00000100","00001000","00010000","00100000","01000000"), -- 7
        ("00111100","01000010","10000001","01000010","00111100","01000010","10000001","00111100"), -- 8
        ("00111100","01000010","10000001","01000011","00111101","00000001","01000010","00111100"), -- 9
        ("00111100","01000010","10000001","10000001","11111111","10000001","10000001","10000001"), -- A
        ("11111100","10000010","10000001","11111100","10000010","10000001","10000010","11111100"), -- B
        ("00111100","01000010","10000000","10000000","10000000","10000000","01000010","00111100"), -- C
        ("11111000","10000100","10000010","10000001","10000001","10000010","10000100","11111000"), -- D
        ("11111111","10000000","10000000","11111100","10000000","10000000","10000000","11111111"), -- E
        ("11111111","10000000","10000000","11111100","10000000","10000000","10000000","10000000")  -- F
    );

    FUNCTION get_font_pixel(hex_char : STD_LOGIC_VECTOR(3 DOWNTO 0); row : INTEGER; col : INTEGER) RETURN STD_LOGIC IS
    BEGIN
        RETURN FONT(to_integer(unsigned(hex_char)), row)(7 - col);
    END FUNCTION;

    FUNCTION get_hex_digit(value : STD_LOGIC_VECTOR(31 DOWNTO 0); digit_pos : INTEGER) RETURN STD_LOGIC_VECTOR IS
    BEGIN
        RETURN value((digit_pos * 4 + 3) DOWNTO (digit_pos * 4));
    END FUNCTION;

    TYPE reg_array_t IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    -- FSM State Signals
    SIGNAL btnl_reg, btnu_reg, btnd_reg : STD_LOGIC := '0';
    SIGNAL menu_enable   : STD_LOGIC := '0';
    SIGNAL menu_index    : INTEGER RANGE 0 TO 1 := 0; -- Change max bound to add more items

BEGIN

    -- =========================================================
    -- FSM: MENU STATE AND BUTTON HANDLING (Using v_sync as 60Hz clock)
    -- =========================================================
    PROCESS(v_sync)
    BEGIN
        IF rising_edge(v_sync) THEN
            -- BTNL Toggles Menu Enable (Edge Detection)
            IF BTNL = '1' AND btnl_reg = '0' THEN
                menu_enable <= NOT menu_enable;
            END IF;
            
            -- BTNU/BTND Navigation (Only if menu is open)
            IF menu_enable = '1' THEN
                -- BTNU moves UP (Subtracts from index)
                IF BTNU = '1' AND btnu_reg = '0' THEN
                    IF menu_index > 0 THEN 
                        menu_index <= menu_index - 1;
                    END IF;
                END IF;
                
                -- BTND moves DOWN (Adds to index)
                IF BTND = '1' AND btnd_reg = '0' THEN
                    IF menu_index < 1 THEN -- Currently 2 options (0 and 1)
                        menu_index <= menu_index + 1;
                    END IF;
                END IF;
            END IF;

            -- Update edge detection registers
            btnl_reg <= BTNL;
            btnu_reg <= BTNU;
            btnd_reg <= BTND;
        END IF;
    END PROCESS;

    -- =========================================================
    -- DISPLAY GENERATOR (Combinational Logic)
    -- =========================================================
    PROCESS(pixel_row, pixel_col, ALUresult, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7, Reg8, Reg9, Reg10, Reg11, Reg12, Reg13, Reg14, Reg15, Reg16, Reg17, Reg18, Reg19, Reg20, Reg21, Reg22, Reg23, Reg24, Reg25, Reg26, Reg27, Reg28, Reg29, Reg30, Reg31, menu_enable, menu_index)
        VARIABLE px_col, px_row : INTEGER;
        VARIABLE char_x, char_y, char_index : INTEGER;
        VARIABLE hex_digit : STD_LOGIC_VECTOR(3 DOWNTO 0);
        
        VARIABLE math_r, math_g, math_b : STD_LOGIC_VECTOR(10 DOWNTO 0);
        VARIABLE bg_r, bg_g, bg_b : STD_LOGIC;
        
        VARIABLE all_regs : reg_array_t;
        VARIABLE reg_val : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE grid_row, grid_col : INTEGER;
        VARIABLE start_x, start_y : INTEGER;
        
    BEGIN
        px_col := to_integer(unsigned(pixel_col));
        px_row := to_integer(unsigned(pixel_row));

        -- Map all signals into standard array
        all_regs(0) := ALUresult; all_regs(1) := Reg1; all_regs(2) := Reg2; all_regs(3) := Reg3;
        all_regs(4) := Reg4; all_regs(5) := Reg5; all_regs(6) := Reg6; all_regs(7) := Reg7;
        all_regs(8) := Reg8; all_regs(9) := Reg9; all_regs(10) := Reg10; all_regs(11) := Reg11;
        all_regs(12) := Reg12; all_regs(13) := Reg13; all_regs(14) := Reg14; all_regs(15) := Reg15;
        all_regs(16) := Reg16; all_regs(17) := Reg17; all_regs(18) := Reg18; all_regs(19) := Reg19;
        all_regs(20) := Reg20; all_regs(21) := Reg21; all_regs(22) := Reg22; all_regs(23) := Reg23;
        all_regs(24) := Reg24; all_regs(25) := Reg25; all_regs(26) := Reg26; all_regs(27) := Reg27;
        all_regs(28) := Reg28; all_regs(29) := Reg29; all_regs(30) := Reg30; all_regs(31) := Reg31;

        -- 1. BACKGROUND ART
        math_r := (pixel_col + Reg1(10 DOWNTO 0)) XOR (pixel_row + Reg2(10 DOWNTO 0));
        bg_r   := math_r(5) XOR Reg3(4) XOR ALUresult(2);

        math_g := (pixel_col XOR Reg4(10 DOWNTO 0)) AND (pixel_row XOR Reg5(10 DOWNTO 0));
        bg_g   := math_g(6) XOR Reg6(5);

        math_b := (pixel_col - Reg7(10 DOWNTO 0)) XOR (pixel_row - Reg8(10 DOWNTO 0));
        bg_b   := math_b(4) XOR Reg9(3);

        IF Reg10(4) = '1' THEN
            red <= NOT bg_r; green <= NOT bg_g; blue <= NOT bg_b;
        ELSE
            red <= bg_r; green <= bg_g; blue <= bg_b;
        END IF;

        IF (px_col < 10 OR px_col > 790 OR px_row < 10 OR px_row > 590) THEN
            red <= '1'; green <= '1'; blue <= '1';
        END IF;

        -- 2. FILE MANAGER UI (Visible if menu_enable = '1')
        IF menu_enable = '1' THEN
            -- Menu Box
            IF (px_row >= 110 AND px_row < 350 AND px_col >= 50 AND px_col < 750) THEN
                red <= '0'; green <= '0'; blue <= '0';
                IF (px_row = 110 OR px_row = 349 OR px_col = 50 OR px_col = 749) THEN
                    red <= '1'; green <= '1'; blue <= '1';
                END IF;
            END IF;

            -- OPTION 0 (Top Item)
            IF (px_row >= 130 AND px_row < 160 AND px_col >= 70 AND px_col < 400) THEN
                IF menu_index = 0 THEN
                    red <= '0'; green <= '1'; blue <= '0'; -- Highlight Green
                ELSE
                    red <= '0'; green <= '0'; blue <= '0';
                END IF;
                IF (px_row = 130 OR px_row = 159 OR px_col = 70 OR px_col = 399) THEN
                    red <= '1'; green <= '1'; blue <= '1';
                END IF;
            END IF;
            
            -- OPTION 1 (Bottom Item)
            IF (px_row >= 180 AND px_row < 210 AND px_col >= 70 AND px_col < 400) THEN
                IF menu_index = 1 THEN
                    red <= '0'; green <= '1'; blue <= '0'; -- Highlight Green
                ELSE
                    red <= '0'; green <= '0'; blue <= '0'; 
                END IF;
                IF (px_row = 180 OR px_row = 209 OR px_col = 70 OR px_col = 399) THEN
                    red <= '1'; green <= '1'; blue <= '1';
                END IF;
            END IF;
        END IF;

        -- 3. REGISTER DASHBOARD (32 Grid)
        IF (px_row >= 480 AND px_row < 590 AND px_col >= 10 AND px_col < 790) THEN
            red <= '0'; green <= '0'; blue <= '0';
            IF (px_row = 480) THEN red <= '1'; green <= '1'; blue <= '1'; END IF;

            FOR i IN 0 TO 31 LOOP
                grid_row := i / 8;        
                grid_col := i MOD 8;      
                start_x := 20 + (grid_col * 95);
                start_y := 495 + (grid_row * 20);
                
                IF (px_row >= start_y AND px_row < start_y + 8 AND px_col >= start_x AND px_col < start_x + 64) THEN
                    char_index := (px_col - start_x) / 8;
                    char_x := (px_col - start_x) MOD 8;
                    char_y := px_row - start_y;
                    
                    reg_val := all_regs(i);
                    hex_digit := get_hex_digit(reg_val, 7 - char_index);
                    
                    IF get_font_pixel(hex_digit, char_y, char_x) = '1' THEN 
                        IF i = 0 THEN
                            red <= '1'; green <= '0'; blue <= '0'; -- ALU red
                        ELSE
                            red <= '0'; green <= '1'; blue <= '0'; -- Regs green
                        END IF;
                    END IF;
                END IF;
            END LOOP;
        END IF;

    END PROCESS;
END Behavioral;
