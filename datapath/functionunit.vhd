Library IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity functionunit is
port(
    A, B  : in  std_logic_vector(31 downto 0);
    HS    : in  std_logic_vector(1 downto 0);
    MF    : in  std_logic;
    S     : out std_logic_vector(31 downto 0);
    gsel  : in  std_logic_vector(3 downto 0);
    Cout  : out std_logic
);
end functionunit;

architecture arq of functionunit is

signal S_ULA, S_SHIFT, S_SOMA, B_SOMADOR, MULT_OUT : std_logic_vector(31 downto 0);

component somadorN is
Generic (N : integer := 32);
Port(A, B  : in  std_logic_vector(N-1 downto 0);
     S     : out std_logic_vector(N-1 downto 0);
     Cout  : out std_logic);
end component;

-- Multiplicador matricial 16x16 -> 32 bits
component matricial is
Port(a, b : in  std_logic_vector(15 downto 0);
     p    : out std_logic_vector(31 downto 0));
end component;

begin

    somadorN_inst: somadorN
    port map(
        A    => A,
        B    => B_SOMADOR,
        S    => S_SOMA,
        Cout => Cout
    );

    -- Multiplicador sempre conectado, usa 16 bits baixos de A e B
    -- Ex: A=10 (0x0000000A), B=5 (0x00000005) -> p = 50 (0x00000032)
    matricial_inst: matricial
    port map(
        a => A(15 downto 0),
        b => B(15 downto 0),
        p => MULT_OUT
    );

    -- ALU principal
    process(A, B, gsel, S_SOMA, MULT_OUT)
    begin
        B_SOMADOR <= (others => '0');

        case gsel is

            -- gsel=0000: MULT $rd, $rs, $rt
            --   Resultado = A(15:0) * B(15:0), 32 bits
            --   Ex: 10 * 5 = 50 (0x00000032)
            when "0000" =>
                S_ULA <= A;

            when "0001" =>
                B_SOMADOR <= B;
                S_ULA <= B;

            -- gsel=0010: ADD  A + B
            when "0010" =>
                B_SOMADOR <= B;
                S_ULA <= S_SOMA;

            -- gsel=0011: A + 1
            when "0011" =>
                B_SOMADOR <= (31 downto 1 => '0') & '1';
                S_ULA <= S_SOMA;

            -- gsel=0100: SUB  A - B  (A + (-B))
            when "0100" =>
                B_SOMADOR <= std_logic_vector(-signed(B));
                S_ULA <= S_SOMA;

            when "0101" =>
                B_SOMADOR <= (31 downto 2 => '0') & "10";
                S_ULA <= S_SOMA;

            when "0110" =>
                B_SOMADOR <= NOT(B);
                S_ULA <= S_SOMA;

            when "0111" =>
                B_SOMADOR <= NOT(std_logic_vector(-signed(B)));
                S_ULA <= S_SOMA;

            -- gsel=1000: AND
            when "1000" => S_ULA <= A AND B;

            -- gsel=1001: OR
            when "1001" => S_ULA <= A OR B;

            -- gsel=1010: XOR
            when "1010" => S_ULA <= A XOR B;

            when "1011" => S_ULA <= NOT A;
            when "1100" => S_ULA <= NOT B;
            when "1101" => S_ULA <= A OR  (NOT B);
            when "1110" => S_ULA <= A AND (NOT B);
            when "1111" => S_ULA <= MULT_OUT;

            when others => S_ULA <= (others => '0');

        end case;
    end process;

    process(HS, B)
    begin
        case HS is
            when "01"   => S_SHIFT <= B(30 downto 0) & "0";
            when "10"   => S_SHIFT <= "0" & B(31 downto 1);
            when others => S_SHIFT <= B;
        end case;
    end process;

    S <= S_ULA when MF = '0' else S_SHIFT;

end arq;