package
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.b2AABB;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2FixtureDef;
   import Box2D.Dynamics.b2World;
   import de.polygonal.math.PM_PRNG;
   import flash.geom.Point;
   import org.flixel.FlxEmitter;
   import org.flixel.FlxG;
   import org.flixel.FlxGroup;
   import org.flixel.FlxPoint;
   import org.flixel.FlxSave;
   import org.flixel.FlxSound;
   import org.flixel.FlxSprite;
   import org.flixel.FlxState;
   import org.flixel.FlxText;
   import org.flixel.FlxTilemap;
   import org.flixel.data.FlxPause;
   
   public class PlayState extends FlxState
   {
      
      private static var _startX:Number = 112;
      
      private static var _startY:Number = -2;
       
      
      private const FREE:Number = 0;
      
      private const ASSIGNED:Number = 1;
      
      private const LOCKED:Number = 2;
      
      private const DISABLED:Number = 3;
      
      private const BIRD_START_HEIGHT:Number = 10;
      
      private var ratio:Number = 32;
      
      public var _water:Water;
      
      public var _world:b2World;
      
      private var _ladder:b2FlxSprite;
      
      private var _alphabet:Array;
      
      private var _lettersInUse:Array;
      
      private var _freeLetters:Array;
      
      private var _toeholds:Array;
      
      public var _player:Player;
      
      private var _toeholdsOnScreen:Array;
      
      private var _maxRows:Number = 80;
      
      private var _seed:Number = 32371780;
      
      private var cameraTarget:FlxSprite;
      
      public var prand:PM_PRNG;
      
      private var testB:Boolean = false;
      
      private var tempTH:Toehold;
      
      private var BGLayer:FlxGroup;
      
      private var CliffLayer:FlxGroup;
      
      private var PlayerLayer:FlxGroup;
      
      private var TopLayer:FlxGroup;
      
      private var _ladderUp:Boolean = true;
      
      private var rockTilemap:FlxTilemap;
      
      private var ringTilemap:FlxTilemap;
      
      private var _bestScore:Number = 0;
      
      private var _scoreLabel:FlxText;
      
      private var _waterLevel:Number;
      
      private var _startingScore:Number;
      
      public var _bird:Bird;
      
      private var _splash:FlxEmitter;
      
      private var _worldPaused:Boolean;
      
      private var _soundHeight:Number;
      
      private var _hiScore:Number;
      
      private var _hiScoreType:String;
      
      private var _bestText:FlxText;
      
      private var _save:FlxSave;
      
      private var _time:Number;
      
      private var _started:Boolean;
      
      private var _resetting:Boolean;
      
      public var _resumeKey:String;
      
      private var ImgLadder:Class;
      
      public var RockMap:Class;
      
      public var ImgRocks:Class;
      
      public var RingMap:Class;
      
      public var ImgSky:Class;
      
      private var SplashSnd:Class;
      
      private var CadenceSnd:Class;
      
      private var ImgMountain1:Class;
      
      private var ImgMountain2:Class;
      
      private var ImgMountain3:Class;
      
      public var junk3:String;
      
      private var _amb:FlxSound;
      
      public function PlayState()
      {
         var _loc5_:int = 0;
         var _loc10_:int = 0;
         var _loc15_:Number = NaN;
         var _loc2_:Number = NaN;
         ImgLadder = §ladder_png$c371f20cc79047e7632e8be613984984-884163147§;
         RockMap = §mapCSV_Group1_Map1_csv$6a97ef4fa762f42dcd56d54d28e200da-1011577238§;
         ImgRocks = rocks9_png$b9613f89d5ba77b3a88586a5f51fb6b8908740078;
         RingMap = mapCSV_Group2_Map1_csv$92d74ccc1128f9f247b20758db429c6c906166411;
         ImgSky = gradient_jpg$f6267fb6aab34be3e33651371e090057316389146;
         SplashSnd = splash_mp3$1b28f833200bf8d020ecab86998fc81f20569468;
         CadenceSnd = §cadence_mp3$4d43abe6d028cad214fbf3b8cd1f9c20-1844628466§;
         ImgMountain1 = mountain1_png$8bfb24789640ae588f054ed0f02a9e5f296594223;
         ImgMountain2 = mountain2_png$1bd37e935e5cdd87a054e6ce5438e3e3297763752;
         ImgMountain3 = mountain3_png$adbd7ed61a3b7b09542abc51b7ea02a4293706281;
         junk3 = "Adore64_ttf$bc1e35d91db6fafdc1a0131a1af022d4-69854982";
         super();
         FlxG.debug = false;
         _resetting = false;
         _time = 0;
         _started = false;
         _save = new FlxSave();
         var _loc16_:FlxPause = FlxG._game.pause as FlxPause;
         _loc16_._resumeKey = "R";
         _loc16_._focus = false;
         _save.bind("highScore");
         _save.bind("highScoreType");
         if(_save.read("highScore"))
         {
            _hiScore = _save.read("highScore") as Number;
         }
         else
         {
            _hiScore = 0;
         }
         if(_save.read("highScoreType"))
         {
            _hiScoreType = _save.read("highScoreType") as String;
         }
         else
         {
            _hiScoreType = "distance";
         }
         _soundHeight = 0;
         _worldPaused = false;
         BGLayer = new FlxGroup();
         add(BGLayer);
         CliffLayer = new FlxGroup();
         add(CliffLayer);
         PlayerLayer = new FlxGroup();
         add(PlayerLayer);
         TopLayer = new FlxGroup();
         add(TopLayer);
         prand = new PM_PRNG();
         prand.seed = _seed;
         setupWorld();
         _toeholds = [];
         _toeholdsOnScreen = [];
         _alphabet = [];
         var _loc6_:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
         _alphabet = _loc6_.split("");
         _lettersInUse = [];
         _loc5_ = 0;
         while(_loc5_ < _alphabet.length)
         {
            _lettersInUse[_alphabet[_loc5_]] = 0;
            _loc5_++;
         }
         loadRings();
         var _loc11_:b2PolygonShape = new b2PolygonShape();
         _loc11_.SetAsBox(640 / ratio,100 / ratio);
         var _loc20_:b2FixtureDef = new b2FixtureDef();
         _loc20_.filter.categoryBits = 1;
         _loc20_.filter.maskBits = 65534;
         _loc20_.shape = _loc11_;
         var _loc3_:b2BodyDef = new b2BodyDef();
         _loc3_.userData = "floor";
         _loc3_.position.Set(160 / ratio,322 / ratio);
         _loc3_.type = b2Body.b2_staticBody;
         var _loc14_:b2Body = _world.CreateBody(_loc3_);
         _loc14_.CreateFixture(_loc20_);
         _loc11_.SetAsBox(32 / ratio,3000 / ratio);
         _loc20_.filter.maskBits = 65534;
         _loc20_.shape = _loc11_;
         _loc3_.userData = "rail";
         _loc3_.position.Set(-160 / ratio,-1500 / ratio);
         _loc3_.type = b2Body.b2_staticBody;
         var _loc4_:b2Body = _world.CreateBody(_loc3_);
         _loc4_.CreateFixture(_loc20_);
         _loc11_.SetAsBox(32 / ratio,3000 / ratio);
         _loc20_.filter.maskBits = 65534;
         _loc20_.shape = _loc11_;
         _loc3_.userData = "rail";
         _loc3_.position.Set(480 / ratio,-1500 / ratio);
         _loc3_.type = b2Body.b2_staticBody;
         var _loc18_:b2Body = _world.CreateBody(_loc3_);
         _loc18_.CreateFixture(_loc20_);
         _waterLevel = 0;
         _water = new Water(FlxG.scroll.y - _waterLevel);
         var _loc17_:FlxSprite = new FlxSprite(0,0,ImgSky);
         _loc17_.scrollFactor = new FlxPoint(0,0);
         BGLayer.add(_loc17_);
         var _loc9_:FlxSprite = new FlxSprite(0,-90,ImgMountain1);
         var _loc8_:FlxSprite = new FlxSprite(0,-135,ImgMountain2);
         var _loc7_:FlxSprite = new FlxSprite(0,-100,ImgMountain3);
         _loc9_.scrollFactor = new FlxPoint(0,0.15);
         _loc8_.scrollFactor = new FlxPoint(0,0.1);
         _loc7_.scrollFactor = new FlxPoint(0,0.05);
         BGLayer.add(_loc7_);
         BGLayer.add(_loc8_);
         BGLayer.add(_loc9_);
         rockTilemap = new FlxTilemap();
         rockTilemap.loadMap(new RockMap(),ImgRocks,64,64);
         rockTilemap.x = 0;
         rockTilemap.y = -2400;
         rockTilemap.scrollFactor.x = 1;
         rockTilemap.scrollFactor.y = 1;
         rockTilemap.collideIndex = 1;
         rockTilemap.drawIndex = 1;
         BGLayer.add(rockTilemap);
         _ladder = new b2FlxSprite(_startX + 34,_startY - 15,25,240,_world);
         _ladder.createBody(2);
         _ladder.loadRotatedGraphic(ImgLadder,96);
         CliffLayer.add(_ladder);
         _player = new Player(_startX,_startY,_world);
         PlayerLayer.add(_player);
         _startingScore = _player._head.GetPosition().y;
         _splash = new FlxEmitter(_startX + 20,118);
         _splash.setXSpeed(-60,60);
         _splash.gravity = 0;
         _splash.setYSpeed(0,0);
         _splash.setRotation(0,0);
         _splash.particleDrag = new FlxPoint(2,2);
         _splash.width = 30;
         var _loc19_:int = 25;
         _loc10_ = 0;
         while(_loc10_ < _loc19_)
         {
            _splash.add(new Splash(_startX + 20,118));
            _loc10_++;
         }
         _splash.start();
         PlayerLayer.add(_splash);
         _bird = new Bird(250,-150,_world);
         TopLayer.add(_bird);
         _world.SetContactListener(new myContactListener());
         cameraTarget = new FlxSprite(156,120);
         cameraTarget.visible = false;
         PlayerLayer.add(cameraTarget);
         _scoreLabel = new FlxText(2,205,180,"0.0m",true);
         _scoreLabel.scrollFactor = new FlxPoint(0,0);
         _scoreLabel.setFormat("NES",16,16777215,"left",0);
         _scoreLabel.text = "0.0 m";
         _scoreLabel.shadow = 1;
         TopLayer.add(_scoreLabel);
         _bestText = new FlxText(2,225,110,"",true);
         if(_hiScoreType != "distance")
         {
            _bestText.text = "PB:" + Math.floor(_hiScore / 60) + "\'" + (_hiScore % 60).toFixed(1) + "\"";
         }
         else
         {
            _bestText.text = "PB:" + _hiScore.toFixed(1).toString() + "m";
         }
         _bestText.scrollFactor = new FlxPoint(0,0);
         _bestText.setFormat("NES",8,16777215,"left",0);
         _bestText.shadow = 1;
         TopLayer.add(_bestText);
         FlxG.followLerp = 5;
         FlxG.follow(cameraTarget,15);
         drawToeholds();
         var _loc12_:* = new Toehold(0,0,_world);
         var _loc1_:* = Number(1000);
         var _loc22_:int = 0;
         var _loc21_:* = _toeholdsOnScreen;
         for each(var _loc13_ in _toeholdsOnScreen)
         {
            _loc15_ = b2Math.DistanceSquared(_loc13_._obj.GetPosition(),_player._head.GetPosition());
            _loc2_ = _loc13_._obj.GetPosition().y - _player._head.GetPosition().y;
            if(_loc2_ < -1 * 10)
            {
               if(_loc15_ < _loc1_)
               {
                  _loc1_ = _loc15_;
                  _loc12_ = _loc13_;
               }
            }
         }
         _bird.setTarget(_loc12_);
         FlxG.playMusic(Assets.AmbientSnd,0.4,689953);
         FlxG.music.fadeIn(2);
      }
      
      public function birdTarget(param1:Toehold) : void
      {
         var _loc4_:* = null;
         var _loc6_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc2_:* = Number(1000);
         var _loc8_:int = 0;
         var _loc7_:* = _toeholdsOnScreen;
         for each(var _loc5_ in _toeholdsOnScreen)
         {
            if(_loc5_ != param1 && _loc5_._ringType == 1)
            {
               _loc6_ = b2Math.DistanceSquared(_loc5_._obj.GetPosition(),_player._head.GetPosition());
               _loc3_ = _loc5_._obj.GetPosition().y - _player._head.GetPosition().y;
               if(_loc3_ < -0.5)
               {
                  if(_loc6_ < _loc2_)
                  {
                     _loc2_ = _loc6_;
                     _loc4_ = _loc5_;
                  }
               }
            }
         }
         if(_loc4_)
         {
            _bird.setTarget(_loc4_);
         }
      }
      
      private function loadRings() : void
      {
         var _loc4_:* = null;
         var _loc10_:* = 0;
         var _loc1_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc5_:int = 0;
         var _loc13_:* = null;
         var _loc3_:* = null;
         var _loc14_:String = new RingMap();
         var _loc8_:Array = _loc14_.split("\n");
         var _loc9_:uint = _loc8_.length;
         var _loc15_:Array = [];
         var _loc11_:uint = 0;
         while(_loc11_ < _loc9_)
         {
            _loc4_ = _loc8_[_loc11_++].split(",");
            if(_loc4_.length <= 1)
            {
               _loc9_ = _loc9_ - 1;
            }
            else
            {
               if(_loc10_ == 0)
               {
                  _loc10_ = uint(_loc4_.length);
               }
               _loc6_ = uint(0);
               while(_loc6_ < _loc10_)
               {
                  _loc15_.push(uint(_loc4_[_loc6_++]));
               }
            }
         }
         var _loc12_:int = 8;
         var _loc2_:int = 8;
         _loc7_ = 0;
         while(_loc7_ < _loc9_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc10_)
            {
               if(_loc15_[_loc7_ * _loc10_ + _loc5_] > 0)
               {
                  _loc13_ = new b2Vec2(_loc5_ * _loc12_,_loc7_ * _loc2_ - 2400);
                  _loc3_ = new toeholdData(_loc13_,_loc15_[_loc7_ * _loc10_ + _loc5_]);
                  _toeholds.push(_loc3_);
               }
               _loc5_++;
            }
            _loc7_++;
         }
      }
      
      override public function update() : void
      {
         var _loc7_:int = 0;
         var _loc9_:Number = NaN;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc11_:* = null;
         var _loc13_:int = 0;
         var _loc6_:* = null;
         var _loc12_:Number = NaN;
         if(!_worldPaused)
         {
            if(_player._head.GetPosition().y * ratio > 118 - _waterLevel)
            {
               _player.dropDead();
            }
            if(_player._head.GetPosition().y - _bird._obj.GetPosition().y < -4)
            {
               launchBird();
               var _loc15_:int = 0;
               var _loc14_:* = _player.targetArray;
               for each(var _loc8_ in _player.targetArray)
               {
                  birdTarget(_loc8_);
               }
            }
            var _loc17_:int = 0;
            var _loc16_:* = _player.targetArray;
            for each(var _loc10_ in _player.targetArray)
            {
               if(_loc10_._ringType == 2)
               {
                  launchBird();
                  _bird.setTarget(_loc10_);
               }
            }
            cameraTarget.y = Math.min(118 - _waterLevel,_player._chest.GetPosition().y * ratio);
            _world.Step(FlxG.elapsed,12,12);
            if(_ladderUp)
            {
               if(_player.InitialGrip == false)
               {
                  if(!_started)
                  {
                     _started = true;
                  }
                  _ladder._obj.ApplyImpulse(new b2Vec2(-5,0),_ladder._obj.GetPosition());
                  _ladderUp = false;
               }
            }
            super.update();
            _loc7_ = 0;
            while(_loc7_ < _toeholdsOnScreen.length)
            {
               if(_toeholdsOnScreen[_loc7_]._hasLetter)
               {
                  if(FlxG.keys.justPressed(_toeholdsOnScreen[_loc7_]._letter))
                  {
                     if(_toeholdsOnScreen[_loc7_]._letterVisible)
                     {
                        if(_toeholdsOnScreen[_loc7_].state != 3)
                        {
                           _player.addTarget(_toeholdsOnScreen[_loc7_]);
                        }
                     }
                  }
                  else if(FlxG.keys.justReleased(_toeholdsOnScreen[_loc7_]._letter))
                  {
                     _player.removeTarget(_toeholdsOnScreen[_loc7_]._letter);
                  }
               }
               else
               {
                  _player.removeTarget(_toeholdsOnScreen[_loc7_]._letter);
               }
               _loc7_++;
            }
            assignLetters();
            _loc9_ = -1 * (_player._head.GetPosition().y - _startingScore);
            if(_loc9_ > _bestScore)
            {
               _bestScore = _loc9_;
               _scoreLabel.text = _bestScore.toFixed(1).toString() + "m";
               if(_loc9_ > _soundHeight + 7.5)
               {
                  FlxG.play(CadenceSnd,1,false);
                  _soundHeight = _soundHeight + 7.5;
               }
            }
            if(!testB)
            {
               FlxG.follow(cameraTarget,15);
               FlxG.followMax = new Point(0,96);
               testB = true;
            }
            _water.updateRipple();
            if(!_ladderUp)
            {
               _waterLevel = _waterLevel + FlxG.elapsed;
            }
            _splash.y = 118 - _waterLevel;
            _loc5_ = new b2Vec2();
            _loc4_ = new b2Vec2();
            _loc3_ = new b2Vec2();
            _loc2_ = new b2Vec2();
            _loc5_.x = 0;
            _loc4_.x = 320 / ratio;
            _loc5_.y = (120 - _waterLevel) / ratio;
            _loc4_.y = _loc5_.y;
            _loc11_ = new b2AABB();
            _loc13_ = 0;
            var _loc19_:int = 0;
            var _loc18_:* = _world.RayCastAll(_loc5_,_loc4_);
            for each(var _loc1_ in _world.RayCastAll(_loc5_,_loc4_))
            {
               if(_loc1_.GetFilterData().categoryBits == 2)
               {
                  if(_loc13_ == 0)
                  {
                     _loc11_ = _loc1_.GetAABB();
                  }
                  else if(_loc13_ > 0)
                  {
                     _loc6_ = new b2AABB();
                     _loc6_ = _loc1_.GetAABB();
                     _loc11_.Combine(_loc11_,_loc6_);
                  }
                  _loc13_++;
               }
            }
            _loc12_ = _loc11_.upperBound.x - _loc11_.lowerBound.x;
            if(_loc12_ == 0)
            {
               if(_splash.on)
               {
                  _splash.stop();
               }
            }
            else
            {
               _splash.width = _loc12_ * ratio;
               _splash.x = (_loc11_.lowerBound.x + _loc12_ / 2) * ratio - _splash.width / 2;
               if(!_splash.on)
               {
                  _splash.start(false,0.03,0);
                  FlxG.play(SplashSnd,0.6,false);
               }
            }
            FlxG.followMax.y = Math.min(90,140 - _waterLevel);
            if(FlxG.keys.justPressed("MINUS"))
            {
               if(FlxG.mute)
               {
                  FlxG.mute = false;
               }
               else
               {
                  FlxG.mute = true;
               }
            }
            if(_started)
            {
               _time = _time + FlxG.elapsed;
            }
         }
      }
      
      public function launchBird() : void
      {
         _bird.launch();
      }
      
      public function reset() : void
      {
         if(!_resetting)
         {
            _resetting = true;
            _player.destroy();
            if(_hiScoreType != "time")
            {
               if(_bestScore > _hiScore)
               {
                  _save.write("highScore",_bestScore);
                  _save.write("highScoreType","distance");
                  _save.forceSave();
               }
            }
            FlxG.fade.start(4278190080,1,onFade);
         }
      }
      
      private function assignLetters() : void
      {
         var _loc2_:* = null;
         var _loc1_:Number = NaN;
         var _loc4_:* = NaN;
         var _loc6_:Boolean = false;
         var _loc5_:* = null;
         var _loc7_:b2Vec2 = _player._head.GetPosition();
         var _loc9_:int = 0;
         var _loc8_:* = _toeholdsOnScreen;
         for each(var _loc3_ in _toeholdsOnScreen)
         {
            _loc2_ = _loc3_._obj.GetPosition();
            _loc1_ = b2Math.Distance(_loc7_,_loc2_);
            if(!_loc3_._hasLetter)
            {
               if(_loc1_ < 6)
               {
                  _loc4_ = 0;
                  _loc6_ = false;
                  while(!_loc6_ && _loc4_ < 26)
                  {
                     _loc5_ = generateRandomLetter();
                     if(_lettersInUse[_loc5_] == 0)
                     {
                        _lettersInUse[_loc5_] = 1;
                        _loc6_ = true;
                     }
                     else
                     {
                        _loc4_++;
                     }
                  }
                  if(_loc6_)
                  {
                     _loc3_.setLetter(_loc5_);
                     _loc3_._hasLetter = true;
                     _loc3_.setVisibleLetter(false);
                  }
               }
            }
            if(_loc3_._hasLetter)
            {
               if(_loc1_ < 4 && _loc3_.state != 3)
               {
                  _loc3_.setVisibleLetter(true);
               }
               if(_loc1_ >= 4 && _loc3_.state != 1)
               {
                  _loc3_.setVisibleLetter(false);
                  if(_player.targetArray[_loc3_._letter])
                  {
                     _player.removeTarget(_loc3_._letter);
                  }
               }
               if(_loc1_ >= 5 && _loc3_.state != 1)
               {
                  _lettersInUse[_loc3_._letter] = 0;
                  _loc3_.setLetter("");
                  _loc3_._hasLetter = false;
               }
            }
         }
      }
      
      private function onFade() : void
      {
         FlxG.state = new PlayState();
      }
      
      private function onWinFade() : void
      {
         FlxG.state = new WinState(_time);
      }
      
      private function onLoseFade() : void
      {
         FlxG.state = new LoseState(_time);
      }
      
      private function drawToeholds() : void
      {
         var _loc1_:* = null;
         var _loc3_:Number = cameraTarget.y + 120;
         var _loc4_:Number = cameraTarget.y - 120;
         var _loc6_:int = 0;
         var _loc5_:* = _toeholds;
         for each(var _loc2_ in _toeholds)
         {
            _loc1_ = new Toehold(_loc2_.position.x,_loc2_.position.y,_world,0,"",_loc2_.type);
            _loc1_._hasLetter = false;
            _loc1_._letter = "";
            _toeholdsOnScreen.push(CliffLayer.add(_loc1_));
         }
      }
      
      public function birdWins() : void
      {
         FlxG.log("bird Wins");
         if(_hiScoreType == "time")
         {
            if(_time < _hiScore)
            {
               _save.write("highScore",_time);
               _save.write("highScoreType","time");
               _save.forceSave();
            }
         }
         else
         {
            _save.write("highScore",_time);
            _save.write("highScoreType","time");
            _save.forceSave();
         }
         _worldPaused = true;
         FlxG.fade.start(4278190080,1,onLoseFade);
      }
      
      public function playerWins() : void
      {
         FlxG.log("player Wins");
         if(_hiScoreType == "time")
         {
            if(_time < _hiScore)
            {
               _save.write("highScore",_time);
               _save.write("highScoreType","time");
               _save.forceSave();
            }
         }
         else
         {
            _save.write("highScore",_time);
            _save.write("highScoreType","time");
            _save.forceSave();
         }
         _worldPaused = true;
         FlxG.fade.start(4278190080,1,onWinFade);
      }
      
      private function setupWorld() : void
      {
         var _loc1_:b2Vec2 = new b2Vec2(0,7);
         _world = new b2World(_loc1_,true);
      }
      
      private function generateRandomLetter() : String
      {
         var _loc1_:int = _alphabet.length;
         var _loc2_:String = "";
         _loc2_ = _alphabet[int(Math.floor(prand.nextDouble() * _loc1_))];
         return _loc2_;
      }
      
      override public function postProcess() : void
      {
         _water.draw(FlxG.scroll.y - _waterLevel);
         _scoreLabel.render();
         _bestText.render();
      }
   }
}
