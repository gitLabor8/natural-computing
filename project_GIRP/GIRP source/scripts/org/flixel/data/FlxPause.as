package org.flixel.data
{
   import org.flixel.FlxG;
   import org.flixel.FlxGroup;
   import org.flixel.FlxSprite;
   import org.flixel.FlxText;
   
   public class FlxPause extends FlxGroup
   {
       
      
      private var ImgKeyMinus:Class;
      
      private var ImgKeyPlus:Class;
      
      private var ImgKey0:Class;
      
      private var ImgKeyP:Class;
      
      public var _resumeKey:String;
      
      public var _focus:Boolean;
      
      private var _resumeText:FlxText;
      
      public function FlxPause()
      {
         var _loc2_:* = null;
         ImgKeyMinus = key_minus_png$01a584528204ff7e340ed66930d0244e404822873;
         ImgKeyPlus = key_plus_png$ef8080a89a3d1d6970aca137802fbd371620365927;
         ImgKey0 = §key_0_png$e7dc1dcf1bf8bf92302624f4e08fc8c3-844407655§;
         ImgKeyP = §key_p_png$8b22b8da96d25a9c95fd565893066286-902464423§;
         super();
         _focus = true;
         _resumeKey = "R";
         scrollFactor.x = 0;
         scrollFactor.y = 0;
         var _loc1_:uint = 360;
         var _loc3_:uint = 92;
         x = (FlxG.width - _loc1_) / 2;
         y = (FlxG.height - _loc3_) / 2;
         _loc2_ = new FlxSprite().createGraphic(_loc1_,_loc3_,4294967295,true);
         _loc2_.solid = false;
         add(_loc2_,true);
         add(new FlxText(0,30,_loc1_,"PAUSED",true).setFormat("NES",16,0,"center"),true);
         _loc2_ = new FlxSprite(4,56,ImgKeyP);
         _loc2_.solid = false;
         add(_loc2_,true);
         _resumeText = new FlxText(0,46,_loc1_,"FIRST CLICK TO RESUME",true).setFormat("NES",8,0,"center");
         add(_resumeText,true);
      }
      
      override public function update() : void
      {
         if(_focus)
         {
            _resumeText.text = "NOW PRESS " + _resumeKey + " TO RESUME";
         }
         if(!_focus)
         {
            _resumeText.text = "FIRST CLICK TO RESUME";
         }
         super.update();
      }
   }
}
