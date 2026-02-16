Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity matricial is
Port(a, b : in std_logic_vector(15 downto 0);
	  p: out std_logic_vector(31 downto 0)
);

End matricial;

architecture arq of matricial is
type matriz is array(15 downto 0) of std_logic_vector(15 downto 0);
signal pp : matriz;

type somas is array(14 downto 0) of std_logic_vector(15 downto 0);
signal soma: somas;

signal c : std_logic_vector(14 downto 0);
signal soma_0: std_logic_vector(7 downto 0);
signal saida: std_logic_vector(31 downto 0);

Component soma16b is
Port(a, b : in std_logic_vector(15 downto 0);
	  s: out std_logic_vector(15 downto 0);
	  cout : out std_logic
);

End Component;

begin

-- gerador dos produtos parciais
G0: for i in 0 to 15 generate
	G1:	for j in 0 to 15 generate
				pp(i)(j) <= a(i) and b(j);
			end generate;
	end generate;

S0: soma16b port map(a => '0' & pp(0)(15 downto 1),
						  b => pp(1),
						  s => soma(0),
						  cout => c(0));
				
	
gen_somas: for i in 2 to 15 generate
				soma_i: soma16b 
						port map(
							 a => c(i-2) & soma(i-2)(15 downto 1),
							 b => pp(i),
							 s => soma(i-1),
						    cout => c(i-1)
						);
			  end generate;
saida(0) <= pp(0)(0);
saida(1) <= soma(0)(0);
saida(2) <= soma(1)(0);
saida(3) <= soma(2)(0);
saida(4) <= soma(3)(0);
saida(5) <= soma(4)(0);
saida(6) <= soma(5)(0);
saida(7) <= soma(6)(0);
saida(8) <= soma(7)(0);
saida(9) <= soma(8)(0);
saida(10) <= soma(9)(0);
saida(11) <= soma(10)(0);
saida(12) <= soma(11)(0);
saida(13) <= soma(12)(0);
saida(14) <= soma(13)(0);
saida(15) <= soma(14)(0);

saida(30 downto 16) <= soma(14)(15 downto 1);
saida(31) <= c(14);

p <= saida;
end arq;