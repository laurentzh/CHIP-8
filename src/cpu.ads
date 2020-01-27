with Types; use Types;

package Cpu is
   type Chip8 is record
      
      Mem : Memory;
      --Regs : Registers;
   
      I : Address;
      PC: Address;
      
      --Stack : Stack;
      Stack_Pointer : Address;
   
      Delay_Timer : Byte;
      Sound_Timer : Byte;
   
      --Screen : Pixels_Array;
      --Keys : Keys_List;

   end record;
end Cpu;
