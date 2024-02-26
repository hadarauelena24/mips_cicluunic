----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2023 12:26:15 PM
-- Design Name: 
-- Module Name: IF - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFF is
    Port ( jAddress : in STD_LOGIC_VECTOR (15 downto 0);
           branchAddress : in STD_LOGIC_VECTOR (15 downto 0);
           pc : out STD_LOGIC_VECTOR (15 downto 0);
           jump : in STD_LOGIC;
           pcSRC : in STD_LOGIC;
           clk:in std_logic;
           enableW: in std_logic;
           enableR: in std_logic;
           instr : out STD_LOGIC_VECTOR (15 downto 0));
end IFF;

architecture Behavioral of IFF is
type mem256_16 is array (0 to 255) of std_logic_vector(15 downto 0);
    signal myROM:mem256_16:=(x"0010",--add $1,$0,$0 #init contor bucla i=0
                             x"210A",--addi $2,$0,10 #salvez nr iteratii
                             x"0030",--add $3,$0,$0 #init index locatie mem
                             x"0040",--add $4,$0,$0 #init contor nr pare
                             x"8887",--beq $1,$2,7 #verific daca s-au facut iteratiile
                             x"4E80",--lw $5,0($3) #salvez elementul curent din sir 
                             x"B701",--andi $6,$5,1 #verific daca ultimul bit e 1
                             x"D801",--bne $6,$0,3 #daca e 1, nu e numar par, deci se face salt la finalul buclei
                             x"3201",--addi $4,$4,1 #contor nr pare++
                             x"2D81",--addi $3,$3,1 #indexul urm element din sir
                             x"2481",--addi $1,$1,1 # actualizare contor bucla i++
                             x"E004",--j 4 #salt la inceputul buclei
                             x"620C",--sw $4,14($0) #salvez la adr 14 nr elemente pare
                             others=>x"0000");
signal d,sum,muxPC,muxJ:std_logic_vector(15 downto 0);
signal q:std_logic_vector(15 downto 0):=x"0000";
begin
    process(clk)
    begin
    if rising_edge(clk) then
        if enableR='1' then
            q<=x"0000";
        else
            if enableW='1' then
                q<=d;
            end if;
        end if;
    end if;
    end process;
    instr<=myROM(conv_integer(q(7 downto 0)));
    sum<=1+q;
    pc<=sum;
    muxPC<=sum when pcSrc='0' else branchAddress;
    muxJ<=muxPC when jump='0' else jAddress;
    d<=muxJ;
end Behavioral;
