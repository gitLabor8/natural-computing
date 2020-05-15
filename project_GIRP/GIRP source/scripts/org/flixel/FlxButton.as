package org.flixel
{
   import flash.events.MouseEvent;
   
   public class FlxButton extends FlxGroup
   {
       
      
      public var pauseProof:Boolean;
      
      protected var _onToggle:Boolean;
      
      protected var _off:FlxSprite;
      
      protected var _on:FlxSprite;
      
      protected var _offT:FlxText;
      
      protected var _onT:FlxText;
      
      protected var _callback:Function;
      
      protected var _pressed:Boolean;
      
      protected var _initialized:Boolean;
      
      protected var _sf:FlxPoint;
      
      public function FlxButton(param1:int, param2:int, param3:Function)
      {
         super();
         x = param1;
         y = param2;
         width = 100;
         height = 20;
         _off = new FlxSprite().createGraphic(width,height,4286545791);
         _off.solid = false;
         add(_off,true);
         _on = new FlxSprite().createGraphic(width,height,4294967295);
         _on.solid = false;
         add(_on,true);
         _offT = null;
         _onT = null;
         _callback = param3;
         _onToggle = false;
         _pressed = false;
         _initialized = false;
         _sf = null;
         pauseProof = false;
      }
      
      public function loadGraphic(param1:FlxSprite, param2:FlxSprite = null) : FlxButton
      {
         _off = replace(_off,param1) as FlxSprite;
         if(param2 == null)
         {
            if(_on != _off)
            {
               remove(_on);
            }
            _on = _off;
         }
         else
         {
            _on = replace(_on,param2) as FlxSprite;
         }
         var _loc3_:Boolean = false;
         _off.solid = _loc3_;
         _on.solid = _loc3_;
         _off.scrollFactor = scrollFactor;
         _on.scrollFactor = scrollFactor;
         width = _off.width;
         height = _off.height;
         refreshHulls();
         return this;
      }
      
      public function loadText(param1:FlxText, param2:FlxText = null) : FlxButton
      {
         if(param1 != null)
         {
            if(_offT == null)
            {
               _offT = param1;
               add(_offT);
            }
            else
            {
               _offT = replace(_offT,param1) as FlxText;
            }
         }
         if(param2 == null)
         {
            _onT = _offT;
         }
         else if(_onT == null)
         {
            _onT = param2;
            add(_onT);
         }
         else
         {
            _onT = replace(_onT,param2) as FlxText;
         }
         _offT.scrollFactor = scrollFactor;
         _onT.scrollFactor = scrollFactor;
         return this;
      }
      
      override public function update() : void
      {
         if(!_initialized)
         {
            if(FlxG.stage != null)
            {
               FlxG.stage.addEventListener("mouseUp",onMouseUp);
               _initialized = true;
            }
         }
         super.update();
         visibility(false);
         if(overlapsPoint(FlxG.mouse.x,FlxG.mouse.y))
         {
            if(!FlxG.mouse.pressed())
            {
               _pressed = false;
            }
            else if(!_pressed)
            {
               _pressed = true;
            }
            visibility(!_pressed);
         }
         if(_onToggle)
         {
            visibility(_off.visible);
         }
      }
      
      public function get on() : Boolean
      {
         return _onToggle;
      }
      
      public function set on(param1:Boolean) : void
      {
         _onToggle = param1;
      }
      
      override public function destroy() : void
      {
         if(FlxG.stage != null)
         {
            FlxG.stage.removeEventListener("mouseUp",onMouseUp);
         }
      }
      
      protected function visibility(param1:Boolean) : void
      {
         if(param1)
         {
            _off.visible = false;
            if(_offT != null)
            {
               _offT.visible = false;
            }
            _on.visible = true;
            if(_onT != null)
            {
               _onT.visible = true;
            }
         }
         else
         {
            _on.visible = false;
            if(_onT != null)
            {
               _onT.visible = false;
            }
            _off.visible = true;
            if(_offT != null)
            {
               _offT.visible = true;
            }
         }
      }
      
      protected function onMouseUp(param1:MouseEvent) : void
      {
         if(!exists || !visible || !active || !FlxG.mouse.justReleased() || FlxG.pause && !pauseProof || _callback == null)
         {
            return;
         }
         if(overlapsPoint(FlxG.mouse.x,FlxG.mouse.y))
         {
            _callback();
         }
      }
   }
}
