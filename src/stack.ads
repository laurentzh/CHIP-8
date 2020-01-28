with Interfaces; use Interfaces;
with Types; use Types;

package Stack is
   
   Stack_Capacity : constant Natural := 16;   
   subtype Stack_Range is Natural range 0 .. Stack_Capacity - 1;
   type Stack_Elements is array (Stack_Range) of Address;

   type Stack_Record is record
      Arr : Stack_Elements;
      Size : Natural;
   end record;
   
   procedure Push_Stack(Stack : in out Stack_Record; Element : Address)
     with Pre => Stack.Size < Stack_Capacity,
     Post => Stack.Size <= Stack_Capacity
     and then Stack.Size = Stack.Size'Old + 1;
   
   function Pop_Stack(Stack : in out Stack_Record) return Address
     with Pre => Stack.Size > 0,
     Post => Stack.Size = Stack.Size'Old - 1
     and then Pop_Stack'Result = Stack.Arr(Stack.Size);
   
   function Peek_Stack(Stack : Stack_Record) return Address
     with Pre => Stack.Size > 0,
     Post => Peek_Stack'Result = Stack.Arr(Stack.Size - 1);
   
end Stack;
