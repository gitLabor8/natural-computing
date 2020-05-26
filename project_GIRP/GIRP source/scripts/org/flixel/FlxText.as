package org.flixel
{
   import flash.display.BitmapData;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class FlxText extends FlxSprite
   {
       
      
      protected var _tf:TextField;
      
      protected var _regen:Boolean;
      
      protected var _shadow:uint;
      
      public function FlxText(param1:Number, param2:Number, param3:uint, param4:String = null, param5:Boolean = true)
      {
         super(param1,param2);
         createGraphic(param3,1,0);
         if(param4 == null)
         {
            param4 = "";
         }
         _tf = new TextField();
         _tf.width = param3;
         _tf.embedFonts = param5;
         _tf.selectable = false;
         _tf.sharpness = 100;
         _tf.multiline = true;
         _tf.wordWrap = true;
         _tf.text = param4;
         var _loc6_:TextFormat = new TextFormat("system",8,16777215);
         _tf.defaultTextFormat = _loc6_;
         _tf.setTextFormat(_loc6_);
         if(param4.length <= 0)
         {
            _tf.height = 1;
         }
         else
         {
            _tf.height = 10;
         }
         _regen = true;
         _shadow = 0;
         solid = false;
         calcFrame();
      }
      
      public function setFormat(param1:String = null, param2:Number = 8, param3:uint = 16777215, param4:String = null, param5:uint = 0) : FlxText
      {
         if(param1 == null)
         {
            param1 = "";
         }
         var _loc6_:TextFormat = dtfCopy();
         _loc6_.font = param1;
         _loc6_.size = param2;
         _loc6_.color = param3;
         _loc6_.align = param4;
         _tf.defaultTextFormat = _loc6_;
         _tf.setTextFormat(_loc6_);
         _shadow = param5;
         _regen = true;
         calcFrame();
         return this;
      }
      
      public function get text() : String
      {
         return _tf.text;
      }
      
      public function set text(param1:String) : void
      {
         var _loc2_:String = _tf.text;
         _tf.text = param1;
         if(_tf.text != _loc2_)
         {
            _regen = true;
            calcFrame();
         }
      }
      
      public function get size() : Number
      {
         return _tf.defaultTextFormat.size as Number;
      }
      
      public function set size(param1:Number) : void
      {
         var _loc2_:TextFormat = dtfCopy();
         _loc2_.size = param1;
         _tf.defaultTextFormat = _loc2_;
         _tf.setTextFormat(_loc2_);
         _regen = true;
         calcFrame();
      }
      
      override public function get color() : uint
      {
         return _tf.defaultTextFormat.color as uint;
      }
      
      override public function set color(param1:uint) : void
      {
         var _loc2_:TextFormat = dtfCopy();
         _loc2_.color = param1;
         _tf.defaultTextFormat = _loc2_;
         _tf.setTextFormat(_loc2_);
         _regen = true;
         calcFrame();
      }
      
      public function get font() : String
      {
         return _tf.defaultTextFormat.font;
      }
      
      public function set font(param1:String) : void
      {
         var _loc2_:TextFormat = dtfCopy();
         _loc2_.font = param1;
         _tf.defaultTextFormat = _loc2_;
         _tf.setTextFormat(_loc2_);
         _regen = true;
         calcFrame();
      }
      
      public function get alignment() : String
      {
         return _tf.defaultTextFormat.align;
      }
      
      public function set alignment(param1:String) : void
      {
         var _loc2_:TextFormat = dtfCopy();
         _loc2_.align = param1;
         _tf.defaultTextFormat = _loc2_;
         _tf.setTextFormat(_loc2_);
         calcFrame();
      }
      
      public function get shadow() : uint
      {
         return _shadow;
      }
      
      public function set shadow(param1:uint) : void
      {
         _shadow = param1;
         calcFrame();
      }
      
      override protected function calcFrame() : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc1_:* = null;
         if(_regen)
         {
            _loc4_ = uint(0);
            _loc3_ = uint(_tf.numLines);
            height = 0;
            while(_loc4_ < _loc3_)
            {
               height = height + _tf.getLineMetrics(_loc4_++).height;
            }
            height = height + 4;
            _pixels = new BitmapData(width,height,true,0);
            _bbb = new BitmapData(width,height,true,0);
            frameHeight = height;
            _tf.height = height * 1.2;
            _flashRect.x = 0;
            _flashRect.y = 0;
            _flashRect.width = width;
            _flashRect.height = height;
            _regen = false;
         }
         else
         {
            _pixels.fillRect(_flashRect,0);
         }
         if(_tf != null && _tf.text != null && _tf.text.length > 0)
         {
            _loc2_ = _tf.defaultTextFormat;
            _loc1_ = _loc2_;
            _mtx.identity();
            if(_loc2_.align == "center" && _tf.numLines == 1)
            {
               _loc1_ = new TextFormat(_loc2_.font,_loc2_.size,_loc2_.color,null,null,null,null,null,"left");
               _tf.setTextFormat(_loc1_);
               _mtx.translate(Math.floor((width - _tf.getLineMetrics(0).width) / 2),0);
            }
            if(_shadow > 0)
            {
               _tf.setTextFormat(new TextFormat(_loc1_.font,_loc1_.size,_shadow,null,null,null,null,null,_loc1_.align));
               _mtx.translate(1,1);
               _pixels.draw(_tf,_mtx,_ct);
               _mtx.translate(-1,-1);
               _tf.setTextFormat(new TextFormat(_loc1_.font,_loc1_.size,_loc1_.color,null,null,null,null,null,_loc1_.align));
            }
            _pixels.draw(_tf,_mtx,_ct);
            _tf.setTextFormat(new TextFormat(_loc2_.font,_loc2_.size,_loc2_.color,null,null,null,null,null,_loc2_.align));
         }
         if(_framePixels == null || _framePixels.width != _pixels.width || _framePixels.height != _pixels.height)
         {
            _framePixels = new BitmapData(_pixels.width,_pixels.height,true,0);
         }
         _framePixels.copyPixels(_pixels,_flashRect,_flashPointZero);
         if(FlxG.showBounds)
         {
            drawBounds();
         }
         if(solid)
         {
            refreshHulls();
         }
      }
      
      protected function dtfCopy() : TextFormat
      {
         var _loc1_:TextFormat = _tf.defaultTextFormat;
         return new TextFormat(_loc1_.font,_loc1_.size,_loc1_.color,_loc1_.bold,_loc1_.italic,_loc1_.underline,_loc1_.url,_loc1_.target,_loc1_.align);
      }
   }
}
