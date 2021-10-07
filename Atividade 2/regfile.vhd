library ieee;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use ieee.numeric_bit.all;

entity regfile is
	generic(
		regn     : natural := 32; --! numero de registradores
		wordSize : natural := 64  -- tamanho de cada palavra
	);
	port(
		clock        : in  bit; --! entrada de clock
		reset        : in  bit; --! clear assincrono
		regWrite     : in  bit; --! write enable
		--! entradas de endereco para leitura (rr1 e rr2) e de escrita (wr)
		rr1, rr2, wr : in  bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
		d            : in  bit_vector(wordSize-1 downto 0); --! entrada para escrita
		q1, q2       : out bit_vector(wordSize-1 downto 0)  --! saidas	
	);
end regfile;

architecture arch_regfile of regfile is
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
	
	type mem_tipo is array(0 to regn-1) of bit_vector(wordSize-1 downto 0);
	signal saidas: mem_tipo; --saida de cada reg 
	signal loadVector: bit_vector(0 to regn-1); --vetor com os sinais de load de cada reg
	signal dVector: mem_tipo;
	
	signal int_wr: integer;
	signal int_rr1: integer;
	signal int_rr2: integer;
begin
	cria_regs: for i in 0 to regn-1 generate
		regs: reg generic map(wordSize) port map(clock, reset, loadVector(i), dVector(i), saidas(i));
	end generate;
	
	int_wr <= to_integer(unsigned(wr));
	int_rr1 <= to_integer(unsigned(rr1));
	int_rr2 <= to_integer(unsigned(rr2));
	
	process(clock)
	begin
		if clock = '1' and clock'event then
			loadVector <= (others => '0');
			dVector(int_wr) <= d;
			if int_wr /= regn-1 then
				loadVector(int_wr) <= regWrite;
			end if;
			q1 <= saidas(int_rr1);
			q2 <= saidas(int_rr2);
		end if;
	end process;

end arch_regfile;

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
architecture arch_reg of reg is 
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
end arch_reg;