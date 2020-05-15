package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2PulleyJoint extends b2Joint
   {
      
      b2internal static const b2_minPulleyLength:Number = 2.0;
       
      
      private var m_ground:b2Body;
      
      private var m_groundAnchor1:b2Vec2;
      
      private var m_groundAnchor2:b2Vec2;
      
      private var m_localAnchor1:b2Vec2;
      
      private var m_localAnchor2:b2Vec2;
      
      private var m_u1:b2Vec2;
      
      private var m_u2:b2Vec2;
      
      private var m_constant:Number;
      
      private var m_ratio:Number;
      
      private var m_maxLength1:Number;
      
      private var m_maxLength2:Number;
      
      private var m_pulleyMass:Number;
      
      private var m_limitMass1:Number;
      
      private var m_limitMass2:Number;
      
      private var m_impulse:Number;
      
      private var m_limitImpulse1:Number;
      
      private var m_limitImpulse2:Number;
      
      private var m_state:int;
      
      private var m_limitState1:int;
      
      private var m_limitState2:int;
      
      public function b2PulleyJoint(param1:b2PulleyJointDef)
      {
         var _loc2_:* = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         m_groundAnchor1 = new b2Vec2();
         m_groundAnchor2 = new b2Vec2();
         m_localAnchor1 = new b2Vec2();
         m_localAnchor2 = new b2Vec2();
         m_u1 = new b2Vec2();
         m_u2 = new b2Vec2();
         super(param1);
         m_ground = m_bodyA.m_world.m_groundBody;
         m_groundAnchor1.x = param1.groundAnchorA.x - m_ground.m_xf.position.x;
         m_groundAnchor1.y = param1.groundAnchorA.y - m_ground.m_xf.position.y;
         m_groundAnchor2.x = param1.groundAnchorB.x - m_ground.m_xf.position.x;
         m_groundAnchor2.y = param1.groundAnchorB.y - m_ground.m_xf.position.y;
         m_localAnchor1.SetV(param1.localAnchorA);
         m_localAnchor2.SetV(param1.localAnchorB);
         m_ratio = param1.ratio;
         m_constant = param1.lengthA + m_ratio * param1.lengthB;
         m_maxLength1 = b2Math.Min(param1.maxLengthA,m_constant - m_ratio * 2);
         m_maxLength2 = b2Math.Min(param1.maxLengthB,(m_constant - 2) / m_ratio);
         m_impulse = 0;
         m_limitImpulse1 = 0;
         m_limitImpulse2 = 0;
      }
      
      override public function GetAnchorA() : b2Vec2
      {
         return m_bodyA.GetWorldPoint(m_localAnchor1);
      }
      
      override public function GetAnchorB() : b2Vec2
      {
         return m_bodyB.GetWorldPoint(m_localAnchor2);
      }
      
      override public function GetReactionForce(param1:Number) : b2Vec2
      {
         return new b2Vec2(param1 * m_impulse * m_u2.x,param1 * m_impulse * m_u2.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return 0;
      }
      
      public function GetGroundAnchorA() : b2Vec2
      {
         var _loc1_:b2Vec2 = m_ground.m_xf.position.Copy();
         _loc1_.Add(m_groundAnchor1);
         return _loc1_;
      }
      
      public function GetGroundAnchorB() : b2Vec2
      {
         var _loc1_:b2Vec2 = m_ground.m_xf.position.Copy();
         _loc1_.Add(m_groundAnchor2);
         return _loc1_;
      }
      
      public function GetLength1() : Number
      {
         var _loc1_:b2Vec2 = m_bodyA.GetWorldPoint(m_localAnchor1);
         var _loc4_:Number = m_ground.m_xf.position.x + m_groundAnchor1.x;
         var _loc5_:Number = m_ground.m_xf.position.y + m_groundAnchor1.y;
         var _loc3_:Number = _loc1_.x - _loc4_;
         var _loc2_:Number = _loc1_.y - _loc5_;
         return Math.sqrt(_loc3_ * _loc3_ + _loc2_ * _loc2_);
      }
      
      public function GetLength2() : Number
      {
         var _loc1_:b2Vec2 = m_bodyB.GetWorldPoint(m_localAnchor2);
         var _loc4_:Number = m_ground.m_xf.position.x + m_groundAnchor2.x;
         var _loc5_:Number = m_ground.m_xf.position.y + m_groundAnchor2.y;
         var _loc3_:Number = _loc1_.x - _loc4_;
         var _loc2_:Number = _loc1_.y - _loc5_;
         return Math.sqrt(_loc3_ * _loc3_ + _loc2_ * _loc2_);
      }
      
      public function GetRatio() : Number
      {
         return m_ratio;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc25_:* = null;
         var _loc7_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc4_:b2Body = m_bodyA;
         var _loc26_:b2Body = m_bodyB;
         _loc25_ = _loc4_.m_xf.R;
         var _loc18_:* = Number(m_localAnchor1.x - _loc4_.m_sweep.localCenter.x);
         var _loc20_:Number = m_localAnchor1.y - _loc4_.m_sweep.localCenter.y;
         var _loc16_:Number = _loc25_.col1.x * _loc18_ + _loc25_.col2.x * _loc20_;
         _loc20_ = _loc25_.col1.y * _loc18_ + _loc25_.col2.y * _loc20_;
         _loc18_ = _loc16_;
         _loc25_ = _loc26_.m_xf.R;
         var _loc3_:* = Number(m_localAnchor2.x - _loc26_.m_sweep.localCenter.x);
         var _loc2_:Number = m_localAnchor2.y - _loc26_.m_sweep.localCenter.y;
         _loc16_ = _loc25_.col1.x * _loc3_ + _loc25_.col2.x * _loc2_;
         _loc2_ = _loc25_.col1.y * _loc3_ + _loc25_.col2.y * _loc2_;
         _loc3_ = _loc16_;
         var _loc12_:Number = _loc4_.m_sweep.c.x + _loc18_;
         var _loc15_:Number = _loc4_.m_sweep.c.y + _loc20_;
         var _loc24_:Number = _loc26_.m_sweep.c.x + _loc3_;
         var _loc23_:Number = _loc26_.m_sweep.c.y + _loc2_;
         var _loc13_:Number = m_ground.m_xf.position.x + m_groundAnchor1.x;
         var _loc14_:Number = m_ground.m_xf.position.y + m_groundAnchor1.y;
         var _loc11_:Number = m_ground.m_xf.position.x + m_groundAnchor2.x;
         var _loc10_:Number = m_ground.m_xf.position.y + m_groundAnchor2.y;
         m_u1.Set(_loc12_ - _loc13_,_loc15_ - _loc14_);
         m_u2.Set(_loc24_ - _loc11_,_loc23_ - _loc10_);
         var _loc8_:Number = m_u1.Length();
         var _loc9_:Number = m_u2.Length();
         if(_loc8_ > 0.005)
         {
            m_u1.Multiply(1 / _loc8_);
         }
         else
         {
            m_u1.SetZero();
         }
         if(_loc9_ > 0.005)
         {
            m_u2.Multiply(1 / _loc9_);
         }
         else
         {
            m_u2.SetZero();
         }
         var _loc6_:Number = m_constant - _loc8_ - m_ratio * _loc9_;
         if(_loc6_ > 0)
         {
            m_state = 0;
            m_impulse = 0;
         }
         else
         {
            m_state = 2;
         }
         if(_loc8_ < m_maxLength1)
         {
            m_limitState1 = 0;
            m_limitImpulse1 = 0;
         }
         else
         {
            m_limitState1 = 2;
         }
         if(_loc9_ < m_maxLength2)
         {
            m_limitState2 = 0;
            m_limitImpulse2 = 0;
         }
         else
         {
            m_limitState2 = 2;
         }
         var _loc17_:Number = _loc18_ * m_u1.y - _loc20_ * m_u1.x;
         var _loc19_:Number = _loc3_ * m_u2.y - _loc2_ * m_u2.x;
         m_limitMass1 = _loc4_.m_invMass + _loc4_.m_invI * _loc17_ * _loc17_;
         m_limitMass2 = _loc26_.m_invMass + _loc26_.m_invI * _loc19_ * _loc19_;
         m_pulleyMass = m_limitMass1 + m_ratio * m_ratio * m_limitMass2;
         m_limitMass1 = 1 / m_limitMass1;
         m_limitMass2 = 1 / m_limitMass2;
         m_pulleyMass = 1 / m_pulleyMass;
         if(param1.warmStarting)
         {
            m_impulse = m_impulse * param1.dtRatio;
            m_limitImpulse1 = m_limitImpulse1 * param1.dtRatio;
            m_limitImpulse2 = m_limitImpulse2 * param1.dtRatio;
            _loc7_ = (-m_impulse - m_limitImpulse1) * m_u1.x;
            _loc5_ = (-m_impulse - m_limitImpulse1) * m_u1.y;
            _loc21_ = (-m_ratio * m_impulse - m_limitImpulse2) * m_u2.x;
            _loc22_ = (-m_ratio * m_impulse - m_limitImpulse2) * m_u2.y;
            _loc4_.m_linearVelocity.x = _loc4_.m_linearVelocity.x + _loc4_.m_invMass * _loc7_;
            _loc4_.m_linearVelocity.y = _loc4_.m_linearVelocity.y + _loc4_.m_invMass * _loc5_;
            _loc4_.m_angularVelocity = _loc4_.m_angularVelocity + _loc4_.m_invI * (_loc18_ * _loc5_ - _loc20_ * _loc7_);
            _loc26_.m_linearVelocity.x = _loc26_.m_linearVelocity.x + _loc26_.m_invMass * _loc21_;
            _loc26_.m_linearVelocity.y = _loc26_.m_linearVelocity.y + _loc26_.m_invMass * _loc22_;
            _loc26_.m_angularVelocity = _loc26_.m_angularVelocity + _loc26_.m_invI * (_loc3_ * _loc22_ - _loc2_ * _loc21_);
         }
         else
         {
            m_impulse = 0;
            m_limitImpulse1 = 0;
            m_limitImpulse2 = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc16_:* = null;
         var _loc12_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc6_:b2Body = m_bodyA;
         var _loc19_:b2Body = m_bodyB;
         _loc16_ = _loc6_.m_xf.R;
         var _loc4_:* = Number(m_localAnchor1.x - _loc6_.m_sweep.localCenter.x);
         var _loc7_:Number = m_localAnchor1.y - _loc6_.m_sweep.localCenter.y;
         var _loc20_:Number = _loc16_.col1.x * _loc4_ + _loc16_.col2.x * _loc7_;
         _loc7_ = _loc16_.col1.y * _loc4_ + _loc16_.col2.y * _loc7_;
         _loc4_ = _loc20_;
         _loc16_ = _loc19_.m_xf.R;
         var _loc3_:* = Number(m_localAnchor2.x - _loc19_.m_sweep.localCenter.x);
         var _loc2_:Number = m_localAnchor2.y - _loc19_.m_sweep.localCenter.y;
         _loc20_ = _loc16_.col1.x * _loc3_ + _loc16_.col2.x * _loc2_;
         _loc2_ = _loc16_.col1.y * _loc3_ + _loc16_.col2.y * _loc2_;
         _loc3_ = _loc20_;
         if(m_state == 2)
         {
            _loc12_ = _loc6_.m_linearVelocity.x + -_loc6_.m_angularVelocity * _loc7_;
            _loc14_ = _loc6_.m_linearVelocity.y + _loc6_.m_angularVelocity * _loc4_;
            _loc17_ = _loc19_.m_linearVelocity.x + -_loc19_.m_angularVelocity * _loc2_;
            _loc18_ = _loc19_.m_linearVelocity.y + _loc19_.m_angularVelocity * _loc3_;
            _loc13_ = -(m_u1.x * _loc12_ + m_u1.y * _loc14_) - m_ratio * (m_u2.x * _loc17_ + m_u2.y * _loc18_);
            _loc11_ = m_pulleyMass * -_loc13_;
            _loc15_ = m_impulse;
            m_impulse = b2Math.Max(0,m_impulse + _loc11_);
            _loc11_ = m_impulse - _loc15_;
            _loc8_ = -_loc11_ * m_u1.x;
            _loc5_ = -_loc11_ * m_u1.y;
            _loc9_ = -m_ratio * _loc11_ * m_u2.x;
            _loc10_ = -m_ratio * _loc11_ * m_u2.y;
            _loc6_.m_linearVelocity.x = _loc6_.m_linearVelocity.x + _loc6_.m_invMass * _loc8_;
            _loc6_.m_linearVelocity.y = _loc6_.m_linearVelocity.y + _loc6_.m_invMass * _loc5_;
            _loc6_.m_angularVelocity = _loc6_.m_angularVelocity + _loc6_.m_invI * (_loc4_ * _loc5_ - _loc7_ * _loc8_);
            _loc19_.m_linearVelocity.x = _loc19_.m_linearVelocity.x + _loc19_.m_invMass * _loc9_;
            _loc19_.m_linearVelocity.y = _loc19_.m_linearVelocity.y + _loc19_.m_invMass * _loc10_;
            _loc19_.m_angularVelocity = _loc19_.m_angularVelocity + _loc19_.m_invI * (_loc3_ * _loc10_ - _loc2_ * _loc9_);
         }
         if(m_limitState1 == 2)
         {
            _loc12_ = _loc6_.m_linearVelocity.x + -_loc6_.m_angularVelocity * _loc7_;
            _loc14_ = _loc6_.m_linearVelocity.y + _loc6_.m_angularVelocity * _loc4_;
            _loc13_ = -(m_u1.x * _loc12_ + m_u1.y * _loc14_);
            _loc11_ = -m_limitMass1 * _loc13_;
            _loc15_ = m_limitImpulse1;
            m_limitImpulse1 = b2Math.Max(0,m_limitImpulse1 + _loc11_);
            _loc11_ = m_limitImpulse1 - _loc15_;
            _loc8_ = -_loc11_ * m_u1.x;
            _loc5_ = -_loc11_ * m_u1.y;
            _loc6_.m_linearVelocity.x = _loc6_.m_linearVelocity.x + _loc6_.m_invMass * _loc8_;
            _loc6_.m_linearVelocity.y = _loc6_.m_linearVelocity.y + _loc6_.m_invMass * _loc5_;
            _loc6_.m_angularVelocity = _loc6_.m_angularVelocity + _loc6_.m_invI * (_loc4_ * _loc5_ - _loc7_ * _loc8_);
         }
         if(m_limitState2 == 2)
         {
            _loc17_ = _loc19_.m_linearVelocity.x + -_loc19_.m_angularVelocity * _loc2_;
            _loc18_ = _loc19_.m_linearVelocity.y + _loc19_.m_angularVelocity * _loc3_;
            _loc13_ = -(m_u2.x * _loc17_ + m_u2.y * _loc18_);
            _loc11_ = -m_limitMass2 * _loc13_;
            _loc15_ = m_limitImpulse2;
            m_limitImpulse2 = b2Math.Max(0,m_limitImpulse2 + _loc11_);
            _loc11_ = m_limitImpulse2 - _loc15_;
            _loc9_ = -_loc11_ * m_u2.x;
            _loc10_ = -_loc11_ * m_u2.y;
            _loc19_.m_linearVelocity.x = _loc19_.m_linearVelocity.x + _loc19_.m_invMass * _loc9_;
            _loc19_.m_linearVelocity.y = _loc19_.m_linearVelocity.y + _loc19_.m_invMass * _loc10_;
            _loc19_.m_angularVelocity = _loc19_.m_angularVelocity + _loc19_.m_invI * (_loc3_ * _loc10_ - _loc2_ * _loc9_);
         }
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc21_:* = null;
         var _loc4_:* = NaN;
         var _loc8_:Number = NaN;
         var _loc3_:* = NaN;
         var _loc2_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc6_:b2Body = m_bodyA;
         var _loc22_:b2Body = m_bodyB;
         var _loc17_:Number = m_ground.m_xf.position.x + m_groundAnchor1.x;
         var _loc19_:Number = m_ground.m_xf.position.y + m_groundAnchor1.y;
         var _loc13_:Number = m_ground.m_xf.position.x + m_groundAnchor2.x;
         var _loc12_:Number = m_ground.m_xf.position.y + m_groundAnchor2.y;
         var _loc5_:* = 0;
         if(m_state == 2)
         {
            _loc21_ = _loc6_.m_xf.R;
            _loc4_ = Number(m_localAnchor1.x - _loc6_.m_sweep.localCenter.x);
            _loc8_ = m_localAnchor1.y - _loc6_.m_sweep.localCenter.y;
            _loc24_ = _loc21_.col1.x * _loc4_ + _loc21_.col2.x * _loc8_;
            _loc8_ = _loc21_.col1.y * _loc4_ + _loc21_.col2.y * _loc8_;
            _loc4_ = _loc24_;
            _loc21_ = _loc22_.m_xf.R;
            _loc3_ = Number(m_localAnchor2.x - _loc22_.m_sweep.localCenter.x);
            _loc2_ = m_localAnchor2.y - _loc22_.m_sweep.localCenter.y;
            _loc24_ = _loc21_.col1.x * _loc3_ + _loc21_.col2.x * _loc2_;
            _loc2_ = _loc21_.col1.y * _loc3_ + _loc21_.col2.y * _loc2_;
            _loc3_ = _loc24_;
            _loc15_ = _loc6_.m_sweep.c.x + _loc4_;
            _loc23_ = _loc6_.m_sweep.c.y + _loc8_;
            _loc18_ = _loc22_.m_sweep.c.x + _loc3_;
            _loc16_ = _loc22_.m_sweep.c.y + _loc2_;
            m_u1.Set(_loc15_ - _loc17_,_loc23_ - _loc19_);
            m_u2.Set(_loc18_ - _loc13_,_loc16_ - _loc12_);
            _loc10_ = m_u1.Length();
            _loc11_ = m_u2.Length();
            if(_loc10_ > 0.005)
            {
               m_u1.Multiply(1 / _loc10_);
            }
            else
            {
               m_u1.SetZero();
            }
            if(_loc11_ > 0.005)
            {
               m_u2.Multiply(1 / _loc11_);
            }
            else
            {
               m_u2.SetZero();
            }
            _loc7_ = m_constant - _loc10_ - m_ratio * _loc11_;
            _loc5_ = Number(b2Math.Max(_loc5_,-_loc7_));
            _loc7_ = b2Math.Clamp(_loc7_ + 0.005,-0.2,0);
            _loc14_ = -m_pulleyMass * _loc7_;
            _loc15_ = -_loc14_ * m_u1.x;
            _loc23_ = -_loc14_ * m_u1.y;
            _loc18_ = -m_ratio * _loc14_ * m_u2.x;
            _loc16_ = -m_ratio * _loc14_ * m_u2.y;
            _loc6_.m_sweep.c.x = _loc6_.m_sweep.c.x + _loc6_.m_invMass * _loc15_;
            _loc6_.m_sweep.c.y = _loc6_.m_sweep.c.y + _loc6_.m_invMass * _loc23_;
            _loc6_.m_sweep.a = _loc6_.m_sweep.a + _loc6_.m_invI * (_loc4_ * _loc23_ - _loc8_ * _loc15_);
            _loc22_.m_sweep.c.x = _loc22_.m_sweep.c.x + _loc22_.m_invMass * _loc18_;
            _loc22_.m_sweep.c.y = _loc22_.m_sweep.c.y + _loc22_.m_invMass * _loc16_;
            _loc22_.m_sweep.a = _loc22_.m_sweep.a + _loc22_.m_invI * (_loc3_ * _loc16_ - _loc2_ * _loc18_);
            _loc6_.SynchronizeTransform();
            _loc22_.SynchronizeTransform();
         }
         if(m_limitState1 == 2)
         {
            _loc21_ = _loc6_.m_xf.R;
            _loc4_ = Number(m_localAnchor1.x - _loc6_.m_sweep.localCenter.x);
            _loc8_ = m_localAnchor1.y - _loc6_.m_sweep.localCenter.y;
            _loc24_ = _loc21_.col1.x * _loc4_ + _loc21_.col2.x * _loc8_;
            _loc8_ = _loc21_.col1.y * _loc4_ + _loc21_.col2.y * _loc8_;
            _loc4_ = _loc24_;
            _loc15_ = _loc6_.m_sweep.c.x + _loc4_;
            _loc23_ = _loc6_.m_sweep.c.y + _loc8_;
            m_u1.Set(_loc15_ - _loc17_,_loc23_ - _loc19_);
            _loc10_ = m_u1.Length();
            if(_loc10_ > 0.005)
            {
               m_u1.x = m_u1.x * (1 / _loc10_);
               m_u1.y = m_u1.y * (1 / _loc10_);
            }
            else
            {
               m_u1.SetZero();
            }
            _loc7_ = m_maxLength1 - _loc10_;
            _loc5_ = Number(b2Math.Max(_loc5_,-_loc7_));
            _loc7_ = b2Math.Clamp(_loc7_ + 0.005,-0.2,0);
            _loc14_ = -m_limitMass1 * _loc7_;
            _loc15_ = -_loc14_ * m_u1.x;
            _loc23_ = -_loc14_ * m_u1.y;
            _loc6_.m_sweep.c.x = _loc6_.m_sweep.c.x + _loc6_.m_invMass * _loc15_;
            _loc6_.m_sweep.c.y = _loc6_.m_sweep.c.y + _loc6_.m_invMass * _loc23_;
            _loc6_.m_sweep.a = _loc6_.m_sweep.a + _loc6_.m_invI * (_loc4_ * _loc23_ - _loc8_ * _loc15_);
            _loc6_.SynchronizeTransform();
         }
         if(m_limitState2 == 2)
         {
            _loc21_ = _loc22_.m_xf.R;
            _loc3_ = Number(m_localAnchor2.x - _loc22_.m_sweep.localCenter.x);
            _loc2_ = m_localAnchor2.y - _loc22_.m_sweep.localCenter.y;
            _loc24_ = _loc21_.col1.x * _loc3_ + _loc21_.col2.x * _loc2_;
            _loc2_ = _loc21_.col1.y * _loc3_ + _loc21_.col2.y * _loc2_;
            _loc3_ = _loc24_;
            _loc18_ = _loc22_.m_sweep.c.x + _loc3_;
            _loc16_ = _loc22_.m_sweep.c.y + _loc2_;
            m_u2.Set(_loc18_ - _loc13_,_loc16_ - _loc12_);
            _loc11_ = m_u2.Length();
            if(_loc11_ > 0.005)
            {
               m_u2.x = m_u2.x * (1 / _loc11_);
               m_u2.y = m_u2.y * (1 / _loc11_);
            }
            else
            {
               m_u2.SetZero();
            }
            _loc7_ = m_maxLength2 - _loc11_;
            _loc5_ = Number(b2Math.Max(_loc5_,-_loc7_));
            _loc7_ = b2Math.Clamp(_loc7_ + 0.005,-0.2,0);
            _loc14_ = -m_limitMass2 * _loc7_;
            _loc18_ = -_loc14_ * m_u2.x;
            _loc16_ = -_loc14_ * m_u2.y;
            _loc22_.m_sweep.c.x = _loc22_.m_sweep.c.x + _loc22_.m_invMass * _loc18_;
            _loc22_.m_sweep.c.y = _loc22_.m_sweep.c.y + _loc22_.m_invMass * _loc16_;
            _loc22_.m_sweep.a = _loc22_.m_sweep.a + _loc22_.m_invI * (_loc3_ * _loc16_ - _loc2_ * _loc18_);
            _loc22_.SynchronizeTransform();
         }
         return _loc5_ < 0.005;
      }
   }
}
