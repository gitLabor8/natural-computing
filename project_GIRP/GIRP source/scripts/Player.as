package
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.Joints.b2RevoluteJointDef;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.Joints.b2WeldJointDef;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FixtureDef;
   import Box2D.Dynamics.b2World;
   import org.flixel.FlxG;
   import org.flixel.FlxGroup;
   import org.flixel.FlxPoint;
   import org.flixel.FlxSprite;
   import org.flixel.FlxText;
   import org.flixel.data.FlxPause;
   
   public class Player extends FlxGroup
   {
       
      
      private const MAX_IK_TRIES:Number = 1;
      
      private const IK_POS_THRESH:Number = 0.05;
      
      private const DISTANCE_THRESH:Number = 0.05;
      
      private const FREE:Number = 0;
      
      private const ASSIGNED:Number = 1;
      
      private const LOCKED:Number = 2;
      
      private const DISABLED:Number = 3;
      
      private var ratio:Number = 32;
      
      private var _world:b2World;
      
      public var _friction:Number = 0.8;
      
      public var _restitution:Number = 0.3;
      
      public var _density:Number = 1.0;
      
      public var _rotArray:Array;
      
      public var _gripRotArray:Array;
      
      public var _angle:Number = 0;
      
      private var _rootX:Number;
      
      private var _rootY:Number;
      
      public var _head:b2Body;
      
      public var _chest:b2Body;
      
      private var _leftThigh:b2Body;
      
      private var _rightThigh:b2Body;
      
      private var _leftCalf:b2Body;
      
      private var _rightCalf:b2Body;
      
      private var _leftArm:b2Body;
      
      private var _rightArm:b2Body;
      
      private var _leftForearm:b2Body;
      
      private var _rightForearm:b2Body;
      
      public var _leftElbow:b2RevoluteJoint;
      
      public var _rightElbow:b2RevoluteJoint;
      
      public var _leftShoulder:b2RevoluteJoint;
      
      public var _rightShoulder:b2RevoluteJoint;
      
      public var _leftHip:b2RevoluteJoint;
      
      public var _rightHip:b2RevoluteJoint;
      
      public var _leftKnee:b2RevoluteJoint;
      
      public var _rightKnee:b2RevoluteJoint;
      
      public var _neck:b2RevoluteJoint;
      
      private var _lhJoint:b2WeldJoint;
      
      private var _rhJoint:b2WeldJoint;
      
      private var _lfJoint:b2WeldJoint;
      
      private var _rfJoint:b2WeldJoint;
      
      private var _rhPin:b2RevoluteJoint;
      
      private var _lhPin:b2RevoluteJoint;
      
      private var _rfPin:b2RevoluteJoint;
      
      private var _lfPin:b2RevoluteJoint;
      
      public var _leftHand:b2Body;
      
      public var _rightHand:b2Body;
      
      public var _leftFoot:b2Body;
      
      public var _rightFoot:b2Body;
      
      private var bodyArray:Array;
      
      public var spriteArray:Array;
      
      public var targetArray:Array;
      
      private var gripArray:Array;
      
      public var InitialGrip:Boolean;
      
      private var tempSprite:FlxSprite;
      
      private var tempSprite2:FlxSprite;
      
      private var tempSprite3:FlxSprite;
      
      private var debugText1:FlxText;
      
      private var debugText2:FlxText;
      
      private var LeftThighImg:Class;
      
      private var RightThighImg:Class;
      
      private var LeftCalfImg:Class;
      
      private var RightCalfImg:Class;
      
      private var LeftShoulderImg:Class;
      
      private var RightShoulderImg:Class;
      
      private var LeftForearmImg:Class;
      
      private var RightForearmImg:Class;
      
      private var ChestImg:Class;
      
      private var HeadImg:Class;
      
      private var LeftHandImg:Class;
      
      private var RightHandImg:Class;
      
      private var GripSnd:Class;
      
      private var ReleaseSnd:Class;
      
      private var GruntSnd:Class;
      
      private var AahSnd:Class;
      
      public function Player(param1:Number, param2:Number, param3:b2World)
      {
         _rotArray = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
         _gripRotArray = [32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63];
         LeftThighImg = leftThigh_png$27cbd2d1db46269ec83e63654d283fa5658481058;
         RightThighImg = §rightThigh_png$5e173581e12bbcd950bdc42badbe7ef4-61671811§;
         LeftCalfImg = §leftCalf_png$38c2020b8f945b737be14ff0195d2e5b-1062675942§;
         RightCalfImg = rightCalf_png$9af8dafe55b2b0372fe36ba6c636a4651770280959;
         LeftShoulderImg = §leftShoulder_png$158e90fee666b7e461b62fc7f46bee9b-1277108142§;
         RightShoulderImg = rightShoulder_png$f513b78a27a32fb588c78d67574ed3ed1983439543;
         LeftForearmImg = leftArm_png$a063c1a14ad589ff61cdd88471c612381820694840;
         RightForearmImg = rightArm_png$af2ef6b08007cb3669f0637dcd685943779611451;
         ChestImg = §chest_png$48fdbbb6aca9066de9f1aede2eddcc21-821604372§;
         HeadImg = head_png$362df3fb088cf3414e2d085bb575f9f5455707643;
         LeftHandImg = §leftHand_png$84cf40695f5fb3464d7bb5a583746b95-698058335§;
         RightHandImg = rightHand_png$fa1ef97bd8ea221f2177fbf75df530c62138305798;
         GripSnd = grip_mp3$1367d5c0592564c05562933ea2e64bee822757129;
         ReleaseSnd = release_mp3$96a951f36351f34f806f4cb9b08cfb6f978416532;
         GruntSnd = §grunt_mp3$3fcf8666308035bb57ed335314e3b63f-1107344657§;
         AahSnd = §aah_mp3$291b95692f405cc4699b063bd39466fe-2060554793§;
         super();
         _world = param3;
         _rootX = param1;
         _rootY = param2;
         createBodies();
         targetArray = [];
         gripArray = [];
         InitialGrip = true;
         gripArray["leftHand"] = 0;
         gripArray["rightHand"] = 0;
         var _loc4_:b2RevoluteJointDef = new b2RevoluteJointDef();
         _loc4_.Initialize(_chest,_world.GetGroundBody(),_leftThigh.GetPosition());
         _lfPin = _world.CreateJoint(_loc4_) as b2RevoluteJoint;
         _loc4_.Initialize(_chest,_world.GetGroundBody(),_rightThigh.GetPosition());
         _rfPin = _world.CreateJoint(_loc4_) as b2RevoluteJoint;
      }
      
      override public function update() : void
      {
         var _loc1_:* = null;
         var _loc4_:* = NaN;
         var _loc3_:Number = NaN;
         var _loc7_:int = 0;
         var _loc6_:* = bodyArray;
         for(var _loc2_ in bodyArray)
         {
            _loc1_ = bodyArray[_loc2_];
            _loc4_ = 6.28318530717959;
            var _loc5_:* = _loc2_;
            switch(_loc5_)
            {
               case "leftHand":
                  spriteArray[_loc2_].x = _loc1_.GetPosition().x * ratio - spriteArray[_loc2_].width / 2;
                  spriteArray[_loc2_].y = _loc1_.GetPosition().y * ratio - spriteArray[_loc2_].height / 2;
                  _loc3_ = 200 * 3.14159265358979 + _loc1_.GetAngle();
                  if(gripArray["leftHand"] != 2)
                  {
                     spriteArray[_loc2_].frame = Math.round(32 * (_loc3_ / _loc4_)) % 32;
                  }
                  else
                  {
                     spriteArray[_loc2_].frame = Math.round(32 * (_loc3_ / _loc4_)) % 32 + 32;
                  }
                  continue;
               case "rightHand":
                  spriteArray[_loc2_].x = _loc1_.GetPosition().x * ratio - spriteArray[_loc2_].width / 2;
                  spriteArray[_loc2_].y = _loc1_.GetPosition().y * ratio - spriteArray[_loc2_].height / 2;
                  _loc3_ = 200 * 3.14159265358979 + _loc1_.GetAngle();
                  if(gripArray["rightHand"] != 2)
                  {
                     spriteArray[_loc2_].frame = Math.round(32 * (_loc3_ / _loc4_)) % 32;
                  }
                  else
                  {
                     spriteArray[_loc2_].frame = Math.round(32 * (_loc3_ / _loc4_)) % 32 + 32;
                  }
                  continue;
               default:
                  spriteArray[_loc2_].x = _loc1_.GetPosition().x * ratio - spriteArray[_loc2_].width / 2;
                  spriteArray[_loc2_].y = _loc1_.GetPosition().y * ratio - spriteArray[_loc2_].height / 2;
                  _loc3_ = 200 * 3.14159265358979 + _loc1_.GetAngle();
                  spriteArray[_loc2_].frame = Math.round(32 * (_loc3_ / _loc4_)) % 32;
                  continue;
            }
         }
         attempt();
         super.update();
      }
      
      public function attempt() : void
      {
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc3_:PlayState = FlxG.state as PlayState;
         var _loc1_:FlxPause = FlxG._game.pause as FlxPause;
         var _loc8_:int = 0;
         var _loc7_:* = targetArray;
         for each(var _loc5_ in targetArray)
         {
            _loc2_ = [];
            _loc2_["leftHand"] = new myAngles(0,0,false,999);
            _loc2_["rightHand"] = new myAngles(0,0,false,999);
            if(_loc5_.state == 0)
            {
               if(gripArray["leftHand"] == 0)
               {
                  _loc2_["leftHand"] = IKSolve(_leftElbow,_leftShoulder,_leftHand,_loc5_) as myAngles;
               }
               if(gripArray["rightHand"] == 0)
               {
                  _loc2_["rightHand"] = IKSolve(_rightElbow,_rightShoulder,_rightHand,_loc5_) as myAngles;
               }
            }
            else if(_loc5_.state == 1)
            {
               var _loc6_:* = _loc5_.limb;
               switch(_loc6_)
               {
                  case "leftHand":
                     _loc2_["leftHand"] = IKSolve(_leftElbow,_leftShoulder,_leftHand,_loc5_) as myAngles;
                     break;
                  case "rightHand":
                     _loc2_["rightHand"] = IKSolve(_rightElbow,_rightShoulder,_rightHand,_loc5_) as myAngles;
               }
            }
            if(_loc5_.state == 0)
            {
               if(_loc5_._ringType == 1)
               {
                  _loc5_._sprite.frame = 0;
               }
               if(gripArray["leftHand"] == 0 && gripArray["rightHand"] == 0)
               {
                  if(_loc2_["leftHand"].distanceSquared < _loc2_["rightHand"].distanceSquared)
                  {
                     gripArray["leftHand"] = 1;
                     _loc5_.limb = "leftHand";
                     _loc5_.state = 1;
                  }
                  else
                  {
                     gripArray["rightHand"] = 1;
                     _loc5_.limb = "rightHand";
                     _loc5_.state = 1;
                  }
               }
               else if(gripArray["leftHand"] == 0 || gripArray["rightHand"] == 0)
               {
                  if(gripArray["leftHand"] != 0)
                  {
                     gripArray["rightHand"] = 1;
                     _loc5_.limb = "rightHand";
                     _loc5_.state = 1;
                  }
                  else
                  {
                     gripArray["leftHand"] = 1;
                     _loc5_.limb = "leftHand";
                     _loc5_.state = 1;
                  }
               }
            }
            if(_loc5_.state == 1)
            {
               if(_loc5_._ringType == 1)
               {
                  _loc5_._sprite.frame = 1;
               }
               _loc6_ = _loc5_.limb;
               switch(_loc6_)
               {
                  case "leftHand":
                     reach(_loc2_[_loc5_.limb].elbowAngle,_loc2_[_loc5_.limb].shoulderAngle,_leftElbow,_leftShoulder);
                     _loc4_ = _leftHand;
                     break;
                  case "rightHand":
                     reach(_loc2_[_loc5_.limb].elbowAngle,_loc2_[_loc5_.limb].shoulderAngle,_rightElbow,_rightShoulder);
                     _loc4_ = _rightHand;
               }
               if(b2Math.DistanceSquared(_loc5_._obj.GetPosition(),_loc4_.GetPosition()) < 0.05)
               {
                  gripArray[_loc5_.limb] = 2;
                  FlxG.play(GripSnd,0.7,false);
                  _loc5_.state = 2;
                  snapJoint(_loc5_.limb);
                  _loc1_._resumeKey = _loc5_._letter;
                  if(InitialGrip)
                  {
                     FlxG.log("clearing initial grip");
                     InitialGrip = false;
                     _world.DestroyJoint(_rfPin);
                     _world.DestroyJoint(_lfPin);
                  }
                  if(_loc5_._ringType == 2)
                  {
                     _loc3_.playerWins();
                  }
               }
            }
            if(_loc5_.state == 2)
            {
               if(_loc5_._ringType == 1)
               {
                  _loc5_._sprite.frame = 2;
               }
               _loc6_ = _loc5_.limb;
               switch(_loc6_)
               {
                  case "leftHand":
                     if(FlxG.keys.SHIFT || FlxG.mouse.pressed())
                     {
                        contract(_leftElbow,_leftShoulder,"left");
                     }
                     else if(FlxG.keys.ALT || FlxG.keys.CONTROL)
                     {
                        contract(_leftElbow,_leftShoulder,"left");
                     }
                     else
                     {
                        relax("left");
                     }
                     break;
                  case "rightHand":
                     if(FlxG.keys.SHIFT || FlxG.mouse.pressed())
                     {
                        contract(_rightElbow,_rightShoulder,"right");
                     }
                     else if(FlxG.keys.ALT || FlxG.keys.CONTROL)
                     {
                        contract(_rightElbow,_rightShoulder,"right");
                     }
                     else
                     {
                        relax("right");
                     }
               }
            }
            if(FlxG.keys.justPressed("SHIFT") || FlxG.mouse.justPressed())
            {
               FlxG.play(GruntSnd,0.5,false);
            }
            if(FlxG.keys.justReleased("SHIFT") || FlxG.mouse.justReleased())
            {
               FlxG.play(AahSnd,0.5,false);
            }
            if(FlxG.keys.justPressed("ALT") || FlxG.keys.justPressed("CONTROL"))
            {
               FlxG.play(GruntSnd,0.5,false);
            }
            if(FlxG.keys.justReleased("ALT") || FlxG.keys.justReleased("CONTROL"))
            {
               FlxG.play(AahSnd,0.5,false);
            }
         }
      }
      
      public function dropDead() : void
      {
         relax("left");
         relax("right");
         if(gripArray["leftHand"] == 2)
         {
            breakJoint("leftHand");
         }
         if(gripArray["rightHand"] == 2)
         {
            breakJoint("rightHand");
         }
      }
      
      public function contract(param1:b2RevoluteJoint, param2:b2RevoluteJoint, param3:String) : void
      {
         var _loc4_:* = 12;
         param1.EnableMotor(true);
         param2.EnableMotor(true);
         if(param3 == "right")
         {
            param1.SetMotorSpeed(_loc4_ * (param1.GetLowerLimit() - param1.GetJointAngle()));
            param2.SetMotorSpeed(_loc4_ * (param2.GetUpperLimit() - param2.GetJointAngle()));
         }
         else
         {
            param1.SetMotorSpeed(_loc4_ * (param1.GetUpperLimit() - param1.GetJointAngle()));
            param2.SetMotorSpeed(_loc4_ * (param2.GetLowerLimit() - param2.GetJointAngle()));
         }
      }
      
      public function relax(param1:String) : void
      {
         if(param1 == "left")
         {
            _leftShoulder.EnableMotor(false);
            _leftElbow.EnableMotor(false);
         }
         else if(param1 == "right")
         {
            _rightShoulder.EnableMotor(false);
            _rightElbow.EnableMotor(false);
         }
      }
      
      public function reach(param1:Number, param2:Number, param3:b2RevoluteJoint, param4:b2RevoluteJoint) : void
      {
         var _loc6_:Number = param4.GetJointAngle();
         var _loc7_:Number = param3.GetJointAngle();
         while(_loc7_ > 3.14159265358979)
         {
            _loc7_ = _loc7_ - 2 * 3.14159265358979;
         }
         while(_loc7_ < -3.14159265358979)
         {
            _loc7_ = _loc7_ + 2 * 3.14159265358979;
         }
         while(_loc6_ > 3.14159265358979)
         {
            _loc6_ = _loc6_ - 2 * 3.14159265358979;
         }
         while(_loc6_ < -3.14159265358979)
         {
            _loc6_ = _loc6_ + 2 * 3.14159265358979;
         }
         var _loc5_:* = 12;
         param3.EnableMotor(true);
         param4.EnableMotor(true);
         param3.SetMotorSpeed(_loc5_ * (param1 - _loc7_));
         param4.SetMotorSpeed(_loc5_ * (param2 - _loc6_));
      }
      
      public function IKSolve(param1:b2RevoluteJoint, param2:b2RevoluteJoint, param3:b2Body, param4:Toehold) : myAngles
      {
         var _loc29_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc20_:* = null;
         var _loc22_:* = null;
         var _loc27_:* = null;
         var _loc21_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc23_:* = NaN;
         var _loc7_:* = NaN;
         var _loc5_:* = NaN;
         var _loc16_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc10_:int = 0;
         var _loc28_:* = Number(999);
         var _loc17_:myPoint = new myPoint(param1.GetAnchorA(),param1.GetJointAngle());
         var _loc15_:myPoint = new myPoint(param2.GetAnchorA(),param2.GetJointAngle());
         var _loc19_:myPoint = new myPoint(param3.GetPosition(),param3.GetAngle());
         while(_loc17_.angle > 3.14159265358979)
         {
            _loc17_.angle = _loc17_.angle - 2 * 3.14159265358979;
         }
         while(_loc17_.angle < -3.14159265358979)
         {
            _loc17_.angle = _loc17_.angle + 2 * 3.14159265358979;
         }
         while(_loc15_.angle > 3.14159265358979)
         {
            _loc15_.angle = _loc15_.angle - 2 * 3.14159265358979;
         }
         while(_loc15_.angle < -3.14159265358979)
         {
            _loc15_.angle = _loc15_.angle + 2 * 3.14159265358979;
         }
         var _loc24_:myPoint = new myPoint(param4._obj.GetPosition(),0);
         var _loc13_:Boolean = false;
         var _loc25_:b2Vec2 = new b2Vec2();
         var _loc26_:b2Vec2 = new b2Vec2();
         _loc28_ = Number(b2Math.DistanceSquared(_loc24_.position,_loc19_.position));
         while(_loc10_ < 1 && !_loc13_)
         {
            if(_loc28_ > 0.05)
            {
               _loc20_ = b2Math.SubtractVV(_loc19_.position,_loc17_.position);
               _loc27_ = b2Math.SubtractVV(_loc24_.position,_loc17_.position);
               _loc27_.Normalize();
               _loc20_.Normalize();
               _loc16_ = -1 * Math.atan2(_loc27_.y,_loc27_.x);
               _loc18_ = -1 * Math.atan2(_loc20_.y,_loc20_.x);
               _loc12_ = _loc18_ - _loc16_;
               if(_loc12_ > 0)
               {
                  _loc14_ = -2 * 3.14159265358979 + _loc12_;
               }
               else
               {
                  _loc14_ = 2 * 3.14159265358979 + _loc12_;
               }
               if(_loc17_.angle + _loc14_ > param1.GetUpperLimit())
               {
                  _loc7_ = Number(param1.GetUpperLimit() - _loc17_.angle);
               }
               else if(_loc17_.angle + _loc14_ < param1.GetLowerLimit())
               {
                  _loc7_ = Number(param1.GetLowerLimit() - _loc17_.angle);
               }
               else
               {
                  _loc7_ = _loc14_;
               }
               if(_loc17_.angle + _loc12_ > param1.GetUpperLimit())
               {
                  _loc5_ = Number(param1.GetUpperLimit() - _loc17_.angle);
               }
               else if(_loc17_.angle + _loc12_ < param1.GetLowerLimit())
               {
                  _loc5_ = Number(param1.GetLowerLimit() - _loc17_.angle);
               }
               else
               {
                  _loc5_ = _loc12_;
               }
               if(Math.abs(_loc14_ - _loc7_) > Math.abs(_loc12_ - _loc5_))
               {
                  _loc23_ = _loc5_;
               }
               else
               {
                  _loc23_ = _loc7_;
               }
               _loc17_.angle = _loc17_.angle + _loc23_;
               while(_loc17_.angle > 3.14159265358979)
               {
                  _loc17_.angle = _loc17_.angle - 2 * 3.14159265358979;
               }
               while(_loc17_.angle < -3.14159265358979)
               {
                  _loc17_.angle = _loc17_.angle + 2 * 3.14159265358979;
               }
               _loc19_.position.x = _loc17_.position.x + (_loc19_.position.x - _loc17_.position.x) * Math.cos(_loc23_) - (_loc19_.position.y - _loc17_.position.y) * Math.sin(_loc23_);
               _loc19_.position.y = _loc17_.position.y + (_loc19_.position.x - _loc17_.position.x) * Math.sin(_loc23_) + (_loc19_.position.y - _loc17_.position.y) * Math.cos(_loc23_);
               _loc20_ = b2Math.SubtractVV(_loc19_.position,_loc15_.position);
               _loc27_ = b2Math.SubtractVV(_loc24_.position,_loc15_.position);
               _loc27_.Normalize();
               _loc20_.Normalize();
               _loc16_ = -1 * Math.atan2(_loc27_.y,_loc27_.x);
               _loc18_ = -1 * Math.atan2(_loc20_.y,_loc20_.x);
               _loc12_ = _loc18_ - _loc16_;
               if(_loc12_ > 0)
               {
                  _loc14_ = -2 * 3.14159265358979 + _loc12_;
               }
               else
               {
                  _loc14_ = 2 * 3.14159265358979 + _loc12_;
               }
               if(_loc15_.angle + _loc14_ > param2.GetUpperLimit())
               {
                  _loc7_ = Number(param2.GetUpperLimit() - _loc15_.angle);
               }
               else if(_loc15_.angle + _loc14_ < param2.GetLowerLimit())
               {
                  _loc7_ = Number(param2.GetLowerLimit() - _loc15_.angle);
               }
               else
               {
                  _loc7_ = _loc14_;
               }
               if(_loc15_.angle + _loc12_ > param2.GetUpperLimit())
               {
                  _loc5_ = Number(param2.GetUpperLimit() - _loc15_.angle);
               }
               else if(_loc15_.angle + _loc12_ < param2.GetLowerLimit())
               {
                  _loc5_ = Number(param2.GetLowerLimit() - _loc15_.angle);
               }
               else
               {
                  _loc5_ = _loc12_;
               }
               if(Math.abs(_loc14_ - _loc7_) > Math.abs(_loc12_ - _loc5_))
               {
                  _loc23_ = _loc5_;
               }
               else
               {
                  _loc23_ = _loc7_;
               }
               _loc15_.angle = _loc15_.angle + _loc23_;
               while(_loc15_.angle > 3.14159265358979)
               {
                  _loc15_.angle = _loc15_.angle - 2 * 3.14159265358979;
               }
               while(_loc15_.angle < -3.14159265358979)
               {
                  _loc15_.angle = _loc15_.angle + 2 * 3.14159265358979;
               }
               _loc17_.position.x = _loc15_.position.x + (_loc17_.position.x - _loc15_.position.x) * Math.cos(_loc23_) - (_loc17_.position.y - _loc15_.position.y) * Math.sin(_loc23_);
               _loc17_.position.y = _loc15_.position.y + (_loc17_.position.x - _loc15_.position.x) * Math.sin(_loc23_) + (_loc17_.position.y - _loc15_.position.y) * Math.cos(_loc23_);
               _loc19_.position.x = _loc15_.position.x + (_loc19_.position.x - _loc15_.position.x) * Math.cos(_loc23_) - (_loc19_.position.y - _loc15_.position.y) * Math.sin(_loc23_);
               _loc19_.position.y = _loc15_.position.y + (_loc19_.position.x - _loc15_.position.x) * Math.sin(_loc23_) + (_loc19_.position.y - _loc15_.position.y) * Math.cos(_loc23_);
            }
            else
            {
               _loc13_ = true;
               _loc28_ = 0;
            }
            _loc28_ = Number(b2Math.DistanceSquared(_loc24_.position,_loc19_.position));
            _loc10_++;
         }
         var _loc6_:myAngles = new myAngles(_loc17_.angle,_loc15_.angle,_loc13_,_loc28_);
         return _loc6_;
      }
      
      public function addTarget(param1:Toehold) : void
      {
         targetArray[param1._letter] = param1;
      }
      
      public function cancelGrip(param1:Toehold) : void
      {
         removeTarget(param1._letter);
         param1.state = 3;
         param1.setVisibleLetter(false);
      }
      
      public function removeTarget(param1:String) : void
      {
         if(targetArray[param1])
         {
            if(targetArray[param1].state == 2 || targetArray[param1].state == 1)
            {
               if(targetArray[param1]._ringType == 1)
               {
                  targetArray[param1]._sprite.frame = 0;
               }
               gripArray[targetArray[param1].limb] = 0;
            }
            if(targetArray[param1].state == 2)
            {
               breakJoint(targetArray[param1].limb);
            }
            targetArray[param1].state = 0;
            FlxG.play(ReleaseSnd,0.8,false);
            var _loc2_:* = targetArray[param1].limb;
            switch(_loc2_)
            {
               case "rightHand":
                  _rightShoulder.EnableMotor(false);
                  _rightElbow.EnableMotor(false);
                  break;
               case "leftHand":
                  _leftShoulder.EnableMotor(false);
                  _leftElbow.EnableMotor(false);
            }
            delete targetArray[param1];
         }
      }
      
      public function breakJoint(param1:String) : void
      {
         FlxG.log("breaking joint: " + param1);
         var _loc2_:* = param1;
         switch(_loc2_)
         {
            case "leftHand":
               _world.DestroyJoint(_lhPin);
               break;
            case "rightHand":
               _world.DestroyJoint(_rhPin);
         }
      }
      
      public function snapJoint(param1:String) : void
      {
         var _loc2_:b2RevoluteJointDef = new b2RevoluteJointDef();
         _loc2_.Initialize(bodyArray[param1],_world.GetGroundBody(),bodyArray[param1].GetPosition());
         var _loc3_:* = param1;
         switch(_loc3_)
         {
            case "leftHand":
               _lhPin = _world.CreateJoint(_loc2_) as b2RevoluteJoint;
               break;
            case "rightHand":
               _rhPin = _world.CreateJoint(_loc2_) as b2RevoluteJoint;
         }
      }
      
      public function createBodies() : void
      {
         var _loc11_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = null;
         var _loc10_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc5_:* = null;
         var _loc1_:* = null;
         var _loc4_:* = null;
         bodyArray = [];
         spriteArray = [];
         var _loc3_:uint = b2Body.b2_dynamicBody;
         var _loc6_:Boolean = true;
         _loc2_ = new b2FixtureDef();
         _loc2_.density = _density;
         _loc2_.restitution = _restitution;
         _loc2_.friction = _friction;
         _loc2_.filter.categoryBits = 2;
         _loc2_.filter.maskBits = 65465;
         _loc10_ = new b2RevoluteJointDef();
         _loc10_.motorSpeed = 0;
         _loc10_.maxMotorTorque = 10;
         _loc10_.enableMotor = false;
         _loc10_.enableLimit = true;
         _loc10_.collideConnected = false;
         _loc8_ = new b2WeldJointDef();
         _loc8_.collideConnected = false;
         _loc7_ = new b2BodyDef();
         _loc7_.userData = "player";
         _loc7_.type = _loc3_;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 32;
         _loc4_.height = 32;
         _loc4_.x = -2 + _rootX;
         _loc4_.y = 1 + _rootY;
         _loc4_.origin = new FlxPoint(16,16);
         _loc4_.loadGraphic(LeftForearmImg,true,false,32,32,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(13 / ratio,4 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((13 + _rootX) / ratio,(17 + _rootY) / ratio);
         _leftForearm = _world.CreateBody(_loc7_);
         _leftForearm.CreateFixture(_loc2_);
         spriteArray["leftForearm"] = add(_loc4_);
         bodyArray["leftForearm"] = _leftForearm;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 32;
         _loc4_.height = 32;
         _loc4_.x = 65 + _rootX;
         _loc4_.y = 1 + _rootY;
         _loc4_.origin = new FlxPoint(16,16);
         _loc4_.loadGraphic(RightForearmImg,true,false,32,32,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(13 / ratio,4 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((81 + _rootX) / ratio,(17 + _rootY) / ratio);
         _rightForearm = _world.CreateBody(_loc7_);
         _rightForearm.CreateFixture(_loc2_);
         spriteArray["rightForearm"] = add(_loc4_);
         bodyArray["rightForearm"] = _rightForearm;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 32;
         _loc4_.height = 32;
         _loc4_.x = 16 + _rootX;
         _loc4_.y = 1 + _rootY;
         _loc4_.origin = new FlxPoint(16,16);
         _loc4_.loadGraphic(LeftShoulderImg,true,false,32,32,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(13 / ratio,4 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((32 + _rootX) / ratio,(17 + _rootY) / ratio);
         _leftArm = _world.CreateBody(_loc7_);
         _leftArm.CreateFixture(_loc2_);
         spriteArray["leftArm"] = add(_loc4_);
         bodyArray["leftArm"] = _leftArm;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 32;
         _loc4_.height = 32;
         _loc4_.origin = new FlxPoint(16,16);
         _loc4_.x = 46 + _rootX;
         _loc4_.y = 1 + _rootY;
         _loc4_.loadGraphic(RightShoulderImg,true,false,32,32,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(13 / ratio,4 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((62 + _rootX) / ratio,(17 + _rootY) / ratio);
         _rightArm = _world.CreateBody(_loc7_);
         _rightArm.CreateFixture(_loc2_);
         spriteArray["rightArm"] = add(_loc4_);
         bodyArray["rightArm"] = _rightArm;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 14;
         _loc4_.height = 14;
         _loc4_.origin = new FlxPoint(5,5);
         _loc4_.x = -1 + _rootX;
         _loc4_.y = 12 + _rootY;
         _loc4_.loadGraphic(LeftHandImg,true,false,14,14,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.addAnimation("gripRotate",_gripRotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(4 / ratio,4 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((4 + _rootX) / ratio,(17 + _rootY) / ratio);
         _leftHand = _world.CreateBody(_loc7_);
         _leftHand.CreateFixture(_loc2_);
         spriteArray["leftHand"] = add(_loc4_);
         bodyArray["leftHand"] = _leftHand;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 14;
         _loc4_.height = 14;
         _loc4_.origin = new FlxPoint(5,5);
         _loc4_.x = 85 + _rootX;
         _loc4_.y = 12 + _rootY;
         _loc4_.loadGraphic(RightHandImg,true,false,14,14,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.addAnimation("gripRotate",_gripRotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(4 / ratio,4 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((90 + _rootX) / ratio,(17 + _rootY) / ratio);
         _rightHand = _world.CreateBody(_loc7_);
         _rightHand.CreateFixture(_loc2_);
         spriteArray["rightHand"] = add(_loc4_);
         bodyArray["rightHand"] = _rightHand;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 40;
         _loc4_.height = 40;
         _loc4_.origin = new FlxPoint(20,20);
         _loc4_.x = 32 + _rootX;
         _loc4_.y = 37 + _rootY;
         _loc4_.loadGraphic(RightThighImg,true,false,40,40,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(5 / ratio,17.5 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((52 + _rootX) / ratio,(57 + _rootY) / ratio);
         _rightThigh = _world.CreateBody(_loc7_);
         _rightThigh.CreateFixture(_loc2_);
         spriteArray["rightThigh"] = add(_loc4_);
         bodyArray["rightThigh"] = _rightThigh;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 40;
         _loc4_.height = 40;
         _loc4_.origin = new FlxPoint(20,20);
         _loc4_.x = 22 + _rootX;
         _loc4_.y = 37 + _rootY;
         _loc4_.loadGraphic(LeftThighImg,true,false,40,40,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(5 / ratio,17.5 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((42 + _rootX) / ratio,(57 + _rootY) / ratio);
         _leftThigh = _world.CreateBody(_loc7_);
         _leftThigh.CreateFixture(_loc2_);
         spriteArray["leftThigh"] = add(_loc4_);
         bodyArray["leftThigh"] = _leftThigh;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 40;
         _loc4_.height = 40;
         _loc4_.origin = new FlxPoint(20,20);
         _loc4_.x = 22 + _rootX;
         _loc4_.y = 62 + _rootY;
         _loc4_.loadGraphic(LeftCalfImg,true,false,40,40,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(5 / ratio,17.5 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((42 + _rootX) / ratio,(82 + _rootY) / ratio);
         _leftCalf = _world.CreateBody(_loc7_);
         _leftCalf.CreateFixture(_loc2_);
         spriteArray["leftCalf"] = add(_loc4_);
         bodyArray["leftCalf"] = _leftCalf;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 40;
         _loc4_.height = 40;
         _loc4_.origin = new FlxPoint(20,20);
         _loc4_.x = 32 + _rootX;
         _loc4_.y = 62 + _rootY;
         _loc4_.loadGraphic(RightCalfImg,true,false,40,40,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(5 / ratio,17.5 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((52 + _rootX) / ratio,(82 + _rootY) / ratio);
         _rightCalf = _world.CreateBody(_loc7_);
         _rightCalf.CreateFixture(_loc2_);
         spriteArray["rightCalf"] = add(_loc4_);
         bodyArray["rightCalf"] = _rightCalf;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 20;
         _loc4_.height = 20;
         _loc4_.x = 37 + _rootX;
         _loc4_.y = -2 + _rootY;
         _loc4_.loadGraphic(HeadImg,true,false,20,20,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(5 / ratio,8 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((47 + _rootX) / ratio,(9 + _rootY) / ratio);
         _head = _world.CreateBody(_loc7_);
         _head.CreateFixture(_loc2_);
         spriteArray["head"] = add(_loc4_);
         bodyArray["head"] = _head;
         _loc4_ = new FlxSprite();
         _loc4_.antialiasing = false;
         _loc4_.width = 40;
         _loc4_.height = 40;
         _loc4_.x = 27 + _rootX;
         _loc4_.y = 11 + _rootY;
         _loc4_.loadGraphic(ChestImg,true,false,40,40,true);
         _loc4_.addAnimation("rotate",_rotArray,0,false);
         _loc4_.play("rotate");
         _loc4_.frame = 0;
         _loc1_ = new b2PolygonShape();
         _loc1_.SetAsBox(10 / ratio,18.5 / ratio);
         _loc2_.shape = _loc1_;
         _loc7_.position.Set((47 + _rootX) / ratio,(31 + _rootY) / ratio);
         _chest = _world.CreateBody(_loc7_);
         _chest.CreateFixture(_loc2_);
         spriteArray["chest"] = add(_loc4_);
         bodyArray["chest"] = _chest;
         _loc10_.lowerAngle = -1.8707963267949;
         _loc10_.upperAngle = 1.8707963267949;
         _loc11_ = new b2Vec2((40 + _rootX) / ratio,(16 + _rootY) / ratio);
         _loc10_.Initialize(_chest,_leftArm,_loc11_);
         _loc10_.userData = "left";
         _leftShoulder = _world.CreateJoint(_loc10_) as b2RevoluteJoint;
         _loc10_.lowerAngle = -1.8707963267949;
         _loc10_.upperAngle = 1.8707963267949;
         _loc11_ = new b2Vec2((54 + _rootX) / ratio,(16 + _rootY) / ratio);
         _loc10_.Initialize(_chest,_rightArm,_loc11_);
         _loc10_.userData = "right";
         _rightShoulder = _world.CreateJoint(_loc10_) as b2RevoluteJoint;
         _loc10_.lowerAngle = 0;
         _loc10_.upperAngle = 3.14159265358979 / 1.3;
         _loc11_ = new b2Vec2((22.5 + _rootX) / ratio,(17 + _rootY) / ratio);
         _loc10_.Initialize(_leftArm,_leftForearm,_loc11_);
         _loc10_.userData = "left";
         _leftElbow = _world.CreateJoint(_loc10_) as b2RevoluteJoint;
         _loc10_.lowerAngle = -2.41660973353061;
         _loc10_.upperAngle = 0;
         _loc10_.userData = "right";
         _loc11_ = new b2Vec2((71.5 + _rootX) / ratio,(17 + _rootY) / ratio);
         _loc10_.Initialize(_rightArm,_rightForearm,_loc11_);
         _rightElbow = _world.CreateJoint(_loc10_) as b2RevoluteJoint;
         _loc11_ = new b2Vec2((47 + _rootX) / ratio,(16 + _rootY) / ratio);
         _loc10_.upperAngle = 0.6;
         _loc10_.lowerAngle = -0.6;
         _loc10_.maxMotorTorque = 10;
         _loc10_.enableMotor = true;
         _loc10_.Initialize(_chest,_head,_loc11_);
         _neck = _world.CreateJoint(_loc10_) as b2RevoluteJoint;
         _loc11_ = new b2Vec2((90 + _rootX) / ratio,(17 + _rootY) / ratio);
         _loc8_.Initialize(_rightForearm,_rightHand,_loc11_);
         _rhJoint = _world.CreateJoint(_loc8_) as b2WeldJoint;
         _loc11_ = new b2Vec2((4 + _rootX) / ratio,(17 + _rootY) / ratio);
         _loc8_.Initialize(_leftForearm,_leftHand,_loc11_);
         _lhJoint = _world.CreateJoint(_loc8_) as b2WeldJoint;
         _loc10_.enableMotor = false;
         _loc10_.lowerAngle = -1.96349540849362;
         _loc10_.upperAngle = 0;
         _loc11_ = new b2Vec2((52 + _rootX) / ratio,(45 + _rootY) / ratio);
         _loc10_.Initialize(_chest,_rightThigh,_loc11_);
         _rightHip = _world.CreateJoint(_loc10_) as b2RevoluteJoint;
         _loc10_.lowerAngle = 0;
         _loc10_.upperAngle = 3.14159265358979 / 2;
         _loc11_ = new b2Vec2((42 + _rootX) / ratio,(45 + _rootY) / ratio);
         _loc10_.Initialize(_chest,_leftThigh,_loc11_);
         _leftHip = _world.CreateJoint(_loc10_) as b2RevoluteJoint;
         _loc10_.lowerAngle = 0;
         _loc10_.upperAngle = 3.14159265358979 / 1.6;
         _loc11_ = new b2Vec2((53 + _rootX) / ratio,(67 + _rootY) / ratio);
         _loc10_.Initialize(_rightThigh,_rightCalf,_loc11_);
         _rightKnee = _world.CreateJoint(_loc10_) as b2RevoluteJoint;
         _loc10_.lowerAngle = -1.5707963267949;
         _loc10_.upperAngle = 0;
         _loc10_.maxMotorTorque = 100;
         _loc11_ = new b2Vec2((41 + _rootX) / ratio,(67 + _rootY) / ratio);
         _loc10_.Initialize(_leftThigh,_leftCalf,_loc11_);
         _leftKnee = _world.CreateJoint(_loc10_) as b2RevoluteJoint;
      }
      
      override public function destroy() : void
      {
         _world.DestroyBody(_head);
         _world.DestroyBody(_chest);
         _world.DestroyBody(_leftArm);
         _world.DestroyBody(_rightArm);
         _world.DestroyBody(_leftForearm);
         _world.DestroyBody(_rightForearm);
         _world.DestroyBody(_leftThigh);
         _world.DestroyBody(_rightThigh);
         _world.DestroyBody(_leftCalf);
         _world.DestroyBody(_rightCalf);
         _world.DestroyBody(_leftHand);
         _world.DestroyBody(_rightHand);
         _world.DestroyJoint(_neck);
         _world.DestroyJoint(_leftElbow);
         _world.DestroyJoint(_rightElbow);
         _world.DestroyJoint(_leftShoulder);
         _world.DestroyJoint(_rightShoulder);
         _world.DestroyJoint(_leftKnee);
         _world.DestroyJoint(_rightKnee);
         _world.DestroyJoint(_leftHip);
         _world.DestroyJoint(_rightHip);
         _world.DestroyJoint(_lhJoint);
         _world.DestroyJoint(_rhJoint);
      }
      
      override public function kill() : void
      {
         _world.DestroyBody(_head);
         _world.DestroyBody(_chest);
         _world.DestroyBody(_leftArm);
         _world.DestroyBody(_rightArm);
         _world.DestroyBody(_leftForearm);
         _world.DestroyBody(_rightForearm);
         _world.DestroyBody(_leftThigh);
         _world.DestroyBody(_rightThigh);
         _world.DestroyBody(_leftCalf);
         _world.DestroyBody(_rightCalf);
         _world.DestroyBody(_leftHand);
         _world.DestroyBody(_rightHand);
         _world.DestroyBody(_leftFoot);
         _world.DestroyBody(_rightFoot);
         _world.DestroyJoint(_neck);
         _world.DestroyJoint(_leftElbow);
         _world.DestroyJoint(_rightElbow);
         _world.DestroyJoint(_leftShoulder);
         _world.DestroyJoint(_rightShoulder);
         _world.DestroyJoint(_leftKnee);
         _world.DestroyJoint(_rightKnee);
         _world.DestroyJoint(_leftHip);
         _world.DestroyJoint(_rightHip);
         _world.DestroyJoint(_lhJoint);
         _world.DestroyJoint(_rhJoint);
         _world.DestroyJoint(_lfJoint);
         _world.DestroyJoint(_rfJoint);
         super.kill();
      }
   }
}
