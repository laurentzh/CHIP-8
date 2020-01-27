with Interfaces; use Interfaces;

package body instruction is

   function Fetch (Mem : Memory; Addr : Address) return Opcode is
      Op : Opcode;
   begin
      Op := Unsigned_16(Mem(Addr));
      Op := Shift_Left(Op, 8);
      Op := Op + Unsigned_16(Mem(Addr + 1));
      return Op;
   end Fetch;
   
   procedure Execute (Cpu : Chip8; Op : Opcode) is
      I : Integer;
   begin
      I := Integer(Shift_Right(Op, 12));
      Instr_Handlers(I)(Cpu, Op);
   end Execute;
   
   procedure Handler_0 (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_0;
   
   procedure Handler_1 (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_1;
   
   procedure Handler_2 (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_2;

   procedure Handler_3 (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_3;
   
   procedure Handler_4 (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_4;
   
   procedure Handler_5 (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_5;
   
   procedure Handler_6 (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_6;
   
   procedure Handler_7 (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_7;
   
   procedure Handler_8 (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_8;
   
   procedure Handler_9 (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_9;
   
   procedure Handler_A (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_A;
   
   procedure Handler_B (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_B;
   
   procedure Handler_C (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_C;
   
   procedure Handler_D (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_D;
   
   procedure Handler_E (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_E;
   
   procedure Handler_F (Cpu : Chip8; Op : Opcode) is
   begin
      null;
   end Handler_F;
   
end instruction;
