package org.flixel
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Mouse;
   import flash.utils.getTimer;
   import org.flixel.data.FlxConsole;
   import org.flixel.data.FlxPause;
   
   public class FlxGame extends Sprite
   {
       
      
      protected var junk:String;
      
      protected var SndBeep:Class;
      
      protected var SndFlixel:Class;
      
      public var useDefaultHotKeys:Boolean;
      
      public var pause:FlxGroup;
      
      var _iState:Class;
      
      var _created:Boolean;
      
      var _state:FlxState;
      
      var _screen:Sprite;
      
      var _buffer:Bitmap;
      
      var _zoom:uint;
      
      var _gameXOffset:int;
      
      var _gameYOffset:int;
      
      var _frame:Class;
      
      var _zeroPoint:Point;
      
      var _elapsed:Number;
      
      var _total:uint;
      
      var _paused:Boolean;
      
      var _framerate:uint;
      
      var _frameratePaused:uint;
      
      var _soundTray:Sprite;
      
      var _soundTrayTimer:Number;
      
      var _soundTrayBars:Array;
      
      var _console:FlxConsole;
      
      public function FlxGame(param1:uint, param2:uint, param3:Class, param4:uint = 2)
      {
         junk = "nokiafc22_ttf$27758b020176de349cab4b0011bd0214-256531607";
         SndBeep = beep_mp3$f187031c16735dc92ee9216066fe7bd1500019807;
         SndFlixel = §flixel_mp3$077908dd1f716c1ea84530a3d13b40d6-1986906323§;
         super();
         Mouse.hide();
         _zoom = param4;
         FlxState.bgColor = 4278190080;
         FlxG.setGameData(this,param1,param2,param4);
         _elapsed = 0;
         _total = 0;
         pause = new FlxPause();
         _state = null;
         _iState = param3;
         _zeroPoint = new Point();
         useDefaultHotKeys = false;
         _frame = null;
         _gameXOffset = 0;
         _gameYOffset = 0;
         _paused = false;
         _created = false;
         addEventListener("enterFrame",create);
      }
      
      protected function addFrame(param1:Class, param2:uint, param3:uint) : FlxGame
      {
         _frame = param1;
         _gameXOffset = param2;
         _gameYOffset = param3;
         return this;
      }
      
      public function showSoundTray(param1:Boolean = false) : void
      {
         var _loc3_:* = 0;
         if(!param1)
         {
            FlxG.play(SndBeep);
         }
         _soundTrayTimer = 1;
         _soundTray.y = _gameYOffset * _zoom;
         _soundTray.visible = true;
         var _loc2_:uint = Math.round(FlxG.volume * 10);
         if(FlxG.mute)
         {
            _loc2_ = 0;
         }
         _loc3_ = uint(0);
         while(_loc3_ < _soundTrayBars.length)
         {
            if(_loc3_ < _loc2_)
            {
               _soundTrayBars[_loc3_].alpha = 1;
            }
            else
            {
               _soundTrayBars[_loc3_].alpha = 0.5;
            }
            _loc3_++;
         }
      }
      
      public function switchState(param1:FlxState) : void
      {
         FlxG.panel.hide();
         FlxG.unfollow();
         FlxG.resetInput();
         FlxG.destroySounds();
         FlxG.flash.stop();
         FlxG.fade.stop();
         FlxG.quake.stop();
         _screen.x = 0;
         _screen.y = 0;
         _screen.addChild(param1);
         if(_state != null)
         {
            _state.destroy();
            _screen.swapChildren(param1,_state);
            _screen.removeChild(_state);
         }
         _state = param1;
         var _loc2_:* = _zoom;
         _state.scaleY = _loc2_;
         _state.scaleX = _loc2_;
         _state.create();
      }
      
      protected function onKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         var _loc4_:* = null;
         if(param1.keyCode == 192 || param1.keyCode == 220)
         {
            if(FlxG.debug == true)
            {
               _console.toggle();
            }
            return;
         }
         if(!FlxG.mobile && useDefaultHotKeys)
         {
            _loc2_ = param1.keyCode;
            _loc4_ = String.fromCharCode(param1.charCode);
            var _loc6_:* = _loc2_;
            switch(_loc6_)
            {
               case 48:
                  FlxG.mute = !FlxG.mute;
                  showSoundTray();
                  return;
               case 96:
               case 109:
                  FlxG.mute = false;
                  FlxG.volume = FlxG.volume - 0.1;
                  showSoundTray();
                  return;
               case 189:
               case 107:
                  FlxG.mute = false;
                  FlxG.volume = FlxG.volume + 0.1;
                  showSoundTray();
                  return;
               case 187:
            }
         }
         FlxG.keys.handleKeyUp(param1);
         var _loc5_:uint = 0;
         var _loc3_:uint = FlxG.gamepads.length;
         while(_loc5_ < _loc3_)
         {
            FlxG.gamepads[_loc5_++].handleKeyUp(param1);
         }
      }
      
      protected function onKeyDown(param1:KeyboardEvent) : void
      {
         FlxG.keys.handleKeyDown(param1);
         var _loc3_:uint = 0;
         var _loc2_:uint = FlxG.gamepads.length;
         while(_loc3_ < _loc2_)
         {
            FlxG.gamepads[_loc3_++].handleKeyDown(param1);
         }
      }
      
      protected function onFocus(param1:Event = null) : void
      {
         var _loc2_:* = null;
         if(FlxG.pause)
         {
            _loc2_ = pause as FlxPause;
            _loc2_._focus = true;
         }
      }
      
      protected function onFocusLost(param1:Event = null) : void
      {
         FlxG.resetInput();
         FlxG.pause = true;
         _paused = true;
         var _loc2_:FlxPause = pause as FlxPause;
         _loc2_._focus = false;
      }
      
      function unpauseGame() : void
      {
         if(!FlxG.panel.visible)
         {
            Mouse.hide();
         }
         FlxG.resetInput();
         _paused = false;
         FlxG.pause = false;
         stage.frameRate = _framerate;
      }
      
      function pauseGame() : void
      {
         if(x != 0 || y != 0)
         {
            x = 0;
            y = 0;
         }
         FlxG.resetInput();
         Mouse.show();
         _paused = true;
         stage.frameRate = _frameratePaused;
      }
      
      protected function update(param1:Event) : void
      {
         var _loc7_:int = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:uint = getTimer();
         var _loc6_:uint = _loc4_ - _total;
         _elapsed = _loc6_ / 1000;
         _console.mtrTotal.add(_loc6_);
         _total = _loc4_;
         FlxG.elapsed = _elapsed;
         if(FlxG.elapsed > FlxG.maxElapsed)
         {
            FlxG.elapsed = FlxG.maxElapsed;
         }
         FlxG.elapsed = FlxG.elapsed * FlxG.timeScale;
         if(_soundTray != null)
         {
            if(_soundTrayTimer > 0)
            {
               _soundTrayTimer = _soundTrayTimer - _elapsed;
            }
            else if(_soundTray.y > -_soundTray.height)
            {
               _soundTray.y = _soundTray.y - _elapsed * FlxG.height * 2;
               if(_soundTray.y <= -_soundTray.height)
               {
                  _soundTray.visible = false;
                  _loc3_ = new FlxSave();
                  if(_loc3_.bind("flixel"))
                  {
                     if(_loc3_.data.sound == null)
                     {
                        _loc3_.data.sound = {};
                     }
                     _loc3_.data.mute = FlxG.mute;
                     _loc3_.data.volume = FlxG.volume;
                     _loc3_.forceSave();
                  }
               }
            }
         }
         FlxG.panel.update();
         if(_console.visible)
         {
            _console.update();
         }
         FlxG.updateInput();
         FlxG.updateSounds();
         if(_paused)
         {
            pause.update();
         }
         else
         {
            FlxG.doFollow();
            _state.update();
            if(FlxG.flash.exists)
            {
               FlxG.flash.update();
            }
            if(FlxG.fade.exists)
            {
               FlxG.fade.update();
            }
            FlxG.quake.update();
            _screen.x = FlxG.quake.x;
            _screen.y = FlxG.quake.y;
         }
         var _loc5_:uint = getTimer();
         _console.mtrUpdate.add(_loc5_ - _loc4_);
         FlxG.buffer.lock();
         _state.preProcess();
         _state.render();
         if(FlxG.flash.exists)
         {
            FlxG.flash.render();
         }
         if(FlxG.fade.exists)
         {
            FlxG.fade.render();
         }
         if(FlxG.panel.visible)
         {
            FlxG.panel.render();
         }
         if(FlxG.mouse.cursor != null)
         {
            if(FlxG.mouse.cursor.active)
            {
               FlxG.mouse.cursor.update();
            }
            if(FlxG.mouse.cursor.visible)
            {
               FlxG.mouse.cursor.render();
            }
         }
         _state.postProcess();
         if(_paused)
         {
            pause.render();
            _loc2_ = pause as FlxPause;
            if(FlxG.keys.justPressed(_loc2_._resumeKey))
            {
               unpauseGame();
            }
         }
         FlxG.buffer.unlock();
         _console.mtrRender.add(getTimer() - _loc5_);
         FlxG.mouse.wheel = 0;
      }
      
      function create(param1:Event) : void
      {
         var _loc11_:* = 0;
         var _loc9_:* = 0;
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc10_:* = 0;
         var _loc8_:* = 0;
         var _loc2_:* = null;
         if(root == null)
         {
            return;
         }
         stage.scaleMode = "noScale";
         stage.align = "TL";
         stage.frameRate = _framerate;
         _screen = new Sprite();
         addChild(_screen);
         var _loc7_:Bitmap = new Bitmap(new BitmapData(FlxG.width,FlxG.height,true,FlxState.bgColor));
         _loc7_.x = _gameXOffset;
         _loc7_.y = _gameYOffset;
         var _loc12_:* = _zoom;
         _loc7_.scaleY = _loc12_;
         _loc7_.scaleX = _loc12_;
         _screen.addChild(_loc7_);
         FlxG.buffer = _loc7_.bitmapData;
         _console = new FlxConsole(_gameXOffset,_gameYOffset,_zoom);
         if(!FlxG.mobile)
         {
            addChild(_console);
         }
         var _loc3_:String = FlxG.LIBRARY_NAME + " v" + FlxG.LIBRARY_MAJOR_VERSION + "." + FlxG.LIBRARY_MINOR_VERSION;
         if(FlxG.debug)
         {
            _loc3_ = _loc3_ + " [debug]";
         }
         else
         {
            _loc3_ = _loc3_ + " [release]";
         }
         var _loc5_:String = "";
         _loc11_ = uint(0);
         _loc9_ = uint(_loc3_.length + 32);
         while(_loc11_ < _loc9_)
         {
            _loc5_ = _loc5_ + "-";
            _loc11_++;
         }
         FlxG.log(_loc3_);
         FlxG.log(_loc5_);
         stage.addEventListener("mouseDown",FlxG.mouse.handleMouseDown);
         stage.addEventListener("mouseUp",FlxG.mouse.handleMouseUp);
         stage.addEventListener("keyDown",onKeyDown);
         stage.addEventListener("keyUp",onKeyUp);
         if(!FlxG.mobile)
         {
            stage.addEventListener("mouseOut",FlxG.mouse.handleMouseOut);
            stage.addEventListener("mouseOver",FlxG.mouse.handleMouseOver);
            stage.addEventListener("mouseWheel",FlxG.mouse.handleMouseWheel);
            stage.addEventListener("deactivate",onFocusLost);
            stage.addEventListener("activate",onFocus);
            _soundTray = new Sprite();
            _soundTray.visible = false;
            _soundTray.scaleX = 2;
            _soundTray.scaleY = 2;
            _loc7_ = new Bitmap(new BitmapData(80,30,true,2130706432));
            _soundTray.x = (_gameXOffset + FlxG.width / 2) * _zoom - _loc7_.width / 2 * _soundTray.scaleX;
            _soundTray.addChild(_loc7_);
            _loc4_ = new TextField();
            _loc4_.width = _loc7_.width;
            _loc4_.height = _loc7_.height;
            _loc4_.multiline = true;
            _loc4_.wordWrap = true;
            _loc4_.selectable = false;
            _loc4_.embedFonts = true;
            _loc4_.antiAliasType = "normal";
            _loc4_.gridFitType = "pixel";
            _loc4_.defaultTextFormat = new TextFormat("system",8,16777215,null,null,null,null,null,"center");
            _soundTray.addChild(_loc4_);
            _loc4_.text = "VOLUME";
            _loc4_.y = 16;
            _loc10_ = uint(10);
            _loc8_ = uint(14);
            _soundTrayBars = [];
            _loc11_ = uint(0);
            while(_loc11_ < 10)
            {
               _loc7_ = new Bitmap(new BitmapData(4,++_loc11_,false,16777215));
               _loc7_.x = _loc10_;
               _loc7_.y = _loc8_;
               _soundTrayBars.push(_soundTray.addChild(_loc7_));
               _loc10_ = uint(_loc10_ + 6);
               _loc8_--;
            }
            addChild(_soundTray);
            _loc6_ = new FlxSave();
            if(_loc6_.bind("flixel") && _loc6_.data.sound != null)
            {
               if(_loc6_.data.volume != null)
               {
                  FlxG.volume = _loc6_.data.volume;
               }
               if(_loc6_.data.mute != null)
               {
                  FlxG.mute = _loc6_.data.mute;
               }
               showSoundTray(true);
            }
         }
         if(_frame != null)
         {
            _loc2_ = new _frame();
            _loc2_.scaleX = _zoom;
            _loc2_.scaleY = _zoom;
            addChild(_loc2_);
         }
         switchState(new _iState());
         FlxState.screen.unsafeBind(FlxG.buffer);
         removeEventListener("enterFrame",create);
         addEventListener("enterFrame",update);
      }
   }
}
