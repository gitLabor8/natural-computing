package org.flixel
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class FlxTilemap extends FlxObject
   {
      
      public static var ImgAuto:Class = autotiles_png$464893e4bb0166785d1adae199299875700566007;
      
      public static var ImgAutoAlt:Class = §autotiles_alt_png$fbf2f7a921b1228ecd65b3c3f0612fb9-2084686359§;
      
      public static const OFF:uint = 0;
      
      public static const AUTO:uint = 1;
      
      public static const ALT:uint = 2;
       
      
      public var collideIndex:uint;
      
      public var startingIndex:uint;
      
      public var drawIndex:uint;
      
      public var auto:uint;
      
      public var refresh:Boolean;
      
      public var widthInTiles:uint;
      
      public var heightInTiles:uint;
      
      public var totalTiles:uint;
      
      protected var _flashRect:Rectangle;
      
      protected var _flashRect2:Rectangle;
      
      protected var _pixels:BitmapData;
      
      protected var _bbPixels:BitmapData;
      
      protected var _buffer:BitmapData;
      
      protected var _bufferLoc:FlxPoint;
      
      protected var _bbKey:String;
      
      protected var _data:Array;
      
      protected var _rects:Array;
      
      protected var _tileWidth:uint;
      
      protected var _tileHeight:uint;
      
      protected var _block:FlxObject;
      
      protected var _callbacks:Array;
      
      protected var _screenRows:uint;
      
      protected var _screenCols:uint;
      
      protected var _boundsVisible:Boolean;
      
      public function FlxTilemap()
      {
         super();
         auto = 0;
         collideIndex = 1;
         startingIndex = 0;
         drawIndex = 1;
         widthInTiles = 0;
         heightInTiles = 0;
         totalTiles = 0;
         _buffer = null;
         _bufferLoc = new FlxPoint();
         _flashRect2 = new Rectangle();
         _flashRect = _flashRect2;
         _data = null;
         _tileWidth = 0;
         _tileHeight = 0;
         _rects = null;
         _pixels = null;
         _block = new FlxObject();
         var _loc1_:int = 0;
         _block.height = _loc1_;
         _block.width = _loc1_;
         _block.fixed = true;
         _callbacks = [];
         fixed = true;
      }
      
      public static function arrayToCSV(param1:Array, param2:int) : String
      {
         var _loc3_:* = 0;
         var _loc6_:* = null;
         var _loc4_:uint = 0;
         var _loc5_:int = param1.length / param2;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = uint(0);
            while(_loc3_ < param2)
            {
               if(_loc3_ == 0)
               {
                  if(_loc4_ == 0)
                  {
                     _loc6_ = _loc6_ + param1[0];
                  }
                  else
                  {
                     _loc6_ = _loc6_ + ("\n" + param1[_loc4_ * param2]);
                  }
               }
               else
               {
                  _loc6_ = _loc6_ + (", " + param1[_loc4_ * param2 + _loc3_]);
               }
               _loc3_++;
            }
            _loc4_++;
         }
         return _loc6_;
      }
      
      public static function bitmapToCSV(param1:BitmapData, param2:Boolean = false, param3:uint = 1) : String
      {
         var _loc11_:* = null;
         var _loc10_:* = null;
         var _loc5_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = null;
         if(param3 > 1)
         {
            _loc11_ = param1;
            param1 = new BitmapData(param1.width * param3,param1.height * param3);
            _loc10_ = new Matrix();
            _loc10_.scale(param3,param3);
            param1.draw(_loc11_,_loc10_);
         }
         var _loc6_:uint = 0;
         var _loc4_:uint = param1.width;
         var _loc9_:uint = param1.height;
         while(_loc6_ < _loc9_)
         {
            _loc5_ = uint(0);
            while(_loc5_ < _loc4_)
            {
               _loc7_ = uint(param1.getPixel(_loc5_,_loc6_));
               if(param2 && _loc7_ > 0 || !param2 && _loc7_ == 0)
               {
                  _loc7_ = uint(1);
               }
               else
               {
                  _loc7_ = uint(0);
               }
               if(_loc5_ == 0)
               {
                  if(_loc6_ == 0)
                  {
                     _loc8_ = _loc8_ + _loc7_;
                  }
                  else
                  {
                     _loc8_ = _loc8_ + ("\n" + _loc7_);
                  }
               }
               else
               {
                  _loc8_ = _loc8_ + (", " + _loc7_);
               }
               _loc5_++;
            }
            _loc6_++;
         }
         return _loc8_;
      }
      
      public static function imageToCSV(param1:Class, param2:Boolean = false, param3:uint = 1) : String
      {
         return bitmapToCSV(new param1().bitmapData,param2,param3);
      }
      
      public function loadMap(param1:String, param2:Class, param3:uint = 0, param4:uint = 0) : FlxTilemap
      {
         var _loc5_:* = null;
         var _loc6_:* = 0;
         var _loc10_:* = 0;
         refresh = true;
         var _loc11_:Array = param1.split("\n");
         heightInTiles = _loc11_.length;
         _data = [];
         var _loc7_:uint = 0;
         while(_loc7_ < heightInTiles)
         {
            _loc5_ = _loc11_[_loc7_++].split(",");
            if(_loc5_.length <= 1)
            {
               heightInTiles = heightInTiles - 1;
            }
            else
            {
               if(widthInTiles == 0)
               {
                  widthInTiles = _loc5_.length;
               }
               _loc6_ = uint(0);
               while(_loc6_ < widthInTiles)
               {
                  _data.push(uint(_loc5_[_loc6_++]));
               }
            }
         }
         totalTiles = widthInTiles * heightInTiles;
         if(auto > 0)
         {
            drawIndex = 1;
            startingIndex = 1;
            collideIndex = 1;
            _loc10_ = uint(0);
            while(_loc10_ < totalTiles)
            {
               autoTile(_loc10_++);
            }
         }
         _pixels = FlxG.addBitmap(param2);
         _tileWidth = param3;
         if(_tileWidth == 0)
         {
            _tileWidth = _pixels.height;
         }
         _tileHeight = param4;
         if(_tileHeight == 0)
         {
            _tileHeight = _tileWidth;
         }
         _block.width = _tileWidth;
         _block.height = _tileHeight;
         width = widthInTiles * _tileWidth;
         height = heightInTiles * _tileHeight;
         _rects = new Array(totalTiles);
         _loc10_ = uint(0);
         while(_loc10_ < totalTiles)
         {
            updateTile(_loc10_++);
         }
         var _loc8_:uint = (FlxU.ceil(FlxG.width / _tileWidth) + 1) * _tileWidth;
         var _loc9_:uint = (FlxU.ceil(FlxG.height / _tileHeight) + 1) * _tileHeight;
         _buffer = new BitmapData(_loc8_,_loc9_,true,0);
         _screenRows = Math.ceil(FlxG.height / _tileHeight) + 1;
         if(_screenRows > heightInTiles)
         {
            _screenRows = heightInTiles;
         }
         _screenCols = Math.ceil(FlxG.width / _tileWidth) + 1;
         if(_screenCols > widthInTiles)
         {
            _screenCols = widthInTiles;
         }
         _bbKey = String(param2);
         generateBoundingTiles();
         refreshHulls();
         _flashRect.x = 0;
         _flashRect.y = 0;
         _flashRect.width = _buffer.width;
         _flashRect.height = _buffer.height;
         return this;
      }
      
      protected function generateBoundingTiles() : void
      {
         var _loc1_:Boolean = false;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         var _loc8_:* = 0;
         refresh = true;
         if(_bbKey == null || _bbKey.length <= 0)
         {
            return;
         }
         var _loc9_:uint = getBoundingColor();
         var _loc7_:String = _bbKey + ":BBTILES" + _loc9_;
         var _loc6_:Boolean = FlxG.checkBitmapCache(_loc7_);
         _bbPixels = FlxG.createBitmap(_pixels.width,_pixels.height,0,true,_loc7_);
         if(!_loc6_)
         {
            _flashRect.width = _pixels.width;
            _flashRect.height = _pixels.height;
            _flashPoint.x = 0;
            _flashPoint.y = 0;
            _bbPixels.copyPixels(_pixels,_flashRect,_flashPoint);
            _flashRect.width = _tileWidth;
            _flashRect.height = _tileHeight;
            _loc1_ = _solid;
            _solid = false;
            _loc9_ = getBoundingColor();
            _loc7_ = "BBTILESTAMP" + _tileWidth + "X" + _tileHeight + _loc9_;
            _loc6_ = FlxG.checkBitmapCache(_loc7_);
            _loc5_ = FlxG.createBitmap(_tileWidth,_tileHeight,0,true,_loc7_);
            if(!_loc6_)
            {
               _loc5_.fillRect(_flashRect,_loc9_);
               var _loc10_:int = 1;
               _flashRect.y = _loc10_;
               _flashRect.x = _loc10_;
               _flashRect.width = _flashRect.width - 2;
               _flashRect.height = _flashRect.height - 2;
               _loc5_.fillRect(_flashRect,0);
               _loc10_ = 0;
               _flashRect.y = _loc10_;
               _flashRect.x = _loc10_;
               _flashRect.width = _tileWidth;
               _flashRect.height = _tileHeight;
            }
            _solid = _loc1_;
            _loc9_ = getBoundingColor();
            _loc7_ = "BBTILESTAMP" + _tileWidth + "X" + _tileHeight + _loc9_;
            _loc6_ = FlxG.checkBitmapCache(_loc7_);
            _loc4_ = FlxG.createBitmap(_tileWidth,_tileHeight,0,true,_loc7_);
            if(!_loc6_)
            {
               _loc4_.fillRect(_flashRect,_loc9_);
               _loc10_ = 1;
               _flashRect.y = _loc10_;
               _flashRect.x = _loc10_;
               _flashRect.width = _flashRect.width - 2;
               _flashRect.height = _flashRect.height - 2;
               _loc4_.fillRect(_flashRect,0);
               _loc10_ = 0;
               _flashRect.y = _loc10_;
               _flashRect.x = _loc10_;
               _flashRect.width = _tileWidth;
               _flashRect.height = _tileHeight;
            }
            _loc3_ = uint(0);
            _loc8_ = uint(0);
            while(_loc3_ < _bbPixels.height)
            {
               _loc2_ = uint(0);
               while(_loc2_ < _bbPixels.width)
               {
                  _flashPoint.x = _loc2_;
                  _flashPoint.y = _loc3_;
                  if(_loc8_++ < collideIndex)
                  {
                     _bbPixels.copyPixels(_loc5_,_flashRect,_flashPoint,null,null,true);
                  }
                  else
                  {
                     _bbPixels.copyPixels(_loc4_,_flashRect,_flashPoint,null,null,true);
                  }
                  _loc2_ = uint(_loc2_ + _tileWidth);
               }
               _loc3_ = uint(_loc3_ + _tileHeight);
            }
            _flashRect.x = 0;
            _flashRect.y = 0;
            _flashRect.width = _buffer.width;
            _flashRect.height = _buffer.height;
         }
      }
      
      protected function renderTilemap() : void
      {
         var _loc6_:* = null;
         var _loc3_:* = 0;
         var _loc7_:* = 0;
         _buffer.fillRect(_flashRect,0);
         if(FlxG.showBounds)
         {
            _loc6_ = _bbPixels;
            _boundsVisible = true;
         }
         else
         {
            _loc6_ = _pixels;
            _boundsVisible = false;
         }
         getScreenXY(_point);
         _flashPoint.x = _point.x;
         _flashPoint.y = _point.y;
         var _loc2_:int = Math.floor(-_flashPoint.x / _tileWidth);
         var _loc1_:int = Math.floor(-_flashPoint.y / _tileHeight);
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > widthInTiles - _screenCols)
         {
            _loc2_ = widthInTiles - _screenCols;
         }
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         if(_loc1_ > heightInTiles - _screenRows)
         {
            _loc1_ = heightInTiles - _screenRows;
         }
         var _loc5_:int = _loc1_ * widthInTiles + _loc2_;
         _flashPoint.y = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < _screenRows)
         {
            _loc7_ = uint(_loc5_);
            _loc3_ = uint(0);
            _flashPoint.x = 0;
            while(_loc3_ < _screenCols)
            {
               _flashRect = _rects[_loc7_++] as Rectangle;
               if(_flashRect != null)
               {
                  _buffer.copyPixels(_loc6_,_flashRect,_flashPoint,null,null,true);
               }
               _flashPoint.x = _flashPoint.x + _tileWidth;
               _loc3_++;
            }
            _loc5_ = _loc5_ + widthInTiles;
            _flashPoint.y = _flashPoint.y + _tileHeight;
            _loc4_++;
         }
         _flashRect = _flashRect2;
         _bufferLoc.x = _loc2_ * _tileWidth;
         _bufferLoc.y = _loc1_ * _tileHeight;
      }
      
      override public function update() : void
      {
         super.update();
         getScreenXY(_point);
         _point.x = _point.x + _bufferLoc.x;
         _point.y = _point.y + _bufferLoc.y;
         if(_point.x > 0 || _point.y > 0 || _point.x + _buffer.width < FlxG.width || _point.y + _buffer.height < FlxG.height)
         {
            refresh = true;
         }
      }
      
      override public function render() : void
      {
         if(FlxG.showBounds != _boundsVisible)
         {
            refresh = true;
         }
         if(refresh)
         {
            renderTilemap();
            refresh = false;
         }
         getScreenXY(_point);
         _flashPoint.x = _point.x + _bufferLoc.x;
         _flashPoint.y = _point.y + _bufferLoc.y;
         FlxG.buffer.copyPixels(_buffer,_flashRect,_flashPoint,null,null,true);
      }
      
      override public function set solid(param1:Boolean) : void
      {
         var _loc2_:Boolean = _solid;
         _solid = param1;
         if(_loc2_ != _solid)
         {
            generateBoundingTiles();
         }
      }
      
      override public function set fixed(param1:Boolean) : void
      {
         var _loc2_:Boolean = _fixed;
         _fixed = param1;
         if(_loc2_ != _fixed)
         {
            generateBoundingTiles();
         }
      }
      
      override public function overlaps(param1:FlxObject) : Boolean
      {
         var _loc2_:* = 0;
         var _loc8_:* = 0;
         var _loc3_:* = 0;
         var _loc6_:Array = [];
         var _loc5_:uint = Math.floor((param1.x - x) / _tileWidth);
         var _loc12_:uint = Math.floor((param1.y - y) / _tileHeight);
         var _loc4_:uint = Math.ceil(param1.width / _tileWidth) + 1;
         var _loc9_:uint = Math.ceil(param1.height / _tileHeight) + 1;
         var _loc10_:uint = 0;
         while(_loc10_ < _loc9_)
         {
            if(_loc10_ < heightInTiles)
            {
               _loc2_ = uint((_loc12_ + _loc10_) * widthInTiles + _loc5_);
               _loc3_ = uint(0);
               while(_loc3_ < _loc4_)
               {
                  if(_loc3_ < widthInTiles)
                  {
                     _loc8_ = uint(_data[_loc2_ + _loc3_] as uint);
                     if(_loc8_ >= collideIndex)
                     {
                        _loc6_.push({
                           "x":x + (_loc5_ + _loc3_) * _tileWidth,
                           "y":y + (_loc12_ + _loc10_) * _tileHeight,
                           "data":_loc8_
                        });
                     }
                     _loc3_++;
                     continue;
                  }
                  break;
               }
               _loc10_++;
               continue;
            }
            break;
         }
         var _loc11_:uint = _loc6_.length;
         var _loc13_:Boolean = false;
         var _loc7_:uint = 0;
         while(_loc7_ < _loc11_)
         {
            _block.x = _loc6_[_loc7_].x;
            _block.y = _loc6_[_loc7_++].y;
            if(_block.overlaps(param1))
            {
               return true;
            }
         }
         return false;
      }
      
      override public function overlapsPoint(param1:Number, param2:Number, param3:Boolean = false) : Boolean
      {
         return getTile(uint((param1 - x) / _tileWidth),uint((param2 - y) / _tileHeight)) >= this.collideIndex;
      }
      
      override public function refreshHulls() : void
      {
         colHullX.x = 0;
         colHullX.y = 0;
         colHullX.width = _tileWidth;
         colHullX.height = _tileHeight;
         colHullY.x = 0;
         colHullY.y = 0;
         colHullY.width = _tileWidth;
         colHullY.height = _tileHeight;
      }
      
      override public function preCollide(param1:FlxObject) : void
      {
         var _loc5_:* = 0;
         var _loc4_:* = 0;
         var _loc9_:* = 0;
         colHullX.x = 0;
         colHullX.y = 0;
         colHullY.x = 0;
         colHullY.y = 0;
         var _loc2_:uint = 0;
         var _loc7_:int = FlxU.floor((param1.x - x) / _tileWidth);
         var _loc8_:int = FlxU.floor((param1.y - y) / _tileHeight);
         var _loc6_:uint = _loc7_ + FlxU.ceil(param1.width / _tileWidth) + 1;
         var _loc3_:uint = _loc8_ + FlxU.ceil(param1.height / _tileHeight) + 1;
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
         }
         if(_loc8_ < 0)
         {
            _loc8_ = 0;
         }
         if(_loc6_ > widthInTiles)
         {
            _loc6_ = widthInTiles;
         }
         if(_loc3_ > heightInTiles)
         {
            _loc3_ = heightInTiles;
         }
         _loc9_ = uint(_loc8_ * widthInTiles);
         _loc5_ = uint(_loc8_);
         while(_loc5_ < _loc3_)
         {
            _loc4_ = uint(_loc7_);
            while(_loc4_ < _loc6_)
            {
               if(_data[_loc9_ + _loc4_] as uint >= collideIndex)
               {
                  colOffsets[_loc2_++] = new FlxPoint(x + _loc4_ * _tileWidth,y + _loc5_ * _tileHeight);
               }
               _loc4_++;
            }
            _loc9_ = uint(_loc9_ + widthInTiles);
            _loc5_++;
         }
         if(colOffsets.length != _loc2_)
         {
            colOffsets.length = _loc2_;
         }
      }
      
      public function getTile(param1:uint, param2:uint) : uint
      {
         return getTileByIndex(param2 * widthInTiles + param1);
      }
      
      public function getTileByIndex(param1:uint) : uint
      {
         return _data[param1] as uint;
      }
      
      public function setTile(param1:uint, param2:uint, param3:uint, param4:Boolean = true) : Boolean
      {
         if(param1 >= widthInTiles || param2 >= heightInTiles)
         {
            return false;
         }
         return setTileByIndex(param2 * widthInTiles + param1,param3,param4);
      }
      
      public function setTileByIndex(param1:uint, param2:uint, param3:Boolean = true) : Boolean
      {
         var _loc9_:* = 0;
         if(param1 >= _data.length)
         {
            return false;
         }
         var _loc8_:Boolean = true;
         _data[param1] = param2;
         if(!param3)
         {
            return _loc8_;
         }
         refresh = true;
         if(auto == 0)
         {
            updateTile(param1);
            return _loc8_;
         }
         var _loc6_:int = int(param1 / widthInTiles) - 1;
         var _loc5_:int = _loc6_ + 3;
         var _loc4_:int = param1 % widthInTiles - 1;
         var _loc7_:int = _loc4_ + 3;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = _loc7_ - 3;
            while(_loc4_ < _loc7_)
            {
               if(_loc6_ >= 0 && _loc6_ < heightInTiles && _loc4_ >= 0 && _loc4_ < widthInTiles)
               {
                  _loc9_ = uint(_loc6_ * widthInTiles + _loc4_);
                  autoTile(_loc9_);
                  updateTile(_loc9_);
               }
               _loc4_++;
            }
            _loc6_++;
         }
         return _loc8_;
      }
      
      public function setCallback(param1:uint, param2:Function, param3:uint = 1) : void
      {
         FlxG.log("WARNING: FlxTilemap.setCallback()\nhas been temporarily deprecated.");
      }
      
      public function follow(param1:int = 0) : void
      {
         FlxG.followBounds(x + param1 * _tileWidth,y + param1 * _tileHeight,width - param1 * _tileWidth,height - param1 * _tileHeight);
      }
      
      public function ray(param1:Number, param2:Number, param3:Number, param4:Number, param5:FlxPoint, param6:Number = 1) : Boolean
      {
         var _loc17_:* = 0;
         var _loc15_:* = 0;
         var _loc21_:* = NaN;
         var _loc23_:* = NaN;
         var _loc20_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc22_:Number = _tileWidth;
         if(_tileHeight < _tileWidth)
         {
            _loc22_ = _tileHeight;
         }
         _loc22_ = _loc22_ / param6;
         var _loc9_:Number = param3 - param1;
         var _loc10_:Number = param4 - param2;
         var _loc19_:Number = Math.sqrt(_loc9_ * _loc9_ + _loc10_ * _loc10_);
         var _loc11_:uint = Math.ceil(_loc19_ / _loc22_);
         var _loc7_:Number = _loc9_ / _loc11_;
         var _loc8_:Number = _loc10_ / _loc11_;
         var _loc16_:Number = param1 - _loc7_;
         var _loc18_:Number = param2 - _loc8_;
         var _loc14_:uint = 0;
         while(_loc14_ < _loc11_)
         {
            _loc16_ = _loc16_ + _loc7_;
            _loc18_ = _loc18_ + _loc8_;
            if(_loc16_ < 0 || _loc16_ > width || _loc18_ < 0 || _loc18_ > height)
            {
               _loc14_++;
            }
            else
            {
               _loc17_ = uint(_loc16_ / _tileWidth);
               _loc15_ = uint(_loc18_ / _tileHeight);
               if(_data[_loc15_ * widthInTiles + _loc17_] as uint >= collideIndex)
               {
                  _loc17_ = uint(_loc17_ * _tileWidth);
                  _loc15_ = uint(_loc15_ * _tileHeight);
                  _loc21_ = 0;
                  _loc23_ = 0;
                  _loc13_ = _loc16_ - _loc7_;
                  _loc12_ = _loc18_ - _loc8_;
                  _loc20_ = _loc17_;
                  if(_loc9_ < 0)
                  {
                     _loc20_ = _loc20_ + _tileWidth;
                  }
                  _loc21_ = _loc20_;
                  _loc23_ = Number(_loc12_ + _loc8_ * ((_loc20_ - _loc13_) / _loc7_));
                  if(_loc23_ > _loc15_ && _loc23_ < _loc15_ + _tileHeight)
                  {
                     if(param5 == null)
                     {
                        param5 = new FlxPoint();
                     }
                     param5.x = _loc21_;
                     param5.y = _loc23_;
                     return true;
                  }
                  _loc20_ = _loc15_;
                  if(_loc10_ < 0)
                  {
                     _loc20_ = _loc20_ + _tileHeight;
                  }
                  _loc21_ = Number(_loc13_ + _loc7_ * ((_loc20_ - _loc12_) / _loc8_));
                  _loc23_ = _loc20_;
                  if(_loc21_ > _loc17_ && _loc21_ < _loc17_ + _tileWidth)
                  {
                     if(param5 == null)
                     {
                        param5 = new FlxPoint();
                     }
                     param5.x = _loc21_;
                     param5.y = _loc23_;
                     return true;
                  }
                  return false;
               }
               _loc14_++;
            }
         }
         return false;
      }
      
      protected function autoTile(param1:uint) : void
      {
         if(_data[param1] == 0)
         {
            return;
         }
         _data[param1] = 0;
         if(param1 - widthInTiles < 0 || _data[param1 - widthInTiles] > 0)
         {
            var _loc2_:* = param1;
            var _loc3_:* = _data[_loc2_] + 1;
            _data[_loc2_] = _loc3_;
         }
         if(param1 % widthInTiles >= widthInTiles - 1 || _data[param1 + 1] > 0)
         {
            _loc3_ = param1;
            _loc2_ = _data[_loc3_] + 2;
            _data[_loc3_] = _loc2_;
         }
         if(param1 + widthInTiles >= totalTiles || _data[param1 + widthInTiles] > 0)
         {
            _loc2_ = param1;
            _loc3_ = _data[_loc2_] + 4;
            _data[_loc2_] = _loc3_;
         }
         if(param1 % widthInTiles <= 0 || _data[param1 - 1] > 0)
         {
            _loc3_ = param1;
            _loc2_ = _data[_loc3_] + 8;
            _data[_loc3_] = _loc2_;
         }
         if(auto == 2 && _data[param1] == 15)
         {
            if(param1 % widthInTiles > 0 && param1 + widthInTiles < totalTiles && _data[param1 + widthInTiles - 1] <= 0)
            {
               _data[param1] = 1;
            }
            if(param1 % widthInTiles > 0 && param1 - widthInTiles >= 0 && _data[param1 - widthInTiles - 1] <= 0)
            {
               _data[param1] = 2;
            }
            if(param1 % widthInTiles < widthInTiles - 1 && param1 - widthInTiles >= 0 && _data[param1 - widthInTiles + 1] <= 0)
            {
               _data[param1] = 4;
            }
            if(param1 % widthInTiles < widthInTiles - 1 && param1 + widthInTiles < totalTiles && _data[param1 + widthInTiles + 1] <= 0)
            {
               _data[param1] = 8;
            }
         }
         _loc2_ = param1;
         _loc3_ = _data[_loc2_] + 1;
         _data[_loc2_] = _loc3_;
      }
      
      protected function updateTile(param1:uint) : void
      {
         if(_data[param1] < drawIndex)
         {
            _rects[param1] = null;
            return;
         }
         var _loc2_:uint = (_data[param1] - startingIndex) * _tileWidth;
         var _loc3_:uint = 0;
         if(_loc2_ >= _pixels.width)
         {
            _loc3_ = uint(_loc2_ / _pixels.width) * _tileHeight;
            _loc2_ = _loc2_ % _pixels.width;
         }
         _rects[param1] = new Rectangle(_loc2_,_loc3_,_tileWidth,_tileHeight);
      }
   }
}
