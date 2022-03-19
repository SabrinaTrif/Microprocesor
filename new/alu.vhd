library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
  Port (s : in STD_LOGIC_VECTOR (15 downto 0);
 s1 : in STD_LOGIC_VECTOR (15 downto 0);
 ALUOp : in std_logic_vector(2 downto 0);
 ALUOut: out std_logic_vector(15 downto 0);
 regout:out std_logic_vector(2 downto 0));
end alu;

architecture Behavioral of alu is
signal aluo:std_logic_vector(15 downto 0);
begin
process(ALUOp,s,s1)
begin
case (ALUOp) is
when "000"=>aluo<=s+s1;
when "001"=>aluo<=s-s1;
when "100"=>aluo<=s and s1;
when "110"=>aluo<=s xor s1;
when "101"=>aluo<=s or s1;
when "011"=>aluo<=s -1;
when "010"=>aluo<=s +1;
when "111"=>aluo<= not s;
when others=>aluo<="XXXXXXXXXXXXXXXX";         
end case;   
end process;

ALUOut<=aluo;

regout(0)<='1' when aluo<= "00000000000000000000000000000000" else '0';  --zero
regout(1)<='1' when aluo(0)<='0' else '0'; --parity
regout(2)<='1' when signed(aluo)< 0 else '0';--sign
end Behavioral;