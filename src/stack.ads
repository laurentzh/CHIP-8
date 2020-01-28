with Types; use Types;

package Stack is
   Stack_Capacity : constant Natural := 16;   
   type Stack_Range is range 0 .. Stack_Capacity - 1;
   type Stack_Elements is array (Stack_Range) of Byte;

   type Stack_Record is record
      Arr : Stack_Elements;
      Size : Stack_Range;
   end record;
   
   procedure Push_Stack(Stack : in out Stack_Record; Element : Byte);
   
   function Pop_Stack(Stack : in out Stack_Record) return Address;
   
   function Peek_Stack(Stack : Stack_Record) return Address;
end Stack;
