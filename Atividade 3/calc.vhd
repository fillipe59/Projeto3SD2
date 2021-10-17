library ieee;
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
	type mem_tipo is array(0 to 31) of bit_vector(15 downto 0);
	signal regs: mem_tipo; --registradores	
	
	signal opcode: bit_vector(1 downto 0);
	signal oper1, oper2, dest: bit_vector(4 downto 0);
begin
	opcode <= instruction(16 downto 15);
	oper2 <= instruction(14 downto 10);
	oper1 <= instruction(9 downto 5);
	dest <= instruction(4 downto 0);

	q1 <= regs(to_integer(unsigned(oper1)));
	process(clock)
	begin
		if reset = '1' then 
			regs <= (others => bit_vector(to_signed(0, 16)));
		elsif clock = '1' and clock'event then
			if opcode = "00" then --! ADD
				regs(to_integer(unsigned(dest))) <= bit_vector(signed(regs(to_integer(unsigned(oper1)))) + signed(regs(to_integer(unsigned(oper2)))));
			elsif opcode = "01" then --! ADDI
				regs(to_integer(unsigned(dest))) <= bit_vector(signed(regs(to_integer(unsigned(oper1)))) + to_integer(signed(oper2)));
			elsif opcode = "10" then --! SUB
				regs(to_integer(unsigned(dest))) <= bit_vector(signed(regs(to_integer(unsigned(oper1)))) - signed(regs(to_integer(unsigned(oper2)))));
			else --! SUBI
				regs(to_integer(unsigned(dest))) <= bit_vector(signed(regs(to_integer(unsigned(oper1)))) - to_integer(signed(oper2)));
			end if;
		end if;
		regs(31) <= (others => '0');
	end process;
end arch_calc;