library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mem_32 is
    generic (wlength : integer := 32;
             words : integer := 8); -- Endereço de 8 bits (256 posições)
    port(
        Addr_in: in std_logic_vector(words -1 downto 0);
        DataOut : out std_logic_vector(wlength -1 downto 0)
    );
end mem_32;

architecture arq of mem_32 is

    type memory_type is array (0 to 2**words -1) of std_logic_vector(wlength -1 downto 0);

    signal memory : memory_type := (
        -- 0: LW $1, 0($0)  -> Lê da MemDados[0] e salva em $1
        -- Hex: 8C010000
        0 => x"8C010000", 
    
        -- 1: LW $2, 4($0)  -> Lê da MemDados[4] e salva em $2
        -- Hex: 8C020004
        1 => x"8C020004",
    
        -- 2: ADD $3, $1, $2 -> $3 = $1 + $2
        -- Opcode 0 (R-Type), funct 32 (ADD). rd=$3
        -- Hex: 00221820
        2 => x"00221820",
        
        -- 3: MULT $4, $1, $2 -> $4 = $1 * $2 (Usando seu hardware customizado)
        -- Opcode 0 (R-Type), funct 24 (MULT custom). rd=$4
        -- Hex: 00222018
        3 => x"00222018",
    
        -- 4: SW $3, 8($0) -> Escreve o valor de $3 na MemDados[8]
        -- Opcode 43 (SW)
        -- Hex: AC030008
        4 => x"AC030008",

        -- 5: BEQ $1, $2, 1 -> Se $1 == $2, pula 1 instrução (PC+4+4). 
        -- Como 10 != 5, NÃO deve pular.
        -- Hex: 10220001
        5 => x"10220001",
        
        -- 6: BEQ $0, $0, -1 -> Loop infinito (PC = PC - 4 + 4)
        -- Trava o processador aqui para terminar o teste
        -- Hex: 1000FFFF
        6 => x"00000000",
    
        others => (others => '0') -- NOPs no resto da memória
    );

begin

    -- Conversão do endereço de entrada para inteiro
    DataOut <= memory(to_integer(unsigned(Addr_in))); 

end arq;