with Types; use Types;

package instruction is
   
   subtype Opcode is Word;
   
   function Fetch (Mem : Memory; Addr : Address) return Opcode;
   procedure Execute (Op : Opcode);
   
end instruction;
