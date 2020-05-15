package org.flixel
{
   import flash.events.Event;
   import flash.events.SampleDataEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class FlxSound extends FlxObject
   {
       
      
      public var survive:Boolean;
      
      public var playing:Boolean;
      
      public var name:String;
      
      public var artist:String;
      
      protected const MAGIC_DELAY:Number = 2766.0;
      
      protected const bufferSize:int = 4096;
      
      protected var samplesTotal:int = 0;
      
      protected var samplesPosition:int = 0;
      
      protected var _streaming:Boolean;
      
      protected var _init:Boolean;
      
      protected var _sound:Sound;
      
      protected var _in:Sound;
      
      protected var _channel:SoundChannel;
      
      protected var _transform:SoundTransform;
      
      protected var _position:Number;
      
      protected var _volume:Number;
      
      protected var _volumeAdjust:Number;
      
      protected var _looped:Boolean;
      
      protected var _core:FlxObject;
      
      protected var _radius:Number;
      
      protected var _pan:Boolean;
      
      protected var _fadeOutTimer:Number;
      
      protected var _fadeOutTotal:Number;
      
      protected var _pauseOnFadeOut:Boolean;
      
      protected var _fadeInTimer:Number;
      
      protected var _fadeInTotal:Number;
      
      protected var _point2:FlxPoint;
      
      public function FlxSound()
      {
         super();
         _point2 = new FlxPoint();
         _transform = new SoundTransform();
         init();
         fixed = true;
      }
      
      protected function init() : void
      {
         _transform.pan = 0;
         _sound = null;
         _in = null;
         _position = 0;
         _volume = 1;
         _volumeAdjust = 1;
         _looped = false;
         _core = null;
         _radius = 0;
         _pan = false;
         _fadeOutTimer = 0;
         _fadeOutTotal = 0;
         _pauseOnFadeOut = false;
         _fadeInTimer = 0;
         _fadeInTotal = 0;
         active = false;
         visible = false;
         solid = false;
         playing = false;
         name = null;
         artist = null;
      }
      
      public function loadEmbedded(param1:Class, param2:Boolean = false, param3:int = 0) : FlxSound
      {
         stop();
         init();
         if(param2)
         {
            _in = new param1();
            _sound = new Sound();
            _sound.addEventListener("sampleData",sampleData);
            samplesTotal = param3 - 2766;
         }
         else
         {
            _sound = new param1();
         }
         _streaming = false;
         _looped = param2;
         updateTransform();
         active = true;
         return this;
      }
      
      public function loadStream(param1:String, param2:Boolean = false) : FlxSound
      {
         stop();
         init();
         _sound = new Sound();
         _sound.addEventListener("id3",gotID3);
         _sound.load(new URLRequest(param1));
         _streaming = true;
         _looped = param2;
         updateTransform();
         active = true;
         return this;
      }
      
      public function proximity(param1:Number, param2:Number, param3:FlxObject, param4:Number, param5:Boolean = true) : FlxSound
      {
         x = param1;
         y = param2;
         _core = param3;
         _radius = param4;
         _pan = param5;
         return this;
      }
      
      public function play() : void
      {
         if(_position < 0)
         {
            return;
         }
         if(_looped)
         {
            if(!_streaming)
            {
               if(_channel == null)
               {
                  _channel = _sound.play(0,9999,_transform);
               }
               if(_channel == null)
               {
                  active = false;
               }
            }
            else if(_position == 0)
            {
               if(_channel == null)
               {
                  _channel = _sound.play(0,9999,_transform);
               }
               if(_channel == null)
               {
                  active = false;
               }
            }
            else
            {
               _channel = _sound.play(_position,0,_transform);
               if(_channel == null)
               {
                  active = false;
               }
               else
               {
                  _channel.addEventListener("soundComplete",looped);
               }
            }
         }
         else if(_position == 0)
         {
            if(_channel == null)
            {
               _channel = _sound.play(0,0,_transform);
               if(_channel == null)
               {
                  active = false;
               }
               else
               {
                  _channel.addEventListener("soundComplete",stopped);
               }
            }
         }
         else
         {
            _channel = _sound.play(_position,0,_transform);
            if(_channel == null)
            {
               active = false;
            }
         }
         playing = _channel != null;
         _position = 0;
      }
      
      public function pause() : void
      {
         if(_channel == null)
         {
            _position = -1;
            return;
         }
         _position = _channel.position;
         _channel.stop();
         if(_looped)
         {
            while(_position > samplesTotal)
            {
               _position = _position - samplesTotal;
            }
         }
         _channel = null;
         playing = false;
      }
      
      public function stop() : void
      {
         _position = 0;
         if(_channel != null)
         {
            _channel.stop();
            stopped();
         }
      }
      
      public function fadeOut(param1:Number, param2:Boolean = false) : void
      {
         _pauseOnFadeOut = param2;
         _fadeInTimer = 0;
         _fadeOutTimer = param1;
         _fadeOutTotal = _fadeOutTimer;
      }
      
      public function fadeIn(param1:Number) : void
      {
         _fadeOutTimer = 0;
         _fadeInTimer = param1;
         _fadeInTotal = _fadeInTimer;
         play();
      }
      
      public function get volume() : Number
      {
         return _volume;
      }
      
      public function set volume(param1:Number) : void
      {
         _volume = param1;
         if(_volume < 0)
         {
            _volume = 0;
         }
         else if(_volume > 1)
         {
            _volume = 1;
         }
         updateTransform();
      }
      
      protected function updateSound() : void
      {
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:* = NaN;
         if(_position != 0)
         {
            return;
         }
         var _loc3_:* = 1;
         var _loc2_:* = 1;
         if(_core != null)
         {
            _loc7_ = new FlxPoint();
            _loc6_ = new FlxPoint();
            _core.getScreenXY(_loc7_);
            getScreenXY(_loc6_);
            _loc4_ = _loc7_.x - _loc6_.x;
            _loc5_ = _loc7_.y - _loc6_.y;
            _loc3_ = Number((_radius - Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_)) / _radius);
            if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            if(_loc3_ > 1)
            {
               _loc3_ = 1;
            }
            if(_pan)
            {
               _loc1_ = Number(-_loc4_ / _radius);
               if(_loc1_ < -1)
               {
                  _loc1_ = -1;
               }
               else if(_loc1_ > 1)
               {
                  _loc1_ = 1;
               }
               _transform.pan = _loc1_;
            }
         }
         if(_fadeOutTimer > 0)
         {
            _fadeOutTimer = _fadeOutTimer - FlxG.elapsed;
            if(_fadeOutTimer <= 0)
            {
               if(_pauseOnFadeOut)
               {
                  pause();
               }
               else
               {
                  stop();
               }
            }
            _loc2_ = Number(_fadeOutTimer / _fadeOutTotal);
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
         }
         else if(_fadeInTimer > 0)
         {
            _fadeInTimer = _fadeInTimer - FlxG.elapsed;
            _loc2_ = Number(_fadeInTimer / _fadeInTotal);
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            _loc2_ = Number(1 - _loc2_);
         }
         _volumeAdjust = _loc3_ * _loc2_;
         updateTransform();
      }
      
      override public function update() : void
      {
         super.update();
         updateSound();
      }
      
      override public function destroy() : void
      {
         if(active)
         {
            stop();
         }
      }
      
      function updateTransform() : void
      {
         _transform.volume = FlxG.getMuteValue() * FlxG.volume * _volume * _volumeAdjust;
         if(_channel != null)
         {
            _channel.soundTransform = _transform;
         }
      }
      
      protected function looped(param1:Event = null) : void
      {
         if(_channel == null)
         {
            return;
         }
         _channel.removeEventListener("soundComplete",looped);
         _channel = null;
         play();
      }
      
      protected function stopped(param1:Event = null) : void
      {
         if(!_looped)
         {
            _channel.removeEventListener("soundComplete",stopped);
         }
         else
         {
            _channel.removeEventListener("soundComplete",looped);
         }
         _channel = null;
         active = false;
         playing = false;
      }
      
      protected function gotID3(param1:Event = null) : void
      {
         FlxG.log("got ID3 info!");
         if(_sound.id3.songName.length > 0)
         {
            name = _sound.id3.songName;
         }
         if(_sound.id3.artist.length > 0)
         {
            artist = _sound.id3.artist;
         }
         _sound.removeEventListener("id3",gotID3);
      }
      
      protected function sampleData(param1:SampleDataEvent) : void
      {
         extract(param1.data,4096);
      }
      
      protected function extract(param1:ByteArray, param2:int) : void
      {
         var _loc3_:int = 0;
         if(samplesTotal == 0)
         {
            return;
         }
         while(0 < param2)
         {
            if(samplesPosition + param2 > samplesTotal)
            {
               _loc3_ = samplesTotal - samplesPosition;
               _in.extract(param1,_loc3_,samplesPosition + 2766);
               samplesPosition = samplesPosition + _loc3_;
               param2 = param2 - _loc3_;
            }
            else
            {
               _in.extract(param1,param2,samplesPosition + 2766);
               samplesPosition = samplesPosition + param2;
               param2 = 0;
            }
            if(samplesPosition == samplesTotal)
            {
               samplesPosition = 0;
            }
         }
      }
   }
}
