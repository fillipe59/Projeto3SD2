entity reg_tb is
end reg_tb;

architecture tb of reg_tb is
	component reg is
		generic(wordSize: natural := 4);
		port(
			clock : in  bit;
			reset : in  bit;
			load  : in  bit; 
			d     : in  bit_vector(wordSize-1 downto 0);
			q     : out bit_vector(wordSize-1 downto 0)
		);
	end component;
	
	constant wS: natural := 4;
	signal clock_in : bit := '0';
	signal reset_in : bit;
	signal load_in  : bit;
	signal d_in     :  bit_vector(wS-1 downto 0);
	signal q_out    :  bit_vector(wS-1 downto 0);
	
	constant clockPeriod: time := 2 ns; -- periodo do clock
	signal simulando : bit := '0';
begin
	DUT: reg
	generic map(wS)
	port    map(clock_in, reset_in, load_in, d_in, q_out);
	
	clock_in <= (simulando and (not clock_in)) after clockPeriod/2;
	
	estimulos: process is
		type pattern_type is record 
			reset : bit;
			load  : bit; 
			d     : bit_vector(wS-1 downto 0);
			q     : bit_vector(wS-1 downto 0);
		end record;
		
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns: pattern_array :=
		--rst  load    d    	q
		(('1', '0',  "0000", "0000"),
		 ('0', '1',  "1111", "1111"),
		 ('0', '1',  "1010", "1010"),
		 ('1', '0',  "0010", "0000"),
		 ('1', '1',  "1000", "0000"),
		 ('0', '1',  "0110", "0110"),
		 ('0', '0',  "0111", "0110"));
	begin
		assert false report "Testes iniciados" severity note;
		simulando <= '1'; -- Habilita clock
		
		for i in patterns'range loop
			reset_in <= patterns(i).reset;
			load_in  <= patterns(i).load;
			d_in     <= patterns(i).d;
			
			wait for 20 ns;
			
			assert q_out = patterns(i).q
			report "Erro no sinal data do teste " & integer'image(i)  
			severity error;
			
		end loop;
		assert false report "Testes concluidos" severity note;
		simulando <= '0'; -- Desabilita clock		
		wait;  -- para a execução do simulador, caso contrário este process é reexecutado indefinidamente.
	end process;
end tb;