package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Mat33;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2Vec3;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2WeldJoint extends b2Joint
   {
       
      
      private var m_localAnchorA:b2Vec2;
      
      private var m_localAnchorB:b2Vec2;
      
      private var m_referenceAngle:Number;
      
      private var m_impulse:b2Vec3;
      
      private var m_mass:b2Mat33;
      
      public function b2WeldJoint(param1:b2WeldJointDef)
      {
         m_localAnchorA = new b2Vec2();
         m_localAnchorB = new b2Vec2();
         m_impulse = new b2Vec3();
         m_mass = new b2Mat33();
         super(param1);
         m_localAnchorA.SetV(param1.localAnchorA);
         m_localAnchorB.SetV(param1.localAnchorB);
         m_referenceAngle = param1.referenceAngle;
         m_impulse.SetZero();
         m_mass = new b2Mat33();
      }
      
      override public function GetAnchorA() : b2Vec2
      {
         return m_bodyA.GetWorldPoint(m_localAnchorA);
      }
      
      override public function GetAnchorB() : b2Vec2
      {
         return m_bodyB.GetWorldPoint(m_localAnchorB);
      }
      
      override public function GetReactionForce(param1:Number) : b2Vec2
      {
         return new b2Vec2(param1 * m_impulse.x,param1 * m_impulse.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return param1 * m_impulse.z;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc5_:* = null;
         var _loc11_:Number = NaN;
         var _loc2_:b2Body = m_bodyA;
         var _loc9_:b2Body = m_bodyB;
         _loc5_ = _loc2_.m_xf.R;
         var _loc7_:* = Number(m_localAnchorA.x - _loc2_.m_sweep.localCenter.x);
         var _loc10_:Number = m_localAnchorA.y - _loc2_.m_sweep.localCenter.y;
         _loc11_ = _loc5_.col1.x * _loc7_ + _loc5_.col2.x * _loc10_;
         _loc10_ = _loc5_.col1.y * _loc7_ + _loc5_.col2.y * _loc10_;
         _loc7_ = _loc11_;
         _loc5_ = _loc9_.m_xf.R;
         var _loc12_:* = Number(m_localAnchorB.x - _loc9_.m_sweep.localCenter.x);
         var _loc13_:Number = m_localAnchorB.y - _loc9_.m_sweep.localCenter.y;
         _loc11_ = _loc5_.col1.x * _loc12_ + _loc5_.col2.x * _loc13_;
         _loc13_ = _loc5_.col1.y * _loc12_ + _loc5_.col2.y * _loc13_;
         _loc12_ = _loc11_;
         var _loc8_:Number = _loc2_.m_invMass;
         var _loc6_:Number = _loc9_.m_invMass;
         var _loc3_:Number = _loc2_.m_invI;
         var _loc4_:Number = _loc9_.m_invI;
         m_mass.col1.x = _loc8_ + _loc6_ + _loc10_ * _loc10_ * _loc3_ + _loc13_ * _loc13_ * _loc4_;
         m_mass.col2.x = -_loc10_ * _loc7_ * _loc3_ - _loc13_ * _loc12_ * _loc4_;
         m_mass.col3.x = -_loc10_ * _loc3_ - _loc13_ * _loc4_;
         m_mass.col1.y = m_mass.col2.x;
         m_mass.col2.y = _loc8_ + _loc6_ + _loc7_ * _loc7_ * _loc3_ + _loc12_ * _loc12_ * _loc4_;
         m_mass.col3.y = _loc7_ * _loc3_ + _loc12_ * _loc4_;
         m_mass.col1.z = m_mass.col3.x;
         m_mass.col2.z = m_mass.col3.y;
         m_mass.col3.z = _loc3_ + _loc4_;
         if(param1.warmStarting)
         {
            m_impulse.x = m_impulse.x * param1.dtRatio;
            m_impulse.y = m_impulse.y * param1.dtRatio;
            m_impulse.z = m_impulse.z * param1.dtRatio;
            _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x - _loc8_ * m_impulse.x;
            _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y - _loc8_ * m_impulse.y;
            _loc2_.m_angularVelocity = _loc2_.m_angularVelocity - _loc3_ * (_loc7_ * m_impulse.y - _loc10_ * m_impulse.x + m_impulse.z);
            _loc9_.m_linearVelocity.x = _loc9_.m_linearVelocity.x + _loc6_ * m_impulse.x;
            _loc9_.m_linearVelocity.y = _loc9_.m_linearVelocity.y + _loc6_ * m_impulse.y;
            _loc9_.m_angularVelocity = _loc9_.m_angularVelocity + _loc4_ * (_loc12_ * m_impulse.y - _loc13_ * m_impulse.x + m_impulse.z);
         }
         else
         {
            m_impulse.SetZero();
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc8_:* = null;
         var _loc19_:Number = NaN;
         var _loc4_:b2Body = m_bodyA;
         var _loc14_:b2Body = m_bodyB;
         var _loc20_:b2Vec2 = _loc4_.m_linearVelocity;
         var _loc17_:Number = _loc4_.m_angularVelocity;
         var _loc11_:b2Vec2 = _loc14_.m_linearVelocity;
         var _loc16_:Number = _loc14_.m_angularVelocity;
         var _loc12_:Number = _loc4_.m_invMass;
         var _loc9_:Number = _loc14_.m_invMass;
         var _loc5_:Number = _loc4_.m_invI;
         var _loc7_:Number = _loc14_.m_invI;
         _loc8_ = _loc4_.m_xf.R;
         var _loc10_:* = Number(m_localAnchorA.x - _loc4_.m_sweep.localCenter.x);
         var _loc13_:Number = m_localAnchorA.y - _loc4_.m_sweep.localCenter.y;
         _loc19_ = _loc8_.col1.x * _loc10_ + _loc8_.col2.x * _loc13_;
         _loc13_ = _loc8_.col1.y * _loc10_ + _loc8_.col2.y * _loc13_;
         _loc10_ = _loc19_;
         _loc8_ = _loc14_.m_xf.R;
         var _loc18_:* = Number(m_localAnchorB.x - _loc14_.m_sweep.localCenter.x);
         var _loc21_:Number = m_localAnchorB.y - _loc14_.m_sweep.localCenter.y;
         _loc19_ = _loc8_.col1.x * _loc18_ + _loc8_.col2.x * _loc21_;
         _loc21_ = _loc8_.col1.y * _loc18_ + _loc8_.col2.y * _loc21_;
         _loc18_ = _loc19_;
         var _loc3_:Number = _loc11_.x - _loc16_ * _loc21_ - _loc20_.x + _loc17_ * _loc13_;
         var _loc2_:Number = _loc11_.y + _loc16_ * _loc18_ - _loc20_.y - _loc17_ * _loc10_;
         var _loc15_:Number = _loc16_ - _loc17_;
         var _loc6_:b2Vec3 = new b2Vec3();
         m_mass.Solve33(_loc6_,-_loc3_,-_loc2_,-_loc15_);
         m_impulse.Add(_loc6_);
         _loc20_.x = _loc20_.x - _loc12_ * _loc6_.x;
         _loc20_.y = _loc20_.y - _loc12_ * _loc6_.y;
         _loc17_ = _loc17_ - _loc5_ * (_loc10_ * _loc6_.y - _loc13_ * _loc6_.x + _loc6_.z);
         _loc11_.x = _loc11_.x + _loc9_ * _loc6_.x;
         _loc11_.y = _loc11_.y + _loc9_ * _loc6_.y;
         _loc16_ = _loc16_ + _loc7_ * (_loc18_ * _loc6_.y - _loc21_ * _loc6_.x + _loc6_.z);
         _loc4_.m_angularVelocity = _loc17_;
         _loc14_.m_angularVelocity = _loc16_;
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc11_:* = null;
         var _loc18_:Number = NaN;
         var _loc5_:b2Body = m_bodyA;
         var _loc15_:b2Body = m_bodyB;
         _loc11_ = _loc5_.m_xf.R;
         var _loc13_:* = Number(m_localAnchorA.x - _loc5_.m_sweep.localCenter.x);
         var _loc16_:Number = m_localAnchorA.y - _loc5_.m_sweep.localCenter.y;
         _loc18_ = _loc11_.col1.x * _loc13_ + _loc11_.col2.x * _loc16_;
         _loc16_ = _loc11_.col1.y * _loc13_ + _loc11_.col2.y * _loc16_;
         _loc13_ = _loc18_;
         _loc11_ = _loc15_.m_xf.R;
         var _loc19_:* = Number(m_localAnchorB.x - _loc15_.m_sweep.localCenter.x);
         var _loc20_:Number = m_localAnchorB.y - _loc15_.m_sweep.localCenter.y;
         _loc18_ = _loc11_.col1.x * _loc19_ + _loc11_.col2.x * _loc20_;
         _loc20_ = _loc11_.col1.y * _loc19_ + _loc11_.col2.y * _loc20_;
         _loc19_ = _loc18_;
         var _loc14_:Number = _loc5_.m_invMass;
         var _loc12_:Number = _loc15_.m_invMass;
         var _loc7_:Number = _loc5_.m_invI;
         var _loc9_:Number = _loc15_.m_invI;
         var _loc2_:Number = _loc15_.m_sweep.c.x + _loc19_ - _loc5_.m_sweep.c.x - _loc13_;
         var _loc3_:Number = _loc15_.m_sweep.c.y + _loc20_ - _loc5_.m_sweep.c.y - _loc16_;
         var _loc17_:Number = _loc15_.m_sweep.a - _loc5_.m_sweep.a - m_referenceAngle;
         var _loc4_:* = 0.05;
         var _loc10_:Number = Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
         var _loc6_:Number = b2Math.Abs(_loc17_);
         if(_loc10_ > _loc4_)
         {
            _loc7_ = _loc7_ * 1;
            _loc9_ = _loc9_ * 1;
         }
         m_mass.col1.x = _loc14_ + _loc12_ + _loc16_ * _loc16_ * _loc7_ + _loc20_ * _loc20_ * _loc9_;
         m_mass.col2.x = -_loc16_ * _loc13_ * _loc7_ - _loc20_ * _loc19_ * _loc9_;
         m_mass.col3.x = -_loc16_ * _loc7_ - _loc20_ * _loc9_;
         m_mass.col1.y = m_mass.col2.x;
         m_mass.col2.y = _loc14_ + _loc12_ + _loc13_ * _loc13_ * _loc7_ + _loc19_ * _loc19_ * _loc9_;
         m_mass.col3.y = _loc13_ * _loc7_ + _loc19_ * _loc9_;
         m_mass.col1.z = m_mass.col3.x;
         m_mass.col2.z = m_mass.col3.y;
         m_mass.col3.z = _loc7_ + _loc9_;
         var _loc8_:b2Vec3 = new b2Vec3();
         m_mass.Solve33(_loc8_,-_loc2_,-_loc3_,-_loc17_);
         _loc5_.m_sweep.c.x = _loc5_.m_sweep.c.x - _loc14_ * _loc8_.x;
         _loc5_.m_sweep.c.y = _loc5_.m_sweep.c.y - _loc14_ * _loc8_.y;
         _loc5_.m_sweep.a = _loc5_.m_sweep.a - _loc7_ * (_loc13_ * _loc8_.y - _loc16_ * _loc8_.x + _loc8_.z);
         _loc15_.m_sweep.c.x = _loc15_.m_sweep.c.x + _loc12_ * _loc8_.x;
         _loc15_.m_sweep.c.y = _loc15_.m_sweep.c.y + _loc12_ * _loc8_.y;
         _loc15_.m_sweep.a = _loc15_.m_sweep.a + _loc9_ * (_loc19_ * _loc8_.y - _loc20_ * _loc8_.x + _loc8_.z);
         _loc5_.SynchronizeTransform();
         _loc15_.SynchronizeTransform();
         return _loc10_ <= 0.005 && _loc6_ <= 0.0349065850398866;
      }
   }
}
