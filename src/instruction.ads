with Interfaces; use Interfaces;

with Cpu; use Cpu;
with Types; use Types;

package Instruction with
SPARK_Mode => On
is
   
   subtype Opcode is Word;
   
   function Fetch (Cpu : Chip8) return Opcode
     with Post => Fetch'Result = Shift_Left(Word(Cpu.Mem(Cpu.PC)), 8) +
     Word(Cpu.Mem(Cpu.PC + 1));
   
   procedure Execute (Cpu : in out Chip8; Op : Opcode);
   
   procedure Handler_0 (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#0000#,
     Contract_Cases =>
       (Op = 16#00E0# => (for all I in Cpu.Screen'Range(1) => 
                            (for all J in Cpu.Screen'Range(2) =>
                                 Cpu.Screen(I, J) = False)),
        Op = 16#00EE# => Cpu.Stack.Size = Cpu.Stack.Size'Old - 1,
        Op /= 16#00E0# and then Op /= 16#00EE# => Cpu.PC = Op mod 16#1000#);
   
   procedure Handler_1 (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#1000#,
     Post => Cpu.PC = Op mod 16#1000#;
   
   procedure Handler_2 (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#2000#,
     Post => Cpu.PC = Op mod 16#1000#
     and then Cpu.Stack.Arr(Cpu.Stack.Size'Old) = Cpu.PC'Old;
   
   procedure Handler_3 (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#3000#,
     Post => Cpu.PC >= Cpu.PC'Old + 2,
     Contract_Cases =>
       (Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) = Byte(Op mod 16#100#)
        => Cpu.PC = Cpu.PC'Old + 4,
        Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) /= Byte(Op mod 16#100#)
        => Cpu.PC = Cpu.PC'Old + 2);
   
   procedure Handler_4 (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#4000#,
     Contract_Cases =>
       (Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) /= Byte(Op mod 16#100#)
        => Cpu.PC = Cpu.PC'Old + 4,
        Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) = Byte(Op mod 16#100#)
        => Cpu.PC = Cpu.PC'Old + 2);
   
   procedure Handler_5 (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#5000#,
     Post => Cpu.PC >= Cpu.PC'Old + 2,
     Contract_Cases =>
       (Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) =
          Cpu.Regs(Integer(Shift_Right(Op, 4) and 16#F#)) =>
          Cpu.PC = Cpu.PC'Old + 4,
        Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) /=
          Cpu.Regs(Integer(Shift_Right(Op, 4) and 16#F#)) =>
          Cpu.PC = Cpu.PC'Old + 2);
   
   procedure Handler_6 (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#6000#,
     Post => Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) =
     Byte(Op mod 16#100#) and then Cpu.PC = Cpu.PC'Old + 2;
   
   procedure Handler_7 (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#7000#,
     Post => Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) =
     Cpu.Regs'Old(Integer(Shift_Right(Op, 8) and 16#F#)) + Byte(Op mod 16#100#)
     and then Cpu.PC = Cpu.PC'Old + 2;
   
   procedure Handler_8 (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#8000# and then
     (Op mod 16#10# = 0 or Op mod 16#10# = 1 or Op mod 16#10# = 2
      or Op mod 16#10# = 3 or Op mod 16#10# = 4 or Op mod 16#10# = 5
      or Op mod 16#10# = 6 or Op mod 16#10# = 7 or Op mod 16#10# = 16#E#),
     Post => Cpu.PC = Cpu.PC'Old + 2;
   
   procedure Handler_9 (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#9000#,
     Post => Cpu.PC >= Cpu.PC'Old + 2,
     Contract_Cases =>
       (Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) /=
          Cpu.Regs(Integer(Shift_Right(Op, 4) and 16#F#)) =>
          Cpu.PC = Cpu.PC'Old + 4,
        Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) =
          Cpu.Regs(Integer(Shift_Right(Op, 4) and 16#F#)) =>
          Cpu.PC = Cpu.PC'Old + 2);
   
   procedure Handler_A (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#A000#,
     Post => Cpu.I = Op mod 16#1000# and then Cpu.PC = Cpu.PC'Old + 2;
   
   procedure Handler_B (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#B000#,
     Post => Cpu.PC = (Op mod 16#1000#) + Word(Cpu.Regs(0));
   
   procedure Handler_C (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#C000#,
     Post => Cpu.PC = Cpu.PC'Old + 2;
   
   procedure Handler_D (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#D000#,
     Post => Cpu.PC = Cpu.PC'Old + 2;
   
   procedure Handler_E (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#E000#
     and then (Op mod 16#100# = 16#9E# or Op mod 16#100# = 16#A1#),
     Post => Cpu.PC >= Cpu.PC'Old + 2 and then
     Cpu.Keys(Integer(Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)))) = False;
   
   procedure Handler_F (Cpu : in out Chip8; Op : Opcode)
     with Pre => (Op and 16#F000#) = 16#F000#
     and then (Op mod 16#100# = 16#07# or Op mod 16#100# = 16#0A#
               or Op mod 16#100# = 16#15# or Op mod 16#100# = 16#18#
               or Op mod 16#100# = 16#1E# or Op mod 16#100# = 16#29#
               or Op mod 16#100# = 16#33# or Op mod 16#100# = 16#55#
               or Op mod 16#100# = 16#65#),
     Post => Cpu.PC = Cpu.PC'Old + 2,
     Contract_Cases =>
       (Op mod 16#100# = 16#07# =>
          Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) = Cpu.Delay_Timer,
        Op mod 16#100# = 16#0A# => True,
        Op mod 16#100# = 16#15# => Cpu.Delay_Timer =
          Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)),
        Op mod 16#100# = 16#18# => Cpu.Sound_Timer =
          Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)),
        Op mod 16#100# = 16#1E# => Cpu.I = Cpu.I'Old +
          Word(Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#))),
        Op mod 16#100# = 16#29# => Cpu.I =
          Word(Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#))) * 5,
        Op mod 16#100# = 16#33# => Cpu.Mem(Cpu.I) =
              Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) / 100
        and then Cpu.Mem(Cpu.I + 1) =
              Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) / 10 mod 10
        and then Cpu.Mem(Cpu.I + 2) =
              Cpu.Regs(Integer(Shift_Right(Op, 8) and 16#F#)) mod 10,
        Op mod 16#100# = 16#55# => True,
        Op mod 16#100# = 16#65# => True);
   
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
