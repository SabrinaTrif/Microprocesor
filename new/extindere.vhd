----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/05/2021 05:56:21 PM
-- Design Name: 
-- Module Name: extindere - Behavioral
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

entity extindere is
Port (-- input
        input  : in std_logic_vector(6 downto 0);

        -- output
        output : out std_logic_vector(15 downto 0) );
end extindere;

architecture Behavioral of extindere is

begin
output <= "000000000" & input when (input(6) = '0') else
           "111111111" & input;


end Behavioral;
