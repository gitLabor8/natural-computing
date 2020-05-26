package Box2D.Dynamics
{
   import Box2D.Collision.IBroadPhase;
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2EdgeShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Collision.b2AABB;
   import Box2D.Collision.b2RayCastInput;
   import Box2D.Collision.b2RayCastOutput;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Sweep;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Color;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.Contacts.b2Contact;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   import Box2D.Dynamics.Contacts.b2ContactSolver;
   import Box2D.Dynamics.Controllers.b2Controller;
   import Box2D.Dynamics.Controllers.b2ControllerEdge;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2JointDef;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.Joints.b2PulleyJoint;
   
   use namespace b2internal;
   
   public class b2World
   {
      
      private static var s_timestep2:b2TimeStep = new b2TimeStep();
      
      private static var s_xf:b2Transform = new b2Transform();
      
      private static var s_backupA:b2Sweep = new b2Sweep();
      
      private static var s_backupB:b2Sweep = new b2Sweep();
      
      private static var s_timestep:b2TimeStep = new b2TimeStep();
      
      private static var s_queue:Vector.<b2Body> = new Vector.<b2Body>();
      
      private static var s_jointColor:b2Color = new b2Color(0.5,0.8,0.8);
      
      private static var m_warmStarting:Boolean;
      
      private static var m_continuousPhysics:Boolean;
      
      public static const e_newFixture:int = 1;
      
      public static const e_locked:int = 2;
       
      
      private var s_stack:Vector.<b2Body>;
      
      b2internal var m_flags:int;
      
      b2internal var m_contactManager:b2ContactManager;
      
      private var m_contactSolver:b2ContactSolver;
      
      private var m_island:b2Island;
      
      b2internal var m_bodyList:b2Body;
      
      private var m_jointList:b2Joint;
      
      b2internal var m_contactList:b2Contact;
      
      private var m_bodyCount:int;
      
      b2internal var m_contactCount:int;
      
      private var m_jointCount:int;
      
      private var m_controllerList:b2Controller;
      
      private var m_controllerCount:int;
      
      private var m_gravity:b2Vec2;
      
      private var m_allowSleep:Boolean;
      
      b2internal var m_groundBody:b2Body;
      
      private var m_destructionListener:b2DestructionListener;
      
      private var m_debugDraw:b2DebugDraw;
      
      private var m_inv_dt0:Number;
      
      public function b2World(param1:b2Vec2, param2:Boolean)
      {
         s_stack = new Vector.<b2Body>();
         m_contactManager = new b2ContactManager();
         m_contactSolver = new b2ContactSolver();
         m_island = new b2Island();
         super();
         m_destructionListener = null;
         m_debugDraw = null;
         m_bodyList = null;
         m_contactList = null;
         m_jointList = null;
         m_controllerList = null;
         m_bodyCount = 0;
         m_contactCount = 0;
         m_jointCount = 0;
         m_controllerCount = 0;
         m_warmStarting = true;
         m_continuousPhysics = true;
         m_allowSleep = param2;
         m_gravity = param1;
         m_inv_dt0 = 0;
         m_contactManager.m_world = this;
         var _loc3_:b2BodyDef = new b2BodyDef();
         m_groundBody = CreateBody(_loc3_);
      }
      
      public function SetDestructionListener(param1:b2DestructionListener) : void
      {
         m_destructionListener = param1;
      }
      
      public function SetContactFilter(param1:b2ContactFilter) : void
      {
         m_contactManager.m_contactFilter = param1;
      }
      
      public function SetContactListener(param1:b2ContactListener) : void
      {
         m_contactManager.m_contactListener = param1;
      }
      
      public function SetDebugDraw(param1:b2DebugDraw) : void
      {
         m_debugDraw = param1;
      }
      
      public function SetBroadPhase(param1:IBroadPhase) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:IBroadPhase = m_contactManager.m_broadPhase;
         m_contactManager.m_broadPhase = param1;
         _loc3_ = m_bodyList;
         while(_loc3_)
         {
            _loc2_ = _loc3_.m_fixtureList;
            while(_loc2_)
            {
               _loc2_.m_proxy = param1.CreateProxy(_loc4_.GetFatAABB(_loc2_.m_proxy),_loc2_);
               _loc2_ = _loc2_.m_next;
            }
            _loc3_ = _loc3_.m_next;
         }
      }
      
      public function Validate() : void
      {
         m_contactManager.m_broadPhase.Validate();
      }
      
      public function GetProxyCount() : int
      {
         return m_contactManager.m_broadPhase.GetProxyCount();
      }
      
      public function CreateBody(param1:b2BodyDef) : b2Body
      {
         if(IsLocked() == true)
         {
            return null;
         }
         var _loc2_:b2Body = new b2Body(param1,this);
         _loc2_.m_prev = null;
         _loc2_.m_next = m_bodyList;
         if(m_bodyList)
         {
            m_bodyList.m_prev = _loc2_;
         }
         m_bodyList = _loc2_;
         m_bodyCount = m_bodyCount + 1;
         return _loc2_;
      }
      
      public function DestroyBody(param1:b2Body) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc8_:* = null;
         if(IsLocked() == true)
         {
            return;
         }
         var _loc7_:b2JointEdge = param1.m_jointList;
         while(_loc7_)
         {
            _loc4_ = _loc7_;
            _loc7_ = _loc7_.next;
            if(m_destructionListener)
            {
               m_destructionListener.SayGoodbyeJoint(_loc4_.joint);
            }
            DestroyJoint(_loc4_.joint);
         }
         var _loc5_:b2ControllerEdge = param1.m_controllerList;
         while(_loc5_)
         {
            _loc3_ = _loc5_;
            _loc5_ = _loc5_.nextController;
            _loc3_.controller.RemoveBody(param1);
         }
         var _loc9_:b2ContactEdge = param1.m_contactList;
         while(_loc9_)
         {
            _loc6_ = _loc9_;
            _loc9_ = _loc9_.next;
            m_contactManager.Destroy(_loc6_.contact);
         }
         param1.m_contactList = null;
         var _loc2_:b2Fixture = param1.m_fixtureList;
         while(_loc2_)
         {
            _loc8_ = _loc2_;
            _loc2_ = _loc2_.m_next;
            if(m_destructionListener)
            {
               m_destructionListener.SayGoodbyeFixture(_loc8_);
            }
            _loc8_.DestroyProxy(m_contactManager.m_broadPhase);
            _loc8_.Destroy();
         }
         param1.m_fixtureList = null;
         param1.m_fixtureCount = 0;
         if(param1.m_prev)
         {
            param1.m_prev.m_next = param1.m_next;
         }
         if(param1.m_next)
         {
            param1.m_next.m_prev = param1.m_prev;
         }
         if(param1 == m_bodyList)
         {
            m_bodyList = param1.m_next;
         }
         m_bodyCount = m_bodyCount - 1;
      }
      
      public function CreateJoint(param1:b2JointDef) : b2Joint
      {
         var _loc2_:* = null;
         var _loc4_:b2Joint = b2Joint.Create(param1,null);
         _loc4_.m_prev = null;
         _loc4_.m_next = m_jointList;
         if(m_jointList)
         {
            m_jointList.m_prev = _loc4_;
         }
         m_jointList = _loc4_;
         m_jointCount = m_jointCount + 1;
         _loc4_.m_edgeA.joint = _loc4_;
         _loc4_.m_edgeA.other = _loc4_.m_bodyB;
         _loc4_.m_edgeA.prev = null;
         _loc4_.m_edgeA.next = _loc4_.m_bodyA.m_jointList;
         if(_loc4_.m_bodyA.m_jointList)
         {
            _loc4_.m_bodyA.m_jointList.prev = _loc4_.m_edgeA;
         }
         _loc4_.m_bodyA.m_jointList = _loc4_.m_edgeA;
         _loc4_.m_edgeB.joint = _loc4_;
         _loc4_.m_edgeB.other = _loc4_.m_bodyA;
         _loc4_.m_edgeB.prev = null;
         _loc4_.m_edgeB.next = _loc4_.m_bodyB.m_jointList;
         if(_loc4_.m_bodyB.m_jointList)
         {
            _loc4_.m_bodyB.m_jointList.prev = _loc4_.m_edgeB;
         }
         _loc4_.m_bodyB.m_jointList = _loc4_.m_edgeB;
         var _loc5_:b2Body = param1.bodyA;
         var _loc3_:b2Body = param1.bodyB;
         if(param1.collideConnected == false)
         {
            _loc2_ = _loc3_.GetContactList();
            while(_loc2_)
            {
               if(_loc2_.other == _loc5_)
               {
                  _loc2_.contact.FlagForFiltering();
               }
               _loc2_ = _loc2_.next;
            }
         }
         return _loc4_;
      }
      
      public function DestroyJoint(param1:b2Joint) : void
      {
         var _loc2_:* = null;
         var _loc4_:Boolean = param1.m_collideConnected;
         if(param1.m_prev)
         {
            param1.m_prev.m_next = param1.m_next;
         }
         if(param1.m_next)
         {
            param1.m_next.m_prev = param1.m_prev;
         }
         if(param1 == m_jointList)
         {
            m_jointList = param1.m_next;
         }
         var _loc5_:b2Body = param1.m_bodyA;
         var _loc3_:b2Body = param1.m_bodyB;
         _loc5_.SetAwake(true);
         _loc3_.SetAwake(true);
         if(param1.m_edgeA.prev)
         {
            param1.m_edgeA.prev.next = param1.m_edgeA.next;
         }
         if(param1.m_edgeA.next)
         {
            param1.m_edgeA.next.prev = param1.m_edgeA.prev;
         }
         if(param1.m_edgeA == _loc5_.m_jointList)
         {
            _loc5_.m_jointList = param1.m_edgeA.next;
         }
         param1.m_edgeA.prev = null;
         param1.m_edgeA.next = null;
         if(param1.m_edgeB.prev)
         {
            param1.m_edgeB.prev.next = param1.m_edgeB.next;
         }
         if(param1.m_edgeB.next)
         {
            param1.m_edgeB.next.prev = param1.m_edgeB.prev;
         }
         if(param1.m_edgeB == _loc3_.m_jointList)
         {
            _loc3_.m_jointList = param1.m_edgeB.next;
         }
         param1.m_edgeB.prev = null;
         param1.m_edgeB.next = null;
         b2Joint.Destroy(param1,null);
         m_jointCount = m_jointCount - 1;
         if(_loc4_ == false)
         {
            _loc2_ = _loc3_.GetContactList();
            while(_loc2_)
            {
               if(_loc2_.other == _loc5_)
               {
                  _loc2_.contact.FlagForFiltering();
               }
               _loc2_ = _loc2_.next;
            }
         }
      }
      
      public function AddController(param1:b2Controller) : b2Controller
      {
         param1.m_next = m_controllerList;
         param1.m_prev = null;
         m_controllerList = param1;
         param1.m_world = this;
         m_controllerCount = Number(m_controllerCount) + 1;
         return param1;
      }
      
      public function RemoveController(param1:b2Controller) : void
      {
         if(param1.m_prev)
         {
            param1.m_prev.m_next = param1.m_next;
         }
         if(param1.m_next)
         {
            param1.m_next.m_prev = param1.m_prev;
         }
         if(m_controllerList == param1)
         {
            m_controllerList = param1.m_next;
         }
         m_controllerCount = Number(m_controllerCount) - 1;
      }
      
      public function CreateController(param1:b2Controller) : b2Controller
      {
         if(param1.m_world != this)
         {
            throw new Error("Controller can only be a member of one world");
         }
         param1.m_next = m_controllerList;
         param1.m_prev = null;
         if(m_controllerList)
         {
            m_controllerList.m_prev = param1;
         }
         m_controllerList = param1;
         m_controllerCount = m_controllerCount + 1;
         param1.m_world = this;
         return param1;
      }
      
      public function DestroyController(param1:b2Controller) : void
      {
         param1.Clear();
         if(param1.m_next)
         {
            param1.m_next.m_prev = param1.m_prev;
         }
         if(param1.m_prev)
         {
            param1.m_prev.m_next = param1.m_next;
         }
         if(param1 == m_controllerList)
         {
            m_controllerList = param1.m_next;
         }
         m_controllerCount = m_controllerCount - 1;
      }
      
      public function SetWarmStarting(param1:Boolean) : void
      {
         m_warmStarting = param1;
      }
      
      public function SetContinuousPhysics(param1:Boolean) : void
      {
         m_continuousPhysics = param1;
      }
      
      public function GetBodyCount() : int
      {
         return m_bodyCount;
      }
      
      public function GetJointCount() : int
      {
         return m_jointCount;
      }
      
      public function GetContactCount() : int
      {
         return m_contactCount;
      }
      
      public function SetGravity(param1:b2Vec2) : void
      {
         m_gravity = param1;
      }
      
      public function GetGravity() : b2Vec2
      {
         return m_gravity;
      }
      
      public function GetGroundBody() : b2Body
      {
         return m_groundBody;
      }
      
      public function Step(param1:Number, param2:int, param3:int) : void
      {
         if(m_flags & 1)
         {
            m_contactManager.FindNewContacts();
            m_flags = m_flags & ~1;
         }
         m_flags = m_flags | 2;
         var _loc4_:b2TimeStep = s_timestep2;
         _loc4_.dt = param1;
         _loc4_.velocityIterations = param2;
         _loc4_.positionIterations = param3;
         if(param1 > 0)
         {
            _loc4_.inv_dt = 1 / param1;
         }
         else
         {
            _loc4_.inv_dt = 0;
         }
         _loc4_.dtRatio = m_inv_dt0 * param1;
         _loc4_.warmStarting = m_warmStarting;
         m_contactManager.Collide();
         if(_loc4_.dt > 0)
         {
            Solve(_loc4_);
         }
         if(m_continuousPhysics && _loc4_.dt > 0)
         {
            SolveTOI(_loc4_);
         }
         if(_loc4_.dt > 0)
         {
            m_inv_dt0 = _loc4_.inv_dt;
         }
         m_flags = m_flags & ~2;
      }
      
      public function ClearForces() : void
      {
         var _loc1_:* = null;
         _loc1_ = m_bodyList;
         while(_loc1_)
         {
            _loc1_.m_force.SetZero();
            _loc1_.m_torque = 0;
            _loc1_ = _loc1_.m_next;
         }
      }
      
      public function DrawDebugData() : void
      {
         var _loc15_:int = 0;
         var _loc4_:* = null;
         var _loc1_:* = null;
         var _loc18_:* = null;
         var _loc10_:* = null;
         var _loc17_:* = null;
         var _loc22_:* = null;
         var _loc6_:* = null;
         var _loc12_:* = null;
         var _loc13_:* = null;
         var _loc14_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc19_:* = null;
         if(m_debugDraw == null)
         {
            return;
         }
         m_debugDraw.m_sprite.graphics.clear();
         var _loc2_:uint = m_debugDraw.GetFlags();
         var _loc7_:b2Vec2 = new b2Vec2();
         var _loc16_:b2Vec2 = new b2Vec2();
         var _loc11_:b2Vec2 = new b2Vec2();
         var _loc21_:b2AABB = new b2AABB();
         var _loc8_:b2AABB = new b2AABB();
         var _loc9_:Array = [new b2Vec2(),new b2Vec2(),new b2Vec2(),new b2Vec2()];
         var _loc20_:b2Color = new b2Color(0,0,0);
         if(_loc2_ & b2DebugDraw.e_shapeBit)
         {
            _loc4_ = m_bodyList;
            while(_loc4_)
            {
               _loc22_ = _loc4_.m_xf;
               _loc1_ = _loc4_.GetFixtureList();
               while(_loc1_)
               {
                  _loc18_ = _loc1_.GetShape();
                  if(_loc4_.IsActive() == false)
                  {
                     _loc20_.Set(0.5,0.5,0.3);
                     DrawShape(_loc18_,_loc22_,_loc20_);
                  }
                  else if(_loc4_.GetType() == b2Body.b2_staticBody)
                  {
                     _loc20_.Set(0.5,0.9,0.5);
                     DrawShape(_loc18_,_loc22_,_loc20_);
                  }
                  else if(_loc4_.GetType() == b2Body.b2_kinematicBody)
                  {
                     _loc20_.Set(0.5,0.5,0.9);
                     DrawShape(_loc18_,_loc22_,_loc20_);
                  }
                  else if(_loc4_.IsAwake() == false)
                  {
                     _loc20_.Set(0.6,0.6,0.6);
                     DrawShape(_loc18_,_loc22_,_loc20_);
                  }
                  else
                  {
                     _loc20_.Set(0.9,0.7,0.7);
                     DrawShape(_loc18_,_loc22_,_loc20_);
                  }
                  _loc1_ = _loc1_.m_next;
               }
               _loc4_ = _loc4_.m_next;
            }
         }
         if(_loc2_ & b2DebugDraw.e_jointBit)
         {
            _loc10_ = m_jointList;
            while(_loc10_)
            {
               DrawJoint(_loc10_);
               _loc10_ = _loc10_.m_next;
            }
         }
         if(_loc2_ & b2DebugDraw.e_controllerBit)
         {
            _loc6_ = m_controllerList;
            while(_loc6_)
            {
               _loc6_.Draw(m_debugDraw);
               _loc6_ = _loc6_.m_next;
            }
         }
         if(_loc2_ & b2DebugDraw.e_pairBit)
         {
            _loc20_.Set(0.3,0.9,0.9);
            _loc12_ = m_contactManager.m_contactList;
            while(_loc12_)
            {
               _loc13_ = _loc12_.GetFixtureA();
               _loc14_ = _loc12_.GetFixtureB();
               _loc5_ = _loc13_.GetAABB().GetCenter();
               _loc3_ = _loc14_.GetAABB().GetCenter();
               m_debugDraw.DrawSegment(_loc5_,_loc3_,_loc20_);
               _loc12_ = _loc12_.GetNext();
            }
         }
         if(_loc2_ & b2DebugDraw.e_aabbBit)
         {
            _loc17_ = m_contactManager.m_broadPhase;
            _loc9_ = [new b2Vec2(),new b2Vec2(),new b2Vec2(),new b2Vec2()];
            _loc4_ = m_bodyList;
            while(_loc4_)
            {
               if(_loc4_.IsActive() != false)
               {
                  _loc1_ = _loc4_.GetFixtureList();
                  while(_loc1_)
                  {
                     _loc19_ = _loc17_.GetFatAABB(_loc1_.m_proxy);
                     _loc9_[0].Set(_loc19_.lowerBound.x,_loc19_.lowerBound.y);
                     _loc9_[1].Set(_loc19_.upperBound.x,_loc19_.lowerBound.y);
                     _loc9_[2].Set(_loc19_.upperBound.x,_loc19_.upperBound.y);
                     _loc9_[3].Set(_loc19_.lowerBound.x,_loc19_.upperBound.y);
                     m_debugDraw.DrawPolygon(_loc9_,4,_loc20_);
                     _loc1_ = _loc1_.GetNext();
                  }
               }
               _loc4_ = _loc4_.GetNext();
            }
         }
         if(_loc2_ & b2DebugDraw.e_centerOfMassBit)
         {
            _loc4_ = m_bodyList;
            while(_loc4_)
            {
               _loc22_ = s_xf;
               _loc22_.R = _loc4_.m_xf.R;
               _loc22_.position = _loc4_.GetWorldCenter();
               m_debugDraw.DrawTransform(_loc22_);
               _loc4_ = _loc4_.m_next;
            }
         }
      }
      
      public function QueryAABB(param1:Function, param2:b2AABB) : void
      {
         callback = param1;
         aabb = param2;
         WorldQueryWrapper = function(param1:*):Boolean
         {
            return callback(broadPhase.GetUserData(param1));
         };
         var broadPhase:IBroadPhase = m_contactManager.m_broadPhase;
         broadPhase.Query(WorldQueryWrapper,aabb);
      }
      
      public function QueryShape(param1:Function, param2:b2Shape, param3:b2Transform = null) : void
      {
         callback = param1;
         shape = param2;
         transform = param3;
         WorldQueryWrapper = function(param1:*):Boolean
         {
            var _loc2_:b2Fixture = broadPhase.GetUserData(param1) as b2Fixture;
            if(b2Shape.TestOverlap(shape,transform,_loc2_.GetShape(),_loc2_.GetBody().GetTransform()))
            {
               return callback(_loc2_);
            }
            return true;
         };
         if(transform == null)
         {
            var transform:b2Transform = new b2Transform();
            transform.SetIdentity();
         }
         var broadPhase:IBroadPhase = m_contactManager.m_broadPhase;
         var aabb:b2AABB = new b2AABB();
         shape.ComputeAABB(aabb,transform);
         broadPhase.Query(WorldQueryWrapper,aabb);
      }
      
      public function QueryPoint(param1:Function, param2:b2Vec2) : void
      {
         callback = param1;
         p = param2;
         WorldQueryWrapper = function(param1:*):Boolean
         {
            var _loc2_:b2Fixture = broadPhase.GetUserData(param1) as b2Fixture;
            if(_loc2_.TestPoint(p))
            {
               return callback(_loc2_);
            }
            return true;
         };
         var broadPhase:IBroadPhase = m_contactManager.m_broadPhase;
         var aabb:b2AABB = new b2AABB();
         aabb.lowerBound.Set(p.x - 0.005,p.y - 0.005);
         aabb.upperBound.Set(p.x + 0.005,p.y + 0.005);
         broadPhase.Query(WorldQueryWrapper,aabb);
      }
      
      public function RayCast(param1:Function, param2:b2Vec2, param3:b2Vec2) : void
      {
         callback = param1;
         point1 = param2;
         point2 = param3;
         RayCastWrapper = function(param1:b2RayCastInput, param2:*):Number
         {
            var _loc4_:Number = NaN;
            var _loc3_:* = null;
            var _loc7_:* = broadPhase.GetUserData(param2);
            var _loc5_:b2Fixture = _loc7_ as b2Fixture;
            var _loc6_:Boolean = _loc5_.RayCast(output,param1);
            if(_loc6_)
            {
               _loc4_ = output.fraction;
               _loc3_ = new b2Vec2((1 - _loc4_) * point1.x + _loc4_ * point2.x,(1 - _loc4_) * point1.y + _loc4_ * point2.y);
               return callback(_loc5_,_loc3_,output.normal,_loc4_);
            }
            return param1.maxFraction;
         };
         var broadPhase:IBroadPhase = m_contactManager.m_broadPhase;
         var output:b2RayCastOutput = new b2RayCastOutput();
         var input:b2RayCastInput = new b2RayCastInput(point1,point2);
         broadPhase.RayCast(RayCastWrapper,input);
      }
      
      public function RayCastOne(param1:b2Vec2, param2:b2Vec2) : b2Fixture
      {
         point1 = param1;
         point2 = param2;
         RayCastOneWrapper = function(param1:b2Fixture, param2:b2Vec2, param3:b2Vec2, param4:Number):Number
         {
            result = param1;
            return param4;
         };
         RayCast(RayCastOneWrapper,point1,point2);
         return result;
      }
      
      public function RayCastAll(param1:b2Vec2, param2:b2Vec2) : Vector.<b2Fixture>
      {
         point1 = param1;
         point2 = param2;
         RayCastAllWrapper = function(param1:b2Fixture, param2:b2Vec2, param3:b2Vec2, param4:Number):Number
         {
            result[result.length] = param1;
            return 1;
         };
         var result:Vector.<b2Fixture> = new Vector.<b2Fixture>();
         RayCast(RayCastAllWrapper,point1,point2);
         return result;
      }
      
      public function GetBodyList() : b2Body
      {
         return m_bodyList;
      }
      
      public function GetJointList() : b2Joint
      {
         return m_jointList;
      }
      
      public function GetContactList() : b2Contact
      {
         return m_contactList;
      }
      
      public function IsLocked() : Boolean
      {
         return (m_flags & 2) > 0;
      }
      
      b2internal function Solve(param1:b2TimeStep) : void
      {
         var _loc4_:* = null;
         var _loc12_:* = null;
         var _loc5_:* = null;
         var _loc8_:* = null;
         var _loc6_:* = null;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc14_:* = null;
         var _loc7_:* = null;
         var _loc9_:int = 0;
         _loc12_ = m_controllerList;
         while(_loc12_)
         {
            _loc12_.Step(param1);
            _loc12_ = _loc12_.m_next;
         }
         var _loc10_:b2Island = m_island;
         _loc10_.Initialize(m_bodyCount,m_contactCount,m_jointCount,null,m_contactManager.m_contactListener,m_contactSolver);
         _loc4_ = m_bodyList;
         while(_loc4_)
         {
            _loc4_.m_flags = _loc4_.m_flags & ~b2Body.e_islandFlag;
            _loc4_ = _loc4_.m_next;
         }
         _loc5_ = m_contactList;
         while(_loc5_)
         {
            _loc5_.m_flags = _loc5_.m_flags & ~b2Contact.e_islandFlag;
            _loc5_ = _loc5_.m_next;
         }
         _loc8_ = m_jointList;
         while(_loc8_)
         {
            _loc8_.m_islandFlag = false;
            _loc8_ = _loc8_.m_next;
         }
         var _loc11_:int = m_bodyCount;
         var _loc13_:Vector.<b2Body> = s_stack;
         _loc6_ = m_bodyList;
         while(_loc6_)
         {
            if(!(_loc6_.m_flags & b2Body.e_islandFlag))
            {
               if(!(_loc6_.IsAwake() == false || _loc6_.IsActive() == false))
               {
                  if(_loc6_.GetType() != b2Body.b2_staticBody)
                  {
                     _loc10_.Clear();
                     _loc2_ = 0;
                     _loc2_++;
                     _loc13_[_loc2_] = _loc6_;
                     _loc6_.m_flags = _loc6_.m_flags | b2Body.e_islandFlag;
                     while(_loc2_ > 0)
                     {
                        _loc2_--;
                        _loc4_ = _loc13_[_loc2_];
                        _loc10_.AddBody(_loc4_);
                        if(_loc4_.IsAwake() == false)
                        {
                           _loc4_.SetAwake(true);
                        }
                        if(_loc4_.GetType() != b2Body.b2_staticBody)
                        {
                           _loc14_ = _loc4_.m_contactList;
                           while(_loc14_)
                           {
                              if(!(_loc14_.contact.m_flags & b2Contact.e_islandFlag))
                              {
                                 if(!(_loc14_.contact.IsSensor() == true || _loc14_.contact.IsEnabled() == false || _loc14_.contact.IsTouching() == false))
                                 {
                                    _loc10_.AddContact(_loc14_.contact);
                                    _loc14_.contact.m_flags = _loc14_.contact.m_flags | b2Contact.e_islandFlag;
                                    _loc3_ = _loc14_.other;
                                    if(!(_loc3_.m_flags & b2Body.e_islandFlag))
                                    {
                                       _loc2_++;
                                       _loc13_[_loc2_] = _loc3_;
                                       _loc3_.m_flags = _loc3_.m_flags | b2Body.e_islandFlag;
                                    }
                                 }
                              }
                              _loc14_ = _loc14_.next;
                           }
                           _loc7_ = _loc4_.m_jointList;
                           while(_loc7_)
                           {
                              if(_loc7_.joint.m_islandFlag != true)
                              {
                                 _loc3_ = _loc7_.other;
                                 if(_loc3_.IsActive() != false)
                                 {
                                    _loc10_.AddJoint(_loc7_.joint);
                                    _loc7_.joint.m_islandFlag = true;
                                    if(!(_loc3_.m_flags & b2Body.e_islandFlag))
                                    {
                                       _loc2_++;
                                       _loc13_[_loc2_] = _loc3_;
                                       _loc3_.m_flags = _loc3_.m_flags | b2Body.e_islandFlag;
                                    }
                                 }
                              }
                              _loc7_ = _loc7_.next;
                           }
                           continue;
                        }
                     }
                     _loc10_.Solve(param1,m_gravity,m_allowSleep);
                     _loc9_ = 0;
                     while(_loc9_ < _loc10_.m_bodyCount)
                     {
                        _loc4_ = _loc10_.m_bodies[_loc9_];
                        if(_loc4_.GetType() == b2Body.b2_staticBody)
                        {
                           _loc4_.m_flags = _loc4_.m_flags & ~b2Body.e_islandFlag;
                        }
                        _loc9_++;
                     }
                  }
               }
            }
            _loc6_ = _loc6_.m_next;
         }
         _loc9_ = 0;
         while(_loc9_ < _loc13_.length)
         {
            if(_loc13_[_loc9_])
            {
               _loc13_[_loc9_] = null;
               _loc9_++;
               continue;
            }
            break;
         }
         _loc4_ = m_bodyList;
         while(_loc4_)
         {
            if(!(_loc4_.IsAwake() == false || _loc4_.IsActive() == false))
            {
               if(_loc4_.GetType() != b2Body.b2_staticBody)
               {
                  _loc4_.SynchronizeFixtures();
               }
            }
            _loc4_ = _loc4_.m_next;
         }
         m_contactManager.FindNewContacts();
      }
      
      b2internal function SolveTOI(param1:b2TimeStep) : void
      {
         var _loc7_:* = null;
         var _loc12_:* = null;
         var _loc13_:* = null;
         var _loc11_:* = null;
         var _loc20_:* = null;
         var _loc22_:* = null;
         var _loc14_:* = null;
         var _loc9_:* = null;
         var _loc21_:* = null;
         var _loc17_:* = NaN;
         var _loc8_:* = NaN;
         var _loc6_:Number = NaN;
         var _loc10_:* = null;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc19_:* = null;
         var _loc18_:* = null;
         var _loc15_:int = 0;
         var _loc16_:b2Island = m_island;
         _loc16_.Initialize(m_bodyCount,32,32,null,m_contactManager.m_contactListener,m_contactSolver);
         var _loc2_:Vector.<b2Body> = s_queue;
         _loc7_ = m_bodyList;
         while(_loc7_)
         {
            _loc7_.m_flags = _loc7_.m_flags & ~b2Body.e_islandFlag;
            _loc7_.m_sweep.t0 = 0;
            _loc7_ = _loc7_.m_next;
         }
         _loc9_ = m_contactList;
         while(_loc9_)
         {
            _loc9_.m_flags = _loc9_.m_flags & ~(b2Contact.e_toiFlag | b2Contact.e_islandFlag);
            _loc9_ = _loc9_.m_next;
         }
         _loc14_ = m_jointList;
         while(_loc14_)
         {
            _loc14_.m_islandFlag = false;
            _loc14_ = _loc14_.m_next;
         }
         while(true)
         {
            _loc21_ = null;
            _loc17_ = 1;
            _loc9_ = m_contactList;
            while(_loc9_)
            {
               if(!(_loc9_.IsSensor() == true || _loc9_.IsEnabled() == false || _loc9_.IsContinuous() == false))
               {
                  _loc8_ = 1;
                  if(_loc9_.m_flags & b2Contact.e_toiFlag)
                  {
                     _loc8_ = Number(_loc9_.m_toi);
                     addr299:
                     if(Number.MIN_VALUE < _loc8_ && _loc8_ < _loc17_)
                     {
                        _loc21_ = _loc9_;
                        _loc17_ = _loc8_;
                     }
                  }
                  else
                  {
                     _loc12_ = _loc9_.m_fixtureA;
                     _loc13_ = _loc9_.m_fixtureB;
                     _loc11_ = _loc12_.m_body;
                     _loc20_ = _loc13_.m_body;
                     if(!((_loc11_.GetType() != b2Body.b2_dynamicBody || _loc11_.IsAwake() == false) && (_loc20_.GetType() != b2Body.b2_dynamicBody || _loc20_.IsAwake() == false)))
                     {
                        _loc6_ = _loc11_.m_sweep.t0;
                        if(_loc11_.m_sweep.t0 < _loc20_.m_sweep.t0)
                        {
                           _loc6_ = _loc20_.m_sweep.t0;
                           _loc11_.m_sweep.Advance(_loc6_);
                        }
                        else if(_loc20_.m_sweep.t0 < _loc11_.m_sweep.t0)
                        {
                           _loc6_ = _loc11_.m_sweep.t0;
                           _loc20_.m_sweep.Advance(_loc6_);
                        }
                        _loc8_ = Number(_loc9_.ComputeTOI(_loc11_.m_sweep,_loc20_.m_sweep));
                        b2Settings.b2Assert(0 <= _loc8_ && _loc8_ <= 1);
                        if(_loc8_ > 0 && _loc8_ < 1)
                        {
                           _loc8_ = Number((1 - _loc8_) * _loc6_ + _loc8_);
                           if(_loc8_ > 1)
                           {
                              _loc8_ = 1;
                           }
                        }
                        _loc9_.m_toi = _loc8_;
                        _loc9_.m_flags = _loc9_.m_flags | b2Contact.e_toiFlag;
                        §§goto(addr299);
                     }
                  }
               }
               _loc9_ = _loc9_.m_next;
            }
            if(!(_loc21_ == null || 1 - 100 * Number.MIN_VALUE < _loc17_))
            {
               _loc12_ = _loc21_.m_fixtureA;
               _loc13_ = _loc21_.m_fixtureB;
               _loc11_ = _loc12_.m_body;
               _loc20_ = _loc13_.m_body;
               s_backupA.Set(_loc11_.m_sweep);
               s_backupB.Set(_loc20_.m_sweep);
               _loc11_.Advance(_loc17_);
               _loc20_.Advance(_loc17_);
               _loc21_.Update(m_contactManager.m_contactListener);
               _loc21_.m_flags = _loc21_.m_flags & ~b2Contact.e_toiFlag;
               if(_loc21_.IsSensor() == true || _loc21_.IsEnabled() == false)
               {
                  _loc11_.m_sweep.Set(s_backupA);
                  _loc20_.m_sweep.Set(s_backupB);
                  _loc11_.SynchronizeTransform();
                  _loc20_.SynchronizeTransform();
               }
               else if(_loc21_.IsTouching() != false)
               {
                  _loc10_ = _loc11_;
                  if(_loc10_.GetType() != b2Body.b2_dynamicBody)
                  {
                     _loc10_ = _loc20_;
                  }
                  _loc16_.Clear();
                  _loc5_ = 0;
                  _loc3_ = 0;
                  _loc3_++;
                  _loc2_[_loc5_ + _loc3_] = _loc10_;
                  _loc10_.m_flags = _loc10_.m_flags | b2Body.e_islandFlag;
                  while(_loc3_ > 0)
                  {
                     _loc5_++;
                     _loc7_ = _loc2_[_loc5_];
                     _loc3_--;
                     _loc16_.AddBody(_loc7_);
                     if(_loc7_.IsAwake() == false)
                     {
                        _loc7_.SetAwake(true);
                     }
                     if(_loc7_.GetType() == b2Body.b2_dynamicBody)
                     {
                        _loc22_ = _loc7_.m_contactList;
                        while(_loc22_)
                        {
                           if(_loc16_.m_contactCount != _loc16_.m_contactCapacity)
                           {
                              if(!(_loc22_.contact.m_flags & b2Contact.e_islandFlag))
                              {
                                 if(!(_loc22_.contact.IsSensor() == true || _loc22_.contact.IsEnabled() == false || _loc22_.contact.IsTouching() == false))
                                 {
                                    _loc16_.AddContact(_loc22_.contact);
                                    _loc22_.contact.m_flags = _loc22_.contact.m_flags | b2Contact.e_islandFlag;
                                    _loc4_ = _loc22_.other;
                                    if(!(_loc4_.m_flags & b2Body.e_islandFlag))
                                    {
                                       if(_loc4_.GetType() != b2Body.b2_staticBody)
                                       {
                                          _loc4_.Advance(_loc17_);
                                          _loc4_.SetAwake(true);
                                       }
                                       _loc2_[_loc5_ + _loc3_] = _loc4_;
                                       _loc3_++;
                                       _loc4_.m_flags = _loc4_.m_flags | b2Body.e_islandFlag;
                                    }
                                 }
                              }
                              _loc22_ = _loc22_.next;
                              continue;
                           }
                           break;
                        }
                        _loc19_ = _loc7_.m_jointList;
                        while(_loc19_)
                        {
                           if(_loc16_.m_jointCount != _loc16_.m_jointCapacity)
                           {
                              if(_loc19_.joint.m_islandFlag != true)
                              {
                                 _loc4_ = _loc19_.other;
                                 if(_loc4_.IsActive() != false)
                                 {
                                    _loc16_.AddJoint(_loc19_.joint);
                                    _loc19_.joint.m_islandFlag = true;
                                    if(!(_loc4_.m_flags & b2Body.e_islandFlag))
                                    {
                                       if(_loc4_.GetType() != b2Body.b2_staticBody)
                                       {
                                          _loc4_.Advance(_loc17_);
                                          _loc4_.SetAwake(true);
                                       }
                                       _loc2_[_loc5_ + _loc3_] = _loc4_;
                                       _loc3_++;
                                       _loc4_.m_flags = _loc4_.m_flags | b2Body.e_islandFlag;
                                    }
                                 }
                              }
                           }
                           _loc19_ = _loc19_.next;
                        }
                        continue;
                     }
                  }
                  _loc18_ = s_timestep;
                  _loc18_.warmStarting = false;
                  _loc18_.dt = (1 - _loc17_) * param1.dt;
                  _loc18_.inv_dt = 1 / _loc18_.dt;
                  _loc18_.dtRatio = 0;
                  _loc18_.velocityIterations = param1.velocityIterations;
                  _loc18_.positionIterations = param1.positionIterations;
                  _loc16_.SolveTOI(_loc18_);
                  _loc15_ = 0;
                  while(_loc15_ < _loc16_.m_bodyCount)
                  {
                     _loc7_ = _loc16_.m_bodies[_loc15_];
                     _loc7_.m_flags = _loc7_.m_flags & ~b2Body.e_islandFlag;
                     if(_loc7_.IsAwake() != false)
                     {
                        if(_loc7_.GetType() == b2Body.b2_dynamicBody)
                        {
                           _loc7_.SynchronizeFixtures();
                           _loc22_ = _loc7_.m_contactList;
                           while(_loc22_)
                           {
                              _loc22_.contact.m_flags = _loc22_.contact.m_flags & ~b2Contact.e_toiFlag;
                              _loc22_ = _loc22_.next;
                           }
                        }
                     }
                     _loc15_++;
                  }
                  _loc15_ = 0;
                  while(_loc15_ < _loc16_.m_contactCount)
                  {
                     _loc9_ = _loc16_.m_contacts[_loc15_];
                     _loc9_.m_flags = _loc9_.m_flags & ~(b2Contact.e_toiFlag | b2Contact.e_islandFlag);
                     _loc15_++;
                  }
                  _loc15_ = 0;
                  while(_loc15_ < _loc16_.m_jointCount)
                  {
                     _loc14_ = _loc16_.m_joints[_loc15_];
                     _loc14_.m_islandFlag = false;
                     _loc15_++;
                  }
                  m_contactManager.FindNewContacts();
               }
               continue;
            }
            break;
         }
      }
      
      b2internal function DrawJoint(param1:b2Joint) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc12_:b2Body = param1.GetBodyA();
         var _loc7_:b2Body = param1.GetBodyB();
         var _loc10_:b2Transform = _loc12_.m_xf;
         var _loc13_:b2Transform = _loc7_.m_xf;
         var _loc9_:b2Vec2 = _loc10_.position;
         var _loc8_:b2Vec2 = _loc13_.position;
         var _loc6_:b2Vec2 = param1.GetAnchorA();
         var _loc5_:b2Vec2 = param1.GetAnchorB();
         var _loc11_:b2Color = s_jointColor;
         switch(int(param1.m_type) - 3)
         {
            case 0:
               m_debugDraw.DrawSegment(_loc6_,_loc5_,_loc11_);
               break;
            case 1:
               _loc2_ = param1 as b2PulleyJoint;
               _loc4_ = _loc2_.GetGroundAnchorA();
               _loc3_ = _loc2_.GetGroundAnchorB();
               m_debugDraw.DrawSegment(_loc4_,_loc6_,_loc11_);
               m_debugDraw.DrawSegment(_loc3_,_loc5_,_loc11_);
               m_debugDraw.DrawSegment(_loc4_,_loc3_,_loc11_);
               break;
            case 2:
               m_debugDraw.DrawSegment(_loc6_,_loc5_,_loc11_);
         }
      }
      
      b2internal function DrawShape(param1:b2Shape, param2:b2Transform, param3:b2Color) : void
      {
         var _loc8_:* = null;
         var _loc10_:* = null;
         var _loc13_:Number = NaN;
         var _loc4_:* = null;
         var _loc9_:int = 0;
         var _loc6_:* = null;
         var _loc11_:int = 0;
         var _loc12_:* = undefined;
         var _loc7_:* = undefined;
         var _loc5_:* = null;
         switch(int(param1.m_type))
         {
            case 0:
               _loc8_ = param1 as b2CircleShape;
               _loc10_ = b2Math.MulX(param2,_loc8_.m_p);
               _loc13_ = _loc8_.m_radius;
               _loc4_ = param2.R.col1;
               m_debugDraw.DrawSolidCircle(_loc10_,_loc13_,_loc4_,param3);
               break;
            case 1:
               _loc6_ = param1 as b2PolygonShape;
               _loc11_ = _loc6_.GetVertexCount();
               _loc12_ = _loc6_.GetVertices();
               _loc7_ = new Vector.<b2Vec2>(_loc11_);
               _loc9_ = 0;
               while(_loc9_ < _loc11_)
               {
                  _loc7_[_loc9_] = b2Math.MulX(param2,_loc12_[_loc9_]);
                  _loc9_++;
               }
               m_debugDraw.DrawSolidPolygon(_loc7_,_loc11_,param3);
               break;
            case 2:
               _loc5_ = param1 as b2EdgeShape;
               m_debugDraw.DrawSegment(b2Math.MulX(param2,_loc5_.GetVertex1()),b2Math.MulX(param2,_loc5_.GetVertex2()),param3);
         }
      }
   }
}
