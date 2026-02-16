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
    DataOut: out std_logic_vector(wlength-1 downto 0)
);
end mem_dados_32;

architecture arq of mem_dados_32 is

type memory_type is array (0 to 2**words -1)
    of std_logic_vector(wlength-1 downto 0);

signal memory : memory_type;

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

-- Leitura assíncrona
DataOut <= memory(to_integer(unsigned(Addr_in))) when LerMem = '1' else (others => '0');

end arq;
