with Cpu; use Cpu;
with Instruction; use Instruction;
with Roms; use Roms;
with Types; use Types;
with Inputs; use Inputs;
with Gfx;

procedure Main is

   procedure Load_Rom(Cpu : in out Chip8; R : Rom) is
   begin
      for I in R'Range loop
         Cpu.Mem(I) := R(I);
      end loop;
   end Load_Rom;

   Op : Opcode;
begin
   Gfx.Initialize;
   Load_Rom(Global_Cpu, IBM);
   loop
      Op := Fetch(Global_Cpu);
      Execute(Global_Cpu, Op);
      Update_Pressed_Keys(Global_Cpu.Keys);
   end loop;
end Main;
