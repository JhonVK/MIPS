library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPS_Top_Level is
    port (
        clk, reset : in std_logic
    );
end MIPS_Top_Level;

architecture shell of MIPS_Top_Level is
    -- Sinais de união entre Controle e Operativa
    signal s_opcode, s_funct : std_logic_vector(5 downto 0);
    signal s_RegDst, s_EscReg, s_ULAFonte, s_EscMem, s_LerMem, s_MemParaReg, s_Branch : std_logic;
    signal s_gsel : std_logic_vector(3 downto 0);
begin

    CONTROLE: entity work.ParteControle
    port map (
        opcode => s_opcode,
        funct  => s_funct,
        RegDst => s_RegDst,
        EscReg => s_EscReg,
        ULAFonte => s_ULAFonte,
        EscMem => s_EscMem,
        LerMem => s_LerMem,
        MemParaReg => s_MemParaReg,
        Branch => s_Branch,
        gsel => s_gsel
    );

    OPERATIVA: entity work.ParteOperativa
        port map (
            clk => clk, reset => reset,
            LE => s_EscReg, RegDst => s_RegDst,
            HS => "00", MF => '0', MD => s_MemParaReg, MB => s_ULAFonte,
            gsel => s_gsel, EscMem => s_EscMem, LerMem => s_LerMem,
            Branch => s_Branch, opcode => s_opcode, funct => s_funct
        );

end shell;