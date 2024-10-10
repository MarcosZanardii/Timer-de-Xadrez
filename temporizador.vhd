--------------------------------------------------------------------------------
-- Temporizador decimal do cronometro de xadrez
-- Fernando Moraes - 25/out/2023
--------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;

entity temporizador is
    port( clock, reset, load, en : in std_logic;
          init_time : in  std_logic_vector(7 downto 0);
          cont      : out std_logic_vector(15 downto 0)
      );
end temporizador;

architecture behavioral of temporizador is

    signal clock_1s     : std_logic;--clock para 1 segundo
    signal counter_1s   : std_logic_vector(25 downto 0); -- contador para gerar 1Hz
    signal minH, minL   : std_logic_vector(3 downto 0);--minutos(dezena e unidade)
    signal segH, segL   : std_logic_vector(3 downto 0);--segundos
    signal enA          : std_logic; -- Sinal auxiliar para controle de `en`

begin
    clock_1HZ: process(clock, reset)--gera clock de 1HZ, atraves do clock de 100MHZ
        begin
            if reset = '1' then
                clock_1s <= '0';--inicia em zero
                counter_1s <= (others => '0');--zera contador
            elsif rising_edge(clock) then--verifica borda de subida
                if counter_1s = 49999999 then--49.999.999 ultima borda antes de completar 1s
                    clock_1s <= not clock_1s;--inverte o clock
                    counter_1s <= (others => '0');--"zera" contador
                else 
                    counter_1s <= counter_1s + 1;--incrementa contador
                end if;
            end if;
        end process clock_1HZ;

    contador: process(clock_1s, load, en)
        begin 
            if reset = '1' then -- Quando resetado, zera todos valores
                minH <= (others => '0'); -- Dezena do minuto    = 0
                minL <= (others => '0'); -- Unidade do minuto   = 0
                segH <= (others => '0'); -- Dezena do segundo   = 0
                segL <= (others => '0'); -- Unidade do segundo  = 0
                enA  <= '0';             -- Desativa o enable
                cont <= minH & minL & segH & segL;

            elsif rising_edge(clock_1s) then--verifica borda de clock
                if load = '1' then
                    minH <= init_time(7 downto 4);
                    minL <= init_time(3 downto 0); -- Corrigido para minL
                    segH <= (others => '0');
                    segL <= (others => '0');
                    cont <= minH & minL & segH & segL;

                else
                    if en = '1' then
                        case segL is
                            when "0000" =>
                                if segH /= "0000" then
                                    segH <= segH - 1;
                                    segL <= "1001";
                                elsif minL /= "0000" then
                                    minL <= minL - 1;
                                    segH <= "0101";
                                    segL <= "1001";
                                elsif minH /= "0000" then
                                    minH <= minH - 1;
                                    minL <= "1001";
                                    segH <= "0101";
                                    segL <= "1001";
                                else
                                    minH <= (others => '0');
                                    minL <= (others => '0');
                                    segH <= (others => '0');
                                    segL <= (others => '0');
                                end if;
                            when others =>
                                segL <= segL - 1;
                        end case;


                        cont <= minH & minL & segH & segL;
                        
                    end if;
                end if;
            end if;
        end process contador;

end behavioral;
