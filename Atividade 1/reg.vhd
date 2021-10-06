entity reg is
	generic(wordSize: natural := 4);
	port(
		clock : in  bit; --! entrada de clock
		reset : in  bit; --! clear assincrono
		load  : in  bit; --! write enable (carga paralela)
		d     : in  bit_vector(wordSize-1 downto 0); --! entrada
		q     : out bit_vector(wordSize-1 downto 0)  --! saida	
	);
end reg;
architecture arch of reg is 
begin
	process(clock, reset)
	begin
		if reset = '1' then 
			q <= (others => '0');
		elsif clock = '1' and clock'event then
			if load = '1' then
				q <= d;
			end if;
		end if;
	end process;
end arch;