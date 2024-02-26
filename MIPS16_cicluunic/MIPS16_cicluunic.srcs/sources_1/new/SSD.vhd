----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2023 12:02:28 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( Digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           Digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC);
end SSD;

architecture Behavioral of SSD is
signal cnt:std_logic_vector(15 downto 0):="0000000000000000";
signal out_mux1:std_logic_vector(3 downto 0);

component HEX7TOSEG is
 Port ( input : in STD_LOGIC_VECTOR (3 downto 0);
          output : out STD_LOGIC_VECTOR (6 downto 0));
end component;

begin
--counter16b
process(clk)
begin
if rising_edge(clk) then
    cnt<=cnt+1;
end if;
end process;

--mux pt catod
process(cnt,Digit0,Digit1,Digit2,Digit3)
begin
    case cnt(15 downto 14) is
        when "00" => out_mux1 <=Digit0;
        when "01" => out_mux1 <=Digit1;
        when "10" => out_mux1 <=Digit2;
        when others =>out_mux1<=Digit3;
    end case;
end process;

seg: HEX7TOSEG port map (input=>out_mux1,output=>cat);

--mux pt anod
process(cnt)
begin
    case cnt(15 downto 14) is
         when "00" => an <="1110";
         when "01" => an <="1101";
         when "10" => an <="1011";
         when others =>an<="0111";
    end case;
end process;

end Behavioral;
