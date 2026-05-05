LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY display_generator IS
    PORT (
        v_sync     : IN STD_LOGIC;
        pixel_row  : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col  : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        ALUresult  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg1       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg2       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg3       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg4       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg5       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg6       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg7       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg8       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg9       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Reg10      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        red        : OUT STD_LOGIC;
        green      : OUT STD_LOGIC;
        blue       : OUT STD_LOGIC
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

BEGIN
    PROCESS(pixel_row, pixel_col, ALUresult, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7, Reg8, Reg9, Reg10)
        VARIABLE px_col, px_row : INTEGER;
        VARIABLE char_x, char_y, char_index : INTEGER;
        VARIABLE hex_digit : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE pixel_bit : STD_LOGIC;
        
        -- Art Variables
        VARIABLE math_r, math_g, math_b : STD_LOGIC_VECTOR(10 DOWNTO 0);
        VARIABLE bg_r, bg_g, bg_b : STD_LOGIC;
    BEGIN
        px_col := to_integer(unsigned(pixel_col));
        px_row := to_integer(unsigned(pixel_row));

        -- =========================================================
        -- LAYERED 10-REGISTER CHAOS ART
        -- =========================================================
        -- RED LAYER: Diagonal scroll warped by R1, R2, R3
        math_r := (pixel_col + Reg1(10 DOWNTO 0)) XOR (pixel_row + Reg2(10 DOWNTO 0));
        bg_r   := math_r(5) XOR Reg3(4) XOR ALUresult(2);

        -- GREEN LAYER: Sierpinski AND-fractal masked by R4, R5, R6
        math_g := (pixel_col XOR Reg4(10 DOWNTO 0)) AND (pixel_row XOR Reg5(10 DOWNTO 0));
        bg_g   := math_g(6) XOR Reg6(5);

        -- BLUE LAYER: Inverse scroll driven by R7, R8, R9
        math_b := (pixel_col - Reg7(10 DOWNTO 0)) XOR (pixel_row - Reg8(10 DOWNTO 0));
        bg_b   := math_b(4) XOR Reg9(3);

        -- GLOBAL MODIFIER: Use R10 to create a flashing color inversion pulse
        IF Reg10(4) = '1' THEN
            red   <= NOT bg_r;
            green <= NOT bg_g;
            blue  <= NOT bg_b;
        ELSE
            red   <= bg_r;
            green <= bg_g;
            blue  <= bg_b;
        END IF;

        -- =========================================================
        -- UI OVERLAY (Kept minimal so we can see the art)
        -- =========================================================
        IF (px_col < 10 OR px_col > 790 OR px_row < 10 OR px_row > 590) THEN
            red <= '1'; green <= '1'; blue <= '1'; -- White Border
        END IF;

        -- Display ALUresult (Top Left)
        IF (px_row >= 30 AND px_row < 38 AND px_col >= 20 AND px_col < 84) THEN
            red <= '0'; green <= '0'; blue <= '0'; 
            char_index := (px_col - 20) / 8;
            char_x := (px_col - 20) MOD 8;
            char_y := px_row - 30;
            IF char_index < 8 THEN
                hex_digit := get_hex_digit(ALUresult, 7 - char_index);
                IF get_font_pixel(hex_digit, char_y, char_x) = '1' THEN red <= '1'; END IF;
            END IF;
        END IF;

        -- Display Reg1 (Top Middle)
        IF (px_row >= 30 AND px_row < 38 AND px_col >= 300 AND px_col < 364) THEN
            red <= '0'; green <= '0'; blue <= '0'; 
            char_index := (px_col - 300) / 8;
            char_x := (px_col - 300) MOD 8;
            char_y := px_row - 30;
            IF char_index < 8 THEN
                hex_digit := get_hex_digit(Reg1, 7 - char_index);
                IF get_font_pixel(hex_digit, char_y, char_x) = '1' THEN green <= '1'; END IF;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;
