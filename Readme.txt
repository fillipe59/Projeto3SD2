Projeto 3 de Sistemas Digitais 2 da Escola Politécnica da USP
Por Fillipe Pinheiro Lima da Silva - 17/10/2021

Detalhe importente: Estava vedada a utilização da biblioteca ieee.std_logic_1164

Atividade 1:
Consiste na implementação de um registrador parimetrizável com reset assíncrono e sensível a borda de clock de subida.

Atividade 2:
Consiste na implementação de um banco de registradores parimetrizável com reset assíncrono e sensível a borda de clock de subida. 
Há um sinal de habilitaçao de saída nível alto (regWrite).
rr1 e rr2 são os "endereços", ou seja, o número do registrador em binário, que serão lidos assíncroamente.
wr é o número do registrador em que o conteúdo será aramzenado.
Vale ressaltar que o último registrador sempre retornará zero por definição.

Atividade 3
Consiste na implementação de uma calculadora de banco de registradores com o seguinte vetor de instrução de 17 bits, do bit mais significativo para o menos:
- 16 e 15: opcode - indica a operação a ser feita
- 14 a 10: oper2
- 9 a 5: oper1
- 4 a 0: dest
Sendo que:
- opcode: 00 para ADD, 01 para ADDI, 10 para SUB, 11 para SUBI;
- oper2: o segundo operando, que será um registrador para ADD e
  SUB, e será um imediato em complemento de 2 para ADDI e SUBI;
- oper1: o primeiro operando, que será sempre um registrador;
- dest: o registrador destino, onde se guardará o resultado da soma
Obs: o o conteúdo do oper1 sempre será o minuedo das substrações.