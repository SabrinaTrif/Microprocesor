library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registers is
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
end Registers;

architecture Behavioral of Registers is
  type   registers_type is array (0 to 7) of std_logic_vector(15 downto 0);
  signal reg : registers_type := (
   0 => "0000000000000001",
   1 => "0000000000000001",
   2 => "0000000000000010",
   3 => "0000000000000011",
   4 => "0000000000000100",
   5 => "0000000000000101",
  others => (others => '0'));

begin

  process(CLK)
  begin
    if reset_neg = '0' then -- reset
      reg(to_integer(unsigned(write_reg))) <= (others => '0');
      else if rising_edge(CLK) and RegWrite = '1' then
        reg(to_integer(unsigned(write_reg))) <= write_data;
      end if;
    end if;
  end process;

  register_1 <= reg(to_integer(unsigned(address_in_1)));  -- read in address 1
  register_2 <= reg(to_integer(unsigned(address_in_2)));  -- read in address 2

end Behavioral;