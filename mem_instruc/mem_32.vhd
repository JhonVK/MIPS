library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mem_32 is
	generic (wlength : integer := 32;
				words : integer := 8);
port(
	Addr_in: in std_logic_vector(words -1 downto 0);
	DataOut : out std_logic_vector(wlength -1 downto 0)
);
end mem_32;

architecture arq of mem_32 is

type memory_type is array (2**words -1 downto 0) of std_logic_vector(wlength -1 downto 0);

signal memory : memory_type := (
    0 => x"012A4020",
    1 => x"8D090004",
    others => (others => '0')
);

begin

DataOut <= memory(to_integer(unsigned(Addr_in))) after 1 ns;

end arq;