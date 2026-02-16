library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ParteControle is
    port (
        opcode     : in  std_logic_vector(5 downto 0);
        RegDst     : out std_logic;
        EscReg     : out std_logic;
        ULAFonte   : out std_logic;
        EscMem     : out std_logic;
        LerMem     : out std_logic;
        MemParaReg : out std_logic;
        Branch     : out std_logic;
        gsel       : out std_logic_vector(3 downto 0)
    );
end ParteControle;

architecture comportamento of ParteControle is
begin
    process(opcode)
    begin
        -- Default: tudo desativado
        RegDst <= '0'; EscReg <= '0'; ULAFonte <= '0'; EscMem <= '0'; 
        LerMem <= '0'; MemParaReg <= '0'; Branch <= '0'; gsel <= "0000";

        case opcode is
            when "000000" => -- Tipo R (ADD/MULT)
                RegDst <= '1'; EscReg <= '1'; gsel <= "0010"; -- Ex: ADD
            when "100011" => -- LW
                ULAFonte <= '1'; MemParaReg <= '1'; EscReg <= '1'; LerMem <= '1';
            when "101011" => -- SW
                ULAFonte <= '1'; EscMem <= '1';
            when "000100" => -- BEQ
                Branch <= '1'; gsel <= "0110"; -- Subtração para comparar
            when others => null;
        end case;
    end process;
end comportamento;



