with Cpu; use Cpu;
with Instruction; use Instruction;
with Stack; use Stack;

procedure Main is
   Cpu : Chip8 := (Mem => (16#F0#, 16#90#, 16#90#, 16#90#, 16#F0#,
                           16#20#, 16#60#, 16#20#, 16#20#, 16#70#,
                           16#F0#, 16#10#, 16#F0#, 16#80#, 16#F0#,
                           16#F0#, 16#10#, 16#F0#, 16#10#, 16#F0#,
                           16#90#, 16#90#, 16#F0#, 16#10#, 16#10#,
                           16#F0#, 16#80#, 16#F0#, 16#10#, 16#F0#,
                           16#F0#, 16#80#, 16#F0#, 16#90#, 16#F0#,
                           16#F0#, 16#10#, 16#20#, 16#40#, 16#40#,
                           16#F0#, 16#90#, 16#F0#, 16#90#, 16#F0#,
                           16#F0#, 16#90#, 16#F0#, 16#10#, 16#F0#,
                           16#F0#, 16#90#, 16#F0#, 16#90#, 16#90#,
                           16#E0#, 16#90#, 16#E0#, 16#90#, 16#E0#,
                           16#F0#, 16#80#, 16#80#, 16#80#, 16#F0#,
                           16#E0#, 16#90#, 16#90#, 16#90#, 16#E0#,
                           16#F0#, 16#80#, 16#F0#, 16#80#, 16#F0#,
                           16#F0#, 16#80#, 16#F0#, 16#80#, 16#80#,
                           others => 0),
                   Regs => (others => 0),
                   I => 0,
                   PC => 16#200#,
                   Stack => Init_Stack,
                   Delay_Timer => 0,
                   Sound_Timer => 0,
                   Screen => (others => (others => False)),
                   Keys => (others => False));
   Op : Opcode;
begin
   loop
      Op := Fetch(Cpu);
      Execute(Cpu, Op);
   end loop;
end Main;
