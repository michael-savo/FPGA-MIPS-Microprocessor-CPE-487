LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY display_generator IS
    PORT (
        clk        : IN STD_LOGIC;
        v_sync     : IN STD_LOGIC;
        pixel_row  : IN STD_LOGIC_VECTOR(10 DOWNTO 0);  -- 0-599
        pixel_col  : IN STD_LOGIC_VECTOR(10 DOWNTO 0);  -- 0-799
        mem_data   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- 
        mem_addr   : OUT STD_LOGIC_VECTOR(17 DOWNTO 0); 
        red        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        green      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        blue       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END display_generator;

ARCHITECTURE Behavioral OF display_generator IS
BEGIN

    PROCESS(pixel_row, pixel_col, mem_data)
        VARIABLE px_col : INTEGER;z
        VARIABLE px_row : INTEGER;
        VARIABLE word_addr : INTEGER;
        VARIABLE pixel_in_word : INTEGER;
        VARIABLE color_8bit : STD_LOGIC_VECTOR(7 DOWNTO 0);
    BEGIN
        px_col := to_integer(unsigned(pixel_col));
        px_row := to_integer(unsigned(pixel_row));
        
        -- Each row has 800 pixels = 200 words (4 pixels per word)
        word_addr := (px_row * 200) + (px_col / 4);
        mem_addr <= std_logic_vector(to_unsigned(word_addr, 17));
        
        -- Calculate which pixel within the 32-bit word (0-3)
        pixel_in_word := px_col MOD 4;
        
        CASE pixel_in_word IS
            WHEN 0 => color_8bit := mem_data(7 DOWNTO 0);
            WHEN 1 => color_8bit := mem_data(15 DOWNTO 8);
            WHEN 2 => color_8bit := mem_data(23 DOWNTO 16);
            WHEN OTHERS => color_8bit := mem_data(31 DOWNTO 24);
        END CASE;
        
        red <= color_8bit(7 DOWNTO 5);
        green <= color_8bit(4 DOWNTO 2);
        blue <= color_8bit(1 DOWNTO 0);
        
    END PROCESS;

END Behavioral;
