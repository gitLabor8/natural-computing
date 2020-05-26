package org.flixel.data
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import org.flixel.FlxG;
   import org.flixel.FlxMonitor;
   
   public class FlxConsole extends Sprite
   {
       
      
      public var mtrUpdate:FlxMonitor;
      
      public var mtrRender:FlxMonitor;
      
      public var mtrTotal:FlxMonitor;
      
      protected const MAX_CONSOLE_LINES:uint = 256;
      
      protected var _console:Sprite;
      
      protected var _text:TextField;
      
      protected var _fpsDisplay:TextField;
      
      protected var _extraDisplay:TextField;
      
      protected var _curFPS:uint;
      
      protected var _lines:Array;
      
      protected var _Y:Number;
      
      protected var _YT:Number;
      
      protected var _bx:int;
      
      protected var _by:int;
      
      protected var _byt:int;
      
      public function FlxConsole(param1:uint, param2:uint, param3:uint)
      {
         super();
         visible = false;
         x = param1 * param3;
         _by = param2 * param3;
         _byt = _by - FlxG.height * param3;
         y = _byt;
         _Y = _byt;
         _YT = _byt;
         var _loc4_:Bitmap = new Bitmap(new BitmapData(FlxG.width * param3,FlxG.height * param3,true,2130706432));
         addChild(_loc4_);
         mtrUpdate = new FlxMonitor(16);
         mtrRender = new FlxMonitor(16);
         mtrTotal = new FlxMonitor(16);
         _text = new TextField();
         _text.width = _loc4_.width;
         _text.height = _loc4_.height;
         _text.multiline = true;
         _text.wordWrap = true;
         _text.embedFonts = true;
         _text.selectable = false;
         _text.antiAliasType = "normal";
         _text.gridFitType = "pixel";
         _text.defaultTextFormat = new TextFormat("system",8,16777215);
         addChild(_text);
         _fpsDisplay = new TextField();
         _fpsDisplay.width = 100;
         _fpsDisplay.x = _loc4_.width - 100;
         _fpsDisplay.height = 20;
         _fpsDisplay.multiline = true;
         _fpsDisplay.wordWrap = true;
         _fpsDisplay.embedFonts = true;
         _fpsDisplay.selectable = false;
         _fpsDisplay.antiAliasType = "normal";
         _fpsDisplay.gridFitType = "pixel";
         _fpsDisplay.defaultTextFormat = new TextFormat("system",16,16777215,true,null,null,null,null,"right");
         addChild(_fpsDisplay);
         _extraDisplay = new TextField();
         _extraDisplay.width = 100;
         _extraDisplay.x = _loc4_.width - 100;
         _extraDisplay.height = 64;
         _extraDisplay.y = 20;
         _extraDisplay.alpha = 0.5;
         _extraDisplay.multiline = true;
         _extraDisplay.wordWrap = true;
         _extraDisplay.embedFonts = true;
         _extraDisplay.selectable = false;
         _extraDisplay.antiAliasType = "normal";
         _extraDisplay.gridFitType = "pixel";
         _extraDisplay.defaultTextFormat = new TextFormat("system",8,16777215,true,null,null,null,null,"right");
         addChild(_extraDisplay);
         _lines = [];
      }
      
      public function log(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         if(param1 == null)
         {
            param1 = "NULL";
         }
         trace(param1);
         if(FlxG.mobile)
         {
            return;
         }
         _lines.push(param1);
         if(_lines.length > 256)
         {
            _lines.shift();
            _loc2_ = "";
            _loc3_ = uint(0);
            while(_loc3_ < _lines.length)
            {
               _loc2_ = _loc2_ + (_lines[_loc3_] + "\n");
               _loc3_++;
            }
            _text.text = _loc2_;
         }
         else
         {
            _text.appendText(param1 + "\n");
         }
         _text.scrollV = _text.height;
      }
      
      public function toggle() : void
      {
         if(FlxG.mobile)
         {
            log("FRAME TIMING DATA:\n=========================\n" + printTimingData() + "\n");
            return;
         }
         if(_YT == _by)
         {
            _YT = _byt;
         }
         else
         {
            _YT = _by;
            visible = true;
         }
      }
      
      public function update() : void
      {
         var _loc1_:Number = mtrTotal.average();
         _fpsDisplay.text = uint(1000 / _loc1_) + " fps";
         _extraDisplay.text = printTimingData();
         if(_Y < _YT)
         {
            _Y = _Y + FlxG.height * 10 * FlxG.elapsed;
         }
         else if(_Y > _YT)
         {
            _Y = _Y - FlxG.height * 10 * FlxG.elapsed;
         }
         if(_Y > _by)
         {
            _Y = _by;
         }
         else if(_Y < _byt)
         {
            _Y = _byt;
            visible = false;
         }
         y = Math.floor(_Y);
      }
      
      protected function printTimingData() : String
      {
         var _loc4_:uint = mtrUpdate.average();
         var _loc1_:uint = mtrRender.average();
         var _loc3_:uint = _loc4_ + _loc1_;
         var _loc2_:uint = mtrTotal.average();
         return _loc4_ + "ms update\n" + _loc1_ + "ms render\n" + _loc3_ + "ms flixel\n" + (_loc2_ - _loc3_) + "ms flash\n" + _loc2_ + "ms total";
      }
   }
}
