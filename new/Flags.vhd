----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/09/2022 05:20:08 PM
-- Design Name: 
-- Module Name: Flags - Behavioral
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

entity Flags is
Port (regout:in std_logic_vector(2 downto 0);
RegWrite1:in std_logic;
clk:in std_logic;
flagout:out std_logic_vector(2 downto 0) );
end Flags;

architecture Behavioral of Flags is

begin

  process(clk, RegWrite1)
  begin
    if rising_edge(CLK) and RegWrite1='1'then
      flagout<=regout;
    end if;
  end process;

end Behavioral;
