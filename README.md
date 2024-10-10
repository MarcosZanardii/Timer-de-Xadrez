Projeto: Relógio de Xadrez em VHDL
Este projeto implementa um relógio de xadrez em VHDL, desenvolvido para gerenciar o tempo de partidas de xadrez. A solução utiliza uma máquina de estados finita (FSM) para controlar a alternância entre os jogadores e um temporizador para contabilizar o tempo de jogo de forma precisa.

Estrutura do Projeto
O projeto é composto por diversos arquivos que desempenham funções específicas no funcionamento do relógio:

FSM.pdv: Diagrama da máquina de estados que ilustra a lógica de controle do relógio. Este diagrama ajuda na visualização das transições entre os estados do jogo.

dspl_drv_NexysA7.vhd: Módulo responsável pelo controle dos dígitos do display no FPGA, permitindo que o tempo restante de cada jogador seja exibido de forma clara e legível.

detector_de_borda.v: Este módulo é responsável por limpar o sinal do botão com base no clock. Ele garante que o botão de controle do relógio responda de forma precisa, evitando múltiplos acionamentos indesejados.

relogio_xadrez.bit: Arquivo bitstream gerado no Vivado, utilizado para programar o FPGA. Este arquivo contém todas as informações necessárias para implementar o projeto no hardware.

relogio_xadrez.vhd: Arquivo principal que contém a implementação completa do relógio de xadrez, incluindo a lógica de alternância de tempo entre os jogadores e o gerenciamento do temporizador.

relogio_xadrez.xdc: Arquivo de restrições que mapeia as portas do código com as conexões físicas do FPGA. Este arquivo é essencial para garantir que o hardware funcione corretamente.

temporizador.vhd: Módulo que descreve o comportamento do temporizador. Ele é instanciado no projeto principal e gerencia a contagem do tempo durante as partidas.

Funcionamento
O relógio de xadrez alterna entre os tempos de dois jogadores, utilizando botões para iniciar e parar o cronômetro. A máquina de estados controla as transições entre os diferentes estados do jogo, garantindo uma experiência de jogo fluida e sem interrupções.

Como Usar
Configuração do Ambiente: Abra o Vivado e crie um novo projeto.
Importação dos Arquivos: Adicione todos os arquivos mencionados ao projeto no Vivado.
Mapeamento das Portas: Verifique e ajuste as configurações no arquivo relogio_xadrez.xdc conforme necessário para o seu hardware.
Compilação: Compile o projeto para gerar o arquivo bitstream.
Programação do FPGA: Carregue o arquivo relogio_xadrez.bit no FPGA usando o Vivado.
Controle do Jogo: Utilize os botões configurados para iniciar e parar o tempo de cada jogador.
Conclusão
Este projeto proporciona uma implementação prática e funcional de um relógio de xadrez em VHDL, combinando conceitos de máquinas de estados e temporização em hardware digital. É uma excelente oportunidade para explorar e entender o funcionamento de sistemas embarcados.
