----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2023 11:03:03 PM
-- Design Name: 
-- Module Name: lab4 - Behavioral
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


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2023 08:44:10 PM
-- Design Name: 
-- Module Name: counter16b - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MIPS16_unic is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0));
end MIPS16_unic;

 architecture Behavioral of MIPS16_unic is

    signal enR,enW:std_logic;
    signal cnt:std_logic_vector(7 downto 0):=x"00";
    signal DO:std_logic_vector(15 downto 0);
    signal pc,instr:std_logic_vector(15 downto 0);
    
    signal regDst : STD_LOGIC;
    signal extOp : STD_LOGIC;
    signal ALUsrc : STD_LOGIC;
    signal ALUop : std_logic_vector(1 downto 0);
    signal branch : STD_LOGIC;
    signal sbne : std_logic;
    signal jump : STD_LOGIC;
    signal memWrite : STD_LOGIC;
    signal memtoreg : STD_LOGIC;
    signal regWrite : STD_LOGIC;
    signal pcsrc:std_logic;
    
     signal rd1: std_logic_vector(15 downto 0);
     signal rd2: std_logic_vector(15 downto 0);
     signal ext_imm: std_logic_vector(15 downto 0);
     signal func: std_logic_vector(2 downto 0);
     signal sa: std_logic;
     signal wd: std_logic_vector(15 downto 0);
     
     signal zeroALU : STD_LOGIC;
     signal ALUres : STD_LOGIC_VECTOR (15 downto 0);
     signal branchAdd,jumpAdd: std_logic_vector(15 downto 0);
     
     signal memData,ALUres2:std_logic_vector(15 downto 0);
     
     --semnale provizorii
     signal sum,ext_func,ext_sa: std_logic_vector(15 downto 0);
     
    
    component monoimpuls is
    port( input: in std_logic;
              clk: in std_logic;
              output: out std_logic);
    end component;
    
    component SSD is
    Port ( Digit0 : in STD_LOGIC_VECTOR (3 downto 0);
               Digit1 : in STD_LOGIC_VECTOR (3 downto 0);
               Digit2 : in STD_LOGIC_VECTOR (3 downto 0);
               Digit3 : in STD_LOGIC_VECTOR (3 downto 0);
               cat : out STD_LOGIC_VECTOR (6 downto 0);
               an : out STD_LOGIC_VECTOR (3 downto 0);
               clk : in STD_LOGIC);
    end component;
    
    component IFF is
     Port ( jAddress : in STD_LOGIC_VECTOR (15 downto 0);
              branchAddress : in STD_LOGIC_VECTOR (15 downto 0);
              pc : out STD_LOGIC_VECTOR (15 downto 0);
              jump : in STD_LOGIC;
              pcSRC : in STD_LOGIC;
              clk:in std_logic;
              enableW: in std_logic;
              enableR: in std_logic;
              instr : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    component ID is
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
    end component;
    
    component UC is
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
    end component;
    
    component EX is
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
    end component;
    
    component MEM is
    Port ( clk : in STD_LOGIC;
               enable_W:in std_logic;
               ALUres : in STD_LOGIC_VECTOR (15 downto 0);
               rd2 : in STD_LOGIC_VECTOR (15 downto 0);
               memWrite : in STD_LOGIC;
               memData : out STD_LOGIC_VECTOR (15 downto 0);
               ALUres2 : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    
begin
    segdisplay: SSD port map(Digit0=>DO(3 downto 0),Digit1=>DO(7 downto 4),Digit2=>DO(11 downto 8),Digit3=>DO(15 downto 12),clk=>clk,cat=>cat,an=>an);
    monopulseR: monoimpuls port map(input=>btn(0),output=>enR,clk=>clk);
    monopulseW: monoimpuls port map(input=>btn(4),output=>enW,clk=>clk);
    ifschema: IFF port map(jAddress=>jumpAdd,branchAddress=>branchAdd,pc=>pc,jump=>jump,pcSrc=>pcsrc,clk=>clk,enableW=>enW,enableR=>enR,instr=>instr);
    maincontrol: UC port map(instr=>instr,regDst=>regDst,extOp=>extOp,ALUsrc=>ALUsrc,ALUop=>ALUop,branch=>branch,sbne=>sbne,jump=>jump,memWrite=>memWrite,memtoReg=>memtoReg,regWrite=>regWrite);
    idschema: ID port map(clk=>clk,regWrite=>regWrite,instr=>instr,regDst=>regDst,extOp=>extOp,wd=>wd, enable_w=>enW,rd1=>rd1,rd2=>rd2,ext_imm=>ext_imm,func=>func,sa=>sa);
    exschema: EX port map(pc=>pc,rd1=>rd1,ALUsrc=>ALUsrc,rd2=>rd2,ext_imm=>ext_imm,sa=>sa,func=>func,ALUop=>ALUop,zeroALU=>zeroALU,ALUres=>ALUres,branchAdd=>branchAdd);
    memschema: MEM port map(clk=>clk,enable_W=>enW,ALUres=>ALUres,rd2=>rd2,memWrite=>memWrite,memData=>memData,ALUres2=>ALUres2);

    jumpAdd<=pc(15 downto 13)&instr(12 downto 0);
    wd<=ALUres when memtoReg='0' else memData;
    pcsrc<=(branch and zeroALU) or (sbne and (not zeroALU));
    --DO<=pc when sw(7)='1' else instr;--va fi process
    process(sw)
    begin
    case sw(7 downto 5) is
        when "000"=> DO <=instr;
        when "001"=> DO <=pc;
        when "010"=> DO <=rd1;
        when "011"=> DO <=rd2;
        when "100"=> DO <=ext_imm;
        when "101"=> DO <=ALUres;
        when "110"=> DO <=memData;
        when others=> DO <=wd;
    end case;
    end process;
    led(10)<=regDst;
    led(9)<=extOp;
    led(8)<=ALUsrc;
    led(7)<=branch;
    led(6)<=sbne;
    led(5)<=jump;
    led(4)<=memWrite;
    led(3)<=memtoReg;
    led(2)<=regWrite;
    led(1)<=ALUop(1);
    led(0)<=ALUop(0);
end Behavioral;
