library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;

entity relogio_xadrez is
    port( 
        reset          : in  std_logic;
        clock          : in  std_logic;
        load           : in  std_logic;
        init_time      : in  std_logic_vector(7 downto 0);
        j1, j2         : in  std_logic;
        an, dec_cat    : out std_logic_vector(7 downto 0);
        winJ1, winJ2   : out std_logic
    );
end relogio_xadrez;

architecture behavioral of relogio_xadrez is
    signal j1_clear, j2_clear: std_logic;
    signal cont1, cont2   : std_logic_vector(15 downto 0);
    signal en1, en2: std_logic;
    signal dA, dB , dC, dD, dE, dF, dG, dH, dOff : std_logic_vector(5 downto 0);

    type state is (idle, c1, c2); -- estados
    signal EA, PE: state;   -- Estado Atual e Próximo Estado

begin

    edj1: entity work.edge_detector
    port map (clock => clock, reset => reset, din => j1, rising => j1_clear);

    edj2: entity work.edge_detector
    port map (clock => clock, reset => reset, din => j2, rising => j2_clear);

    -- Temporizador para jogador 1
    contador1 : entity work.temporizador
        port map (reset => reset, clock => clock, load => load, init_time => init_time, en => en1, cont => cont1);

    -- Temporizador para jogador 2
    contador2 : entity work.temporizador
        port map (reset => reset, clock => clock, load => load, init_time => init_time, en => en2, cont => cont2 );

    -- FSM 
    process(clock, reset)
        begin
            if reset = '1' then
                EA <= idle;
            elsif rising_edge(clock) then
                EA <= PE; -- Atualiza o estado
            end if;
    end process;

    process(EA, j1_clear, j2_clear)
        begin
            -- Comportamento baseado no estado atual
            case EA is
                when idle =>
                    if j1_clear = '1' then
                        PE <= c1;
                    elsif j2_clear = '1' then
                        PE <= c2;
                    elsif j1_clear = '0' and j2_clear = '0' then
                        PE <= idle;
                    end if;    
                    
                when c1 =>
                    if j1_clear = '1' then
                        PE <= c2; -- Transição para o turno do jogador 2
                        elsif load = '1' then
                            PE <= idle;
                            elsif j1_clear = '0' and j2_clear = '0' and load = '0' then
                                PE <= c1; -- Transição para o turno do jogador 2
                    end if;

                when c2 => --verfificar se zerou cont, volta pro idl
                    if j2_clear = '1' then
                        PE <= c1; -- Transição para o turno do jogador 1
                        elsif load = '1' then
                            PE <= idle;
                            elsif j1_clear = '0' and j2_clear = '0' and load = '0' then
                                PE <= c2; -- Transição para o turno do jogador 1
                    end if;
            end case;
    end process;

    en1 <= '1' when EA = c1 else '0';
    en2 <= '1' when EA = c2 else '0';
 
    -- Determina quem ganhou
    process(cont1, cont2)
        begin
            if cont1 = "0000000000000000" then
                winJ2 <= '1';  -- Jogador 2 venceu
                winJ1 <= '0';
            elsif cont2 = "0000000000000000" then
                winJ1 <= '1';  -- Jogador 1 venceu
                winJ2 <= '0';
            else
                winJ1 <= '0';
                winJ2 <= '0';
            end if;
    end process;

    dD <= '1' & cont1 (15 downto 12) & '0';
    dC <= '1' & cont1 (11 downto 8) & '0';
    dB <= '1' & cont1 (7 downto 4) & '0';
    dA <= '1' & cont1 (3 downto 0) & '0';

    dH <= '1' & cont2 (15 downto 12) & '0';
    dG <= '1' & cont2 (11 downto 8) & '0';
    dF <= '1' & cont2 (7 downto 4) & '0';
    dE <= '1' & cont2 (3 downto 0) & '0';
    
    DISP_CONTROL: entity work.dspl_drv_NexysA7
    port map(clock => clock, reset => reset, d1 => dA, d2 => dB , d3 => dC, d4 => dD, d5 => dE, d6 => dF, d7 => dG, d8 => dH, an => an, dec_cat => dec_cat );

end behavioral;
