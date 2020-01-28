with Types; use Types;
with Cpu; use Cpu;

package Instruction is
   
   subtype Opcode is Word;
   
   function Fetch (Mem : Memory; Addr : Address) return Opcode;
   procedure Execute (Cpu : in out Chip8; Op : Opcode);
   
   procedure Handler_0 (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_1 (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_2 (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_3 (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_4 (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_5 (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_6 (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_7 (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_8 (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_9 (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_A (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_B (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_C (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_D (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_E (Cpu : in out Chip8; Op : Opcode);
   procedure Handler_F (Cpu : in out Chip8; Op : Opcode);
   
   type Instr_Handler is access procedure (Cpu : in out Chip8; Op : Opcode);
   type Instr_Handler_Array is array (0 .. 15) of Instr_Handler;
   
   Instr_Handlers : constant Instr_Handler_Array := (Handler_0'Access,
                                                     Handler_1'Access,
                                                     Handler_2'Access,
                                                     Handler_3'Access,
                                                     Handler_4'Access,
                                                     Handler_5'Access,
                                                     Handler_6'Access,
                                                     Handler_7'Access,
                                                     Handler_8'Access,
                                                     Handler_9'Access,
                                                     Handler_A'Access,
                                                     Handler_B'Access,
                                                     Handler_C'Access,
                                                     Handler_D'Access,
                                                     Handler_E'Access,
                                                     Handler_F'Access);
   
end Instruction;
