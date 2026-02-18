library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_processador is

end tb_processador;

architecture sim of tb_processador is

    -- 1. Declarar o componente Top Level 
    component MIPS_Top_Level is
        port (
            clk   : in std_logic;
            reset : in std_logic
        );
    end component;

    -- 2. Sinais para ligar no componente
    signal s_clk   : std_logic := '0';
    signal s_reset : std_logic := '0';

    -- 3. Definição do período do clock (ex: 10ns = 100MHz)
    constant clk_period : time := 10 ns;

begin

    -- 4. Instanciar o Processador (Unit Under Test - UUT)
    UUT: MIPS_Top_Level
        port map (
            clk   => s_clk,
            reset => s_reset
        );

    -- 5. Processo gerador de Clock
    clk_process: process
    begin
        s_clk <= '0';
        wait for clk_period/2;
        s_clk <= '1';
        wait for clk_period/2;
    end process;

    -- 6. Processo de Estímulo (Reset inicial)
    stim_proc: process
    begin
        -- Segura o reset ativado por um tempo
        s_reset <= '1';
        wait for 20 ns; 
        
        -- Solta o reset para o processador começar
        s_reset <= '0';

        -- Deixa rodar por um tempo suficiente para ver as instruções
        wait for 200 ns;

        -- Para a simulação (opcional, ou apenas deixe rodando)
        wait;
    end process;

end sim;