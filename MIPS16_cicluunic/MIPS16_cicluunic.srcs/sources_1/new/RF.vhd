----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2023 12:34:03 PM
-- Design Name: 
-- Module Name: RF - Behavioral
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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RF is
    Port ( RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           enable_w: in std_logic;
           RegWr : in STD_LOGIC);
end RF;

architecture Behavioral of RF is
type regf is array (0 to 7) of std_logic_vector(15 downto 0);
    signal myRF:regf:=(x"0000",others=>x"0000");
begin
    process(clk,RA1,RA2,WA,WD,RegWr,enable_w)
    begin
        
        if rising_edge(clk) then 
            if RegWr='1' then
                if enable_w='1' then
                myRF(conv_integer(WA))<=WD;
                end if;
            end if;
        end if;
        RD1<=myRF(conv_integer(RA1));
        RD2<=myRF(conv_integer(RA2));
    end process;

end Behavioral;
