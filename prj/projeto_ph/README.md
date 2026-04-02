SystemVerilog e o simulador Icarus Verilog.

 O circuito é descrito em nível RTL (Register Transfer Level), onde a lógica é definida por código. 
 A função implementada é: c = a OR b 
 Ou seja, a saída c é 1 quando pelo menos uma das entradas (a ou b) for igual a 1. 
 
 
 O projeto é dividido em: DUT (rtl/dut.sv): circuito Testbench (tb/tb_top.sv): responsável pelos testes 
 Como rodar Instalar o simulador: sudo apt update sudo apt install iverilog 

 Compilar o projeto: cd prj/hello/tb iverilog -g2012 -s tb_top -o simv tb_top.sv ../rtl/dut.sv 

 Executar a simulação: vvp simv 
 
 
 Objetivo Demonstrar o fluxo básico de EDA: descrição do circuito, criação de testes, simulação e validação.