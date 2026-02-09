Library IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
USE IEEE.NUMERIC_STD.ALL;

Entity somadorN_TB is
end somadorN_TB;

architecture Arq of somadorN_TB is

component somadorN is
Generic (N : integer := 8);
Port(A,B : in std_logic_vector(N-1 downto 0);
     S : out std_logic_vector(N-1 downto 0);
	  Cout : out std_logic);
end component;

signal A : std_logic_vector(7 downto 0) := (others => '0');
signal B : std_logic_vector(7 downto 0) := (others => '0');

signal S : std_logic_vector(7 downto 0);
signal Cout : std_logic;


----------------------------------------------------------------------------

-- Funcao de String para STD_LOGIC_VECTOR:
function str_to_stdvec(inp: string) return std_logic_vector is
	variable temp: std_logic_vector(inp'range);
	begin
		for i in inp'range loop
			if (inp(i) = '1') then
					temp(i):= '1';
			elsif(inp(i)='0') then
		      temp(i):= '0';
			end if;
		end loop;
		return temp; 
end function str_to_stdvec;

-- Funcao de STD_LOGIC_VECTOR para string:
function stdvec_to_str(inp: std_logic_vector) return string is
	variable temp: string(inp'left+1 downto 1);
	begin
		for i in inp'reverse_range loop
			if (inp(i) = '1') then
					temp(i+1):= '1';
			elsif(inp(i)='0') then
					temp(i+1):= '0';
			end if;
		end loop;
		return temp; 
end function stdvec_to_str;
----------------------------------------------------------------------------


begin

DUT: somadorN generic map (N => 8) port map(A => A,
                                            B => B,
														  S => S,
														  Cout => Cout);
														  
--P1: process
--    begin
--	      A <= "00000000";
--			  B <= "00000001";
			  
--      		wait for 20 ns;
      				
--		   A <= "00000001";
--  			B <= "00000001";
    			
--    			wait for 20 ns;
			
--		   A <= "00000011";
--    			B <= "00000011";
     
--     		wait for 20 ns;

--		   A <= "10000000";
--    			B <= "10000000";
		
--       wait;
		
--	 end process;	
	 
	 
P2: process

--arquivo de entrada--
file fileType : text;
variable inType : std_logic_vector(15 downto 0);
variable str_type : string(16 downto 1);
variable lineType : line;

--arquivo de saida--
file outfile : text;
variable out1 : std_logic_vector(7 downto 0);
variable str_out1 : string(8 downto 1);
variable outline : line;



begin

  FILE_OPEN(fileType,"entrada.txt",READ_MODE);
	FILE_OPEN(outfile,"saida.txt",WRITE_MODE);
	

	WHILE NOT ENDFILE(fileType) LOOP
	  

		
		readline(fileType,lineType);
		read(lineType,str_type);
		inType := str_to_stdvec(str_type);
		
		
		A <= inType(15 downto 8) after 20 ns;
		B <= inType(7 downto 0) after 20 ns;

				
		out1 := S;
		str_out1 := stdvec_to_str(out1);
		write(outline,str_out1);
		writeline(outfile,outline);
		
		

	END LOOP;
	
	
	wait;
	
end process;

	 
	 
	 
end Arq;
			
