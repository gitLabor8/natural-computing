package org.flixel
{
   import flash.display.Sprite;
   
   public class FlxState extends Sprite
   {
      
      public static var screen:FlxSprite;
      
      public static var bgColor:uint;
       
      
      public var defaultGroup:FlxGroup;
      
      public function FlxState()
      {
         super();
         defaultGroup = new FlxGroup();
         if(screen == null)
         {
            screen = new FlxSprite();
            screen.createGraphic(FlxG.width,FlxG.height,0,true);
            var _loc1_:int = 0;
            screen.origin.y = _loc1_;
            screen.origin.x = _loc1_;
            screen.antialiasing = true;
            screen.exists = false;
            screen.solid = false;
            screen.fixed = true;
         }
      }
      
      public function create() : void
      {
      }
      
      public function add(param1:FlxObject) : FlxObject
      {
         return defaultGroup.add(param1);
      }
      
      public function preProcess() : void
      {
         screen.fill(bgColor);
      }
      
      public function update() : void
      {
         defaultGroup.update();
      }
      
      public function collide() : void
      {
         FlxU.collide(defaultGroup,defaultGroup);
      }
      
      public function render() : void
      {
         defaultGroup.render();
      }
      
      public function postProcess() : void
      {
      }
      
      public function destroy() : void
      {
         defaultGroup.destroy();
      }
   }
}
