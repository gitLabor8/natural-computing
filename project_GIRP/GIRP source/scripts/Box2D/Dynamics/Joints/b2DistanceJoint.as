package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2DistanceJoint extends b2Joint
   {
       
      
      private var m_localAnchor1:b2Vec2;
      
      private var m_localAnchor2:b2Vec2;
      
      private var m_u:b2Vec2;
      
      private var m_frequencyHz:Number;
      
      private var m_dampingRatio:Number;
      
      private var m_gamma:Number;
      
      private var m_bias:Number;
      
      private var m_impulse:Number;
      
      private var m_mass:Number;
      
      private var m_length:Number;
      
      public function b2DistanceJoint(param1:b2DistanceJointDef)
      {
         var _loc2_:* = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         m_localAnchor1 = new b2Vec2();
         m_localAnchor2 = new b2Vec2();
         m_u = new b2Vec2();
         super(param1);
         m_localAnchor1.SetV(param1.localAnchorA);
         m_localAnchor2.SetV(param1.localAnchorB);
         m_length = param1.length;
         m_frequencyHz = param1.frequencyHz;
         m_dampingRatio = param1.dampingRatio;
         m_impulse = 0;
         m_gamma = 0;
         m_bias = 0;
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
         return new b2Vec2(param1 * m_impulse * m_u.x,param1 * m_impulse * m_u.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return 0;
      }
      
      public function GetLength() : Number
      {
         return m_length;
      }
      
      public function SetLength(param1:Number) : void
      {
         m_length = param1;
      }
      
      public function GetFrequency() : Number
      {
         return m_frequencyHz;
      }
      
      public function SetFrequency(param1:Number) : void
      {
         m_frequencyHz = param1;
      }
      
      public function GetDampingRatio() : Number
      {
         return m_dampingRatio;
      }
      
      public function SetDampingRatio(param1:Number) : void
      {
         m_dampingRatio = param1;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc14_:* = null;
         var _loc19_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc7_:b2Body = m_bodyA;
         var _loc16_:b2Body = m_bodyB;
         _loc14_ = _loc7_.m_xf.R;
         var _loc5_:* = Number(m_localAnchor1.x - _loc7_.m_sweep.localCenter.x);
         var _loc10_:Number = m_localAnchor1.y - _loc7_.m_sweep.localCenter.y;
         _loc19_ = _loc14_.col1.x * _loc5_ + _loc14_.col2.x * _loc10_;
         _loc10_ = _loc14_.col1.y * _loc5_ + _loc14_.col2.y * _loc10_;
         _loc5_ = _loc19_;
         _loc14_ = _loc16_.m_xf.R;
         var _loc4_:* = Number(m_localAnchor2.x - _loc16_.m_sweep.localCenter.x);
         var _loc3_:Number = m_localAnchor2.y - _loc16_.m_sweep.localCenter.y;
         _loc19_ = _loc14_.col1.x * _loc4_ + _loc14_.col2.x * _loc3_;
         _loc3_ = _loc14_.col1.y * _loc4_ + _loc14_.col2.y * _loc3_;
         _loc4_ = _loc19_;
         m_u.x = _loc16_.m_sweep.c.x + _loc4_ - _loc7_.m_sweep.c.x - _loc5_;
         m_u.y = _loc16_.m_sweep.c.y + _loc3_ - _loc7_.m_sweep.c.y - _loc10_;
         var _loc15_:Number = Math.sqrt(m_u.x * m_u.x + m_u.y * m_u.y);
         if(_loc15_ > 0.005)
         {
            m_u.Multiply(1 / _loc15_);
         }
         else
         {
            m_u.SetZero();
         }
         var _loc8_:Number = _loc5_ * m_u.y - _loc10_ * m_u.x;
         var _loc6_:Number = _loc4_ * m_u.y - _loc3_ * m_u.x;
         var _loc11_:Number = _loc7_.m_invMass + _loc7_.m_invI * _loc8_ * _loc8_ + _loc16_.m_invMass + _loc16_.m_invI * _loc6_ * _loc6_;
         m_mass = _loc11_ != 0?1 / _loc11_:0;
         if(m_frequencyHz > 0)
         {
            _loc9_ = _loc15_ - m_length;
            _loc13_ = 2 * 3.14159265358979 * m_frequencyHz;
            _loc2_ = 2 * m_mass * m_dampingRatio * _loc13_;
            _loc12_ = m_mass * _loc13_ * _loc13_;
            m_gamma = param1.dt * (_loc2_ + param1.dt * _loc12_);
            m_gamma = m_gamma != 0?1 / m_gamma:0;
            m_bias = _loc9_ * param1.dt * _loc12_ * m_gamma;
            m_mass = _loc11_ + m_gamma;
            m_mass = m_mass != 0?1 / m_mass:0;
         }
         if(param1.warmStarting)
         {
            m_impulse = m_impulse * param1.dtRatio;
            _loc17_ = m_impulse * m_u.x;
            _loc18_ = m_impulse * m_u.y;
            _loc7_.m_linearVelocity.x = _loc7_.m_linearVelocity.x - _loc7_.m_invMass * _loc17_;
            _loc7_.m_linearVelocity.y = _loc7_.m_linearVelocity.y - _loc7_.m_invMass * _loc18_;
            _loc7_.m_angularVelocity = _loc7_.m_angularVelocity - _loc7_.m_invI * (_loc5_ * _loc18_ - _loc10_ * _loc17_);
            _loc16_.m_linearVelocity.x = _loc16_.m_linearVelocity.x + _loc16_.m_invMass * _loc17_;
            _loc16_.m_linearVelocity.y = _loc16_.m_linearVelocity.y + _loc16_.m_invMass * _loc18_;
            _loc16_.m_angularVelocity = _loc16_.m_angularVelocity + _loc16_.m_invI * (_loc4_ * _loc18_ - _loc3_ * _loc17_);
         }
         else
         {
            m_impulse = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc11_:* = null;
         var _loc5_:b2Body = m_bodyA;
         var _loc14_:b2Body = m_bodyB;
         _loc11_ = _loc5_.m_xf.R;
         var _loc4_:* = Number(m_localAnchor1.x - _loc5_.m_sweep.localCenter.x);
         var _loc6_:Number = m_localAnchor1.y - _loc5_.m_sweep.localCenter.y;
         var _loc17_:Number = _loc11_.col1.x * _loc4_ + _loc11_.col2.x * _loc6_;
         _loc6_ = _loc11_.col1.y * _loc4_ + _loc11_.col2.y * _loc6_;
         _loc4_ = _loc17_;
         _loc11_ = _loc14_.m_xf.R;
         var _loc3_:* = Number(m_localAnchor2.x - _loc14_.m_sweep.localCenter.x);
         var _loc2_:Number = m_localAnchor2.y - _loc14_.m_sweep.localCenter.y;
         _loc17_ = _loc11_.col1.x * _loc3_ + _loc11_.col2.x * _loc2_;
         _loc2_ = _loc11_.col1.y * _loc3_ + _loc11_.col2.y * _loc2_;
         _loc3_ = _loc17_;
         var _loc8_:Number = _loc5_.m_linearVelocity.x + -_loc5_.m_angularVelocity * _loc6_;
         var _loc10_:Number = _loc5_.m_linearVelocity.y + _loc5_.m_angularVelocity * _loc4_;
         var _loc12_:Number = _loc14_.m_linearVelocity.x + -_loc14_.m_angularVelocity * _loc2_;
         var _loc13_:Number = _loc14_.m_linearVelocity.y + _loc14_.m_angularVelocity * _loc3_;
         var _loc9_:Number = m_u.x * (_loc12_ - _loc8_) + m_u.y * (_loc13_ - _loc10_);
         var _loc7_:Number = -m_mass * (_loc9_ + m_bias + m_gamma * m_impulse);
         m_impulse = m_impulse + _loc7_;
         var _loc15_:Number = _loc7_ * m_u.x;
         var _loc16_:Number = _loc7_ * m_u.y;
         _loc5_.m_linearVelocity.x = _loc5_.m_linearVelocity.x - _loc5_.m_invMass * _loc15_;
         _loc5_.m_linearVelocity.y = _loc5_.m_linearVelocity.y - _loc5_.m_invMass * _loc16_;
         _loc5_.m_angularVelocity = _loc5_.m_angularVelocity - _loc5_.m_invI * (_loc4_ * _loc16_ - _loc6_ * _loc15_);
         _loc14_.m_linearVelocity.x = _loc14_.m_linearVelocity.x + _loc14_.m_invMass * _loc15_;
         _loc14_.m_linearVelocity.y = _loc14_.m_linearVelocity.y + _loc14_.m_invMass * _loc16_;
         _loc14_.m_angularVelocity = _loc14_.m_angularVelocity + _loc14_.m_invI * (_loc3_ * _loc16_ - _loc2_ * _loc15_);
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc11_:* = null;
         if(m_frequencyHz > 0)
         {
            return true;
         }
         var _loc5_:b2Body = m_bodyA;
         var _loc13_:b2Body = m_bodyB;
         _loc11_ = _loc5_.m_xf.R;
         var _loc4_:* = Number(m_localAnchor1.x - _loc5_.m_sweep.localCenter.x);
         var _loc6_:Number = m_localAnchor1.y - _loc5_.m_sweep.localCenter.y;
         var _loc16_:Number = _loc11_.col1.x * _loc4_ + _loc11_.col2.x * _loc6_;
         _loc6_ = _loc11_.col1.y * _loc4_ + _loc11_.col2.y * _loc6_;
         _loc4_ = _loc16_;
         _loc11_ = _loc13_.m_xf.R;
         var _loc3_:* = Number(m_localAnchor2.x - _loc13_.m_sweep.localCenter.x);
         var _loc2_:Number = m_localAnchor2.y - _loc13_.m_sweep.localCenter.y;
         _loc16_ = _loc11_.col1.x * _loc3_ + _loc11_.col2.x * _loc2_;
         _loc2_ = _loc11_.col1.y * _loc3_ + _loc11_.col2.y * _loc2_;
         _loc3_ = _loc16_;
         var _loc9_:Number = _loc13_.m_sweep.c.x + _loc3_ - _loc5_.m_sweep.c.x - _loc4_;
         var _loc8_:Number = _loc13_.m_sweep.c.y + _loc2_ - _loc5_.m_sweep.c.y - _loc6_;
         var _loc12_:Number = Math.sqrt(_loc9_ * _loc9_ + _loc8_ * _loc8_);
         _loc9_ = _loc9_ / _loc12_;
         _loc8_ = _loc8_ / _loc12_;
         var _loc7_:Number = _loc12_ - m_length;
         _loc7_ = b2Math.Clamp(_loc7_,-0.2,0.2);
         var _loc10_:Number = -m_mass * _loc7_;
         m_u.Set(_loc9_,_loc8_);
         var _loc14_:Number = _loc10_ * m_u.x;
         var _loc15_:Number = _loc10_ * m_u.y;
         _loc5_.m_sweep.c.x = _loc5_.m_sweep.c.x - _loc5_.m_invMass * _loc14_;
         _loc5_.m_sweep.c.y = _loc5_.m_sweep.c.y - _loc5_.m_invMass * _loc15_;
         _loc5_.m_sweep.a = _loc5_.m_sweep.a - _loc5_.m_invI * (_loc4_ * _loc15_ - _loc6_ * _loc14_);
         _loc13_.m_sweep.c.x = _loc13_.m_sweep.c.x + _loc13_.m_invMass * _loc14_;
         _loc13_.m_sweep.c.y = _loc13_.m_sweep.c.y + _loc13_.m_invMass * _loc15_;
         _loc13_.m_sweep.a = _loc13_.m_sweep.a + _loc13_.m_invI * (_loc3_ * _loc15_ - _loc2_ * _loc14_);
         _loc5_.SynchronizeTransform();
         _loc13_.SynchronizeTransform();
         return b2Math.Abs(_loc7_) < 0.005;
      }
   }
}
