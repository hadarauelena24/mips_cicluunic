----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2023 12:16:54 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
    Port ( clk:in std_logic;
           regWrite : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           regDst : in STD_LOGIC;
           extOp : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR(15 downto 0);
           enable_w : in STD_LOGIC;
           rd1: out std_logic_vector(15 downto 0);
           rd2: out std_logic_vector(15 downto 0);
           ext_imm:  out std_logic_vector(15 downto 0);
           func:out std_logic_vector(2 downto 0);
           sa: out std_logic
           );
end ID;

architecture Behavioral of ID is
    signal wa:std_logic_vector(2 downto 0);
    
    component RF is
         Port ( RA1 : in STD_LOGIC_VECTOR (2 downto 0);
              RA2 : in STD_LOGIC_VECTOR (2 downto 0);
              WA : in STD_LOGIC_VECTOR (2 downto 0);
              WD : in STD_LOGIC_VECTOR (15 downto 0);
              RD1 : out STD_LOGIC_VECTOR (15 downto 0);
              RD2 : out STD_LOGIC_VECTOR (15 downto 0);
              clk : in STD_LOGIC;
              enable_w: in std_logic;
              RegWr : in STD_LOGIC);
    end component;
begin
    reg_file: RF port map(RA1=>instr(12 downto 10),RA2=>instr(9 downto 7),WA=>wa,WD=>wd,RD1=>rd1,RD2=>rd2,clk=>clk,enable_w=>enable_w,RegWr=>regWrite);
    wa<=instr(6 downto 4) when regDst='1' else instr(9 downto 7);
    sa<=instr(3);
    func<=instr(2 downto 0);
    process(extOp)
    begin
    if extOp='0' then
        ext_imm<="000000000"&instr(6 downto 0);
    elsif extOP='1' then
        if instr(6)='1' then
            ext_imm<="111111111"&instr(6 downto 0);
        elsif instr(6)='0' then
            ext_imm<="000000000"&instr(6 downto 0);
        end if;
    end if;
    end process;

end Behavioral;
