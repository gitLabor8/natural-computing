package Box2D.Dynamics
{
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.Contacts.b2Contact;
   import Box2D.Dynamics.Contacts.b2ContactConstraint;
   import Box2D.Dynamics.Contacts.b2ContactSolver;
   import Box2D.Dynamics.Joints.b2Joint;
   
   use namespace b2internal;
   
   public class b2Island
   {
      
      private static var s_impulse:b2ContactImpulse = new b2ContactImpulse();
       
      
      private var m_allocator;
      
      private var m_listener:b2ContactListener;
      
      private var m_contactSolver:b2ContactSolver;
      
      b2internal var m_bodies:Vector.<b2Body>;
      
      b2internal var m_contacts:Vector.<b2Contact>;
      
      b2internal var m_joints:Vector.<b2Joint>;
      
      b2internal var m_bodyCount:int;
      
      b2internal var m_jointCount:int;
      
      b2internal var m_contactCount:int;
      
      private var m_bodyCapacity:int;
      
      b2internal var m_contactCapacity:int;
      
      b2internal var m_jointCapacity:int;
      
      public function b2Island()
      {
         super();
         m_bodies = new Vector.<b2Body>();
         m_contacts = new Vector.<b2Contact>();
         m_joints = new Vector.<b2Joint>();
      }
      
      public function Initialize(param1:int, param2:int, param3:int, param4:*, param5:b2ContactListener, param6:b2ContactSolver) : void
      {
         var _loc7_:int = 0;
         m_bodyCapacity = param1;
         m_contactCapacity = param2;
         m_jointCapacity = param3;
         m_bodyCount = 0;
         m_contactCount = 0;
         m_jointCount = 0;
         m_allocator = param4;
         m_listener = param5;
         m_contactSolver = param6;
         _loc7_ = m_bodies.length;
         while(_loc7_ < param1)
         {
            m_bodies[_loc7_] = null;
            _loc7_++;
         }
         _loc7_ = m_contacts.length;
         while(_loc7_ < param2)
         {
            m_contacts[_loc7_] = null;
            _loc7_++;
         }
         _loc7_ = m_joints.length;
         while(_loc7_ < param3)
         {
            m_joints[_loc7_] = null;
            _loc7_++;
         }
      }
      
      public function Clear() : void
      {
         m_bodyCount = 0;
         m_contactCount = 0;
         m_jointCount = 0;
      }
      
      public function Solve(param1:b2TimeStep, param2:b2Vec2, param3:Boolean) : void
      {
         var _loc10_:int = 0;
         var _loc8_:int = 0;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc17_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc16_:* = NaN;
         var _loc7_:* = NaN;
         var _loc15_:* = NaN;
         _loc10_ = 0;
         while(_loc10_ < m_bodyCount)
         {
            _loc5_ = m_bodies[_loc10_];
            if(_loc5_.GetType() == b2Body.b2_dynamicBody)
            {
               _loc5_.m_linearVelocity.x = _loc5_.m_linearVelocity.x + param1.dt * (param2.x + _loc5_.m_invMass * _loc5_.m_force.x);
               _loc5_.m_linearVelocity.y = _loc5_.m_linearVelocity.y + param1.dt * (param2.y + _loc5_.m_invMass * _loc5_.m_force.y);
               _loc5_.m_angularVelocity = _loc5_.m_angularVelocity + param1.dt * _loc5_.m_invI * _loc5_.m_torque;
               _loc5_.m_linearVelocity.Multiply(b2Math.Clamp(1 - param1.dt * _loc5_.m_linearDamping,0,1));
               _loc5_.m_angularVelocity = _loc5_.m_angularVelocity * b2Math.Clamp(1 - param1.dt * _loc5_.m_angularDamping,0,1);
            }
            _loc10_++;
         }
         m_contactSolver.Initialize(param1,m_contacts,m_contactCount,m_allocator);
         var _loc13_:b2ContactSolver = m_contactSolver;
         _loc13_.InitVelocityConstraints(param1);
         _loc10_ = 0;
         while(_loc10_ < m_jointCount)
         {
            _loc4_ = m_joints[_loc10_];
            _loc4_.InitVelocityConstraints(param1);
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < param1.velocityIterations)
         {
            _loc8_ = 0;
            while(_loc8_ < m_jointCount)
            {
               _loc4_ = m_joints[_loc8_];
               _loc4_.SolveVelocityConstraints(param1);
               _loc8_++;
            }
            _loc13_.SolveVelocityConstraints();
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < m_jointCount)
         {
            _loc4_ = m_joints[_loc10_];
            _loc4_.FinalizeVelocityConstraints();
            _loc10_++;
         }
         _loc13_.FinalizeVelocityConstraints();
         _loc10_ = 0;
         while(_loc10_ < m_bodyCount)
         {
            _loc5_ = m_bodies[_loc10_];
            if(_loc5_.GetType() != b2Body.b2_staticBody)
            {
               _loc17_ = param1.dt * _loc5_.m_linearVelocity.x;
               _loc11_ = param1.dt * _loc5_.m_linearVelocity.y;
               if(_loc17_ * _loc17_ + _loc11_ * _loc11_ > 4)
               {
                  _loc5_.m_linearVelocity.Normalize();
                  _loc5_.m_linearVelocity.x = _loc5_.m_linearVelocity.x * (2 * param1.inv_dt);
                  _loc5_.m_linearVelocity.y = _loc5_.m_linearVelocity.y * (2 * param1.inv_dt);
               }
               _loc12_ = param1.dt * _loc5_.m_angularVelocity;
               if(_loc12_ * _loc12_ > 2.46740110027234)
               {
                  if(_loc5_.m_angularVelocity < 0)
                  {
                     _loc5_.m_angularVelocity = -1.5707963267949 * param1.inv_dt;
                  }
                  else
                  {
                     _loc5_.m_angularVelocity = 1.5707963267949 * param1.inv_dt;
                  }
               }
               _loc5_.m_sweep.c0.SetV(_loc5_.m_sweep.c);
               _loc5_.m_sweep.a0 = _loc5_.m_sweep.a;
               _loc5_.m_sweep.c.x = _loc5_.m_sweep.c.x + param1.dt * _loc5_.m_linearVelocity.x;
               _loc5_.m_sweep.c.y = _loc5_.m_sweep.c.y + param1.dt * _loc5_.m_linearVelocity.y;
               _loc5_.m_sweep.a = _loc5_.m_sweep.a + param1.dt * _loc5_.m_angularVelocity;
               _loc5_.SynchronizeTransform();
            }
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < param1.positionIterations)
         {
            _loc6_ = _loc13_.SolvePositionConstraints(0.2);
            _loc14_ = true;
            _loc8_ = 0;
            while(_loc8_ < m_jointCount)
            {
               _loc4_ = m_joints[_loc8_];
               _loc9_ = _loc4_.SolvePositionConstraints(0.2);
               _loc14_ = _loc14_ && _loc9_;
               _loc8_++;
            }
            if(!(_loc6_ && _loc14_))
            {
               _loc10_++;
               continue;
            }
            break;
         }
         Report(_loc13_.m_constraints);
         if(param3)
         {
            _loc16_ = 1.79769313486232e308;
            _loc7_ = 0.0001;
            _loc15_ = 0.00121846967914683;
            _loc10_ = 0;
            while(_loc10_ < m_bodyCount)
            {
               _loc5_ = m_bodies[_loc10_];
               if(_loc5_.GetType() != b2Body.b2_staticBody)
               {
                  if((_loc5_.m_flags & b2Body.e_allowSleepFlag) == 0)
                  {
                     _loc5_.m_sleepTime = 0;
                     _loc16_ = 0;
                  }
                  if((_loc5_.m_flags & b2Body.e_allowSleepFlag) == 0 || _loc5_.m_angularVelocity * _loc5_.m_angularVelocity > _loc15_ || b2Math.Dot(_loc5_.m_linearVelocity,_loc5_.m_linearVelocity) > _loc7_)
                  {
                     _loc5_.m_sleepTime = 0;
                     _loc16_ = 0;
                  }
                  else
                  {
                     _loc5_.m_sleepTime = _loc5_.m_sleepTime + param1.dt;
                     _loc16_ = Number(b2Math.Min(_loc16_,_loc5_.m_sleepTime));
                  }
               }
               _loc10_++;
            }
            if(_loc16_ >= 0.5)
            {
               _loc10_ = 0;
               while(_loc10_ < m_bodyCount)
               {
                  _loc5_ = m_bodies[_loc10_];
                  _loc5_.SetAwake(false);
                  _loc10_++;
               }
            }
         }
      }
      
      public function SolveTOI(param1:b2TimeStep) : void
      {
         var _loc12_:int = 0;
         var _loc9_:int = 0;
         var _loc4_:* = null;
         var _loc11_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc10_:Boolean = false;
         m_contactSolver.Initialize(param1,m_contacts,m_contactCount,m_allocator);
         var _loc7_:b2ContactSolver = m_contactSolver;
         _loc12_ = 0;
         while(_loc12_ < m_jointCount)
         {
            m_joints[_loc12_].InitVelocityConstraints(param1);
            _loc12_++;
         }
         _loc12_ = 0;
         while(_loc12_ < param1.velocityIterations)
         {
            _loc7_.SolveVelocityConstraints();
            _loc9_ = 0;
            while(_loc9_ < m_jointCount)
            {
               m_joints[_loc9_].SolveVelocityConstraints(param1);
               _loc9_++;
            }
            _loc12_++;
         }
         _loc12_ = 0;
         while(_loc12_ < m_bodyCount)
         {
            _loc4_ = m_bodies[_loc12_];
            if(_loc4_.GetType() != b2Body.b2_staticBody)
            {
               _loc11_ = param1.dt * _loc4_.m_linearVelocity.x;
               _loc2_ = param1.dt * _loc4_.m_linearVelocity.y;
               if(_loc11_ * _loc11_ + _loc2_ * _loc2_ > 4)
               {
                  _loc4_.m_linearVelocity.Normalize();
                  _loc4_.m_linearVelocity.x = _loc4_.m_linearVelocity.x * (2 * param1.inv_dt);
                  _loc4_.m_linearVelocity.y = _loc4_.m_linearVelocity.y * (2 * param1.inv_dt);
               }
               _loc6_ = param1.dt * _loc4_.m_angularVelocity;
               if(_loc6_ * _loc6_ > 2.46740110027234)
               {
                  if(_loc4_.m_angularVelocity < 0)
                  {
                     _loc4_.m_angularVelocity = -1.5707963267949 * param1.inv_dt;
                  }
                  else
                  {
                     _loc4_.m_angularVelocity = 1.5707963267949 * param1.inv_dt;
                  }
               }
               _loc4_.m_sweep.c0.SetV(_loc4_.m_sweep.c);
               _loc4_.m_sweep.a0 = _loc4_.m_sweep.a;
               _loc4_.m_sweep.c.x = _loc4_.m_sweep.c.x + param1.dt * _loc4_.m_linearVelocity.x;
               _loc4_.m_sweep.c.y = _loc4_.m_sweep.c.y + param1.dt * _loc4_.m_linearVelocity.y;
               _loc4_.m_sweep.a = _loc4_.m_sweep.a + param1.dt * _loc4_.m_angularVelocity;
               _loc4_.SynchronizeTransform();
            }
            _loc12_++;
         }
         var _loc3_:* = 0.75;
         _loc12_ = 0;
         while(_loc12_ < param1.positionIterations)
         {
            _loc5_ = _loc7_.SolvePositionConstraints(_loc3_);
            _loc8_ = true;
            _loc9_ = 0;
            while(_loc9_ < m_jointCount)
            {
               _loc10_ = m_joints[_loc9_].SolvePositionConstraints(0.2);
               _loc8_ = _loc8_ && _loc10_;
               _loc9_++;
            }
            if(!(_loc5_ && _loc8_))
            {
               _loc12_++;
               continue;
            }
            break;
         }
         Report(_loc7_.m_constraints);
      }
      
      public function Report(param1:Vector.<b2ContactConstraint>) : void
      {
         var _loc5_:int = 0;
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc3_:int = 0;
         if(m_listener == null)
         {
            return;
         }
         _loc5_ = 0;
         while(_loc5_ < m_contactCount)
         {
            _loc2_ = m_contacts[_loc5_];
            _loc4_ = param1[_loc5_];
            _loc3_ = 0;
            while(_loc3_ < _loc4_.pointCount)
            {
               s_impulse.normalImpulses[_loc3_] = _loc4_.points[_loc3_].normalImpulse;
               s_impulse.tangentImpulses[_loc3_] = _loc4_.points[_loc3_].tangentImpulse;
               _loc3_++;
            }
            m_listener.PostSolve(_loc2_,s_impulse);
            _loc5_++;
         }
      }
      
      public function AddBody(param1:b2Body) : void
      {
         param1.m_islandIndex = m_bodyCount;
         m_bodyCount = Number(m_bodyCount) + 1;
         m_bodies[Number(m_bodyCount)] = param1;
      }
      
      public function AddContact(param1:b2Contact) : void
      {
         m_contactCount = Number(m_contactCount) + 1;
         m_contacts[Number(m_contactCount)] = param1;
      }
      
      public function AddJoint(param1:b2Joint) : void
      {
         m_jointCount = Number(m_jointCount) + 1;
         m_joints[Number(m_jointCount)] = param1;
      }
   }
}
