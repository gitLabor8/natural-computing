package org.flixel
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.flixel.data.FlxAnim;
   
   public class FlxSprite extends FlxObject
   {
      
      public static const LEFT:uint = 0;
      
      public static const RIGHT:uint = 1;
      
      public static const UP:uint = 2;
      
      public static const DOWN:uint = 3;
      
      protected static var _gfxSprite:Sprite;
      
      protected static var _gfx:Graphics;
       
      
      public var offset:FlxPoint;
      
      public var scale:FlxPoint;
      
      public var blend:String;
      
      public var antialiasing:Boolean;
      
      public var finished:Boolean;
      
      public var frameWidth:uint;
      
      public var frameHeight:uint;
      
      public var frames:uint;
      
      protected var _animations:Array;
      
      protected var _flipped:uint;
      
      protected var _curAnim:FlxAnim;
      
      protected var _curFrame:uint;
      
      protected var _caf:uint;
      
      protected var _frameTimer:Number;
      
      protected var _callback:Function;
      
      protected var _facing:uint;
      
      protected var _bakedRotation:Number;
      
      protected var _flashRect:Rectangle;
      
      protected var _flashRect2:Rectangle;
      
      protected var _flashPointZero:Point;
      
      protected var _pixels:BitmapData;
      
      protected var _framePixels:BitmapData;
      
      protected var _alpha:Number;
      
      protected var _color:uint;
      
      protected var _ct:ColorTransform;
      
      protected var _mtx:Matrix;
      
      protected var _bbb:BitmapData;
      
      protected var _boundsVisible:Boolean;
      
      public function FlxSprite(param1:Number = 0, param2:Number = 0, param3:Class = null)
      {
         super();
         x = param1;
         y = param2;
         _flashRect = new Rectangle();
         _flashRect2 = new Rectangle();
         _flashPointZero = new Point();
         offset = new FlxPoint();
         scale = new FlxPoint(1,1);
         _alpha = 1;
         _color = 16777215;
         blend = null;
         antialiasing = false;
         finished = false;
         _facing = 1;
         _animations = [];
         _flipped = 0;
         _curAnim = null;
         _curFrame = 0;
         _caf = 0;
         _frameTimer = 0;
         _mtx = new Matrix();
         _callback = null;
         if(_gfxSprite == null)
         {
            _gfxSprite = new Sprite();
            _gfx = _gfxSprite.graphics;
         }
         if(param3 == null)
         {
            createGraphic(8,8);
         }
         else
         {
            loadGraphic(param3);
         }
      }
      
      public function loadGraphic(param1:Class, param2:Boolean = false, param3:Boolean = false, param4:uint = 0, param5:uint = 0, param6:Boolean = false) : FlxSprite
      {
         _bakedRotation = 0;
         _pixels = FlxG.addBitmap(param1,param3,param6);
         if(param3)
         {
            _flipped = _pixels.width >> 1;
         }
         else
         {
            _flipped = 0;
         }
         if(param4 == 0)
         {
            if(param2)
            {
               param4 = _pixels.height;
            }
            else if(_flipped > 0)
            {
               param4 = _pixels.width * 0.5;
            }
            else
            {
               param4 = _pixels.width;
            }
         }
         frameWidth = param4;
         width = param4;
         if(param5 == 0)
         {
            if(param2)
            {
               param5 = width;
            }
            else
            {
               param5 = _pixels.height;
            }
         }
         frameHeight = param5;
         height = param5;
         resetHelpers();
         return this;
      }
      
      public function loadRotatedGraphic(param1:Class, param2:uint = 16, param3:int = -1, param4:Boolean = false, param5:Boolean = false) : FlxSprite
      {
         var _loc17_:* = null;
         var _loc21_:* = 0;
         var _loc22_:* = 0;
         var _loc10_:* = 0;
         var _loc16_:* = 0;
         var _loc9_:* = 0;
         var _loc8_:* = NaN;
         var _loc14_:* = 0;
         var _loc11_:* = 0;
         var _loc13_:* = 0;
         var _loc15_:* = 0;
         var _loc12_:uint = Math.sqrt(param2);
         var _loc18_:BitmapData = FlxG.addBitmap(param1);
         if(param3 >= 0)
         {
            _loc17_ = _loc18_;
            _loc18_ = new BitmapData(_loc17_.height,_loc17_.height);
            _loc21_ = uint(param3 * _loc18_.width);
            _loc22_ = uint(0);
            _loc10_ = uint(_loc17_.width);
            if(_loc21_ >= _loc10_)
            {
               _loc22_ = uint(uint(_loc21_ / _loc10_) * _loc18_.height);
               _loc21_ = uint(_loc21_ % _loc10_);
            }
            _flashRect.x = _loc21_;
            _flashRect.y = _loc22_;
            _flashRect.width = _loc18_.width;
            _flashRect.height = _loc18_.height;
            _loc18_.copyPixels(_loc17_,_flashRect,_flashPointZero);
         }
         var _loc7_:uint = _loc18_.width;
         if(_loc18_.height > _loc7_)
         {
            _loc7_ = _loc18_.height;
         }
         if(param5)
         {
            _loc7_ = _loc7_ * 1.5;
         }
         var _loc6_:uint = FlxU.ceil(param2 / _loc12_);
         width = _loc7_ * _loc6_;
         height = _loc7_ * _loc12_;
         var _loc20_:String = String(param1) + ":" + param3 + ":" + width + "x" + height;
         var _loc19_:Boolean = FlxG.checkBitmapCache(_loc20_);
         _pixels = FlxG.createBitmap(width,height,0,true,_loc20_);
         frameWidth = _pixels.width;
         width = _pixels.width;
         frameHeight = _pixels.height;
         height = _pixels.height;
         _bakedRotation = 360 / param2;
         if(!_loc19_)
         {
            _loc16_ = uint(0);
            _loc8_ = 0;
            _loc14_ = uint(_loc18_.width * 0.5);
            _loc11_ = uint(_loc18_.height * 0.5);
            _loc13_ = uint(_loc7_ * 0.5);
            _loc15_ = uint(_loc7_ * 0.5);
            while(_loc16_ < _loc12_)
            {
               _loc9_ = uint(0);
               while(_loc9_ < _loc6_)
               {
                  _mtx.identity();
                  _mtx.translate(-_loc14_,-_loc11_);
                  _mtx.rotate(_loc8_ * 0.017453293);
                  _mtx.translate(_loc7_ * _loc9_ + _loc13_,_loc15_);
                  _loc8_ = Number(_loc8_ + _bakedRotation);
                  _pixels.draw(_loc18_,_mtx,null,null,null,param4);
                  _loc9_++;
               }
               _loc15_ = uint(_loc15_ + _loc7_);
               _loc16_++;
            }
         }
         height = _loc7_;
         width = _loc7_;
         frameHeight = _loc7_;
         frameWidth = _loc7_;
         resetHelpers();
         return this;
      }
      
      public function createGraphic(param1:uint, param2:uint, param3:uint = 4294967295, param4:Boolean = false, param5:String = null) : FlxSprite
      {
         _bakedRotation = 0;
         _pixels = FlxG.createBitmap(param1,param2,param3,param4,param5);
         frameWidth = _pixels.width;
         width = _pixels.width;
         frameHeight = _pixels.height;
         height = _pixels.height;
         resetHelpers();
         return this;
      }
      
      public function get pixels() : BitmapData
      {
         return _pixels;
      }
      
      public function set pixels(param1:BitmapData) : void
      {
         _pixels = param1;
         frameWidth = _pixels.width;
         width = _pixels.width;
         frameHeight = _pixels.height;
         height = _pixels.height;
         resetHelpers();
      }
      
      protected function resetHelpers() : void
      {
         _boundsVisible = false;
         _flashRect.x = 0;
         _flashRect.y = 0;
         _flashRect.width = frameWidth;
         _flashRect.height = frameHeight;
         _flashRect2.x = 0;
         _flashRect2.y = 0;
         _flashRect2.width = _pixels.width;
         _flashRect2.height = _pixels.height;
         if(_framePixels == null || _framePixels.width != width || _framePixels.height != height)
         {
            _framePixels = new BitmapData(width,height);
         }
         if(_bbb == null || _bbb.width != width || _bbb.height != height)
         {
            _bbb = new BitmapData(width,height);
         }
         origin.x = frameWidth * 0.5;
         origin.y = frameHeight * 0.5;
         _framePixels.copyPixels(_pixels,_flashRect,_flashPointZero);
         frames = _flashRect2.width / _flashRect.width * (_flashRect2.height / _flashRect.height);
         if(_ct != null)
         {
            _framePixels.colorTransform(_flashRect,_ct);
         }
         if(FlxG.showBounds)
         {
            drawBounds();
         }
         _caf = 0;
         refreshHulls();
      }
      
      override public function set solid(param1:Boolean) : void
      {
         var _loc2_:Boolean = _solid;
         _solid = param1;
         if(_loc2_ != _solid && FlxG.showBounds)
         {
            calcFrame();
         }
      }
      
      override public function set fixed(param1:Boolean) : void
      {
         var _loc2_:Boolean = _fixed;
         _fixed = param1;
         if(_loc2_ != _fixed && FlxG.showBounds)
         {
            calcFrame();
         }
      }
      
      public function get facing() : uint
      {
         return _facing;
      }
      
      public function set facing(param1:uint) : void
      {
         var _loc2_:* = _facing != param1;
         _facing = param1;
         if(_loc2_)
         {
            calcFrame();
         }
      }
      
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 == _alpha)
         {
            return;
         }
         _alpha = param1;
         if(_alpha != 1 || _color != 16777215)
         {
            _ct = new ColorTransform((_color >> 16) * 0.00392,(_color >> 8 & 255) * 0.00392,(_color & 255) * 0.00392,_alpha);
         }
         else
         {
            _ct = null;
         }
         calcFrame();
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function set color(param1:uint) : void
      {
         param1 = param1 & 16777215;
         if(_color == param1)
         {
            return;
         }
         _color = param1;
         if(_alpha != 1 || _color != 16777215)
         {
            _ct = new ColorTransform((_color >> 16) * 0.00392,(_color >> 8 & 255) * 0.00392,(_color & 255) * 0.00392,_alpha);
         }
         else
         {
            _ct = null;
         }
         calcFrame();
      }
      
      public function draw(param1:FlxSprite, param2:int = 0, param3:int = 0) : void
      {
         var _loc4_:BitmapData = param1._framePixels;
         if((param1.angle == 0 || param1._bakedRotation > 0) && param1.scale.x == 1 && param1.scale.y == 1 && param1.blend == null)
         {
            _flashPoint.x = param2;
            _flashPoint.y = param3;
            _flashRect2.width = _loc4_.width;
            _flashRect2.height = _loc4_.height;
            _pixels.copyPixels(_loc4_,_flashRect2,_flashPoint,null,null,true);
            _flashRect2.width = _pixels.width;
            _flashRect2.height = _pixels.height;
            calcFrame();
            return;
         }
         _mtx.identity();
         _mtx.translate(-param1.origin.x,-param1.origin.y);
         _mtx.scale(param1.scale.x,param1.scale.y);
         if(param1.angle != 0)
         {
            _mtx.rotate(param1.angle * 0.017453293);
         }
         _mtx.translate(param2 + param1.origin.x,param3 + param1.origin.y);
         _pixels.draw(_loc4_,_mtx,null,param1.blend,null,param1.antialiasing);
         calcFrame();
      }
      
      public function drawLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint, param6:uint = 1) : void
      {
         _gfx.clear();
         _gfx.moveTo(param1,param2);
         _gfx.lineStyle(param6,param5);
         _gfx.lineTo(param3,param4);
         _pixels.draw(_gfxSprite);
         calcFrame();
      }
      
      public function fill(param1:uint) : void
      {
         _pixels.fillRect(_flashRect2,param1);
         if(_pixels != _framePixels)
         {
            calcFrame();
         }
      }
      
      protected function updateAnimation() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         if(_bakedRotation)
         {
            _loc1_ = uint(_caf);
            _loc2_ = angle % 360;
            if(_loc2_ < 0)
            {
               _loc2_ = _loc2_ + 360;
            }
            _caf = _loc2_ / _bakedRotation;
            if(_loc1_ != _caf)
            {
               calcFrame();
            }
            return;
         }
         if(_curAnim != null && _curAnim.delay > 0 && (_curAnim.looped || !finished))
         {
            _frameTimer = _frameTimer + FlxG.elapsed;
            while(_frameTimer > _curAnim.delay)
            {
               _frameTimer = _frameTimer - _curAnim.delay;
               if(_curFrame == _curAnim.frames.length - 1)
               {
                  if(_curAnim.looped)
                  {
                     _curFrame = 0;
                  }
                  finished = true;
               }
               else
               {
                  _curFrame = Number(_curFrame) + 1;
               }
               _caf = _curAnim.frames[_curFrame];
               calcFrame();
            }
         }
      }
      
      override public function update() : void
      {
         updateMotion();
         updateAnimation();
         updateFlickering();
      }
      
      protected function renderSprite() : void
      {
         if(FlxG.showBounds != _boundsVisible)
         {
            calcFrame();
         }
         getScreenXY(_point);
         _flashPoint.x = _point.x;
         _flashPoint.y = _point.y;
         if((angle == 0 || _bakedRotation > 0) && scale.x == 1 && scale.y == 1 && blend == null)
         {
            FlxG.buffer.copyPixels(_framePixels,_flashRect,_flashPoint,null,null,true);
            return;
         }
         _mtx.identity();
         _mtx.translate(-origin.x,-origin.y);
         _mtx.scale(scale.x,scale.y);
         if(angle != 0)
         {
            _mtx.rotate(angle * 0.017453293);
         }
         _mtx.translate(_point.x + origin.x,_point.y + origin.y);
         FlxG.buffer.draw(_framePixels,_mtx,null,blend,null,antialiasing);
      }
      
      override public function render() : void
      {
         renderSprite();
      }
      
      override public function overlapsPoint(param1:Number, param2:Number, param3:Boolean = false) : Boolean
      {
         param1 = param1 + FlxU.floor(FlxG.scroll.x);
         param2 = param2 + FlxU.floor(FlxG.scroll.y);
         getScreenXY(_point);
         if(param3)
         {
            return _framePixels.hitTest(new Point(0,0),255,new Point(param1 - _point.x,param2 - _point.y));
         }
         if(param1 <= _point.x || param1 >= _point.x + frameWidth || param2 <= _point.y || param2 >= _point.y + frameHeight)
         {
            return false;
         }
         return true;
      }
      
      public function onEmit() : void
      {
      }
      
      public function addAnimation(param1:String, param2:Array, param3:Number = 0, param4:Boolean = true) : void
      {
         _animations.push(new FlxAnim(param1,param2,param3,param4));
      }
      
      public function addAnimationCallback(param1:Function) : void
      {
         _callback = param1;
      }
      
      public function play(param1:String, param2:Boolean = false) : void
      {
         if(!param2 && _curAnim != null && param1 == _curAnim.name && (_curAnim.looped || !finished))
         {
            return;
         }
         _curFrame = 0;
         _caf = 0;
         _frameTimer = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = _animations.length;
         while(_loc4_ < _loc3_)
         {
            if(_animations[_loc4_].name == param1)
            {
               _curAnim = _animations[_loc4_];
               if(_curAnim.delay <= 0)
               {
                  finished = true;
               }
               else
               {
                  finished = false;
               }
               _caf = _curAnim.frames[_curFrame];
               calcFrame();
               return;
            }
            _loc4_++;
         }
      }
      
      public function randomFrame() : void
      {
         _curAnim = null;
         _caf = int(FlxU.random() * (_pixels.width / frameWidth));
         calcFrame();
      }
      
      public function get frame() : uint
      {
         return _caf;
      }
      
      public function set frame(param1:uint) : void
      {
         _curAnim = null;
         _caf = param1;
         calcFrame();
      }
      
      override public function getScreenXY(param1:FlxPoint = null) : FlxPoint
      {
         if(param1 == null)
         {
            param1 = new FlxPoint();
         }
         param1.x = FlxU.floor(x + FlxU.roundingError) + FlxU.floor(FlxG.scroll.x * scrollFactor.x) - offset.x;
         param1.y = FlxU.floor(y + FlxU.roundingError) + FlxU.floor(FlxG.scroll.y * scrollFactor.y) - offset.y;
         return param1;
      }
      
      protected function calcFrame() : void
      {
         _boundsVisible = false;
         var _loc2_:uint = _caf * frameWidth;
         var _loc3_:uint = 0;
         var _loc1_:uint = !!_flipped?_flipped:_pixels.width;
         if(_loc2_ >= _loc1_)
         {
            _loc3_ = uint(_loc2_ / _loc1_) * frameHeight;
            _loc2_ = _loc2_ % _loc1_;
         }
         if(_flipped && _facing == 0)
         {
            _loc2_ = (_flipped << 1) - _loc2_ - frameWidth;
         }
         _flashRect.x = _loc2_;
         _flashRect.y = _loc3_;
         _framePixels.copyPixels(_pixels,_flashRect,_flashPointZero);
         var _loc4_:int = 0;
         _flashRect.y = _loc4_;
         _flashRect.x = _loc4_;
         if(_ct != null)
         {
            _framePixels.colorTransform(_flashRect,_ct);
         }
         if(FlxG.showBounds)
         {
            drawBounds();
         }
         if(_callback != null)
         {
            _callback(_curAnim.name,_curFrame,_caf);
         }
      }
      
      protected function drawBounds() : void
      {
         _boundsVisible = true;
         if(_bbb == null || _bbb.width != width || _bbb.height != height)
         {
            _bbb = new BitmapData(width,height);
         }
         var _loc1_:uint = getBoundingColor();
         _bbb.fillRect(_flashRect,0);
         var _loc3_:uint = _flashRect.width;
         var _loc2_:uint = _flashRect.height;
         _flashRect.width = int(width);
         _flashRect.height = int(height);
         _bbb.fillRect(_flashRect,_loc1_);
         _flashRect.width = _flashRect.width - 2;
         _flashRect.height = _flashRect.height - 2;
         _flashRect.x = 1;
         _flashRect.y = 1;
         _bbb.fillRect(_flashRect,0);
         _flashRect.width = _loc3_;
         _flashRect.height = _loc2_;
         var _loc4_:int = 0;
         _flashRect.y = _loc4_;
         _flashRect.x = _loc4_;
         _flashPoint.x = int(offset.x);
         _flashPoint.y = int(offset.y);
         _framePixels.copyPixels(_bbb,_flashRect,_flashPoint,null,null,true);
      }
      
      function unsafeBind(param1:BitmapData) : void
      {
         _framePixels = param1;
         _pixels = param1;
      }
   }
}
