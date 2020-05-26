package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2MouseJoint extends b2Joint
   {
       
      
      private var K:b2Mat22;
      
      private var K1:b2Mat22;
      
      private var K2:b2Mat22;
      
      private var m_localAnchor:b2Vec2;
      
      private var m_target:b2Vec2;
      
      private var m_impulse:b2Vec2;
      
      private var m_mass:b2Mat22;
      
      private var m_C:b2Vec2;
      
      private var m_maxForce:Number;
      
      private var m_frequencyHz:Number;
      
      private var m_dampingRatio:Number;
      
      private var m_beta:Number;
      
      private var m_gamma:Number;
      
      public function b2MouseJoint(param1:b2MouseJointDef)
      {
         K = new b2Mat22();
         K1 = new b2Mat22();
         K2 = new b2Mat22();
         m_localAnchor = new b2Vec2();
         m_target = new b2Vec2();
         m_impulse = new b2Vec2();
         m_mass = new b2Mat22();
         m_C = new b2Vec2();
         super(param1);
         m_target.SetV(param1.target);
         var _loc3_:Number = m_target.x - m_bodyB.m_xf.position.x;
         var _loc4_:Number = m_target.y - m_bodyB.m_xf.position.y;
         var _loc2_:b2Mat22 = m_bodyB.m_xf.R;
         m_localAnchor.x = _loc3_ * _loc2_.col1.x + _loc4_ * _loc2_.col1.y;
         m_localAnchor.y = _loc3_ * _loc2_.col2.x + _loc4_ * _loc2_.col2.y;
         m_maxForce = param1.maxForce;
         m_impulse.SetZero();
         m_frequencyHz = param1.frequencyHz;
         m_dampingRatio = param1.dampingRatio;
         m_beta = 0;
         m_gamma = 0;
      }
      
      override public function GetAnchorA() : b2Vec2
      {
         return m_target;
      }
      
      override public function GetAnchorB() : b2Vec2
      {
         return m_bodyB.GetWorldPoint(m_localAnchor);
      }
      
      override public function GetReactionForce(param1:Number) : b2Vec2
      {
         return new b2Vec2(param1 * m_impulse.x,param1 * m_impulse.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return 0;
      }
      
      public function GetTarget() : b2Vec2
      {
         return m_target;
      }
      
      public function SetTarget(param1:b2Vec2) : void
      {
         if(m_bodyB.IsAwake() == false)
         {
            m_bodyB.SetAwake(true);
         }
         m_target = param1;
      }
      
      public function GetMaxForce() : Number
      {
         return m_maxForce;
      }
      
      public function SetMaxForce(param1:Number) : void
      {
         m_maxForce = param1;
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
         var _loc6_:* = null;
         var _loc5_:b2Body = m_bodyB;
         var _loc2_:Number = _loc5_.GetMass();
         var _loc11_:Number = 2 * 3.14159265358979 * m_frequencyHz;
         var _loc4_:Number = 2 * _loc2_ * m_dampingRatio * _loc11_;
         var _loc10_:Number = _loc2_ * _loc11_ * _loc11_;
         m_gamma = param1.dt * (_loc4_ + param1.dt * _loc10_);
         m_gamma = m_gamma != 0?1 / m_gamma:0;
         m_beta = param1.dt * _loc10_ * m_gamma;
         _loc6_ = _loc5_.m_xf.R;
         var _loc7_:* = Number(m_localAnchor.x - _loc5_.m_sweep.localCenter.x);
         var _loc8_:Number = m_localAnchor.y - _loc5_.m_sweep.localCenter.y;
         var _loc12_:Number = _loc6_.col1.x * _loc7_ + _loc6_.col2.x * _loc8_;
         _loc8_ = _loc6_.col1.y * _loc7_ + _loc6_.col2.y * _loc8_;
         _loc7_ = _loc12_;
         var _loc9_:Number = _loc5_.m_invMass;
         var _loc3_:Number = _loc5_.m_invI;
         K1.col1.x = _loc9_;
         K1.col2.x = 0;
         K1.col1.y = 0;
         K1.col2.y = _loc9_;
         K2.col1.x = _loc3_ * _loc8_ * _loc8_;
         K2.col2.x = -_loc3_ * _loc7_ * _loc8_;
         K2.col1.y = -_loc3_ * _loc7_ * _loc8_;
         K2.col2.y = _loc3_ * _loc7_ * _loc7_;
         K.SetM(K1);
         K.AddM(K2);
         K.col1.x = K.col1.x + m_gamma;
         K.col2.y = K.col2.y + m_gamma;
         K.GetInverse(m_mass);
         m_C.x = _loc5_.m_sweep.c.x + _loc7_ - m_target.x;
         m_C.y = _loc5_.m_sweep.c.y + _loc8_ - m_target.y;
         _loc5_.m_angularVelocity = _loc5_.m_angularVelocity * 0.98;
         m_impulse.x = m_impulse.x * param1.dtRatio;
         m_impulse.y = m_impulse.y * param1.dtRatio;
         _loc5_.m_linearVelocity.x = _loc5_.m_linearVelocity.x + _loc9_ * m_impulse.x;
         _loc5_.m_linearVelocity.y = _loc5_.m_linearVelocity.y + _loc9_ * m_impulse.y;
         _loc5_.m_angularVelocity = _loc5_.m_angularVelocity + _loc3_ * (_loc7_ * m_impulse.y - _loc8_ * m_impulse.x);
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc9_:* = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc2_:b2Body = m_bodyB;
         _loc9_ = _loc2_.m_xf.R;
         var _loc11_:* = Number(m_localAnchor.x - _loc2_.m_sweep.localCenter.x);
         var _loc12_:Number = m_localAnchor.y - _loc2_.m_sweep.localCenter.y;
         _loc13_ = _loc9_.col1.x * _loc11_ + _loc9_.col2.x * _loc12_;
         _loc12_ = _loc9_.col1.y * _loc11_ + _loc9_.col2.y * _loc12_;
         _loc11_ = _loc13_;
         var _loc3_:Number = _loc2_.m_linearVelocity.x + -_loc2_.m_angularVelocity * _loc12_;
         var _loc4_:Number = _loc2_.m_linearVelocity.y + _loc2_.m_angularVelocity * _loc11_;
         _loc9_ = m_mass;
         _loc13_ = _loc3_ + m_beta * m_C.x + m_gamma * m_impulse.x;
         _loc14_ = _loc4_ + m_beta * m_C.y + m_gamma * m_impulse.y;
         var _loc7_:Number = -(_loc9_.col1.x * _loc13_ + _loc9_.col2.x * _loc14_);
         var _loc10_:Number = -(_loc9_.col1.y * _loc13_ + _loc9_.col2.y * _loc14_);
         var _loc6_:Number = m_impulse.x;
         var _loc5_:Number = m_impulse.y;
         m_impulse.x = m_impulse.x + _loc7_;
         m_impulse.y = m_impulse.y + _loc10_;
         var _loc8_:Number = param1.dt * m_maxForce;
         if(m_impulse.LengthSquared() > _loc8_ * _loc8_)
         {
            m_impulse.Multiply(_loc8_ / m_impulse.Length());
         }
         _loc7_ = m_impulse.x - _loc6_;
         _loc10_ = m_impulse.y - _loc5_;
         _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x + _loc2_.m_invMass * _loc7_;
         _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y + _loc2_.m_invMass * _loc10_;
         _loc2_.m_angularVelocity = _loc2_.m_angularVelocity + _loc2_.m_invI * (_loc11_ * _loc10_ - _loc12_ * _loc7_);
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         return true;
      }
   }
}
