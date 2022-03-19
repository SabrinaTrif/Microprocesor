
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux21 is
  port( -- input
        input_1    : in std_logic_vector(2 downto 0);
        input_2    : in std_logic_vector(2 downto 0);
        mux_select : in std_logic;

        -- output
        output     : out std_logic_vector(2 downto 0) );
end Mux21;

architecture Behavioral of Mux21 is
begin
  with mux_select select
    output <= input_1 when '0', input_2 when others;

end Behavioral;