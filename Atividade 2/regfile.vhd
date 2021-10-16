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
	type mem_tipo is array(0 to regn-1) of bit_vector(wordSize-1 downto 0);
	signal regs: mem_tipo; --registradores
	
	signal int_wr: integer;
	signal int_rr1: integer;
	signal int_rr2: integer;
begin
	int_wr <= to_integer(unsigned(wr));
	int_rr1 <= to_integer(unsigned(rr1));
	int_rr2 <= to_integer(unsigned(rr2));
	
	process(clock, reset)
	begin
		if reset = '1' then
			regs <= (others => bit_vector(to_unsigned(0, wordSize)));
			q1 <= regs(int_rr1);
			q2 <= regs(int_rr2);
		elsif clock = '1' and clock'event then
			if regWrite = '1' then
				regs(int_wr) <= d; 
			end if;
			regs(regn-1) <= (others => '0');
			q1 <= regs(int_rr1);
			q2 <= regs(int_rr2);
		end if;
	end process;
end arch_regfile;
