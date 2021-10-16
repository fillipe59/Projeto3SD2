library ieee;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use ieee.numeric_bit.all;
entity calc_tb is
end calc_tb;

architecture tb of calc_tb is
	component calc is
		port(
			clock:       in bit;
			reset:       in bit;
			instruction: in bit_vector(16 downto 0);
			q1:          out bit_vector(15 downto 0)
		);
	end component;
	
	signal clock_in: bit := '0';
	signal reset_in: bit;
	signal instruction_in: bit_vector(16 downto 0);
	signal q1_out: bit_vector(15 downto 0);
	
	constant clockPeriod: time := 2 ns; -- periodo do clock
	signal simulando : bit := '0';
begin
	DUT: calc port map(clock_in, reset_in, instruction_in, q1_out);
	clock_in <= (simulando and (not clock_in)) after clockPeriod/2;
	
	estimulos: process is
		type pattern_type is record 
			reset        : bit;
			instruction  : bit_vector(16 downto 0);
			q1           : bit_vector(15 downto 0); 
		end record;
		
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns: pattern_array := 
	   -- rst      instruction               q1  
		(('0', "00000100000100001", "0000000000000010"),
		 ('0', "01001000001100011", "0000000000000100"),
		 ('0', "00000100001100000", "0000000000000110"),
		 ('0', "10000010000000010", "0000000000000100"),
		 ('0', "11000110000000100", "0000000000000011"),
		 --('0', "01110110000000101", "0000000000000001"),
		 --('0', "11110110001000110", "0000000000001001"),
		 ('1', "00110110001000001", "0000000000000000"));
	begin
		assert false report "Testes iniciados" severity note;
		simulando <= '1'; -- Habilita clock
		
		for i in patterns'range loop
			reset_in       <= patterns(i).reset;
			instruction_in <= patterns(i).instruction;
			
			wait for clockPeriod;
			
			assert q1_out = patterns(i).q1
			report "Erro no sinal q1 do teste " & integer'image(i)  
			severity error;
		end loop;
		assert false report "Testes concluidos" severity note;
		simulando <= '0'; -- Desabilita clock		
		wait;  -- para a execução do simulador, caso contrário este process é reexecutado indefinidamente.
	end process;
end architecture;