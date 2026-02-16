Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity soma16b is
Port(a, b : in std_logic_vector(15 downto 0);
	  s: out std_logic_vector(15 downto 0);
	  cout : out std_logic
);

End soma16b;


architecture arq of soma16b is
signal aux_a, aux_b, aux_s : std_logic_vector(16 downto 0);

begin
aux_a <= '0' & a;
aux_b <= '0' & b;

aux_s <= aux_a + aux_b;--somador de 17 bits
s <= aux_s(15 downto 0);--soma de 16 bits
cout <= aux_s(16);--carry out

end arq;