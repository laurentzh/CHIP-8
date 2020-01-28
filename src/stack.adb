package body Stack is

   procedure Push_Stack(Stack : in out Stack_Record; Element : Address) is
   begin
      Stack.Arr(Stack.Size) := Element;
      Stack.Size := Stack.Size + 1;
   end Push_Stack;
   
   function Pop_Stack(Stack : in out Stack_Record) return Address is
   begin
      Stack.Size := Stack.Size - 1;
      return Stack.Arr(Stack.Size);
   end Pop_Stack;
   
   function Peek_Stack(Stack : Stack_Record) return Address is
   begin
      return Stack.Arr(Stack.Size - 1);
   end Peek_Stack;

end Stack;
