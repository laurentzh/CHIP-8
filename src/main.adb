with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);
with STM32.Board; use STM32.Board;

with Cpu; use Cpu;
with Instruction; use Instruction;
with Roms; use Roms;
with Types; use Types;
with Inputs; use Inputs;
with Gfx; use Gfx;

procedure Main is

   procedure Load_Rom(Cpu : in out Chip8; R : Rom) is
   begin
      for I in R'Range loop
         Cpu.Mem(I) := R(I);
      end loop;
   end Load_Rom;

   Op : Opcode;
begin
   Init_Draw;
   Touch_Panel.Initialize;
   Clear_Layer(1);
   Clear_Layer(2);
   Draw_Keyboard(Global_Cpu.Mem);
   Load_Rom(Global_Cpu, BLINKY);
   loop
      Op := Fetch(Global_Cpu);
      Execute(Global_Cpu, Op);
      Update_Pressed_Keys(Global_Cpu.Keys);
   end loop;
end Main;
