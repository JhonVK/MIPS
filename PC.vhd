Library IEEE;
USE IEEE.std_logic_1164.all;

Entity PC is
Port(RegDst: in std_logic;
     EscReg: in std_logic;
	  ULAFonte: in std_logic;
	  FontePC: in std_logic;
	  EscMem: in std_logic;
	  LerMem: in std_logic;
	  MemParaReg: in std_logic;
	  Controle_ULA: in std_logic_vector(3 downto 0)   
	  );
End PC;

architecture Arq of PC is

begin




End Arq; 