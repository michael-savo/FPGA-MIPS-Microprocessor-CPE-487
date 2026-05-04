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
        red        : OUT STD_LOGIC;
        green      : OUT STD_LOGIC;
        blue       : OUT STD_LOGIC
    );
END display_generator;

ARCHITECTURE Behavioral OF display_generator IS

    -- Font ROM for displaying hex characters (8x8 pixels each)
    -- This is a simplified 4-bit hex character set
    TYPE font_array IS ARRAY (0 TO 15, 0 TO 7) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    CONSTANT FONT : font_array := (
        -- 0
        ("00111100", "01000010", "10000001", "10000001", "10000001", "10000001", "01000010", "00111100"),
        -- 1
        ("00011000", "00101000", "00001000", "00001000", "00001000", "00001000", "00001000", "00111110"),
        -- 2
        ("00111100", "01000010", "10000001", "00000001", "00000010", "00000100", "00001000", "11111111"),
        -- 3
        ("00111100", "01000010", "10000001", "00000110", "00000001", "10000001", "01000010", "00111100"),
        -- 4
        ("00001000", "00011000", "00101000", "01001000", "10001000", "11111111", "00001000", "00001000"),
        -- 5
        ("11111111", "10000000", "10000000", "11111100", "00000010", "10000001", "01000010", "00111100"),
        -- 6
        ("00111100", "01000010", "10000000", "11111100", "10000010", "10000001", "01000010", "00111100"),
        -- 7
        ("11111111", "00000001", "00000010", "00000100", "00001000", "00010000", "00100000", "01000000"),
        -- 8
        ("00111100", "01000010", "10000001", "01000010", "00111100", "01000010", "10000001", "00111100"),
        -- 9
        ("00111100", "01000010", "10000001", "01000011", "00111101", "00000001", "01000010", "00111100"),
        -- A
        ("00111100", "01000010", "10000001", "10000001", "11111111", "10000001", "10000001", "10000001"),
        -- B
        ("11111100", "10000010", "10000001", "11111100", "10000010", "10000001", "10000010", "11111100"),
        -- C
        ("00111100", "01000010", "10000000", "10000000", "10000000", "10000000", "01000010", "00111100"),
        -- D
        ("11111000", "10000100", "10000010", "10000001", "10000001", "10000010", "10000100", "11111000"),
        -- E
        ("11111111", "10000000", "10000000", "11111100", "10000000", "10000000", "10000000", "11111111"),
        -- F
        ("11111111", "10000000", "10000000", "11111100", "10000000", "10000000", "10000000", "10000000")
    );

    -- Function to get a single bit from the font
    FUNCTION get_font_pixel(hex_char : STD_LOGIC_VECTOR(3 DOWNTO 0); row : INTEGER; col : INTEGER) RETURN STD_LOGIC IS
    BEGIN
        RETURN FONT(to_integer(unsigned(hex_char)), row)(col);
    END FUNCTION;

    -- Function to extract hex digit from a 32-bit value
    FUNCTION get_hex_digit(value : STD_LOGIC_VECTOR(31 DOWNTO 0); digit_pos : INTEGER) RETURN STD_LOGIC_VECTOR IS
    BEGIN
        RETURN value((digit_pos * 4 + 3) DOWNTO (digit_pos * 4));
    END FUNCTION;

BEGIN

    PROCESS(pixel_row, pixel_col, ALUresult, Reg1, Reg2)
        VARIABLE px_col : INTEGER;
        VARIABLE px_row : INTEGER;
        VARIABLE char_x, char_y : INTEGER;
        VARIABLE char_index : INTEGER;
        VARIABLE hex_digit : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE pixel_bit : STD_LOGIC;
        VARIABLE display_value : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        px_col := to_integer(unsigned(pixel_col));
        px_row := to_integer(unsigned(pixel_row));
        
        red <= '0';
        green <= '0';
        blue <= '0';

        -- Draw border (white)
        IF (px_col < 10 OR px_col > 790 OR px_row < 10 OR px_row > 590) THEN
            red <= '1';
            green <= '1';
            blue <= '1';
        END IF;

        -- Display ALUresult (Red text, upper left)
        -- 8 hex digits, each 8x8 pixels, starting at (20, 30)
        IF (px_row >= 30 AND px_row < 38 AND px_col >= 20 AND px_col < 84) THEN
            char_index := (px_col - 20) / 8;  -- which character (0-7)
            char_x := (px_col - 20) MOD 8;     -- pixel within character (0-7)
            char_y := px_row - 30;             -- row within character (0-7)
            
            IF char_index < 8 THEN
                hex_digit := get_hex_digit(ALUresult, 7 - char_index);
                pixel_bit := get_font_pixel(hex_digit, char_y, char_x);
                IF pixel_bit = '1' THEN
                    red <= '1';
                END IF;
            END IF;
        END IF;

        -- Display Reg1 (Green text, upper middle)
        -- Starting at (300, 30)
        IF (px_row >= 30 AND px_row < 38 AND px_col >= 300 AND px_col < 364) THEN
            char_index := (px_col - 300) / 8;
            char_x := (px_col - 300) MOD 8;
            char_y := px_row - 30;
            
            IF char_index < 8 THEN
                hex_digit := get_hex_digit(Reg1, 7 - char_index);
                pixel_bit := get_font_pixel(hex_digit, char_y, char_x);
                IF pixel_bit = '1' THEN
                    green <= '1';
                END IF;
            END IF;
        END IF;

        -- Display Reg2 (Blue text, upper right)
        -- Starting at (580, 30)
        IF (px_row >= 30 AND px_row < 38 AND px_col >= 580 AND px_col < 644) THEN
            char_index := (px_col - 580) / 8;
            char_x := (px_col - 580) MOD 8;
            char_y := px_row - 30;
            
            IF char_index < 8 THEN
                hex_digit := get_hex_digit(Reg2, 7 - char_index);
                pixel_bit := get_font_pixel(hex_digit, char_y, char_x);
                IF pixel_bit = '1' THEN
                    blue <= '1';
                END IF;
            END IF;
        END IF;

    END PROCESS;

END Behavioral;LIBRARY IEEE;
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
        red        : OUT STD_LOGIC;
        green      : OUT STD_LOGIC;
        blue       : OUT STD_LOGIC
    );
END display_generator;

ARCHITECTURE Behavioral OF display_generator IS

    -- Font ROM for displaying hex characters (8x8 pixels each)
    -- This is a simplified 4-bit hex character set
    TYPE font_array IS ARRAY (0 TO 15, 0 TO 7) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    CONSTANT FONT : font_array := (
        -- 0
        ("00111100", "01000010", "10000001", "10000001", "10000001", "10000001", "01000010", "00111100"),
        -- 1
        ("00011000", "00101000", "00001000", "00001000", "00001000", "00001000", "00001000", "00111110"),
        -- 2
        ("00111100", "01000010", "10000001", "00000001", "00000010", "00000100", "00001000", "11111111"),
        -- 3
        ("00111100", "01000010", "10000001", "00000110", "00000001", "10000001", "01000010", "00111100"),
        -- 4
        ("00001000", "00011000", "00101000", "01001000", "10001000", "11111111", "00001000", "00001000"),
        -- 5
        ("11111111", "10000000", "10000000", "11111100", "00000010", "10000001", "01000010", "00111100"),
        -- 6
        ("00111100", "01000010", "10000000", "11111100", "10000010", "10000001", "01000010", "00111100"),
        -- 7
        ("11111111", "00000001", "00000010", "00000100", "00001000", "00010000", "00100000", "01000000"),
        -- 8
        ("00111100", "01000010", "10000001", "01000010", "00111100", "01000010", "10000001", "00111100"),
        -- 9
        ("00111100", "01000010", "10000001", "01000011", "00111101", "00000001", "01000010", "00111100"),
        -- A
        ("00111100", "01000010", "10000001", "10000001", "11111111", "10000001", "10000001", "10000001"),
        -- B
        ("11111100", "10000010", "10000001", "11111100", "10000010", "10000001", "10000010", "11111100"),
        -- C
        ("00111100", "01000010", "10000000", "10000000", "10000000", "10000000", "01000010", "00111100"),
        -- D
        ("11111000", "10000100", "10000010", "10000001", "10000001", "10000010", "10000100", "11111000"),
        -- E
        ("11111111", "10000000", "10000000", "11111100", "10000000", "10000000", "10000000", "11111111"),
        -- F
        ("11111111", "10000000", "10000000", "11111100", "10000000", "10000000", "10000000", "10000000")
    );

    FUNCTION get_font_pixel(hex_char : STD_LOGIC_VECTOR(3 DOWNTO 0); row : INTEGER; col : INTEGER) RETURN STD_LOGIC IS
    BEGIN
        RETURN FONT(to_integer(unsigned(hex_char)), row)(col);
    END FUNCTION;

    -- Function to extract hex digit from a 32-bit value
    FUNCTION get_hex_digit(value : STD_LOGIC_VECTOR(31 DOWNTO 0); digit_pos : INTEGER) RETURN STD_LOGIC_VECTOR IS
    BEGIN
        RETURN value((digit_pos * 4 + 3) DOWNTO (digit_pos * 4));
    END FUNCTION;

BEGIN

    PROCESS(pixel_row, pixel_col, ALUresult, Reg1, Reg2)
        VARIABLE px_col : INTEGER;
        VARIABLE px_row : INTEGER;
        VARIABLE char_x, char_y : INTEGER;
        VARIABLE char_index : INTEGER;
        VARIABLE hex_digit : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE pixel_bit : STD_LOGIC;
        VARIABLE display_value : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        px_col := to_integer(unsigned(pixel_col));
        px_row := to_integer(unsigned(pixel_row));
        
        red <= '0';
        green <= '0';
        blue <= '0';

        -- Draw border (white)
        IF (px_col < 10 OR px_col > 790 OR px_row < 10 OR px_row > 590) THEN
            red <= '1';
            green <= '1';
            blue <= '1';
        END IF;

        -- Display ALUresult (Red text, upper left)
        -- 8 hex digits, each 8x8 pixels, starting at (20, 30)
        IF (px_row >= 30 AND px_row < 38 AND px_col >= 20 AND px_col < 84) THEN
            char_index := (px_col - 20) / 8;  -- which character (0-7)
            char_x := (px_col - 20) MOD 8;     -- pixel within character (0-7)
            char_y := px_row - 30;             -- row within character (0-7)
            
            IF char_index < 8 THEN
                hex_digit := get_hex_digit(ALUresult, 7 - char_index);
                pixel_bit := get_font_pixel(hex_digit, char_y, char_x);
                IF pixel_bit = '1' THEN
                    red <= '1';
                END IF;
            END IF;
        END IF;

        -- Display Reg1 (Green text, upper middle)
        -- Starting at (300, 30)
        IF (px_row >= 30 AND px_row < 38 AND px_col >= 300 AND px_col < 364) THEN
            char_index := (px_col - 300) / 8;
            char_x := (px_col - 300) MOD 8;
            char_y := px_row - 30;
            
            IF char_index < 8 THEN
                hex_digit := get_hex_digit(Reg1, 7 - char_index);
                pixel_bit := get_font_pixel(hex_digit, char_y, char_x);
                IF pixel_bit = '1' THEN
                    green <= '1';
                END IF;
            END IF;
        END IF;

        -- Display Reg2 (Blue text, upper right)
        -- Starting at (580, 30)
        IF (px_row >= 30 AND px_row < 38 AND px_col >= 580 AND px_col < 644) THEN
            char_index := (px_col - 580) / 8;
            char_x := (px_col - 580) MOD 8;
            char_y := px_row - 30;
            
            IF char_index < 8 THEN
                hex_digit := get_hex_digit(Reg2, 7 - char_index);
                pixel_bit := get_font_pixel(hex_digit, char_y, char_x);
                IF pixel_bit = '1' THEN
                    blue <= '1';
                END IF;
            END IF;
        END IF;

    END PROCESS;

END Behavioral;