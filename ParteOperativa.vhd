library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ParteOperativa is
    port (
        clk, reset  : in std_logic;
        -- Sinais vindos do Controle (PC)
        LE          : in std_logic; -- EscReg
        RegDst      : in std_logic;
        HS          : in std_logic_vector(1 downto 0);
        MF          : in std_logic;
        MD          : in std_logic; -- MemParaReg
        MB          : in std_logic; -- ULAFonte
        gsel        : in std_logic_vector(3 downto 0);
        EscMem      : in std_logic;
        LerMem      : in std_logic;
        Branch      : in std_logic;
        -- Sinais indo para o Controle (PC)
        opcode      : out std_logic_vector(5 downto 0);
		  DataOutMem    : out std_logic_vector(31 downto 0);
        funct       : out std_logic_vector(5 downto 0)
    );
end ParteOperativa;

architecture arq of ParteOperativa is
    -- Sinais internos
    signal PC_reg    : unsigned(7 downto 0) := (others => '0');
    signal instrucao : std_logic_vector(31 downto 0);
    signal imm_ext   : std_logic_vector(31 downto 0);
    signal mux_DS    : std_logic_vector(4 downto 0); -- Mux para RegDst
    signal ALU_out   : std_logic_vector(31 downto 0);
    signal RAM_out   : std_logic_vector(31 downto 0);
    signal B_OUT_int : std_logic_vector(31 downto 0); -- Precisamos do dado do reg rt para o Store

    -- Componentes já definidos por você
    component datapath is
        port(
            clk, reset, LE : in std_logic;
            AS, BS, DS     : in std_logic_vector(4 downto 0);
            HS             : in std_logic_vector(1 downto 0);
            MF, MD, MB     : in std_logic;
            S              : out std_logic_vector(31 downto 0);
            Datain         : in std_logic_vector(31 downto 0);
            constantin     : in std_logic_vector(31 downto 0);
            gsel           : in std_logic_vector(3 downto 0);
            Cout           : out std_logic;
				OUT_B 			: out std_logic_vector(31 downto 0)
        );
    end component;

begin

    -- 1. Program Counter (PC)
    process(clk, reset)
    begin
        if reset = '1' then
            PC_reg <= (others => '0');
        elsif rising_edge(clk) then
            -- Lógica de Branch simplificada: se Branch=1 e ALU_out=0, pula (exemplo BEQ)
            -- Nota: No MIPS real o offset é somado ao PC
            PC_reg <= PC_reg + 1; 
        end if;
    end process;
		
    -- 2. Memória de Instruções (ROM)
    ROM_INST: entity work.mem_32 port map (Addr_in => std_logic_vector(PC_reg), DataOut => instrucao);

    -- 3. Decodificação física (Slices)
    opcode <= instrucao(31 downto 26);
    funct  <= instrucao(5 downto 0);

    -- 4. Extensor de Sinal (16 para 32 bits)
    imm_ext <= std_logic_vector(resize(signed(instrucao(15 downto 0)), 32));

    -- 5. Mux RegDst (RT ou RD)
    mux_DS <= instrucao(20 downto 16) when RegDst = '0' else instrucao(15 downto 11);

    -- 6. Instância do Datapath (Banco de Reg + Unidade Funcional)
    DP_INST: datapath port map (
        clk => clk, reset => reset, LE => LE,
        AS => instrucao(25 downto 21), BS => instrucao(20 downto 16), DS => mux_DS,
        HS => HS, MF => MF, MD => MD, MB => MB,
        S => ALU_out, Datain => RAM_out, constantin => imm_ext,
        gsel => gsel, Cout => open, OUT_B => B_OUT_int
    );

    -- 7. Memória de Dados (RAM)
    -- Importante: Conectar o endereço vindo da ULA e o dado vindo do registrador
    RAM_INST: entity work.mem_dados_32 port map (
        clk => clk, EscMem => EscMem, LerMem => LerMem,
        Addr_in => ALU_out(7 downto 0), 
        DataIn => B_OUT_int, -- Nota: No seu datapath, você precisaria expor B_OUT para o Store
        DataOut => RAM_out,
		  DataOutMem => DataOutMem
    );
end arq;