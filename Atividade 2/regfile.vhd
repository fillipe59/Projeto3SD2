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
	
begin
	process(clock, reset, rr1, rr2)
	begin
		if reset = '1' then
			regs <= (others => bit_vector(to_unsigned(0, wordSize)));
		elsif clock = '1' and clock'event then
			if regWrite = '1' then
				regs(to_integer(unsigned(wr))) <= d; 
			end if;
		end if;
		regs(regn-1) <= (others => '0');
		q1 <= regs(to_integer(unsigned(rr1)));
		q2 <= regs(to_integer(unsigned(rr2)));
	end process;
end arch_regfile;
