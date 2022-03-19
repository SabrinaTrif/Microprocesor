----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/05/2021 05:41:09 PM
-- Design Name: 
-- Module Name: ALUControl - Behavioral
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

entity ALUControl is
Port (ALUOp :in std_logic_vector(2 downto 0);
functie:in std_logic_vector(3 downto 0);
ALUCtrl: out std_logic_vector(2 downto 0) );
end ALUControl;

architecture Behavioral of ALUControl is

begin
process(ALUOp,functie)
begin
case (ALUOp) is 
when "001" =>ALUCtrl<="001";
when "100" =>ALUCtrl<="100";
when "101" =>ALUCtrl<="101";
when "110" =>ALUCtrl<="110";
when "111" =>ALUCtrl<="000";
when "000"=> case (functie) is
             when "0000"=> ALUCtrl<="000";
             when "0001"=> ALUCtrl<="001";
             when "0010"=> ALUCtrl<="010";
             when "0011"=> ALUCtrl<="011";
             when "0100"=> ALUCtrl<="100";
             when "0101"=> ALUCtrl<="101";
             when "0110"=> ALUCtrl<="110";
             when "0111"=> ALUCtrl<="111";
             when "1000"=> ALUCtrl<="001";
             when others => ALUCtrl<="XXX";
             end case;
when others => ALUCtrl<="XXX";
end case;
end process;

end Behavioral;
