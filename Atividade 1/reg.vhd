entity reg is
	generic (wordSize: natural := 4);
	port(
		clock : in bit;  --! entrada de clock
		reset : in bit; --! clear assincrono
		load  : in bit; --! write enable (carga paralela)
		d     : in bit_vector(wordSize−1 downto 0); --! entrada
		q     : out bit_vector(wordSize−1 downto 0) --! saida
	);
end reg ;