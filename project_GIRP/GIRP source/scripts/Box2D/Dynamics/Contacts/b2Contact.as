package Box2D.Dynamics.Contacts
{
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Collision.b2ContactID;
   import Box2D.Collision.b2Manifold;
   import Box2D.Collision.b2ManifoldPoint;
   import Box2D.Collision.b2TOIInput;
   import Box2D.Collision.b2TimeOfImpact;
   import Box2D.Collision.b2WorldManifold;
   import Box2D.Common.Math.b2Sweep;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2ContactListener;
   import Box2D.Dynamics.b2Fixture;
   
   use namespace b2internal;
   
   public class b2Contact
   {
      
      b2internal static var e_sensorFlag:uint = 1;
      
      b2internal static var e_continuousFlag:uint = 2;
      
      b2internal static var e_islandFlag:uint = 4;
      
      b2internal static var e_toiFlag:uint = 8;
      
      b2internal static var e_touchingFlag:uint = 16;
      
      b2internal static var e_enabledFlag:uint = 32;
      
      b2internal static var e_filterFlag:uint = 64;
      
      private static var s_input:b2TOIInput = new b2TOIInput();
       
      
      b2internal var m_flags:uint;
      
      b2internal var m_prev:b2Contact;
      
      b2internal var m_next:b2Contact;
      
      b2internal var m_nodeA:b2ContactEdge;
      
      b2internal var m_nodeB:b2ContactEdge;
      
      b2internal var m_fixtureA:b2Fixture;
      
      b2internal var m_fixtureB:b2Fixture;
      
      b2internal var m_manifold:b2Manifold;
      
      b2internal var m_oldManifold:b2Manifold;
      
      b2internal var m_toi:Number;
      
      public function b2Contact()
      {
         m_nodeA = new b2ContactEdge();
         m_nodeB = new b2ContactEdge();
         m_manifold = new b2Manifold();
         m_oldManifold = new b2Manifold();
         super();
      }
      
      public function GetManifold() : b2Manifold
      {
         return m_manifold;
      }
      
      public function GetWorldManifold(param1:b2WorldManifold) : void
      {
         var _loc5_:b2Body = m_fixtureA.GetBody();
         var _loc2_:b2Body = m_fixtureB.GetBody();
         var _loc3_:b2Shape = m_fixtureA.GetShape();
         var _loc4_:b2Shape = m_fixtureB.GetShape();
         param1.Initialize(m_manifold,_loc5_.GetTransform(),_loc3_.m_radius,_loc2_.GetTransform(),_loc4_.m_radius);
      }
      
      public function IsTouching() : Boolean
      {
         return (m_flags & e_touchingFlag) == e_touchingFlag;
      }
      
      public function IsContinuous() : Boolean
      {
         return (m_flags & e_continuousFlag) == e_continuousFlag;
      }
      
      public function SetSensor(param1:Boolean) : void
      {
         if(param1)
         {
            m_flags = m_flags | e_sensorFlag;
         }
         else
         {
            m_flags = m_flags & ~e_sensorFlag;
         }
      }
      
      public function IsSensor() : Boolean
      {
         return (m_flags & e_sensorFlag) == e_sensorFlag;
      }
      
      public function SetEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            m_flags = m_flags | e_enabledFlag;
         }
         else
         {
            m_flags = m_flags & ~e_enabledFlag;
         }
      }
      
      public function IsEnabled() : Boolean
      {
         return (m_flags & e_enabledFlag) == e_enabledFlag;
      }
      
      public function GetNext() : b2Contact
      {
         return m_next;
      }
      
      public function GetFixtureA() : b2Fixture
      {
         return m_fixtureA;
      }
      
      public function GetFixtureB() : b2Fixture
      {
         return m_fixtureB;
      }
      
      public function FlagForFiltering() : void
      {
         m_flags = m_flags | e_filterFlag;
      }
      
      b2internal function Reset(param1:b2Fixture = null, param2:b2Fixture = null) : void
      {
         m_flags = e_enabledFlag;
         if(!param1 || !param2)
         {
            m_fixtureA = null;
            m_fixtureB = null;
            return;
         }
         if(param1.IsSensor() || param2.IsSensor())
         {
            m_flags = m_flags | e_sensorFlag;
         }
         var _loc4_:b2Body = param1.GetBody();
         var _loc3_:b2Body = param2.GetBody();
         if(_loc4_.GetType() != b2Body.b2_dynamicBody || _loc4_.IsBullet() || _loc3_.GetType() != b2Body.b2_dynamicBody || _loc3_.IsBullet())
         {
            m_flags = m_flags | e_continuousFlag;
         }
         m_fixtureA = param1;
         m_fixtureB = param2;
         m_manifold.m_pointCount = 0;
         m_prev = null;
         m_next = null;
         m_nodeA.contact = null;
         m_nodeA.prev = null;
         m_nodeA.next = null;
         m_nodeA.other = null;
         m_nodeB.contact = null;
         m_nodeB.prev = null;
         m_nodeB.next = null;
         m_nodeB.other = null;
      }
      
      b2internal function Update(param1:b2ContactListener) : void
      {
         var _loc14_:* = null;
         var _loc16_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc8_:int = 0;
         var _loc12_:* = null;
         var _loc4_:* = null;
         var _loc6_:int = 0;
         var _loc10_:* = null;
         var _loc9_:b2Manifold = m_oldManifold;
         m_oldManifold = m_manifold;
         m_manifold = _loc9_;
         m_flags = m_flags | e_enabledFlag;
         var _loc11_:* = false;
         var _loc13_:* = (m_flags & e_touchingFlag) == e_touchingFlag;
         var _loc15_:b2Body = m_fixtureA.m_body;
         var _loc3_:b2Body = m_fixtureB.m_body;
         var _loc7_:Boolean = m_fixtureA.m_aabb.TestOverlap(m_fixtureB.m_aabb);
         if(m_flags & e_sensorFlag)
         {
            if(_loc7_)
            {
               _loc14_ = m_fixtureA.GetShape();
               _loc16_ = m_fixtureB.GetShape();
               _loc2_ = _loc15_.GetTransform();
               _loc5_ = _loc3_.GetTransform();
               _loc11_ = Boolean(b2Shape.TestOverlap(_loc14_,_loc2_,_loc16_,_loc5_));
            }
            m_manifold.m_pointCount = 0;
         }
         else
         {
            if(_loc15_.GetType() != b2Body.b2_dynamicBody || _loc15_.IsBullet() || _loc3_.GetType() != b2Body.b2_dynamicBody || _loc3_.IsBullet())
            {
               m_flags = m_flags | e_continuousFlag;
            }
            else
            {
               m_flags = m_flags & ~e_continuousFlag;
            }
            if(_loc7_)
            {
               Evaluate();
               _loc11_ = m_manifold.m_pointCount > 0;
               _loc8_ = 0;
               while(_loc8_ < m_manifold.m_pointCount)
               {
                  _loc12_ = m_manifold.m_points[_loc8_];
                  _loc12_.m_normalImpulse = 0;
                  _loc12_.m_tangentImpulse = 0;
                  _loc4_ = _loc12_.m_id;
                  _loc6_ = 0;
                  while(_loc6_ < m_oldManifold.m_pointCount)
                  {
                     _loc10_ = m_oldManifold.m_points[_loc6_];
                     if(_loc10_.m_id.key == _loc4_.key)
                     {
                        _loc12_.m_normalImpulse = _loc10_.m_normalImpulse;
                        _loc12_.m_tangentImpulse = _loc10_.m_tangentImpulse;
                        break;
                     }
                     _loc6_++;
                  }
                  _loc8_++;
               }
            }
            else
            {
               m_manifold.m_pointCount = 0;
            }
            if(_loc11_ != _loc13_)
            {
               _loc15_.SetAwake(true);
               _loc3_.SetAwake(true);
            }
         }
         if(_loc11_)
         {
            m_flags = m_flags | e_touchingFlag;
         }
         else
         {
            m_flags = m_flags & ~e_touchingFlag;
         }
         if(_loc13_ == false && _loc11_ == true)
         {
            param1.BeginContact(this);
         }
         if(_loc13_ == true && _loc11_ == false)
         {
            param1.EndContact(this);
         }
         if((m_flags & e_sensorFlag) == 0)
         {
            param1.PreSolve(this,m_oldManifold);
         }
      }
      
      b2internal function Evaluate() : void
      {
      }
      
      b2internal function ComputeTOI(param1:b2Sweep, param2:b2Sweep) : Number
      {
         s_input.proxyA.Set(m_fixtureA.GetShape());
         s_input.proxyB.Set(m_fixtureB.GetShape());
         s_input.sweepA = param1;
         s_input.sweepB = param2;
         s_input.tolerance = 0.005;
         return b2TimeOfImpact.TimeOfImpact(s_input);
      }
   }
}
