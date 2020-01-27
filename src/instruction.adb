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
   
   procedure Execute (Op : Opcode) is
   begin
      null;
   end Execute;

end instruction;
