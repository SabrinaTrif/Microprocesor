library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Memory is
  port( -- inputs
        CLK       : in std_logic;
        reset_neg : in std_logic;
        address   : in std_logic_vector(15 downto 0);
        MemWrite  : in std_logic;
        MemRead   : in std_logic;
        WriteData : in std_logic_vector(15 downto 0);

        -- output
        MemData   : out std_logic_vector(15 downto 0) );
end Memory;

architecture Behavioral of Memory is
  type mem_type is array (0 to 63) of std_logic_vector(7 downto 0);
  signal mem: mem_type := (
  0 => "10100001",
  1 => "00000010",--mov r2 2
  2 => "00010001",
  3 => "00000100",--add r2 4
  4 => "10111001",
  5 => "00000001",--xcg r2 addr r2
  6 => "10100001",
  7 => "10000110",--mov r3 addr 1,
  8 => "00011001",
  9 => "10000001",--add r3 addr 1
  30=> "00000000",
  31 => "00000001",
others => "00000000" );
signal c:std_logic :='1';
begin

  process(CLK, reset_neg)
  begin
    --if reset_neg = '0' then
      --mem <= (others => (others=>'0'));
    if rising_edge(CLK) and MemWrite = '1' then
      mem(conv_integer(address)) <= WriteData(15 downto 8);
      mem(conv_integer(address+1)) <= WriteData(7  downto 0);
    end if;
  end process;
  
   process(address)
   begin
   if address="UUUUUUUUUUUUUUUU" then
     MemData<="XXXXXXXXXXXXXXXX";
   elsif MemRead='1' then
    MemData <= mem(conv_integer(address))    &
               mem(conv_integer(address + 1)) ;
   end if;
    end process;

end Behavioral;