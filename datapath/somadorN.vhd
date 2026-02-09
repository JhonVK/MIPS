Library IEEE;
USE IEEE.std_logic_1164.all;

Entity somadorN is
Generic (N : integer := 32);
Port(A,B : in std_logic_vector(N-1 downto 0);
     S : out std_logic_vector(N-1 downto 0);
	  Cout : out std_logic);
end somadorN;

architecture Arq of somadorN is

component SC is
Port(A0: in std_logic;
     B0: in std_logic;
	  Cin : in std_logic;
	  S0: out std_logic;
	  Cout: out std_logic);
End component;

signal n_aux : std_logic_vector(N downto 0);

begin
--m: sc port map(A(0),B(0),'0',S(0),n_aux(0));

G1: for i in 0 to N-1 generate
    m: sc port map(A(i),B(i),n_aux(i),S(i),n_aux(i+1));
	 end generate;

n_aux(0) <= '0';
Cout <= n_aux(N);	 
	 
end Arq; 
	  