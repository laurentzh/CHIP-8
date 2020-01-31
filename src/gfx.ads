with Types; use Types;

package Gfx is
   
   procedure Init_Draw;
   procedure Draw_Keyboard(Mem : Memory);
   procedure Draw_Key(Mem : Memory; X : Integer; Y : Integer);
   procedure Draw_Key_Pixel(X : Integer; Y : Integer);
   procedure Draw_Pixel(X : Integer; Y : Integer; Pixel : Boolean);
   procedure Clear_Layer(Layer : Integer);

end Gfx;
