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
    -- RAM inicial: RAM[0]=10, RAM[4]=5
    --
    -- ENCODING MULT: opcode=000000, funct=011000
    --   MULT $rd, $rs, $rt
    --   000000 | rs(5) | rt(5) | rd(5) | 00000 | 011000
    --
    -- O QUE VER NO WAVEFORM:
    --   registers(1)  = 0x0000000A  (10)      LW
    --   registers(2)  = 0x00000005  (5)       LW
    --   registers(3)  = 0x0000000F  (15)      ADD 10+5
    --   registers(4)  = 0x00000005  (5)       SUB 10-5
    --   registers(5)  = 0xFFFFFFFB  (-5)      SUB 5-10
    --   registers(6)  = 0x00000000  (0)       AND 1010 AND 0101
    --   registers(7)  = 0x0000000F  (15)      OR  1010 OR  0101
    --   registers(8)  = 0x0000000F  (15)      XOR 1010 XOR 0101
    --   registers(9)  = 0x00000032  (50)      MULT 10*5
    --   registers(10) = 0x00000032  (50)      MULT 10*5 (confirma)
    --   registers(11) = 0x00000032  (50)      LW RAM[8]=50 (confirma SW)
    --   registers(12) = 0x00000000  (0)       NAO muda (pulado pelo BEQ)
    --
    -- ALU_result nos ciclos chave:
    --   PC=2  ADD  -> ALU_result = 0x0000000F
    --   PC=3  SUB  -> ALU_result = 0x00000005
    --   PC=4  SUB  -> ALU_result = 0xFFFFFFFB
    --   PC=8  MULT -> ALU_result = 0x00000032  <-- multiplicador na ALU!
    --   PC=12 BEQ  -> ALU_result = 0x00000005 (!=0, nao salta)
    --   PC=13 BEQ  -> ALU_result = 0x00000000 (==0, salta para 15)
    -- ============================================================

    signal memory : memory_type := (

        -- 0: LW $1, 0($0)   -> $1 = 10
        0 => x"8C010000",

        -- 1: LW $2, 4($0)   -> $2 = 5
        1 => x"8C020004",

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

        -- 8: MULT $9, $1, $2  -> $9 = 10 * 5 = 50 (0x00000032)
        -- funct=011000 -> gsel=0000 -> functionunit usa matricial
        -- 000000 00001 00010 01001 00000 011000
        8 => x"00224818",

        -- 9: MULT $10, $1, $2  -> $10 = 50 (confirma)
        -- 000000 00001 00010 01010 00000 011000
        9 => x"00225018",

        -- 10: SW $9, 8($0)   -> RAM[8] = 50
        -- 101011 00000 01001 0000000000001000
        10 => x"AC090008",

        -- 11: SW $3, 12($0)  -> RAM[12] = 15
        -- 101011 00000 00011 0000000000001100
        11 => x"AC03000C",

        -- 12: BEQ $1, $2, 2  -> 10 != 5, NAO salta -> PC=13
        -- 000100 00001 00010 0000000000000010
        12 => x"10220002",

        -- 13: BEQ $9, $10, 1 -> 50 == 50, SALTA -> PC=15
        -- 000100 01001 01010 0000000000000001
        13 => x"112A0001",

        -- 14: ADD $12,$0,$0  -> NAO executa (pulado)
        --   Se registers(12) != 0 no waveform, BEQ falhou!
        -- 000000 00000 00000 01100 00000 100000
        14 => x"00006020",

        -- 15: LW $11, 8($0)  -> $11 = RAM[8] = 50 (confirma SW)
        -- 100011 00000 01011 0000000000001000
        15 => x"8C0B0008",

        -- 16: BEQ $0,$0,-2   -> loop infinito voltando para PC=15
        -- 000100 00000 00000 1111111111111110
        16 => x"1000FFFE",

        others => (others => '0')
    );

begin

    DataOut <= memory(to_integer(unsigned(Addr_in)));

end arq;