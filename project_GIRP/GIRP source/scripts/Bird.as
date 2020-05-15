package
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.Joints.b2RevoluteJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2FixtureDef;
   import Box2D.Dynamics.b2World;
   import org.flixel.FlxEmitter;
   import org.flixel.FlxG;
   import org.flixel.FlxGroup;
   import org.flixel.FlxPoint;
   import org.flixel.FlxSprite;
   
   public class Bird extends FlxGroup
   {
       
      
      private const FREE:Number = 0;
      
      private const ASSIGNED:Number = 1;
      
      private const LOCKED:Number = 2;
      
      private const DISABLED:Number = 3;
      
      private var ratio:Number = 32;
      
      private var _st:PlayState;
      
      private var _fix:b2Fixture;
      
      public var _fixDef:b2FixtureDef;
      
      public var _bodyDef:b2BodyDef;
      
      public var _obj:b2Body;
      
      private var _world:b2World;
      
      private var _flapping:Boolean = false;
      
      public var _friction:Number = 0.8;
      
      public var _restitution:Number = 2.3;
      
      public var _density:Number = 0.15;
      
      public var _angle:Number = 0;
      
      public var _type:uint;
      
      public var _pin:b2RevoluteJoint;
      
      public var _target:b2Vec2;
      
      private var _flapTimer:Number;
      
      private var _sprite:FlxSprite;
      
      public var _landed:Boolean;
      
      private var _feathers:FlxEmitter;
      
      public var _targetToehold:Toehold;
      
      public var _invulnerable:Boolean;
      
      public var _invulnerabilityTimer:Number;
      
      private var _previousToehold:Toehold;
      
      private var ImgFeather:Class;
      
      private var ImgGull:Class;
      
      public function Bird(param1:Number, param2:Number, param3:b2World)
      {
         var _loc6_:int = 0;
         var _loc4_:* = null;
         _type = b2Body.b2_dynamicBody;
         ImgFeather = §feather_png$4caa5e79528aa239a4e9bd68bcefb0df-163723762§;
         ImgGull = gull_layout_png$155bd3da3d865cc316e2ac964b8f75b71657128310;
         super();
         _invulnerable = false;
         _invulnerabilityTimer = 0;
         _st = FlxG.state as PlayState;
         _landed = false;
         _sprite = new FlxSprite(param1,param2);
         _target = new b2Vec2();
         _target.x = param1 / ratio;
         _target.y = param2 / ratio;
         _sprite.width = 32;
         _sprite.height = 32;
         _sprite.loadGraphic(ImgGull,true,true,32,32,true);
         _sprite.addAnimation("flap",[1,2,3,4,5],30,false);
         _sprite.addAnimation("land",[3,6,7],30,false);
         _sprite.addAnimation("landed",[7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,7,7,7,7],10,true);
         _sprite.addAnimation("launch",[7,6,3,4,5],30,false);
         _sprite.addAnimation("glide",[0],0,false);
         _sprite.addAnimationCallback(AnimCallback);
         _sprite.play("glide");
         add(_sprite);
         _flapTimer = 0;
         _world = param3;
         createBody();
         _feathers = new FlxEmitter(param1,param2);
         _feathers.setXSpeed(-50,50);
         _feathers.gravity = 10;
         _feathers.setYSpeed(-10,10);
         _feathers.setRotation(0,0);
         _feathers.particleDrag = new FlxPoint(80,800);
         var _loc5_:int = 3;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = new FlxSprite();
            _loc4_.loadGraphic(ImgFeather,true,false,16,8,false);
            _loc4_.addAnimation("loop",[2,3,4,4,3,2,1,0,0,1],8,true);
            _loc4_.play("loop");
            _feathers.add(_loc4_);
            _loc6_++;
         }
         add(_feathers);
         _targetToehold = new Toehold(0,0,_world);
         _target = _targetToehold._obj.GetPosition();
      }
      
      private function AnimCallback(param1:String, param2:uint, param3:uint) : void
      {
         if(param1 == "land" && param3 == 7)
         {
            _sprite.play("landed");
         }
      }
      
      override public function update() : void
      {
         var _loc5_:* = null;
         var _loc8_:* = null;
         var _loc10_:* = null;
         var _loc2_:* = null;
         var _loc9_:* = null;
         if(_invulnerable)
         {
            _invulnerabilityTimer = _invulnerabilityTimer - FlxG.elapsed;
            if(_invulnerabilityTimer < 0)
            {
               goVulnerable();
            }
         }
         _flapTimer = _flapTimer + FlxG.elapsed;
         var _loc12_:b2Vec2 = _obj.GetPosition();
         var _loc11_:Number = b2Math.Distance(_loc12_,_target);
         var _loc7_:Number = Math.min(_target.y - _loc12_.y,0);
         var _loc1_:Number = b2Math.DistanceSquared(_loc12_,_target);
         var _loc6_:Number = Math.max(Math.min(_loc11_ / (-10 * _loc7_),1),0.1);
         var _loc4_:b2Vec2 = _obj.GetLinearVelocity();
         var _loc3_:b2Vec2 = b2Math.AddVV(_loc12_,b2Math.MulFV(FlxG.elapsed,_loc4_));
         if(_loc11_ < 0.05 && _loc4_.Length() < 1)
         {
            if(!_landed && _flapTimer >= 0)
            {
               _obj.SetPosition(_target);
               _loc5_ = new b2RevoluteJointDef();
               _loc5_.Initialize(_obj,_world.GetGroundBody(),_loc12_);
               _pin = _world.CreateJoint(_loc5_) as b2RevoluteJoint;
               _landed = true;
               if(_invulnerable)
               {
                  goVulnerable();
               }
               _sprite.play("land");
               _previousToehold = _targetToehold;
               if(_targetToehold)
               {
                  _st._player.cancelGrip(_targetToehold);
               }
               if(_targetToehold._ringType == 1)
               {
                  _targetToehold._sprite.frame = 3;
               }
               else if(_targetToehold._ringType == 2)
               {
                  _st.birdWins();
               }
            }
         }
         else if(_flapTimer > _loc6_)
         {
            if(!_flapping)
            {
               flap();
            }
            _loc8_ = b2Math.SubtractVV(_loc3_,_target);
            _loc10_ = b2Math.SubtractVV(_loc3_,_target);
            _loc8_.Normalize();
            _loc8_.Multiply(_loc4_.Length());
            _loc2_ = b2Math.SubtractVV(_loc4_,_loc8_);
            _loc2_.Normalize();
            _loc9_ = new b2Vec2();
            _loc9_.Set(0,-2 - _loc4_.y);
            if(Math.abs(_loc10_.x) < 1)
            {
               if(_loc10_.y > 0)
               {
                  _loc9_.Set(0,-2);
               }
               else
               {
                  _loc9_.Set(0,-0.5);
               }
            }
            else
            {
               _loc9_.Set(0,-1);
            }
            _loc2_.Multiply((_loc11_ + 1) * 0.3);
            _loc2_.x = _loc2_.x * 0.5;
            _loc2_.Add(_loc9_);
            _obj.ApplyImpulse(_loc2_,_loc12_);
            _flapTimer = 0;
         }
         _sprite.x = _obj.GetPosition().x * ratio - _sprite.width / 2 - 5;
         _sprite.y = _obj.GetPosition().y * ratio - _sprite.height / 2 - 11;
         if(_sprite.frame == 5)
         {
            _sprite.play("glide");
            _flapping = false;
         }
         _st = FlxG.state as PlayState;
         if(_targetToehold.state == 2)
         {
            _st.birdTarget(_targetToehold);
         }
         super.update();
      }
      
      public function flap() : void
      {
         _flapping = true;
         _sprite.play("flap",false);
      }
      
      public function goInvulnerable(param1:Number) : void
      {
         var _loc2_:* = null;
         if(!_invulnerable)
         {
            _invulnerabilityTimer = param1;
            _invulnerable = true;
            _loc2_ = new b2FilterData();
            _loc2_.maskBits = 65524;
            _loc2_.maskBits = 64;
            _obj.GetFixtureList().SetFilterData(_loc2_);
            FlxG.play(Assets.GullSnd,0.8,false);
            _feathers.at(_sprite);
            _feathers.start(true,10,3);
         }
      }
      
      public function goVulnerable() : void
      {
         _invulnerable = false;
         _invulnerabilityTimer = 0;
         var _loc1_:b2FilterData = new b2FilterData();
         _loc1_.maskBits = 65526;
         _loc1_.categoryBits = 32;
         _obj.GetFixtureList().SetFilterData(_loc1_);
      }
      
      public function setTarget(param1:Toehold) : void
      {
         _targetToehold = param1;
         _target = param1._obj.GetPosition().Copy();
         FlxG.log(param1._ringType);
         if(param1._ringType == 2)
         {
            _target.y = _target.y - 8 / ratio;
         }
         else
         {
            _target.y = _target.y + 6 / ratio;
         }
      }
      
      public function launch() : void
      {
         if(_landed)
         {
            _world.DestroyJoint(_pin);
            _landed = false;
            _flapTimer = -0.5;
            _feathers.at(_sprite);
            _feathers.start(true,10,3);
            _previousToehold.state = 0;
            if(_previousToehold._ringType == 1)
            {
               _previousToehold._sprite.frame = 0;
            }
            _previousToehold.setVisibleLetter(true);
            _sprite.play("launch",true);
            FlxG.play(Assets.GullSnd,0.8,false);
            _st.birdTarget(_targetToehold);
         }
      }
      
      public function createBody() : void
      {
         var _loc1_:b2CircleShape = new b2CircleShape(width / 2 / ratio);
         FlxG.log("width:" + _loc1_.GetRadius());
         _fixDef = new b2FixtureDef();
         _fixDef.filter.categoryBits = 32;
         _fixDef.filter.maskBits = 65526;
         _fixDef.density = _density;
         _fixDef.restitution = _restitution;
         _fixDef.friction = _friction;
         _fixDef.shape = _loc1_;
         _bodyDef = new b2BodyDef();
         _bodyDef.userData = "bird";
         _bodyDef.position.Set((_sprite.x + _sprite.width / 2) / ratio,(_sprite.y + _sprite.height / 2) / ratio);
         _bodyDef.type = _type;
         _bodyDef.bullet = false;
         _bodyDef.linearDamping = 2;
         _obj = _world.CreateBody(_bodyDef);
         _obj.CreateFixture(_fixDef);
      }
   }
}
