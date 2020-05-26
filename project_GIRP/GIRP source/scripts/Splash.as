package
{
   import org.flixel.FlxSprite;
   
   public class Splash extends FlxSprite
   {
       
      
      private var ImgSmoke:Class;
      
      public function Splash(param1:Number, param2:Number)
      {
         ImgSmoke = §smoke_png$1e8d492cc895b12520bfe9ca77cfb495-2123087294§;
         super(param1,param2);
         loadGraphic(ImgSmoke,false,false,16,16);
         addAnimation("loop",[0,1,2,3],10,false);
      }
      
      override public function onEmit() : void
      {
         super.onEmit();
         play("loop");
      }
   }
}
