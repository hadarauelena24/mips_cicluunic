----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2023 12:47:25 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
    Port ( instr : in STD_LOGIC_VECTOR (15 downto 0);
           regDst : out STD_LOGIC;
           extOp : out STD_LOGIC;
           ALUsrc : out STD_LOGIC;
           ALUop: out std_logic_vector(1 downto 0);
           branch : out STD_LOGIC;
           sbne: out std_logic;
           jump : out STD_LOGIC;
           memWrite : out STD_LOGIC;
           memtoreg : out STD_LOGIC;
           regWrite : out STD_LOGIC);
end UC;


architecture Behavioral of UC is

begin
   
    process(instr)
    begin
     regDst<='0';
       extOp<='0';
       ALUsrc<='0';
       ALUop<="00";
       branch<='0';
       sbne<='0';
       jump<='0';
       memWrite<='0';
       memtoreg<='0';
       regWrite<='0';
    case instr(15 downto 13) is--opcode
        when "000"=> regDst<='1'; regWrite<='1'; ALUop<="00"; --instr tip R
        when "001"=> extOp<='1'; ALUsrc<='1';regWRite<='1';ALUop<="01"; -- instr addi
        when "010"=> extOp<='1'; ALUsrc<='1'; regWrite<='1'; memtoreg<='1'; ALUop<="01"; --instr lw
        when "011"=> extOp<='1'; ALUsrc<='1';memWrite<='1'; ALUop<="01"; --instr sw
        when "100"=> extOp<='1'; branch<='1'; ALUop<="10"; -- instr beq
        when "101"=> ALUsrc<='1'; regWRite<='1'; ALUop<="11"; -- instr andi
        when "110"=> extOp<='1'; sbne<='1'; ALUop<="10"; --instr bne
        when "111"=> jump<='1';
    end case;
    end process;

end Behavioral;
