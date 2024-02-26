----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2023 09:46:09 PM
-- Design Name: 
-- Module Name: monoimpuls - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity monoimpuls is
    Port ( input: in std_logic;
           clk: in std_logic;
           output: out std_logic);
end monoimpuls;

architecture Behavioral of monoimpuls is
signal q1:std_logic;
signal q2:std_logic;
signal q3:std_logic;
signal cnt:std_logic_vector(15 downto 0):="0000000000000000";
begin
--counter
process(clk)
begin
if clk='1' and clk'event then
    cnt<=cnt+1;
    end if;
end process;
--reg 1
process(clk)
begin
if clk='1' and clk'event then
    if cnt="1111111111111111" then
        q1<=input;
    end if;
end if;
end process;
--reg2 si 3
process(clk)
begin
    if clk='1' and clk'event then
        q2<=q1;
        q3<=q2;
    end if;
end process;
output<=(not q3)and q2;
end Behavioral;
