library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
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
end ControlUnit;

architecture Behavioral of ControlUnit is

  type state is(
                 InstructionFetch,
                 InstructionDecode,
                 MemoryAddressComp,
                 Execution,
                 Execution_I,
                 Execution2,
                 Execution3,
                 Execution4,
                 Execution5,
                 Execution6,
                 Execution7,
                 Execution8,
                 Execution9,
                 Execution10,
                 Execution11,
                 Execution12,
                 Execution13,
                 Mov1,
                 Mov2,
                 Mov3,
                 Xchg,
                 Jump,
                 Jump1,
                 RTypeCompletion,
                 RTypeCompletion_I,
                 MemoryReadCompletionStep );

  signal current_state, next_state : state :=InstructionFetch;
  signal ctrl_state : std_logic_vector(18 downto 0) := (others => '0');

begin

  process(CLK, Reset, Op)
  begin
    if Reset = '0' then
      current_state <= InstructionFetch;
    elsif rising_edge(CLK) then
      current_state <= next_state;
    end if;

    case current_state is
      when InstructionFetch  => next_state <= InstructionDecode;

      when InstructionDecode => if Op(1 downto 0) = "10" then --adresare directa
                                  next_state <= MemoryAddressComp;
                                elsif Op = "000001" then -- R-type
                                  next_state <= Execution;
                                elsif Op = "000100" then -- add i
                                  next_state <= Execution_I;
                                  elsif Op = "001000" then -- sub i
                                     next_state <= Execution2;
                                elsif Op = "001100" then -- and i
                                       next_state <= Execution3;
                                elsif Op = "010000" then -- or i
                                       next_state <= Execution5;
                                elsif Op = "010100" then -- xor i
                                      next_state <= Execution4;
                                elsif Op="101000" then
                                      next_state<=Mov1;
                                 elsif Op="000101" then
                                       next_state<=Mov2;
                                 elsif Op="110000" then
                                       next_state<=Mov1;
                                  elsif Op="011000" then
                                        next_state<=Execution11;
                                 elsif Op="001001" then
                                        next_state<=Execution12;
                                 elsif Op="011100" then
                                        next_state<=Jump;
                                elsif Op="100000" then
                                        next_state<=Jump1;
                                  end if;

      when MemoryAddressComp=> if Op="000110"then
            next_state<=Execution6;
      elsif Op="001010" then
            next_state<=Execution7;
      elsif Op="001110" then
            next_state<=Execution8;
      elsif Op="010110" then
             next_state<=Execution9;
      elsif Op="010010" then
             next_state<=Execution10;
      elsif Op="101010" then
             next_state<=Mov3;
      elsif Op="101110" then
              next_state<=Xchg;
      elsif Op="011010" then
              next_state<=Execution13;
      end if;
      when Execution         => next_state <= RTypeCompletion;

      when Execution_I       => next_state <= RTypeCompletion_I;
      when Execution2       => next_state <= RTypeCompletion_I;
      when Execution3       => next_state <= RTypeCompletion_I;
      when Execution4       => next_state <= RTypeCompletion_I;
      when Execution5       => next_state <= RTypeCompletion_I;
      when Execution6       => next_state <= RTypeCompletion_I;
      when Execution7       => next_state <= RTypeCompletion_I;
      when Execution8       => next_state <= RTypeCompletion_I;
      when Execution9      => next_state <= RTypeCompletion_I;
      when Execution10       => next_state <= RTypeCompletion_I;
      when Execution11       => next_state <= InstructionFetch;
      when Execution12     => next_state <= InstructionFetch;
      when Execution13       => next_state <= InstructionFetch;
      when RTypeCompletion   => next_state <= InstructionFetch;
      when RTypeCompletion_I   => next_state <= InstructionFetch;
      when Mov1   => next_state <= InstructionFetch;
      when Mov2   => next_state <= InstructionFetch;
      when Mov3   => next_state <= InstructionFetch;
      when Xchg   => next_state <= InstructionFetch;
      when Jump   => next_state <= InstructionFetch;
      when Jump1   => next_state <= InstructionFetch;
      when others            => next_state <= InstructionFetch;

    end case;
  end process;

  with current_state select
    ctrl_state <= 
                  "0100100010011101000" when InstructionFetch,
                  "0000000000000001000" when InstructionDecode,
                  "0001100000000000000" when MemoryAddressComp,
                  "1000000000000000100" when Execution,
                  "1000000000011110100" when Execution_I,
                  "1000000000000110100" when Execution2,
                  "1000000000010010100" when Execution3,
                  "1000000000011010100" when Execution4,
                  "1000000000010110100" when Execution5,
                  "1000000000011111100" when Execution6,
                  "1000000000000111100" when Execution7,
                  "1000000000010011100" when Execution8,
                  "1000000000011011100" when Execution9,
                  "1000000000010111100" when Execution10,
                  "1000000000000000100" when Execution12,
                  "1000000000000110100" when Execution11,
                  "1000000000000111100" when Execution13,
                  "0000000000000000010" when RTypeCompletion,
                  "0000000000000000010" when RTypeCompletion_I,
                  "0000001000000000010" when Mov1,
                  "0000001100000000011" when Mov2,
                  "0000000100000000010" when Mov3,
                  "0001010100000000010" when Xchg,
                  "0100100010100000000" when Jump,
                  "0100100011000000000" when Jump1,
                  "0000001000000000010" when MemoryReadCompletionStep,
                  "0000000000000000000" when others;

  RegWrite1   <= ctrl_state(18);
  PCWrite     <= ctrl_state(17);
  PCWriteCond <= ctrl_state(16);
  IorD        <= ctrl_state(15);
  MemRead     <= ctrl_state(14);
  MemWrite    <= ctrl_state(13);
  MemToReg    <= ctrl_state(12 downto 11);
  IRWrite     <= ctrl_state(10);
  PCSource    <= ctrl_state(9 downto 8);
  ALUOp       <= ctrl_state(7 downto 5);
  ALUSrcB     <= ctrl_state(4 downto 3);
  ALUSrcA     <= ctrl_state(2);
  RegWrite    <= ctrl_state(1);
  RegDst      <= ctrl_state(0);

end Behavioral;