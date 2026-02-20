library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ParteOperativa is
    port (
        clk, reset  : in std_logic;
        LE          : in std_logic;
        RegDst      : in std_logic;
        HS          : in std_logic_vector(1 downto 0);
        MF          : in std_logic;
		  Jump 		  : in std_logic;
        MD          : in std_logic;
        MB          : in std_logic;
        gsel        : in std_logic_vector(3 downto 0);
        EscMem      : in std_logic;
        LerMem      : in std_logic;
        Branch      : in std_logic;
        opcode      : out std_logic_vector(5 downto 0);
        funct       : out std_logic_vector(5 downto 0)
    );
end ParteOperativa;

architecture arq of ParteOperativa is

signal PC_reg      : unsigned(7 downto 0) := (others => '0');
signal instrucao   : std_logic_vector(31 downto 0);
signal imm_ext     : std_logic_vector(31 downto 0);
signal mux_DS      : std_logic_vector(4 downto 0);
signal ALU_result  : std_logic_vector(31 downto 0); -- saída PURA da ALU (BUG 1)
signal RAM_out     : std_logic_vector(31 downto 0);
signal B_OUT_int   : std_logic_vector(31 downto 0);

begin

process(clk, reset)
begin
    if reset = '1' then
        PC_reg <= (others => '0');

    elsif rising_edge(clk) then

        --   agora usa instrucao(15 downto 0) completo, redimensionado para 8 bits com sinal
        if Jump = '1' then
			 PC_reg <= unsigned(instrucao(7 downto 0));  -- endereço absoluto
			elsif (Branch = '1' and ALU_result = x"00000000") then
				 PC_reg <= PC_reg + 1 + unsigned(resize(signed(instrucao(15 downto 0)), 8));
			else
				 PC_reg <= PC_reg + 1;
			end if;

    end if;
end process;

-- ROM

ROM_INST: entity work.mem_32
    port map (
        Addr_in => std_logic_vector(PC_reg),
        DataOut => instrucao
    );


-- Decodificação

opcode <= instrucao(31 downto 26);
funct  <= instrucao(5 downto 0);

-- Extensão de sinal do imediato

imm_ext <= std_logic_vector(resize(signed(instrucao(15 downto 0)), 32));


-- MUX RegDst: escolhe registrador destino

mux_DS <= instrucao(20 downto 16)
          when RegDst = '0'
          else instrucao(15 downto 11);


-- DATAPATH

DP_INST: entity work.datapath
    port map (
        clk => clk,
        reset => reset,
        LE => LE,
        AS => instrucao(25 downto 21),
        BS => instrucao(20 downto 16),
        DS => mux_DS,
        HS => HS,
        MF => MF,
        MD => MD,
        MB => MB,
        S => open,          -- verificar depois
        ALU_result => ALU_result, 
        Datain => RAM_out,
        constantin => imm_ext,
        gsel => gsel,
        Cout => open,
        OUT_B => B_OUT_int
    );

-- RAM

RAM_INST: entity work.mem_dados_32
    port map (
        clk => clk,
        EscMem => EscMem,
        LerMem => LerMem,
        Addr_in => ALU_result(7 downto 0),
        DataIn => B_OUT_int,
        DataOut => RAM_out
    );

end arq;