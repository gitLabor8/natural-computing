package org.flixel.data
{
   import flash.ui.Mouse;
   import org.flixel.FlxButton;
   import org.flixel.FlxG;
   import org.flixel.FlxObject;
   import org.flixel.FlxSprite;
   import org.flixel.FlxText;
   import org.flixel.FlxU;
   
   public class FlxPanel extends FlxObject
   {
       
      
      private var ImgDonate:Class;
      
      private var ImgStumble:Class;
      
      private var ImgDigg:Class;
      
      private var ImgReddit:Class;
      
      private var ImgDelicious:Class;
      
      private var ImgTwitter:Class;
      
      private var ImgClose:Class;
      
      protected var _topBar:FlxSprite;
      
      protected var _mainBar:FlxSprite;
      
      protected var _bottomBar:FlxSprite;
      
      protected var _donate:FlxButton;
      
      protected var _stumble:FlxButton;
      
      protected var _digg:FlxButton;
      
      protected var _reddit:FlxButton;
      
      protected var _delicious:FlxButton;
      
      protected var _twitter:FlxButton;
      
      protected var _close:FlxButton;
      
      protected var _caption:FlxText;
      
      protected var _payPalID:String;
      
      protected var _payPalAmount:Number;
      
      protected var _gameTitle:String;
      
      protected var _gameURL:String;
      
      protected var _initialized:Boolean;
      
      protected var _closed:Boolean;
      
      protected var _ty:Number;
      
      protected var _s:Number;
      
      public function FlxPanel()
      {
         ImgDonate = donate_png$6214e2e7f0f2ef3dd5aed4cead1b1937167252076;
         ImgStumble = stumble_png$c3c418c75b2a736cce207a9c9ac71e80149971019;
         ImgDigg = digg_png$332c1a1786cbdaa9ba0f796aac9527301661531162;
         ImgReddit = reddit_png$7756ddc04e1e7ae13897818fb224f902437073347;
         ImgDelicious = delicious_png$dd2b81dfe3aa46822ec4a6e9ae72b0b02026596962;
         ImgTwitter = twitter_png$6cf519512db02f173578ec97b45dfe48106554548;
         ImgClose = §close_png$faca405c5137cb63b3a3e455e73c1b08-2068212943§;
         super();
         y = -21;
         _ty = y;
         _closed = false;
         _initialized = false;
         _topBar = new FlxSprite();
         _topBar.createGraphic(FlxG.width,1,2147483647);
         _topBar.scrollFactor.x = 0;
         _topBar.scrollFactor.y = 0;
         _mainBar = new FlxSprite();
         _mainBar.createGraphic(FlxG.width,19,2130706432);
         _mainBar.scrollFactor.x = 0;
         _mainBar.scrollFactor.y = 0;
         _bottomBar = new FlxSprite();
         _bottomBar.createGraphic(FlxG.width,1,2147483647);
         _bottomBar.scrollFactor.x = 0;
         _bottomBar.scrollFactor.y = 0;
         _donate = new FlxButton(3,0,onDonate);
         _donate.loadGraphic(new FlxSprite(0,0,ImgDonate));
         _donate.scrollFactor.x = 0;
         _donate.scrollFactor.y = 0;
         _stumble = new FlxButton(FlxG.width / 2 - 6 - 13 - 6 - 13 - 6,0,onStumble);
         _stumble.loadGraphic(new FlxSprite(0,0,ImgStumble));
         _stumble.scrollFactor.x = 0;
         _stumble.scrollFactor.y = 0;
         _digg = new FlxButton(FlxG.width / 2 - 6 - 13 - 6,0,onDigg);
         _digg.loadGraphic(new FlxSprite(0,0,ImgDigg));
         _digg.scrollFactor.x = 0;
         _digg.scrollFactor.y = 0;
         _reddit = new FlxButton(FlxG.width / 2 - 6,0,onReddit);
         _reddit.loadGraphic(new FlxSprite(0,0,ImgReddit));
         _reddit.scrollFactor.x = 0;
         _reddit.scrollFactor.y = 0;
         _delicious = new FlxButton(FlxG.width / 2 + 7 + 6,0,onDelicious);
         _delicious.loadGraphic(new FlxSprite(0,0,ImgDelicious));
         _delicious.scrollFactor.x = 0;
         _delicious.scrollFactor.y = 0;
         _twitter = new FlxButton(FlxG.width / 2 + 7 + 6 + 12 + 6,0,onTwitter);
         _twitter.loadGraphic(new FlxSprite(0,0,ImgTwitter));
         _twitter.scrollFactor.x = 0;
         _twitter.scrollFactor.y = 0;
         _caption = new FlxText(FlxG.width / 2,0,FlxG.width / 2 - 19,"");
         _caption.alignment = "right";
         _caption.scrollFactor.x = 0;
         _caption.scrollFactor.y = 0;
         _close = new FlxButton(FlxG.width - 16,0,onClose);
         _close.loadGraphic(new FlxSprite(0,0,ImgClose));
         _close.scrollFactor.x = 0;
         _close.scrollFactor.y = 0;
         hide();
         visible = false;
         _s = 50;
      }
      
      public function setup(param1:String, param2:Number, param3:String, param4:String, param5:String) : void
      {
         _payPalID = param1;
         if(_payPalID.length <= 0)
         {
            _donate.visible = false;
         }
         _payPalAmount = param2;
         _gameTitle = param3;
         _gameURL = param4;
         _caption.text = param5;
         _initialized = true;
      }
      
      override public function update() : void
      {
         if(!_initialized)
         {
            return;
         }
         if(_ty != y)
         {
            if(y < _ty)
            {
               y = y + FlxG.elapsed * _s;
               if(y > _ty)
               {
                  y = _ty;
               }
            }
            else
            {
               y = y - FlxG.elapsed * _s;
               if(y < _ty)
               {
                  y = _ty;
               }
            }
            _topBar.y = y;
            _mainBar.y = y + 1;
            _bottomBar.y = y + 20;
            _donate.reset(_donate.x,y + 4);
            _stumble.reset(_stumble.x,y + 4);
            _digg.reset(_digg.x,y + 4);
            _reddit.reset(_reddit.x,y + 4);
            _delicious.reset(_delicious.x,y + 5);
            _twitter.reset(_twitter.x,y + 4);
            _caption.reset(_caption.x,y + 4);
            _close.reset(_close.x,y + 4);
         }
         if(y <= -21 || y >= FlxG.height)
         {
            visible = false;
         }
         else
         {
            visible = true;
         }
         if(visible)
         {
            if(_donate.active)
            {
               _donate.update();
            }
            if(_stumble.active)
            {
               _stumble.update();
            }
            if(_digg.active)
            {
               _digg.update();
            }
            if(_reddit.active)
            {
               _reddit.update();
            }
            if(_delicious.active)
            {
               _delicious.update();
            }
            if(_twitter.active)
            {
               _twitter.update();
            }
            if(_caption.active)
            {
               _caption.update();
            }
            if(_close.active)
            {
               _close.update();
            }
         }
      }
      
      override public function render() : void
      {
         if(!_initialized)
         {
            return;
         }
         if(_topBar.visible)
         {
            _topBar.render();
         }
         if(_mainBar.visible)
         {
            _mainBar.render();
         }
         if(_bottomBar.visible)
         {
            _bottomBar.render();
         }
         if(_donate.visible)
         {
            _donate.render();
         }
         if(_stumble.visible)
         {
            _stumble.render();
         }
         if(_digg.visible)
         {
            _digg.render();
         }
         if(_reddit.visible)
         {
            _reddit.render();
         }
         if(_delicious.visible)
         {
            _delicious.render();
         }
         if(_twitter.visible)
         {
            _twitter.render();
         }
         if(_caption.visible)
         {
            _caption.render();
         }
         if(_close.visible)
         {
            _close.render();
         }
      }
      
      public function show(param1:Boolean = true) : void
      {
         if(_closed)
         {
            return;
         }
         if(!_initialized)
         {
            FlxG.log("SUPPORT PANEL ERROR: Uninitialized.\nYou forgot to call FlxGame.setupSupportPanel()\nfrom your game constructor.");
            return;
         }
         if(param1)
         {
            y = -21;
            _ty = -1;
         }
         else
         {
            y = FlxG.height;
            _ty = FlxG.height - 20;
         }
         _donate.reset(_donate.x,y + 4);
         _stumble.reset(_stumble.x,y + 4);
         _digg.reset(_digg.x,y + 4);
         _reddit.reset(_reddit.x,y + 4);
         _delicious.reset(_delicious.x,y + 5);
         _twitter.reset(_twitter.x,y + 4);
         _caption.reset(_caption.x,y + 4);
         _close.reset(_close.x,y + 4);
         if(!FlxG.mouse.cursor.visible)
         {
            Mouse.show();
         }
         visible = true;
      }
      
      public function hide() : void
      {
         if(y < 0)
         {
            _ty = -21;
         }
         else
         {
            _ty = FlxG.height;
         }
         Mouse.hide();
      }
      
      public function onDonate() : void
      {
         FlxU.openURL("https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=" + encodeURIComponent(_payPalID) + "&item_name=" + encodeURIComponent(_gameTitle + " Contribution (" + _gameURL) + ")&currency_code=USD&amount=" + _payPalAmount);
      }
      
      public function onStumble() : void
      {
         FlxU.openURL("http://www.stumbleupon.com/submit?url=" + encodeURIComponent(_gameURL));
      }
      
      public function onDigg() : void
      {
         FlxU.openURL("http://digg.com/submit?url=" + encodeURIComponent(_gameURL) + "&title=" + encodeURIComponent(_gameTitle));
      }
      
      public function onReddit() : void
      {
         FlxU.openURL("http://www.reddit.com/submit?url=" + encodeURIComponent(_gameURL));
      }
      
      public function onDelicious() : void
      {
         FlxU.openURL("http://delicious.com/save?v=5&amp;noui&amp;jump=close&amp;url=" + encodeURIComponent(_gameURL) + "&amp;title=" + encodeURIComponent(_gameTitle));
      }
      
      public function onTwitter() : void
      {
         FlxU.openURL("http://twitter.com/home?status=Playing" + encodeURIComponent(" " + _gameTitle + " - " + _gameURL));
      }
      
      public function onClose() : void
      {
         _closed = true;
         hide();
      }
   }
}
