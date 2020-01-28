with Interfaces; use Interfaces;
with Stack; use Stack;

package body Instruction is

   function Fetch (Mem : Memory; Addr : Address) return Opcode is
      Op : Opcode;
   begin
      Op := Word(Mem(Addr));
      Op := Shift_Left(Op, 8);
      Op := Op + Word(Mem(Addr + 1));
      return Op;
   end Fetch;
   
   procedure Execute (Cpu : in out Chip8; Op : Opcode) is
      I : Integer;
   begin
      I := Integer(Shift_Right(Op, 12));
      Instr_Handlers(I)(Cpu, Op);
   end Execute;
   
   procedure Handler_0 (Cpu : in out Chip8; Op : Opcode) is
      N : Address;
   begin
      case Op is
         when 16#00E0# =>
            -- clear the screen
            null;
         when 16#00EE# =>
            -- return from subroutine
            Cpu.PC := Pop_Stack(Cpu.Stack);
         when others =>
            N := Op mod 16#1000#;
            null;
      end case;
   end Handler_0;
   
   procedure Handler_1 (Cpu : in out Chip8; Op : Opcode) is
      N : Address;
   begin
      N := Op mod 16#1000#;
      
      Cpu.PC := N;
   end Handler_1;
   
   procedure Handler_2 (Cpu : in out Chip8; Op : Opcode) is
      N : Address;
   begin
      N := Op mod 16#1000#;
      
      Push_Stack(Cpu.Stack, Cpu.PC);
      Cpu.PC := N;
   end Handler_2;

   procedure Handler_3 (Cpu : in out Chip8; Op : Opcode) is
      X : Byte;
      N : Integer;
   begin
      X := Byte(Op and 16#F00#);
      N := Integer(Op mod 16#100#);
      
      if Cpu.Regs(N) = X then
         Cpu.PC := Cpu.PC + 2;
      end if;
      
      Cpu.PC := Cpu.PC + 2;
   end Handler_3;
   
   procedure Handler_4 (Cpu : in out Chip8; Op : Opcode) is
      X : Byte;
      N : Integer;
   begin
      X := Byte(Op and 16#F00#);
      N := Integer(Op mod 16#100#);
      
      if Cpu.Regs(N) /= X then
         Cpu.PC := Cpu.PC + 2;
      end if;
      
      Cpu.PC := Cpu.PC + 2;
   end Handler_4;
   
   procedure Handler_5 (Cpu : in out Chip8; Op : Opcode) is
      X : Integer;
      Y : Integer;
   begin
      X := Integer(Op and 16#F00#);
      Y := Integer(Op and 16#F0#);
      
      if Cpu.Regs(X) = Cpu.Regs(Y) then
         Cpu.PC := Cpu.PC + 2;
      end if;
      
      Cpu.PC := Cpu.PC + 2;
   end Handler_5;
   
   procedure Handler_6 (Cpu : in out Chip8; Op : Opcode) is
      X : Integer;
      N : Byte;
   begin
      X := Integer(Op and 16#F00#);
      N := Byte(Op mod 16#100#);
      
      Cpu.Regs(X) := N;
      Cpu.PC := Cpu.PC + 2;
   end Handler_6;
   
   procedure Handler_7 (Cpu : in out Chip8; Op : Opcode) is
      X : Integer;
      N : Byte;
   begin
      X := Integer(Op and 16#F00#);
      N := Byte(Op mod 16#100#);
      
      Cpu.Regs(X) := Cpu.Regs(X) + N;
      Cpu.PC := Cpu.PC + 2;
   end Handler_7;
   
   procedure Handler_8 (Cpu : in out Chip8; Op : Opcode) is
      X : Integer;
      Y : Integer;
   begin
      X := Integer(Op and 16#F00#);
      Y := Integer(Op and 16#F0#);
      
      case Op mod 16#10# is
         when 0 =>
            Cpu.Regs(X) := Cpu.Regs(Y);
         when 1 =>
            Cpu.Regs(X) := Cpu.Regs(X) or Cpu.Regs(Y);
         when 2 =>
            Cpu.Regs(X) := Cpu.Regs(X) and Cpu.Regs(Y);
         when 3 =>
            Cpu.Regs(X) := Cpu.Regs(X) xor Cpu.Regs(Y);
         when 4 =>
            if Cpu.Regs(X) > Byte'Last - Cpu.Regs(Y) then
               Cpu.Regs(16#F#) := 1;
            else
               Cpu.Regs(16#F#) := 0;
            end if;
            Cpu.Regs(X) := Cpu.Regs(X) + Cpu.Regs(Y);
         when 5 =>
            if Cpu.Regs(X) < Cpu.Regs(Y) then
               Cpu.Regs(16#F#) := 1;
            else
               Cpu.Regs(16#F#) := 0;
            end if;
            Cpu.Regs(X) := Cpu.Regs(X) - Cpu.Regs(Y);
         when 6 =>
            Cpu.Regs(16#F#) := Cpu.Regs(X) and 1;
            Cpu.Regs(X) := Shift_Right(Cpu.Regs(X), 1);
         when 7 =>
            if Cpu.Regs(Y) < Cpu.Regs(X) then
               Cpu.Regs(16#F#) := 1;
            else
               Cpu.Regs(16#F#) := 0;
            end if;
            Cpu.Regs(X) := Cpu.Regs(Y) - Cpu.Regs(X);
         when 16#E# =>
            Cpu.Regs(16#F#) := Cpu.Regs(X) and 16#80#;
            Cpu.Regs(X) := Shift_Left(Cpu.Regs(X), 1);
         when others =>
            -- error
            null;
      end case;
      
      Cpu.PC := Cpu.PC + 2;
   end Handler_8;
   
   procedure Handler_9 (Cpu : in out Chip8; Op : Opcode) is
      X : Integer;
      Y : Integer;
   begin
      X := Integer(Op and 16#F00#);
      Y := Integer(Op and 16#F0#);
      
      if Cpu.Regs(X) /= Cpu.Regs(Y) then
         Cpu.PC := Cpu.PC + 2;
      end if;
      
      Cpu.PC := Cpu.PC + 2;
   end Handler_9;
   
   procedure Handler_A (Cpu : in out Chip8; Op : Opcode) is
      N : Address;
   begin
      N := Op mod 16#1000#;
      Cpu.I := N;
   end Handler_A;
   
   procedure Handler_B (Cpu : in out Chip8; Op : Opcode) is
      N : Address;
   begin
      N := Op mod 16#1000#;
      Cpu.PC := N + Word(Cpu.Regs(0));
   end Handler_B;
   
   procedure Handler_C (Cpu : in out Chip8; Op : Opcode) is
      X : Word;
      N : Word;
   begin
      X := Op and 16#F00#;
      N := Op mod 16#100#;
      -- random
      null;
   end Handler_C;
   
   procedure Handler_D (Cpu : in out Chip8; Op : Opcode) is
      X : Word;
      Y : Word;
   begin
      X := Op and 16#F00#;
      Y := Op and 16#F0#;
      -- draw
      null;
   end Handler_D;
   
   procedure Handler_E (Cpu : in out Chip8; Op : Opcode) is
      X : Integer;
      I : Integer;
   begin
      X := Integer(Op and 16#F00#);
      I := Integer(Cpu.Regs(X));
      
      case Op mod 16#100# is
         when 16#9E# =>
            if Cpu.Keys(I) then
               Cpu.PC := Cpu.PC + 2;
            end if;
         when 16#A1# =>
            if not Cpu.Keys(I) then
               Cpu.PC := Cpu.PC + 2;
            end if;
         when others =>
            -- error
            null;
      end case;
      
      Cpu.PC := Cpu.PC + 2;
   end Handler_E;
   
   procedure Handler_F (Cpu : in out Chip8; Op : Opcode) is
      subtype Regs is Integer range 0 .. 15;
      
      X : Integer;
   begin
      X := Integer(Op and 16#F00#);
      
      case Op mod 16#100# is
         when 16#07# =>
            Cpu.Regs(X) := Cpu.Delay_Timer;
         when 16#0A# =>
            -- key
            null;
         when 16#15# =>
            Cpu.Delay_Timer := Cpu.Regs(X);
         when 16#18# =>
            Cpu.Sound_Timer := Cpu.Regs(X);
         when 16#1E# =>
            Cpu.I := Cpu.I + Word(Cpu.Regs(X));
         when 16#29# =>
            -- sprite
            null;
         when 16#33# =>
            -- bcd
            null;
         when 16#55# =>
            for I in Regs loop
               Cpu.Mem(Cpu.I + Word(I)) := Cpu.Regs(I);
            end loop;
         when 16#65# =>
            for I in Regs loop
               Cpu.Regs(I) := Cpu.Mem(Cpu.I + Word(I));
            end loop;
         when others =>
            -- error
            null;
      end case;
   end Handler_F;
   
end Instruction;
