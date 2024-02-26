----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2023 12:27:56 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
    Port ( pc : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUsrc : in STD_LOGIC;
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUop : in STD_LOGIC_VECTOR (1 downto 0);
           zeroALU : out STD_LOGIC;
           ALUres : out STD_LOGIC_VECTOR (15 downto 0);
           branchAdd:out std_logic_vector(15 downto 0));
end EX;

architecture Behavioral of EX is
    signal muxsrc:std_logic_vector(15 downto 0);
    signal ALUctrl:std_logic_vector(2 downto 0):="000";
    signal dif:std_logic_vector(15 downto 0);
begin
    muxsrc<=rd2 when ALUsrc='0' else ext_imm;
    --proces ALUcontrol
    process(ALUop,func)
    begin
    case ALUop is
        when "00"=> case func is
                        when "000"=>ALUctrl<="000";
                        when "001"=>ALUctrl<="001";
                        when "010"=>ALUctrl<="010";
                        when "011"=>ALUctrl<="011";
                        when "100"=>ALUctrl<="100";
                        when "101"=>ALUctrl<="101";
                        when "110"=>ALUctrl<="110";
                        when others=>ALUctrl<="111";
                    end case;
        when "01"=>ALUctrl<="000";
        when "10"=>ALUctrl<="001";
        when others=>ALUctrl<="100";
    end case;
    end process;
    
    --proces ALU
    process(sa,ALUctrl,rd1,muxsrc)
    begin
    dif<=rd1-muxsrc;
    if dif=0 then
        zeroALU<='1';
    else
        zeroALU<='0';
    end if;
    case ALUctrl is
        when "000"=>ALUres<=rd1+muxsrc;
        when "001"=>ALUres<=rd1-muxsrc;
        when "010"=>if sa='1' then ALUres<='0'&rd1(15 downto 1);
                    else ALUres<=rd1;
                    end if;
        when "011"=>if sa='1' then ALUres<='0'&rd1(15 downto 1);
                    else ALUres<=rd1;
                    end if;
        when "100"=>ALUres<=rd1 and muxsrc;
        when "101"=>ALUres<=rd1 or muxsrc;
        when "110"=>ALUres<=rd1 xor muxsrc;
        when others=> if sa='1' then
                        if rd1(15)='1' then ALUres<='1'&rd1(15 downto 1);
                        else ALUres<='0'&rd1(15 downto 1);
                        end if;
                      else ALUres<=rd1;
                      end if;
    end case;
    end process;
    branchAdd<=pc+ext_imm;
end Behavioral;
