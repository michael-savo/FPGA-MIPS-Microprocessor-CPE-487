library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
Port(
    A : in std_logic;
    B : in std_logic;
    S : in std_logic;
    Z : out std_logic
);
end mux;

architecture Behavioral of mux is

begin
process (A, B, S) is 
begin
    if (S = '0') then 
        Z <= A;
    elsif (S = '1') then 
        Z <= B;
    end if;
end process;
end Behavioral;
