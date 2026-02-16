Library IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity datapath is

port(
	clk: in std_logic; --clock dos process que usam
	reset: in std_logic;-- reset
	LE: in std_logic; -- Load enable
	AS, BS: in std_logic_vector(4 downto 0);  -- Aselect e Bselect
	DS: in std_logic_vector(4 downto 0); -- Destination select
	HS: in std_logic_vector(1 downto 0); -- Controla o shifter
	MF: in std_logic;-- Controla quem vai ser a saida do mux
	MD: in std_logic; -- Controla se é data in ou funcunit
	MB: in std_logic; -- Controla se é constantin ou funcunit
	S: out std_logic_vector(31 downto 0); --Saida
	Datain: in std_logic_vector(31 downto 0); -- constante entrada
	constantin: in std_logic_vector(31 downto 0); -- constante entrada
	gsel : in std_logic_vector(3 downto 0); --Seletor de função
	Cout : out std_logic --Carry out
);

end datapath;

architecture arq of datapath is

signal BUS_B, BUS_D, A_OUT, B_OUT, S_OUT: std_logic_vector(31 downto 0);


component functionunit is
port(
	A, B : in std_logic_vector(31 downto 0); --Entrada A e B
	HS: in std_logic_vector(1 downto 0); -- Controla o shifter
	MF: in std_logic;-- Controla quem vai ser a saida do mux
	S: out std_logic_vector(31 downto 0); --Saida
	gsel : in std_logic_vector(3 downto 0); --Seletor de função
	Cout : out std_logic --Carry out
);
end component;

component registerfile is
port(
	clk: in std_logic;
	reset: in std_logic;
	LE: in std_logic; -- Load enable
	AS, BS: in std_logic_vector(4 downto 0); 
	DS: in std_logic_vector(4 downto 0); -- Destination select
	A_out, B_out: out std_logic_vector(31 downto 0); -- saida
	Ddata: in std_logic_vector(31 downto 0) -- data que sai do MUX D
);
end component;

begin
		
		registerfile_inst: registerfile
		port map(
				clk => clk,
				reset => reset,
				LE => LE,
				AS => AS,
				BS => BS,
				DS => DS,
				A_out => A_OUT,
				B_out => B_OUT,
				Ddata => BUS_D
		);
		
		functionunit_inst: functionunit
		port map(
				A => A_OUT,
				B => BUS_B,
				S => S_OUT,
				HS => HS,
				MF => MF,
				gsel => gsel,
				Cout => Cout
		);
		
	BUS_D <= S_OUT	 when MD = '0' else Datain;

	BUS_B <= B_OUT when MB = '0' else constantin;
	
	S <= BUS_D;
	

			 
end arq;