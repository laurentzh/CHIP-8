with BMP_Fonts;
with HAL.Bitmap; use HAL.Bitmap;
with HAL.Framebuffer; use HAL.Framebuffer;
with Inputs; use Inputs;
with LCD_Std_Out;
with STM32.Board; use STM32.Board;
with Interfaces; use Interfaces;

package body Gfx is
   
   procedure Initialize is
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
   end Initialize;
   
   procedure Draw_Keyboard(Mem : Memory) is
      Nibble : Byte;
   begin
      for Y in Layout_Array'Range(1) loop
         for X in Layout_Array'Range(2) loop
            for I in 0 .. 4 loop
               Nibble := Shift_Right(Mem(Word(5 * Layout(Y, X) + I)), 4);
               for J in 0 .. 3 loop
                  if (Shift_Right(Nibble, 3 - J) and 1) = 1 then
                     Draw_Key_Pixel(X * 40 + J, 160 + 40 * Y + I);
                  end if;
               end loop;
            end loop;
         end loop;
      end loop;
      Display.Update_Layer(1, False);
   end Draw_Keyboard;
   
   procedure Draw_Key_Pixel(X : Integer; Y : Integer) is
   begin
      Display.Hidden_Buffer(1).Set_Source(White);
      Display.Hidden_Buffer(1).Set_Pixel((X, Y));
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
