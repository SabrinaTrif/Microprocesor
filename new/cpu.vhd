----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2021 08:57:27 AM
-- Design Name: 
-- Module Name: cpu - Behavioral
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

entity cpu is
Port(clk : in STD_LOGIC;
reset_neg:in std_logic;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end cpu;

architecture Behavioral of cpu is

component alu is
 Port (s : in STD_LOGIC_VECTOR (15 downto 0);
 s1 : in STD_LOGIC_VECTOR (15 downto 0);
 ALUOp : in std_logic_vector(2 downto 0);
 ALUOut: out std_logic_vector(15 downto 0);
 regout:out std_logic_vector(2 downto 0));
end component;

component ALUControl is
Port (ALUOp :in std_logic_vector(2 downto 0);
functie:in std_logic_vector(3 downto 0);
ALUCtrl: out std_logic_vector(2 downto 0) );
end component;

component ControlUnit is
  port( -- input
       CLK         : in std_logic;
       Reset       : in std_logic;
       Op          : in std_logic_vector(5 downto 0);

       -- output (control signals)
       PCWriteCond : out std_logic;
       PCWrite     : out std_logic;
       IorD        : out std_logic;
       MemRead     : out std_logic;
       MemWrite    : out std_logic;
       MemToReg    : out std_logic_vector(1 downto 0);
       IRWrite     : out std_logic;
       PCSource    : out std_logic_vector(1 downto 0);
       ALUOp       : out std_logic_vector(2 downto 0);
       ALUSrcB     : out std_logic_vector(1 downto 0);
       ALUSrcA     : out std_logic;
       RegWrite    : out std_logic;
       RegDst      : out std_logic;
       RegWrite1   :out std_logic );
end component;

component InstructionRegister is
  port( -- input
        CLK             : in std_logic;
        reset_neg       : in std_logic;
        IRWrite         : in std_logic;
        in_instruction  : in std_logic_vector(15 downto 0);

        -- output
        out_instruction : out std_logic_vector(15 downto 0) );
end component;

component Memory is
  port( -- inputs
        CLK       : in std_logic;
        reset_neg : in std_logic;
        address   : in std_logic_vector(15 downto 0);
        MemWrite  : in std_logic;
        MemRead   : in std_logic;
        WriteData : in std_logic_vector(15 downto 0);

        -- output
        MemData   : out std_logic_vector(15 downto 0) );
end component;

component MemoryDataRegister is
  port( -- inputs
        CLK       : in std_logic;
        reset_neg : in std_logic;
        input     : in std_logic_vector(15 downto 0);    -- from MemDataOut

        -- output
        output    : out std_logic_vector(15 downto 0) ); -- to mux
end component;



component ProgramCounter is
  port( -- input
        CLK       : in  std_logic;
        reset_neg : in  std_logic;
        input     : in  std_logic_vector(15 downto 0);
        PCcontrol : in  std_logic;

        -- output
        output    : out std_logic_vector(15 downto 0) );
end component;

component Registers is
  port( -- input
        CLK          : in std_logic;
        reset_neg    : in std_logic;
        address_in_1 : in std_logic_vector(2 downto 0);
        address_in_2 : in std_logic_vector(2 downto 0);
        write_reg    : in std_logic_vector(2 downto 0);

        write_data   : in std_logic_vector(15 downto 0);
        RegWrite     : in std_logic;  -- signal control

        -- output
        register_1   : out std_logic_vector(15 downto 0);
        register_2   : out std_logic_vector(15 downto 0) );
end component;


component extindere is
Port (-- input
        input  : in std_logic_vector(6 downto 0);

        -- output
        output : out std_logic_vector(15 downto 0) );
end component;

component TempRegisters is
  port( -- input
        CLK         : in std_logic;
        reset_neg   : in std_logic;
        in_reg_A    : in std_logic_vector (15 downto 0);
        in_reg_B    : in std_logic_vector (15 downto 0);
        in_ALU_out  : in std_logic_vector (15 downto 0);

        -- output
        out_reg_A   : out std_logic_vector(15 downto 0);
        out_reg_B   : out std_logic_vector(15 downto 0);
        out_ALU_out : out std_logic_vector(15 downto 0) );
end component;

component Mux2 is
  port( -- input
        input_1     : in std_logic_vector(15 downto 0);
        input_2     : in std_logic_vector(15 downto 0);
        mux_select  : in std_logic;

        -- output
        output      : out std_logic_vector(15 downto 0) );
end component;

component Mux21 is
  port( -- input
        input_1     : in std_logic_vector(2 downto 0);
        input_2     : in std_logic_vector(2 downto 0);
        mux_select  : in std_logic;

        -- output
        output      : out std_logic_vector(2 downto 0) );
end component;

component Mux3 is
  port( -- input
        input_1     : in std_logic_vector(15 downto 0);
        input_2     : in std_logic_vector(15 downto 0);
        input_3     : in std_logic_vector(15 downto 0);
        mux_select  : in std_logic_vector(1 downto 0);

        -- output
        output      : out std_logic_vector(15 downto 0) );
end component;

component Mux4 is
  port( -- input
        input_1     : in std_logic_vector(15 downto 0);
        input_2     : in std_logic_vector(15 downto 0);
        input_3     : in std_logic_vector(15 downto 0);
        input_4     : in std_logic_vector(15 downto 0);
        mux_select  : in std_logic_vector(1 downto 0);

        -- output
        output      : out std_logic_vector(15 downto 0) );
end component;
component Flags is
Port (regout:in std_logic_vector(2 downto 0);
RegWrite1:in std_logic;
clk:in std_logic;
flagout:out std_logic_vector(2 downto 0) );
end component;

  constant PC_increment : std_logic_vector(15 downto 0) := "0000000000000010";

-- signals
  signal PC_out, MuxToAddress, MemDataOut, MemoryDataRegOut, InstructionRegOut, MuxToWriteData, ReadData1ToA, ReadData2ToB, RegAToMux, RegBOut, SignExtendOut, ShiftLeft1ToMux4, MuxToAlu, Mux4ToAlu, AluResultOut, AluOutToMux, JumpAddress, MuxToPC,MuxToPC1 : std_logic_vector(15 downto 0);
  signal ZeroCarry_TL, ALUSrcA_TL, RegWrite_TL, RegDst_TL, PCWriteCond_TL, PCWrite_TL, IorD_TL, MemRead_TL, MemWrite_TL, IRWrite_TL, ANDtoOR, ORtoPC,RegWrite1,PcMux,PcMux1 : std_logic;
  signal MuxToWriteRegister, ALUOp_TL  : std_logic_vector(2 downto 0);
  signal ALUControltoALU : std_logic_vector(2 downto 0);
  signal PCsource_TL, ALUSrcB_TL, MemToReg_TL: std_logic_vector(1 downto 0);
  signal ExtOp: std_logic :='0';
  signal regout,flagout: std_logic_vector(2 downto 0);

begin

  ANDtoOR <= ZeroCarry_TL and PCWriteCond_TL;
  ORtoPC <= ANDtoOR or PCWrite_TL;
  JumpAddress <= "000000"&InstructionRegOut(9 downto 0);
  PcMux<=flagout(0) and PCsource_TL(0);
  PcMux1<=not(flagout(0)) and PCsource_TL(1);

  A_Logic_Unit : alu              port map(MuxToAlu, Mux4ToALU, ALUControltoALU, AluResultOut,regOut);
  CTRL_UNIT    : ControlUnit         port map(CLK, reset_neg, InstructionRegOut(15 downto 10), PCWriteCond_TL, PCWrite_TL, IorD_TL, MemRead_TL, MemWrite_TL, MemToReg_TL, IRWrite_TL, PCsource_TL, ALUOp_TL, ALUSrcB_TL, ALUSrcA_TL, RegWrite_TL, RegDst_TL,RegWrite1);
  ALU_CONTROL  : ALUControl          port map(ALUOp_TL, InstructionRegOut(3 downto 0), ALUControltoALU);
  INSTR_REG    : InstructionRegister port map(CLK, reset_neg, IRWrite_TL, MemDataOut, InstructionRegOut);
  MEM          : Memory              port map(CLK, reset_neg, MuxToAddress, MemWrite_TL, MemRead_TL, ReadData1ToA, MemDataOut);
  MEM_DATA_REG : MemoryDataRegister  port map(CLK, reset_neg, MemDataOut, MemoryDataRegOut);
  PC           : ProgramCounter      port map(CLK, reset_neg, MuxToPC1, ORtoPC, PC_out);
  REG          : Registers           port map(CLK, reset_neg, InstructionRegOut(9 downto 7), InstructionRegOut(6 downto 4), MuxToWriteRegister, MuxToWriteData, RegWrite_TL, ReadData1ToA, ReadData2ToB);
  SE           : extindere         port map(InstructionRegOut(6 downto 0), SignExtendOut);
  S            :Flags                port map(regout,RegWrite1,clk,flagout);
  TEMP_REG     : TempRegisters       port map(CLK, reset_neg, ReadData1ToA, ReadData2ToB, AluResultOut, RegAToMux, RegBOut, AluOutToMux);
  MUX_1        : Mux2                port map(PC_out, SignExtendOut, IorD_TL, MuxToAddress);
  MUX_2        : Mux21             port map(InstructionRegOut(9 downto 7), InstructionRegOut(6 downto 4), RegDst_TL, MuxToWriteRegister);
  MUX_3        : Mux4                port map(AluOutToMux, MemoryDataRegOut,SignExtendOut,ReadData2toB, MemToReg_TL, MuxToWriteData);
  MUX_4        : Mux2                port map(PC_out, RegAToMux, ALUSrcA_TL, MuxToAlu);
  MUX_5        : Mux4                port map(RegBOut, PC_increment, SignExtendOut, MemoryDataRegOut, ALUSrcB_TL, Mux4ToAlu);
  MUX_6        : Mux2                port map(AluResultOut,JumpAddress, PcMux, MuxToPC);
  MUX_7        : Mux2                port map(MuxToPC,JumpAddress, PcMux1, MuxToPC1);

end Behavioral;