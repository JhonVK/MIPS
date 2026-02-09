Library IEEE;
USE IEEE.std_logic_1164.all;

Entity SC is
Port(A0: in std_logic;
     B0: in std_logic;
	  Cin : in std_logic;
	  S0: out std_logic;
	  Cout: out std_logic);
End SC;

architecture Arq of SC is
signal aux,sab,scin_a,scin_b : std_logic;

begin

aux <= A0 xor B0;
S0 <= aux xor Cin;

sab <= A0 and B0;
scin_a <= A0 and Cin;
scin_b <= B0 and Cin;
Cout <= sab or scin_a or scin_b;


--Cout <=(A0 and B0) or (A0 and Cin) or (B0 and Cin);

End Arq; 