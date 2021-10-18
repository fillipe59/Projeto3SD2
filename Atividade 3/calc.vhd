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
	signal oper1, oper2, dest: integer range 0 to 31;
	
	signal q_oper1, q_oper2: signed(15 downto 0);
	signal imediato: integer;
begin
	opcode <= instruction(16 downto 15);
	oper2 <= to_integer(unsigned(instruction(14 downto 10)));
	oper1 <= to_integer(unsigned(instruction(9 downto 5)));
	dest <=  to_integer(unsigned(instruction(4 downto 0)));
	
	q_oper1 <= signed(regs(oper1));
	q_oper2 <= signed(regs(oper2));
	imediato <= to_integer(signed(instruction(14 downto 10)));

	q1 <= regs(oper1);
	process(clock)
	begin
		if reset = '1' then 
			regs <= (others => bit_vector(to_signed(0, 16)));
		elsif clock = '1' and clock'event then
			if opcode = "00" then --! ADD
				regs(dest) <= bit_vector(q_oper1 + q_oper2);
			elsif opcode = "01" then --! ADDI
				regs(dest) <= bit_vector(q_oper1 + imediato);
			elsif opcode = "10" then --! SUB
				regs(dest) <= bit_vector(q_oper1 - q_oper2);
			else --! SUBI
				regs(dest) <= bit_vector(q_oper1 - imediato);
			end if;
		end if;
		regs(31) <= (others => '0');
	end process;
end arch_calc;