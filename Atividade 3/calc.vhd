library ieee;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use ieee.numeric_bit.all;
entity calc is
	port(
		clock:       in bit;
		reset:       in bit;
		instruction: in bit_vector(16 downto 0);
		q1:          out bit_vector(15 downto 0)
	);
end calc;

architecture arch_calc of calc is
	component regfile is
		generic(
			regn     : natural := 32; --! numero de registradores
			wordSize : natural := 64  --! tamanho de cada palavra
		);
		port(
			clock        : in  bit; --! entrada de clock
			reset        : in  bit; --! clear assincrono
			regWrite     : in  bit; --! write enable
			rr1, rr2, wr : in  bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
			d            : in  bit_vector(wordSize-1 downto 0); --! entrada para escrita
			q1, q2       : out bit_vector(wordSize-1 downto 0)  --! saidas	
		);
	end component;
	
	signal oper1, roper2, resultado: bit_vector(15 downto 0);
begin
	bancoDeRegs: regfile 
					generic map(32, 16) 
					port map(clock, reset, '1', 
							instruction(14 downto 10), instruction(9 downto 5), 
							instruction(4 downto 0), resultado, roper2, oper1);
	
	q1 <= oper1;
	process(clock)
	begin
		if clock = '1' and clock'event then
			if instruction(16 downto 15) = "00" then --! ADD
				resultado <= bit_vector(signed(roper2) + signed(oper1));
			elsif instruction(16 downto 15) = "01" then --! ADDI
				resultado <= bit_vector(signed(oper1) + to_integer(signed(instruction(14 downto 10))));
			elsif instruction(16 downto 15) = "10" then --! SUB
				resultado <= bit_vector(signed(oper1) - signed(roper2));
			else --! SUBI
				resultado <= bit_vector(signed(oper1) - to_integer(signed(instruction(14 downto 10))));
			end if;
		end if;
	end process;
end arch_calc;

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
		rr1, rr2, wr : in  bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
		d            : in  bit_vector(wordSize-1 downto 0); --! entrada para escrita
		q1, q2       : out bit_vector(wordSize-1 downto 0)  --! saidas	
	);
end regfile;
architecture arch_regfile of regfile is
	type mem_tipo is array(0 to regn-1) of bit_vector(wordSize-1 downto 0);
	signal regs: mem_tipo; --registradores	
begin
	q1 <= regs(to_integer(unsigned(rr1)));
	q2 <= regs(to_integer(unsigned(rr2)));
	process(clock, reset)
	begin
		if reset = '1' then
			regs <= (others => bit_vector(to_signed(0, wordSize)));
		elsif clock = '1' and clock'event then
			if regWrite = '1' then
				regs(to_integer(unsigned(wr))) <= d; 
			end if;
		end if;
		regs(regn-1) <= (others => '0');
	end process;
end arch_regfile;