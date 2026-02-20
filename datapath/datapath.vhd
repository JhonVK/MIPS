Library IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity datapath is

port(
    clk: in std_logic;
    reset: in std_logic;
    LE: in std_logic;
    AS, BS: in std_logic_vector(4 downto 0);
    DS: in std_logic_vector(4 downto 0);
    HS: in std_logic_vector(1 downto 0);
    MF: in std_logic;
    MD: in std_logic;
    MB: in std_logic;
    S: out std_logic_vector(31 downto 0);
    ALU_result: out std_logic_vector(31 downto 0);
    Datain: in std_logic_vector(31 downto 0);
    constantin: in std_logic_vector(31 downto 0);
    gsel : in std_logic_vector(3 downto 0);
    Cout : out std_logic;
    OUT_B : out std_logic_vector(31 downto 0)
);

end datapath;

architecture arq of datapath is

signal BUS_B, BUS_D, A_OUT, B_OUT, S_OUT: std_logic_vector(31 downto 0);

component functionunit is
port(
    A, B : in std_logic_vector(31 downto 0);
    HS: in std_logic_vector(1 downto 0);
    MF: in std_logic;
    S: out std_logic_vector(31 downto 0);
    gsel : in std_logic_vector(3 downto 0);
    Cout : out std_logic
);
end component;

component registerfile is
port(
    clk: in std_logic;
    reset: in std_logic;
    LE: in std_logic;
    AS, BS: in std_logic_vector(4 downto 0);
    DS: in std_logic_vector(4 downto 0);
    A_out, B_out: out std_logic_vector(31 downto 0);
    Ddata: in std_logic_vector(31 downto 0)
);
end component;

begin

    registerfile_inst: registerfile
    port map(
        clk => clk,
        reset => reset,
        LE => LE,
        AS => AS,
        BS => BS,
        DS => DS,
        A_out => A_OUT,
        B_out => B_OUT,
        Ddata => BUS_D
    );

    functionunit_inst: functionunit
    port map(
        A => A_OUT,
        B => BUS_B,
        S => S_OUT,
        HS => HS,
        MF => MF,
        gsel => gsel,
        Cout => Cout
    );

    -- MUX MD: seleciona entre resultado da ALU ou dado vindo da RAM
    BUS_D <= S_OUT when MD = '0' else Datain;

    -- MUX MB: seleciona entre registrador B ou constante imediata
    BUS_B <= B_OUT when MB = '0' else constantin;

    -- S = saída do MUX D, não usamos
    S <= BUS_D; 

    -- Usado em ParteOperativa para endereçar RAM e verificar Branch
    ALU_result <= S_OUT;

    OUT_B <= B_OUT;

end arq;