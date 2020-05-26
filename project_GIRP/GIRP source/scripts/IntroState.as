package
{
   import org.flixel.FlxG;
   import org.flixel.FlxSprite;
   import org.flixel.FlxState;
   
   public class IntroState extends FlxState
   {
       
      
      private var ImgTitle:Class;
      
      private var Focus:Boolean;
      
      private var Flashed:Boolean;
      
      public function IntroState()
      {
         ImgTitle = §title_png$131e92d6d7f73ee273dcbf06709c0c9c-2107636165§;
         super();
         Focus = false;
         FlxG.mouse.show();
         Flashed = false;
         var _loc1_:FlxSprite = new FlxSprite(0,0,ImgTitle);
         add(_loc1_);
      }
      
      override public function update() : void
      {
         if(FlxG.mouse.justPressed() && !Focus)
         {
            Focus = true;
            FlxG.fade.start(4278190080,0.5,onFade);
            FlxG.mouse.hide();
         }
         super.update();
      }
      
      private function onFade() : void
      {
         FlxG.state = new PlayState();
      }
   }
}
