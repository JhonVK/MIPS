library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registerfile is
port(
    clk   : in  std_logic;
    reset : in  std_logic;
    LE    : in  std_logic;  -- Load Enable (RegWrite)

    AS : in std_logic_vector(4 downto 0); -- Read register 1
    BS : in std_logic_vector(4 downto 0); -- Read register 2
    DS : in std_logic_vector(4 downto 0); -- Write register

    A_out : out std_logic_vector(31 downto 0);
    B_out : out std_logic_vector(31 downto 0);

    Ddata : in std_logic_vector(31 downto 0) -- Write data
);
end registerfile;

architecture arq of registerfile is

-- Array com 32 registradores de 32 bits
type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
signal registers : reg_array;

begin

-- Escrita síncrona
process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            registers <= (others => (others => '0'));
        elsif LE = '1' then
            -- No MIPS real, registrador 0 é sempre zero
            if DS /= "00000" then
                registers(to_integer(unsigned(DS))) <= Ddata;
            end if;
        end if;
    end if;
end process;

-- Leitura combinacional
A_out <= registers(to_integer(unsigned(AS)));
B_out <= registers(to_integer(unsigned(BS)));

end arq;
