library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ParteControle is
    port (
        opcode     : in  std_logic_vector(5 downto 0);
        funct      : in  std_logic_vector(5 downto 0);

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

    process(opcode, funct)
    begin

        -- Valores padrão
        RegDst     <= '0';
        EscReg     <= '0';
        ULAFonte   <= '0';
        EscMem     <= '0';
        LerMem     <= '0';
        MemParaReg <= '0';
        Branch     <= '0';
        gsel       <= "0000";

        case opcode is

            -- ==============================
            -- TIPO R
            -- ==============================
            when "000000" =>
                RegDst <= '1';
                EscReg <= '1';

                case funct is

                    -- ADD  (funct = 100000)
                    when "100000" =>
                        gsel <= "0010";  -- A + B

                    -- BUG 3 CORRIGIDO: SUB usava "0110" = A + NOT(B) = A-B-1
                    -- Agora usa "0100" = A + (-B) = A - B (correto)
                    when "100010" =>
                        gsel <= "0100";  -- A + (-B) = A - B

                    -- AND (funct = 100100)
                    when "100100" =>
                        gsel <= "1000";

                    -- OR  (funct = 100101)
                    when "100101" =>
                        gsel <= "1001";

                    -- XOR (funct = 100110)
                    when "100110" =>
                        gsel <= "1010";

                    when others =>
                        gsel <= "0000";

                end case;


            -- ==============================
            -- LW  (opcode = 100011)
            -- ==============================
            when "100011" =>
                ULAFonte   <= '1';
                MemParaReg <= '1';
                EscReg     <= '1';
                LerMem     <= '1';
                gsel       <= "0010";  -- ADD para calcular endereço


            -- ==============================
            -- SW  (opcode = 101011)
            -- ==============================
            when "101011" =>
                ULAFonte <= '1';
                EscMem   <= '1';
                gsel     <= "0010";  -- ADD para calcular endereço


            -- ==============================
            -- BEQ (opcode = 000100)
            -- ==============================
            when "000100" =>
                Branch <= '1';
                -- BUG 3 CORRIGIDO: era "0110" = A-B-1, BEQ nunca detectava igualdade
                -- Agora usa "0100" = A-B, resultado é 0 quando A == B (correto)
                gsel   <= "0100";


            when others =>
                null;

        end case;

    end process;

end comportamento;