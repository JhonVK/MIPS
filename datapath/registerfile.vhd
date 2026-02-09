Library IEEE;
USE IEEE.std_logic_1164.all;

Entity registerfile is

port(
	clk: in std_logic;
	reset: in std_logic;
	LE: in std_logic; -- Load enable
	AS, BS: in std_logic_vector(2 downto 0); 
	DS: in std_logic_vector(2 downto 0); -- Destination select
	A_out, B_out: out std_logic_vector(31 downto 0); -- saida
	Ddata: in std_logic_vector(31 downto 0) -- data que sai do MUX D
);

end registerfile;

architecture arq of registerfile is
signal reg_a, reg_b, reg_c, reg_d, reg_e, reg_f, reg_g, reg_h : std_logic_vector(31 downto 0);
begin
	
process(clk)
	begin
		if rising_edge(clk) then
		if reset = '1' then
			reg_a <= (others => '0');
			reg_b <= (others => '0');
			reg_c <= (others => '0');
			reg_d <= (others => '0');
			reg_e <= (others => '0');
			reg_f <= (others => '0');
			reg_g <= (others => '0');
			reg_h <= (others => '0');
		elsif  LE = '1' then
			case DS is
				when "000" => reg_a <= Ddata;
				when "001" => reg_b <= Ddata;
				when "010" => reg_c <= Ddata;
				when "011" => reg_d <= Ddata;
				when "100" => reg_e <= Ddata;
				when "101" => reg_f <= Ddata;
				when "110" => reg_g <= Ddata;
				when "111" => reg_h <= Ddata;
			end case;
		end if;
		end if;
end process;
	
	process(AS, BS, reg_a, reg_b, reg_c, reg_d, reg_e, reg_f, reg_g, reg_h, Ddata)
	begin
		case AS is
			when "000" => A_out <= reg_a;
			when "001" => A_out <= reg_b;
			when "010" => A_out <= reg_c;
			when "011" => A_out <= reg_d;
			when "100" => A_out <= reg_e;
			when "101" => A_out <= reg_f;
			when "110" => A_out <= reg_g;
			when "111" => A_out <= reg_h;
		end case;
		
		case BS is
			when "000" => B_out <= reg_a;
			when "001" => B_out <= reg_b;
			when "010" => B_out <= reg_c;
			when "011" => B_out <= reg_d;
			when "100" => B_out <= reg_e;
			when "101" => B_out <= reg_f;
			when "110" => B_out <= reg_g;
			when "111" => B_out <= reg_h;
		end case;
	end process;
end arq;