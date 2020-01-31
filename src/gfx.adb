with BMP_Fonts;
with HAL.Bitmap; use HAL.Bitmap;
with HAL.Framebuffer; use HAL.Framebuffer;
with Inputs; use Inputs;
with LCD_Std_Out;
with STM32.Board; use STM32.Board;
with Interfaces; use Interfaces;

package body Gfx is
   
   procedure Init_Draw is
   begin
      -- Initialize LCD
      Display.Initialize;
      Display.Initialize_Layer(1, ARGB_8888);
      Display.Initialize_Layer(2, ARGB_8888);
      Display.Set_Orientation(Landscape);
      
      -- Set Background color
      LCD_Std_Out.Set_Font (BMP_Fonts.Font8x8);
      LCD_Std_Out.Current_Background_Color := Black;
    
      Clear_Layer(1);
      Clear_Layer(2);
      
      -- Apply color
      LCD_Std_Out.Clear_Screen;
   end Init_Draw;
   
   procedure Draw_Keyboard(Mem : Memory) is
   begin
      for Y in Layout_Array'Range(1) loop
         for X in Layout_Array'Range(2) loop
            Draw_Key(Mem, X, Y);
         end loop;
      end loop;
      Display.Update_Layer(1, False);
   end Draw_Keyboard;
   
   procedure Draw_Key(Mem : Memory; X : Integer; Y : Integer) is
      Nibble : Byte;
   begin
      for I in 0 .. 4 loop
         Nibble := Shift_Right(Mem(Word(5 * Layout(Y, X) + I)), 4);
         for J in 0 .. 3 loop
            if (Shift_Right(Nibble, 3 - J) and 1) = 1 then
               Draw_Key_Pixel(X * 40 + J * 3 + 16, 160 + 40 * Y + I * 3 + 12);
            end if;
         end loop;
      end loop;
   end Draw_Key;
   
   procedure Draw_Key_Pixel(X : Integer; Y : Integer) is
      Pt : constant Point := (X, Y);
      Rct : constant Rect := (Pt, 3, 3);
   begin
      Display.Hidden_Buffer(1).Set_Source(White);
      Display.Hidden_Buffer(1).Fill_Rect(Rct);
   end Draw_Key_Pixel;

   procedure Draw_Pixel(X : Integer; Y : Integer; Pixel : Boolean) is
      Color : constant Bitmap_Color := (if Pixel then White else Transparent);
      Pt : constant Point := (X * 5, Y * 5);
      Rct : constant Rect := (Pt, 5, 5);
   begin
      Display.Hidden_Buffer(2).Set_Source(Color);
      Display.Hidden_Buffer(2).Fill_Rect(Rct);
   end Draw_Pixel;
   
   procedure Clear_Layer(Layer : Integer) is
   begin
      Display.Hidden_Buffer(Layer).Set_Source(Transparent);
      Display.Hidden_Buffer(Layer).Fill;
      Display.Hidden_Buffer(Layer).Set_Source(White);
   end Clear_Layer;
   
end Gfx;
