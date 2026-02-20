library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registerfile is
port(
    clk : in std_logic;
    reset : in std_logic;
    LE : in std_logic;
    AS : in std_logic_vector(4 downto 0);
    BS : in std_logic_vector(4 downto 0); 
    DS : in std_logic_vector(4 downto 0); 

    A_out : out std_logic_vector(31 downto 0);
    B_out : out std_logic_vector(31 downto 0);

    Ddata : in std_logic_vector(31 downto 0)
);
end registerfile;

architecture arq of registerfile is

    -- 32 registradores de 32 bits
    type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);

    signal registers : reg_array := (others => (others => '0'));

begin

    -- Escrita síncrona

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                registers <= (others => (others => '0'));
            elsif LE = '1' then
                -- Registrador $0 nunca pode ser alterado
                if DS /= "00000" then
                    registers(to_integer(unsigned(DS))) <= Ddata;
                end if;
            end if;
        end if;
    end process;


    -- Leitura combinacional
    -- $0 sempre retorna zero

    A_out <= (others => '0') 
             when AS = "00000"
             else registers(to_integer(unsigned(AS)));

    B_out <= (others => '0') 
             when BS = "00000"
             else registers(to_integer(unsigned(BS)));

end arq;