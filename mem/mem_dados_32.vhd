library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity mem_dados_32 is
generic (
    wlength: integer := 32;
    words: integer := 8
);
port(
    clk: in std_logic;
    DataIn: in std_logic_vector(wlength-1 downto 0);
    Addr_in: in std_logic_vector(words-1 downto 0);
    EscMem: in std_logic;
    LerMem: in std_logic; 
    DataOut: out std_logic_vector(wlength-1 downto 0);
	 DataOutMem : out std_logic_vector(wlength-1 downto 0)
);
end mem_dados_32;

architecture arq of mem_dados_32 is

type memory_type is array (0 to 2**words -1)
    of std_logic_vector(wlength-1 downto 0);

-- No arquivo mem_dados_32.vhd
signal memory : memory_type := (
    0 => x"0000000A", -- Valor 10 na posição 0
    4 => x"00000005", -- Valor 5 na posição 4
    others => (others => '0')
);
signal D_out: std_logic_vector(31 downto 0);

begin

-- Escrita síncrona
process(clk)
begin
    if rising_edge(clk) then
        if EscMem = '1' then
            memory(to_integer(unsigned(Addr_in))) <= DataIn;
        end if;
    end if;
end process;

-- Leitura síncrona
process(clk)
begin
    if rising_edge(clk) then
        if LerMem = '1' then
            D_out <= memory(to_integer(unsigned(Addr_in)));
        else
            D_out <= (others => '0');
        end if;
    end if;
end process;

DataOut <= D_out;
DataOutMem <= D_out;


end arq;
