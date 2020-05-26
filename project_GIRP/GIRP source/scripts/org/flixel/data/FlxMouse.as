package org.flixel.data
{
   import flash.events.MouseEvent;
   import org.flixel.FlxSprite;
   import org.flixel.FlxU;
   
   public class FlxMouse
   {
       
      
      protected var ImgDefaultCursor:Class;
      
      public var x:int;
      
      public var y:int;
      
      public var wheel:int;
      
      public var screenX:int;
      
      public var screenY:int;
      
      public var cursor:FlxSprite;
      
      protected var _current:int;
      
      protected var _last:int;
      
      protected var _out:Boolean;
      
      public function FlxMouse()
      {
         ImgDefaultCursor = cursor_png$ef0c22bd0544adcfb8829f6edc757d191412764363;
         super();
         x = 0;
         y = 0;
         screenX = 0;
         screenY = 0;
         _current = 0;
         _last = 0;
         cursor = null;
         _out = false;
      }
      
      public function show(param1:Class = null, param2:int = 0, param3:int = 0) : void
      {
         _out = true;
         if(param1 != null)
         {
            load(param1,param2,param3);
         }
         else if(cursor != null)
         {
            cursor.visible = true;
         }
         else
         {
            load(null);
         }
      }
      
      public function hide() : void
      {
         if(cursor != null)
         {
            cursor.visible = false;
            _out = false;
         }
      }
      
      public function load(param1:Class, param2:int = 0, param3:int = 0) : void
      {
         if(param1 == null)
         {
            param1 = ImgDefaultCursor;
         }
         cursor = new FlxSprite(screenX,screenY,param1);
         cursor.solid = false;
         cursor.offset.x = param2;
         cursor.offset.y = param3;
      }
      
      public function unload() : void
      {
         if(cursor != null)
         {
            if(cursor.visible)
            {
               load(null);
            }
            else
            {
               cursor = null;
            }
         }
      }
      
      public function update(param1:int, param2:int, param3:Number, param4:Number) : void
      {
         screenX = param1;
         screenY = param2;
         x = screenX - FlxU.floor(param3);
         y = screenY - FlxU.floor(param4);
         if(cursor != null)
         {
            cursor.x = x;
            cursor.y = y;
         }
         if(_last == -1 && _current == -1)
         {
            _current = 0;
         }
         else if(_last == 2 && _current == 2)
         {
            _current = 1;
         }
         _last = _current;
      }
      
      public function reset() : void
      {
         _current = 0;
         _last = 0;
      }
      
      public function pressed() : Boolean
      {
         return _current > 0;
      }
      
      public function justPressed() : Boolean
      {
         return _current == 2;
      }
      
      public function justReleased() : Boolean
      {
         return _current == -1;
      }
      
      public function handleMouseDown(param1:MouseEvent) : void
      {
         if(_current > 0)
         {
            _current = 1;
         }
         else
         {
            _current = 2;
         }
      }
      
      public function handleMouseUp(param1:MouseEvent) : void
      {
         if(_current > 0)
         {
            _current = -1;
         }
         else
         {
            _current = 0;
         }
      }
      
      public function handleMouseOut(param1:MouseEvent) : void
      {
         if(cursor != null)
         {
            _out = cursor.visible;
            cursor.visible = false;
         }
      }
      
      public function handleMouseOver(param1:MouseEvent) : void
      {
         if(cursor != null)
         {
            cursor.visible = _out;
         }
      }
      
      public function handleMouseWheel(param1:MouseEvent) : void
      {
         wheel = param1.delta;
      }
   }
}
