library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_32 is
    generic (wlength : integer := 32;
             words   : integer := 8);
    port(
        Addr_in : in  std_logic_vector(words-1 downto 0);
        DataOut : out std_logic_vector(wlength-1 downto 0)
    );
end mem_32;

architecture arq of mem_32 is

    type memory_type is array (0 to 2**words-1) of std_logic_vector(wlength-1 downto 0);

    -- ============================================================
    -- WORD-ADDRESSED: indice direto, sem *4
    -- RAM[0]=10, RAM[1]=5
    --
    -- O QUE VER NO WAVEFORM (registers):
    --   registers(1)  = 0x0000000A  (10)   LW RAM[0]
    --   registers(2)  = 0x00000005  (5)    LW RAM[1]
    --   registers(3)  = 0x0000000F  (15)   ADD 10+5
    --   registers(4)  = 0x00000005  (5)    SUB 10-5
    --   registers(5)  = 0xFFFFFFFB  (-5)   SUB 5-10
    --   registers(6)  = 0x00000000  (0)    AND 1010 AND 0101
    --   registers(7)  = 0x0000000F  (15)   OR  1010 OR  0101
    --   registers(8)  = 0x0000000F  (15)   XOR 1010 XOR 0101
    --   registers(9)  = 0x00000032  (50)   MULT 10*5
    --   registers(10) = 0x00000032  (50)   MULT 10*5 (confirma)
    --   registers(11) = 0x00000032  (50)   LW RAM[2]=50 (confirma SW)
    --
    -- O QUE VER NA MEMORIA (Memory List):
    --   RAM[0]  = 10   (dado inicial)
    --   RAM[1]  = 5    (dado inicial)
    --   RAM[2]  = 50   SW $9  -> sempre executa
    --   RAM[3]  = 15   SW $3  -> sempre executa
    --   RAM[4]  = 15   SW $3  -> referencia antes dos BEQs, sempre executa
    --   RAM[5]  = 5    SW $4  -> BEQ nao tomado: APARECE  ✓
    --   RAM[6]  = 0    SW $5  -> BEQ tomado:    NAO APARECE ✓
    --   RAM[7]  = 0    SW $7  -> J funcionou:   NAO APARECE ✓
    --     (se RAM[7]=15, o J falhou!)
    --
    -- ALU_result nos ciclos chave:
    --   PC=2  ADD      -> ALU_result = 0x0000000F
    --   PC=3  SUB      -> ALU_result = 0x00000005
    --   PC=4  SUB      -> ALU_result = 0xFFFFFFFB
    --   PC=8  MULT     -> ALU_result = 0x00000032
    --   PC=13 BEQ ntom -> ALU_result = 0x00000005 (!=0, nao salta)
    --   PC=15 BEQ tom  -> ALU_result = 0x00000000 (==0, salta)
    -- ============================================================

    signal memory : memory_type := (

        -- 0: LW $1, 0($0)   -> $1 = RAM[0] = 10
        -- 100011 00000 00001 0000000000000000
        0 => x"8C010000",

        -- 1: LW $2, 1($0)   -> $2 = RAM[1] = 5
        -- 100011 00000 00010 0000000000000001
        1 => x"8C020001",

        -- 2: ADD $3, $1, $2  -> $3 = 15
        -- 000000 00001 00010 00011 00000 100000
        2 => x"00221820",

        -- 3: SUB $4, $1, $2  -> $4 = 5
        -- 000000 00001 00010 00100 00000 100010
        3 => x"00222022",

        -- 4: SUB $5, $2, $1  -> $5 = -5 (0xFFFFFFFB)
        -- 000000 00010 00001 00101 00000 100010
        4 => x"00412822",

        -- 5: AND $6, $1, $2  -> $6 = 0
        -- 000000 00001 00010 00110 00000 100100
        5 => x"00223024",

        -- 6: OR $7, $1, $2   -> $7 = 15
        -- 000000 00001 00010 00111 00000 100101
        6 => x"00223825",

        -- 7: XOR $8, $1, $2  -> $8 = 15
        -- 000000 00001 00010 01000 00000 100110
        7 => x"00224026",

        -- 8: MULT $9, $1, $2  -> $9 = 10*5 = 50 (0x00000032)
        -- funct=011000 -> gsel=0000 -> matricial
        -- 000000 00001 00010 01001 00000 011000
        8 => x"00224818",

        -- 9: MULT $10, $1, $2  -> $10 = 50 (confirma)
        -- 000000 00001 00010 01010 00000 011000
        9 => x"00225018",

        -- 10: SW $9, 2($0)   -> RAM[2] = 50
        -- 101011 00000 01001 0000000000000010
        10 => x"AC090002",

        -- 11: SW $3, 3($0)  -> RAM[3] = 15
        -- 101011 00000 00011 0000000000000011
        11 => x"AC030003",

        -- 12: SW $3, 4($0)  -> RAM[4] = 15
        --   Referencia: sempre executa antes dos BEQs
        -- 101011 00000 00011 0000000000000100
        12 => x"AC030004",

        -- 13: BEQ $1, $2, 1  -> 10!=5, NAO salta -> PC=14
        -- ALU_result = 10-5 = 5 (!=0)
        -- 000100 00001 00010 0000000000000001
        13 => x"10220001",

        -- 14: SW $4, 5($0)  -> RAM[5] = 5
        --   So executa se BEQ acima NAO foi tomado
        --   RAM[5]=5  -> correto ✓  |  RAM[5]=0 -> BEQ saltou errado!
        -- 101011 00000 00100 0000000000000101
        14 => x"AC040005",

        -- 15: BEQ $9, $10, 1  -> 50==50, SALTA -> PC=17 (pula 16)
        -- ALU_result = 0 (==0, confirma tomado)
        -- 000100 01001 01010 0000000000000001
        15 => x"112A0001",

        -- 16: SW $5, 6($0)  -> RAM[6] = -5
        --   NAO deve executar (pulado pelo BEQ acima)
        --   RAM[6]=0  -> correto ✓  |  RAM[6]!=0 -> BEQ nao saltou, erro!
        -- 101011 00000 00101 0000000000000110
        16 => x"AC050006",

        -- 17: J 19  -> salta para PC=19 (pula instrucao 18)
        -- opcode=000010, target=19 (0x13)
        -- 000010 00000000000000000000010011
        17 => x"08000013",

        -- 18: SW $7, 7($0)  -> RAM[7] = 15 ($7=15)
        --   NAO deve executar (pulado pelo J acima)
        --   RAM[7]=0  -> J funcionou ✓  |  RAM[7]=15 -> J falhou!
        -- 101011 00000 00111 0000000000000111
        18 => x"AC070007",

        -- 19: LW $11, 2($0)  -> $11 = RAM[2] = 50 (confirma SW da instrucao 10)
        -- 100011 00000 01011 0000000000000010
        19 => x"8C0B0002",

        -- 20: BEQ $0,$0,-2  -> loop infinito -> PC=19
        -- 000100 00000 00000 1111111111111110
        20 => x"1000FFFE",

        others => (others => '0')
    );

begin

    DataOut <= memory(to_integer(unsigned(Addr_in)));

end arq;