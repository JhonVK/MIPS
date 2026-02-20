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
		  Jump 		 : out std_logic;
        gsel       : out std_logic_vector(3 downto 0)
    );
end ParteControle;

architecture comportamento of ParteControle is
begin

    process(opcode, funct)
    begin

        RegDst     <= '0';
        EscReg     <= '0';
        ULAFonte   <= '0';
        EscMem     <= '0';
        LerMem     <= '0';
        MemParaReg <= '0';
        Branch     <= '0';
		  Jump 		 <= '0';
        gsel       <= "0000";

        case opcode is

            -- TIPO R
            when "000000" =>
                RegDst <= '1';
                EscReg <= '1';

                case funct is

                    when "101001" => gsel <= "0000"; -- MOVE A
                    when "101010" => gsel <= "0001"; -- MOVE B
                    when "100000" => gsel <= "0010"; -- ADD (A + B)
                    when "100001" => gsel <= "0011"; -- INC (A + 1)
                    when "100010" => gsel <= "0100"; -- SUB (A - B)
                    when "111001" => gsel <= "0101"; -- A + 2
                    when "111010" => gsel <= "0110"; -- A + (not B)
                    when "111011" => gsel <= "0111"; -- A - (not B)
                    when "100100" => gsel <= "1000"; -- AND (A and B)
                    when "100101" => gsel <= "1001"; -- OR (A or B)
                    when "100110" => gsel <= "1010"; -- XOR (A xor B)
                    when "100111" => gsel <= "1011"; -- NOT A
                    when "111100" => gsel <= "1100"; -- NOT B
                    when "111101" => gsel <= "1101"; -- A or (not B)
                    when "111110" => gsel <= "1110"; -- A and (not B)
                    when "011000" => gsel <= "1111"; -- A x B (MULT)

                    when others   => gsel <= "0000";
                end case;


            -- LW  (opcode = 100011)

            when "100011" =>
                ULAFonte   <= '1';
                MemParaReg <= '1';
                EscReg     <= '1';
                LerMem     <= '1';
                gsel       <= "0010";  -- ADD para calcular endereço


            -- SW  (opcode = 101011)

            when "101011" =>
                ULAFonte <= '1';
                EscMem   <= '1';
                gsel     <= "0010";  -- ADD para calcular endereço


					 -- BEQ (opcode = 000100)

            when "000100" =>
                Branch <= '1';
                gsel   <= "0100";
				
				
				when "000010" => Jump <= '1';

            when others =>
                null;

        end case;

    end process;

end comportamento;