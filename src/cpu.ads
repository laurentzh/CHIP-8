with Stack; use Stack;
with Types; use Types;

package Cpu is
   type Chip8 is record
      
      Mem : Memory;
      Regs : Registers;
   
      I : Address;
      PC : Address;
      
      Stack : Stack_Record;
   
      Delay_Timer : Byte;
      Sound_Timer : Byte;
   
      Screen : Display;
      Keys : Keys_List;

   end record;
end Cpu;
