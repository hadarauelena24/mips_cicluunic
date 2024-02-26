----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2023 01:09:42 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Port ( clk : in STD_LOGIC;
           enable_W:in std_logic;
           ALUres : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           memWrite : in STD_LOGIC;
           memData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUres2 : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
type memRam is array(0 to 31) of std_logic_vector(15 downto 0);
signal RAM: memRam:=(x"0001",x"0002",x"0003",x"0004",x"0005",x"0006",x"0007",x"0008",x"0009",x"000A",others=>x"000F");

begin
    process(clk,memWrite)
    begin
    if rising_edge(clk) then
        if memWrite='1' then
            if enable_W='1' then
                RAM(conv_integer(ALUres(4 downto 0)))<=rd2;
            end if;
        end if;
    end if;
    memData<=RAM(conv_integer(ALUres(4 downto 0)));
    end process;
    ALUres2<=ALUres;
end Behavioral;
