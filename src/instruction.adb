with Ada.Numerics.Discrete_Random;
with Gfx;
with Interfaces; use Interfaces;
with Stack; use Stack;
with STM32.Board; use STM32.Board;

package body Instruction is

   function Fetch (Cpu : Chip8) return Opcode is
      Op : Opcode;
   begin
      Op := Word(Cpu.Mem(Cpu.PC));
      Op := Shift_Left(Op, 8);
      Op := Op + Word(Cpu.Mem(Cpu.PC + 1));
      return Op;
   end Fetch;
   
   procedure Execute (Cpu : in out Chip8; Op : Opcode) is
      I : Integer;
   begin
      I := Integer(Shift_Right(Op, 12));
      Instr_Handlers(I)(Cpu, Op);
   end Execute;
   
   procedure Handler_0 (Cpu : in out Chip8; Op : Opcode) is
      N : constant Address := Op mod 16#1000#;
   begin
      case Op is
         when 16#00E0# =>
            -- clear the screen
            Cpu.Screen := (others => (others => False));
            Gfx.Clear;
            Display.Update_Layer(1, True);
            Cpu.PC := Cpu.PC + 2;
         when 16#00EE# =>
            Cpu.PC := Pop_Stack(Cpu.Stack);
         when others =>
            Cpu.PC := N;
      end case;
   end Handler_0;

   procedure Handler_1 (Cpu : in out Chip8; Op : Opcode) is
      N : constant Address := Op mod 16#1000#;
   begin
      Cpu.PC := N;
   end Handler_1;
   
   procedure Handler_2 (Cpu : in out Chip8; Op : Opcode) is
      N : constant Address := Op mod 16#1000#;
   begin
      Push_Stack(Cpu.Stack, Cpu.PC);
      Cpu.PC := N;
   end Handler_2;

   procedure Handler_3 (Cpu : in out Chip8; Op : Opcode) is
      X : constant Integer := Integer(Shift_Right(Op, 8) and 16#F#);
      N : constant Byte := Byte(Op mod 16#100#);
   begin
      if Cpu.Regs(X) = N then
         Cpu.PC := Cpu.PC + 2;
      end if;
      Cpu.PC := Cpu.PC + 2;
   end Handler_3;
   
   procedure Handler_4 (Cpu : in out Chip8; Op : Opcode) is
      X : constant Integer := Integer(Shift_Right(Op, 8) and 16#F#);
      N : constant Byte := Byte(Op mod 16#100#);
   begin
      if Cpu.Regs(X) /= N then
         Cpu.PC := Cpu.PC + 2;
      end if;
      Cpu.PC := Cpu.PC + 2;
   end Handler_4;
   
   procedure Handler_5 (Cpu : in out Chip8; Op : Opcode) is
      X : constant Integer := Integer(Shift_Right(Op, 8) and 16#F#);
      Y : constant Integer := Integer(Shift_Right(Op, 4) and 16#F#);
   begin
      if Cpu.Regs(X) = Cpu.Regs(Y) then
         Cpu.PC := Cpu.PC + 2;
      end if;
      Cpu.PC := Cpu.PC + 2;
   end Handler_5;
   
   procedure Handler_6 (Cpu : in out Chip8; Op : Opcode) is
      X : constant Integer := Integer(Shift_Right(Op, 8) and 16#F#);
      N : constant Byte := Byte(Op mod 16#100#);
   begin
      Cpu.Regs(X) := N;
      Cpu.PC := Cpu.PC + 2;
   end Handler_6;
   
   procedure Handler_7 (Cpu : in out Chip8; Op : Opcode) is
      X : constant Integer := Integer(Shift_Right(Op, 8) and 16#F#);
      N : constant Byte := Byte(Op mod 16#100#);
   begin
      Cpu.Regs(X) := Cpu.Regs(X) + N;
      Cpu.PC := Cpu.PC + 2;
   end Handler_7;
   
   procedure Handler_8 (Cpu : in out Chip8; Op : Opcode) is
      X : constant Integer := Integer(Shift_Right(Op, 8) and 16#F#);
      Y : constant Integer := Integer(Shift_Right(Op, 4) and 16#F#);
   begin
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
      X : constant Integer := Integer(Shift_Right(Op, 8) and 16#F#);
      Y : constant Integer := Integer(Shift_Right(Op, 4) and 16#F#);
   begin
      if Cpu.Regs(X) /= Cpu.Regs(Y) then
         Cpu.PC := Cpu.PC + 2;
      end if;
      Cpu.PC := Cpu.PC + 2;
   end Handler_9;
   
   procedure Handler_A (Cpu : in out Chip8; Op : Opcode) is
      N : constant Address := Op mod 16#1000#;
   begin
      Cpu.I := N;
      Cpu.PC := Cpu.PC + 2;
   end Handler_A;
   
   procedure Handler_B (Cpu : in out Chip8; Op : Opcode) is
      N : constant Address := Op mod 16#1000#;
   begin
      Cpu.PC := N + Word(Cpu.Regs(0));
   end Handler_B;
   
   procedure Handler_C (Cpu : in out Chip8; Op : Opcode) is
      package Random_Byte is new Ada.Numerics.Discrete_Random (Byte);
      use Random_Byte;
      
      G : Generator;
      X : constant Integer := Integer(Shift_Right(Op, 8) and 16#F#);
      N : constant Byte := Byte(Op mod 16#100#);
   begin
      Reset(G);
      Cpu.Regs(X) := Random(G) and N;
      Cpu.PC := Cpu.PC + 2;
   end Handler_C;
   
   procedure Handler_D (Cpu : in out Chip8; Op : Opcode) is
      X : constant Integer := Integer(Shift_Right(Op, 8) and 16#F#);
      Y : constant Integer := Integer(Shift_Right(Op, 4) and 16#F#);
      Height : constant Integer := Integer(Op mod 16#10#);
      Pixel : Byte;
   begin
      -- Reset VF
      Cpu.Regs(15) := 0;
      for Y_Line in 0 .. Height - 1 loop
         Pixel := Cpu.Mem(Cpu.I + Word(Y_Line));
         for X_Line in 0 .. 7 loop
            if (Pixel and Shift_Right(16#80#, X_Line)) /= 0 then
               declare
                  X_Reg : constant Integer := Integer(Cpu.Regs(X));
                  Y_Reg : constant Integer := Integer(Cpu.Regs(Y));
                  Pos_X : constant Integer := (X_Reg + X_Line) mod Gfx.Screen_Width;
                  Pos_Y : constant Integer := (Y_Reg + Y_Line) mod Gfx.Screen_Height;
                  Tmp : constant Boolean := Cpu.Screen(Pos_Y, Pos_X);
               begin
                  if Tmp then
                     Cpu.Regs(15) := 1;
                  end if;
                  Cpu.Screen(Pos_Y, Pos_X) := Tmp xor True;
                  Gfx.Draw_Pixel(Pos_X, Pos_Y, Cpu.Screen(Pos_Y, Pos_X));
               end;
            end if;
         end loop;
      end loop;
      Cpu.PC := Cpu.PC + 2;
      Display.Update_Layer(1, True);
   end Handler_D;
   
   procedure Handler_E (Cpu : in out Chip8; Op : Opcode) is
      X : constant Integer := Integer(Shift_Right(Op, 8) and 16#F#);
      I : constant Integer := Integer(Cpu.Regs(X));
   begin
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
      X : constant Integer := Integer(Shift_Right(Op, 8) and 16#F#);
   begin
      case Op mod 16#100# is
         when 16#07# =>
            Cpu.Regs(X) := Cpu.Delay_Timer;
         when 16#0A# =>
            for I in Cpu.Keys'Range loop
               if Cpu.Keys(I) then
                  Cpu.Regs(X) := Byte(I);
                  Cpu.PC := Cpu.PC + 2;
                  return;
               end if;
            end loop;
            return;
         when 16#15# =>
            Cpu.Delay_Timer := Cpu.Regs(X);
         when 16#18# =>
            Cpu.Sound_Timer := Cpu.Regs(X);
         when 16#1E# =>
            Cpu.I := Cpu.I + Word(Cpu.Regs(X));
         when 16#29# =>
            Cpu.I := Word(Cpu.Regs(X)) * 5;
         when 16#33# =>
            Cpu.Mem(Cpu.I) := Cpu.Regs(X) / 100;
            Cpu.Mem(Cpu.I + 1) := Cpu.Regs(X) / 10 mod 10;
            Cpu.Mem(Cpu.I + 2) := Cpu.Regs(X) mod 10;
         when 16#55# =>
            for I in Cpu.Regs'Range loop
               Cpu.Mem(Cpu.I + Word(I)) := Cpu.Regs(I);
            end loop;
         when 16#65# =>
            for I in Cpu.Regs'Range loop
               Cpu.Regs(I) := Cpu.Mem(Cpu.I + Word(I));
            end loop;
         when others =>
            -- error
            null;
      end case;
      Cpu.PC := Cpu.PC + 2;
   end Handler_F;
   
end Instruction;
