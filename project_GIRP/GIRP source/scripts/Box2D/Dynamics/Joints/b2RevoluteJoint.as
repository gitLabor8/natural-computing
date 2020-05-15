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
   
   public class b2RevoluteJoint extends b2Joint
   {
      
      private static var tImpulse:b2Vec2 = new b2Vec2();
       
      
      private var K:b2Mat22;
      
      private var K1:b2Mat22;
      
      private var K2:b2Mat22;
      
      private var K3:b2Mat22;
      
      private var impulse3:b2Vec3;
      
      private var impulse2:b2Vec2;
      
      private var reduced:b2Vec2;
      
      b2internal var m_localAnchor1:b2Vec2;
      
      b2internal var m_localAnchor2:b2Vec2;
      
      private var m_impulse:b2Vec3;
      
      private var m_motorImpulse:Number;
      
      private var m_mass:b2Mat33;
      
      private var m_motorMass:Number;
      
      private var m_enableMotor:Boolean;
      
      private var m_maxMotorTorque:Number;
      
      private var m_motorSpeed:Number;
      
      private var m_enableLimit:Boolean;
      
      private var m_referenceAngle:Number;
      
      private var m_lowerAngle:Number;
      
      private var m_upperAngle:Number;
      
      private var m_limitState:int;
      
      public function b2RevoluteJoint(param1:b2RevoluteJointDef)
      {
         K = new b2Mat22();
         K1 = new b2Mat22();
         K2 = new b2Mat22();
         K3 = new b2Mat22();
         impulse3 = new b2Vec3();
         impulse2 = new b2Vec2();
         reduced = new b2Vec2();
         m_localAnchor1 = new b2Vec2();
         m_localAnchor2 = new b2Vec2();
         m_impulse = new b2Vec3();
         m_mass = new b2Mat33();
         super(param1);
         m_localAnchor1.SetV(param1.localAnchorA);
         m_localAnchor2.SetV(param1.localAnchorB);
         m_referenceAngle = param1.referenceAngle;
         m_impulse.SetZero();
         m_motorImpulse = 0;
         m_lowerAngle = param1.lowerAngle;
         m_upperAngle = param1.upperAngle;
         m_maxMotorTorque = param1.maxMotorTorque;
         m_motorSpeed = param1.motorSpeed;
         m_enableLimit = param1.enableLimit;
         m_enableMotor = param1.enableMotor;
         m_limitState = 0;
      }
      
      override public function GetAnchorA() : b2Vec2
      {
         return m_bodyA.GetWorldPoint(m_localAnchor1);
      }
      
      override public function GetAnchorB() : b2Vec2
      {
         return m_bodyB.GetWorldPoint(m_localAnchor2);
      }
      
      public function GetReferenceAngle() : Number
      {
         return m_referenceAngle;
      }
      
      override public function GetReactionForce(param1:Number) : b2Vec2
      {
         return new b2Vec2(param1 * m_impulse.x,param1 * m_impulse.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return param1 * m_impulse.z;
      }
      
      public function GetJointAngle() : Number
      {
         return m_bodyB.m_sweep.a - m_bodyA.m_sweep.a - m_referenceAngle;
      }
      
      public function GetJointSpeed() : Number
      {
         return m_bodyB.m_angularVelocity - m_bodyA.m_angularVelocity;
      }
      
      public function IsLimitEnabled() : Boolean
      {
         return m_enableLimit;
      }
      
      public function EnableLimit(param1:Boolean) : void
      {
         m_enableLimit = param1;
      }
      
      public function GetLowerLimit() : Number
      {
         return m_lowerAngle;
      }
      
      public function GetUpperLimit() : Number
      {
         return m_upperAngle;
      }
      
      public function SetLimits(param1:Number, param2:Number) : void
      {
         m_lowerAngle = param1;
         m_upperAngle = param2;
      }
      
      public function IsMotorEnabled() : Boolean
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
         return m_enableMotor;
      }
      
      public function EnableMotor(param1:Boolean) : void
      {
         m_enableMotor = param1;
      }
      
      public function SetMotorSpeed(param1:Number) : void
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
         m_motorSpeed = param1;
      }
      
      public function GetMotorSpeed() : Number
      {
         return m_motorSpeed;
      }
      
      public function SetMaxMotorTorque(param1:Number) : void
      {
         m_maxMotorTorque = param1;
      }
      
      public function GetMotorTorque() : Number
      {
         return m_maxMotorTorque;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc10_:* = null;
         var _loc14_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc5_:b2Body = m_bodyA;
         var _loc11_:b2Body = m_bodyB;
         if(m_enableMotor || m_enableLimit)
         {
         }
         _loc10_ = _loc5_.m_xf.R;
         var _loc4_:* = Number(m_localAnchor1.x - _loc5_.m_sweep.localCenter.x);
         var _loc6_:Number = m_localAnchor1.y - _loc5_.m_sweep.localCenter.y;
         _loc14_ = _loc10_.col1.x * _loc4_ + _loc10_.col2.x * _loc6_;
         _loc6_ = _loc10_.col1.y * _loc4_ + _loc10_.col2.y * _loc6_;
         _loc4_ = _loc14_;
         _loc10_ = _loc11_.m_xf.R;
         var _loc3_:* = Number(m_localAnchor2.x - _loc11_.m_sweep.localCenter.x);
         var _loc2_:Number = m_localAnchor2.y - _loc11_.m_sweep.localCenter.y;
         _loc14_ = _loc10_.col1.x * _loc3_ + _loc10_.col2.x * _loc2_;
         _loc2_ = _loc10_.col1.y * _loc3_ + _loc10_.col2.y * _loc2_;
         _loc3_ = _loc14_;
         var _loc7_:Number = _loc5_.m_invMass;
         var _loc8_:Number = _loc11_.m_invMass;
         var _loc16_:Number = _loc5_.m_invI;
         var _loc15_:Number = _loc11_.m_invI;
         m_mass.col1.x = _loc7_ + _loc8_ + _loc6_ * _loc6_ * _loc16_ + _loc2_ * _loc2_ * _loc15_;
         m_mass.col2.x = -_loc6_ * _loc4_ * _loc16_ - _loc2_ * _loc3_ * _loc15_;
         m_mass.col3.x = -_loc6_ * _loc16_ - _loc2_ * _loc15_;
         m_mass.col1.y = m_mass.col2.x;
         m_mass.col2.y = _loc7_ + _loc8_ + _loc4_ * _loc4_ * _loc16_ + _loc3_ * _loc3_ * _loc15_;
         m_mass.col3.y = _loc4_ * _loc16_ + _loc3_ * _loc15_;
         m_mass.col1.z = m_mass.col3.x;
         m_mass.col2.z = m_mass.col3.y;
         m_mass.col3.z = _loc16_ + _loc15_;
         m_motorMass = 1 / (_loc16_ + _loc15_);
         if(m_enableMotor == false)
         {
            m_motorImpulse = 0;
         }
         if(m_enableLimit)
         {
            _loc9_ = _loc11_.m_sweep.a - _loc5_.m_sweep.a - m_referenceAngle;
            if(b2Math.Abs(m_upperAngle - m_lowerAngle) < 2 * 0.0349065850398866)
            {
               m_limitState = 3;
            }
            else if(_loc9_ <= m_lowerAngle)
            {
               if(m_limitState != 1)
               {
                  m_impulse.z = 0;
               }
               m_limitState = 1;
            }
            else if(_loc9_ >= m_upperAngle)
            {
               if(m_limitState != 2)
               {
                  m_impulse.z = 0;
               }
               m_limitState = 2;
            }
            else
            {
               m_limitState = 0;
               m_impulse.z = 0;
            }
         }
         else
         {
            m_limitState = 0;
         }
         if(param1.warmStarting)
         {
            m_impulse.x = m_impulse.x * param1.dtRatio;
            m_impulse.y = m_impulse.y * param1.dtRatio;
            m_motorImpulse = m_motorImpulse * param1.dtRatio;
            _loc12_ = m_impulse.x;
            _loc13_ = m_impulse.y;
            _loc5_.m_linearVelocity.x = _loc5_.m_linearVelocity.x - _loc7_ * _loc12_;
            _loc5_.m_linearVelocity.y = _loc5_.m_linearVelocity.y - _loc7_ * _loc13_;
            _loc5_.m_angularVelocity = _loc5_.m_angularVelocity - _loc16_ * (_loc4_ * _loc13_ - _loc6_ * _loc12_ + m_motorImpulse + m_impulse.z);
            _loc11_.m_linearVelocity.x = _loc11_.m_linearVelocity.x + _loc8_ * _loc12_;
            _loc11_.m_linearVelocity.y = _loc11_.m_linearVelocity.y + _loc8_ * _loc13_;
            _loc11_.m_angularVelocity = _loc11_.m_angularVelocity + _loc15_ * (_loc3_ * _loc13_ - _loc2_ * _loc12_ + m_motorImpulse + m_impulse.z);
         }
         else
         {
            m_impulse.SetZero();
            m_motorImpulse = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc23_:* = null;
         var _loc13_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc14_:* = NaN;
         var _loc17_:Number = NaN;
         var _loc6_:* = NaN;
         var _loc4_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc7_:b2Body = m_bodyA;
         var _loc25_:b2Body = m_bodyB;
         var _loc2_:b2Vec2 = _loc7_.m_linearVelocity;
         var _loc20_:Number = _loc7_.m_angularVelocity;
         var _loc8_:b2Vec2 = _loc25_.m_linearVelocity;
         var _loc21_:Number = _loc25_.m_angularVelocity;
         var _loc18_:Number = _loc7_.m_invMass;
         var _loc19_:Number = _loc25_.m_invMass;
         var _loc27_:Number = _loc7_.m_invI;
         var _loc26_:Number = _loc25_.m_invI;
         if(m_enableMotor && m_limitState != 3)
         {
            _loc10_ = _loc21_ - _loc20_ - m_motorSpeed;
            _loc9_ = m_motorMass * -_loc10_;
            _loc24_ = m_motorImpulse;
            _loc11_ = param1.dt * m_maxMotorTorque;
            m_motorImpulse = b2Math.Clamp(m_motorImpulse + _loc9_,-_loc11_,_loc11_);
            _loc9_ = m_motorImpulse - _loc24_;
            _loc20_ = _loc20_ - _loc27_ * _loc9_;
            _loc21_ = _loc21_ + _loc26_ * _loc9_;
         }
         if(m_enableLimit && m_limitState != 0)
         {
            _loc23_ = _loc7_.m_xf.R;
            _loc14_ = Number(m_localAnchor1.x - _loc7_.m_sweep.localCenter.x);
            _loc17_ = m_localAnchor1.y - _loc7_.m_sweep.localCenter.y;
            _loc13_ = _loc23_.col1.x * _loc14_ + _loc23_.col2.x * _loc17_;
            _loc17_ = _loc23_.col1.y * _loc14_ + _loc23_.col2.y * _loc17_;
            _loc14_ = _loc13_;
            _loc23_ = _loc25_.m_xf.R;
            _loc6_ = Number(m_localAnchor2.x - _loc25_.m_sweep.localCenter.x);
            _loc4_ = m_localAnchor2.y - _loc25_.m_sweep.localCenter.y;
            _loc13_ = _loc23_.col1.x * _loc6_ + _loc23_.col2.x * _loc4_;
            _loc4_ = _loc23_.col1.y * _loc6_ + _loc23_.col2.y * _loc4_;
            _loc6_ = _loc13_;
            _loc5_ = _loc8_.x + -_loc21_ * _loc4_ - _loc2_.x - -_loc20_ * _loc17_;
            _loc3_ = _loc8_.y + _loc21_ * _loc6_ - _loc2_.y - _loc20_ * _loc14_;
            _loc12_ = _loc21_ - _loc20_;
            m_mass.Solve33(impulse3,-_loc5_,-_loc3_,-_loc12_);
            if(m_limitState == 3)
            {
               m_impulse.Add(impulse3);
            }
            else if(m_limitState == 1)
            {
               _loc22_ = m_impulse.z + impulse3.z;
               if(_loc22_ < 0)
               {
                  m_mass.Solve22(reduced,-_loc5_,-_loc3_);
                  impulse3.x = reduced.x;
                  impulse3.y = reduced.y;
                  impulse3.z = -m_impulse.z;
                  m_impulse.x = m_impulse.x + reduced.x;
                  m_impulse.y = m_impulse.y + reduced.y;
                  m_impulse.z = 0;
               }
            }
            else if(m_limitState == 2)
            {
               _loc22_ = m_impulse.z + impulse3.z;
               if(_loc22_ > 0)
               {
                  m_mass.Solve22(reduced,-_loc5_,-_loc3_);
                  impulse3.x = reduced.x;
                  impulse3.y = reduced.y;
                  impulse3.z = -m_impulse.z;
                  m_impulse.x = m_impulse.x + reduced.x;
                  m_impulse.y = m_impulse.y + reduced.y;
                  m_impulse.z = 0;
               }
            }
            _loc2_.x = _loc2_.x - _loc18_ * impulse3.x;
            _loc2_.y = _loc2_.y - _loc18_ * impulse3.y;
            _loc20_ = _loc20_ - _loc27_ * (_loc14_ * impulse3.y - _loc17_ * impulse3.x + impulse3.z);
            _loc8_.x = _loc8_.x + _loc19_ * impulse3.x;
            _loc8_.y = _loc8_.y + _loc19_ * impulse3.y;
            _loc21_ = _loc21_ + _loc26_ * (_loc6_ * impulse3.y - _loc4_ * impulse3.x + impulse3.z);
         }
         else
         {
            _loc23_ = _loc7_.m_xf.R;
            _loc14_ = Number(m_localAnchor1.x - _loc7_.m_sweep.localCenter.x);
            _loc17_ = m_localAnchor1.y - _loc7_.m_sweep.localCenter.y;
            _loc13_ = _loc23_.col1.x * _loc14_ + _loc23_.col2.x * _loc17_;
            _loc17_ = _loc23_.col1.y * _loc14_ + _loc23_.col2.y * _loc17_;
            _loc14_ = _loc13_;
            _loc23_ = _loc25_.m_xf.R;
            _loc6_ = Number(m_localAnchor2.x - _loc25_.m_sweep.localCenter.x);
            _loc4_ = m_localAnchor2.y - _loc25_.m_sweep.localCenter.y;
            _loc13_ = _loc23_.col1.x * _loc6_ + _loc23_.col2.x * _loc4_;
            _loc4_ = _loc23_.col1.y * _loc6_ + _loc23_.col2.y * _loc4_;
            _loc6_ = _loc13_;
            _loc15_ = _loc8_.x + -_loc21_ * _loc4_ - _loc2_.x - -_loc20_ * _loc17_;
            _loc16_ = _loc8_.y + _loc21_ * _loc6_ - _loc2_.y - _loc20_ * _loc14_;
            m_mass.Solve22(impulse2,-_loc15_,-_loc16_);
            m_impulse.x = m_impulse.x + impulse2.x;
            m_impulse.y = m_impulse.y + impulse2.y;
            _loc2_.x = _loc2_.x - _loc18_ * impulse2.x;
            _loc2_.y = _loc2_.y - _loc18_ * impulse2.y;
            _loc20_ = _loc20_ - _loc27_ * (_loc14_ * impulse2.y - _loc17_ * impulse2.x);
            _loc8_.x = _loc8_.x + _loc19_ * impulse2.x;
            _loc8_.y = _loc8_.y + _loc19_ * impulse2.y;
            _loc21_ = _loc21_ + _loc26_ * (_loc6_ * impulse2.y - _loc4_ * impulse2.x);
         }
         _loc7_.m_linearVelocity.SetV(_loc2_);
         _loc7_.m_angularVelocity = _loc20_;
         _loc25_.m_linearVelocity.SetV(_loc8_);
         _loc25_.m_angularVelocity = _loc21_;
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc27_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc30_:* = null;
         var _loc16_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc10_:* = NaN;
         var _loc20_:* = NaN;
         _loc20_ = 0.05;
         var _loc29_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc7_:* = NaN;
         _loc7_ = 0.5;
         var _loc8_:b2Body = m_bodyA;
         var _loc31_:b2Body = m_bodyB;
         var _loc22_:* = 0;
         var _loc14_:* = 0;
         if(m_enableLimit && m_limitState != 0)
         {
            _loc26_ = _loc31_.m_sweep.a - _loc8_.m_sweep.a - m_referenceAngle;
            _loc10_ = 0;
            if(m_limitState == 3)
            {
               _loc9_ = b2Math.Clamp(_loc26_ - m_lowerAngle,-0.139626340159546,0.139626340159546);
               _loc10_ = Number(-m_motorMass * _loc9_);
               _loc22_ = Number(b2Math.Abs(_loc9_));
            }
            else if(m_limitState == 1)
            {
               _loc9_ = _loc26_ - m_lowerAngle;
               _loc22_ = Number(-_loc9_);
               _loc9_ = b2Math.Clamp(_loc9_ + 0.0349065850398866,-0.139626340159546,0);
               _loc10_ = Number(-m_motorMass * _loc9_);
            }
            else if(m_limitState == 2)
            {
               _loc9_ = _loc26_ - m_upperAngle;
               _loc22_ = _loc9_;
               _loc9_ = b2Math.Clamp(_loc9_ - 0.0349065850398866,0,0.139626340159546);
               _loc10_ = Number(-m_motorMass * _loc9_);
            }
            _loc8_.m_sweep.a = _loc8_.m_sweep.a - _loc8_.m_invI * _loc10_;
            _loc31_.m_sweep.a = _loc31_.m_sweep.a + _loc31_.m_invI * _loc10_;
            _loc8_.SynchronizeTransform();
            _loc31_.SynchronizeTransform();
         }
         _loc30_ = _loc8_.m_xf.R;
         var _loc19_:* = Number(m_localAnchor1.x - _loc8_.m_sweep.localCenter.x);
         var _loc21_:Number = m_localAnchor1.y - _loc8_.m_sweep.localCenter.y;
         _loc16_ = _loc30_.col1.x * _loc19_ + _loc30_.col2.x * _loc21_;
         _loc21_ = _loc30_.col1.y * _loc19_ + _loc30_.col2.y * _loc21_;
         _loc19_ = _loc16_;
         _loc30_ = _loc31_.m_xf.R;
         var _loc5_:* = Number(m_localAnchor2.x - _loc31_.m_sweep.localCenter.x);
         var _loc3_:Number = m_localAnchor2.y - _loc31_.m_sweep.localCenter.y;
         _loc16_ = _loc30_.col1.x * _loc5_ + _loc30_.col2.x * _loc3_;
         _loc3_ = _loc30_.col1.y * _loc5_ + _loc30_.col2.y * _loc3_;
         _loc5_ = _loc16_;
         var _loc18_:Number = _loc31_.m_sweep.c.x + _loc5_ - _loc8_.m_sweep.c.x - _loc19_;
         var _loc17_:Number = _loc31_.m_sweep.c.y + _loc3_ - _loc8_.m_sweep.c.y - _loc21_;
         var _loc2_:Number = _loc18_ * _loc18_ + _loc17_ * _loc17_;
         var _loc24_:Number = Math.sqrt(_loc2_);
         _loc14_ = _loc24_;
         var _loc6_:Number = _loc8_.m_invMass;
         var _loc4_:Number = _loc31_.m_invMass;
         var _loc12_:Number = _loc8_.m_invI;
         var _loc11_:Number = _loc31_.m_invI;
         if(_loc2_ > 0.05 * 0.05)
         {
            _loc29_ = _loc18_ / _loc24_;
            _loc28_ = _loc17_ / _loc24_;
            _loc25_ = _loc6_ + _loc4_;
            _loc23_ = 1 / _loc25_;
            _loc13_ = _loc23_ * -_loc18_;
            _loc15_ = _loc23_ * -_loc17_;
            _loc8_.m_sweep.c.x = _loc8_.m_sweep.c.x - _loc7_ * _loc6_ * _loc13_;
            _loc8_.m_sweep.c.y = _loc8_.m_sweep.c.y - _loc7_ * _loc6_ * _loc15_;
            _loc31_.m_sweep.c.x = _loc31_.m_sweep.c.x + _loc7_ * _loc4_ * _loc13_;
            _loc31_.m_sweep.c.y = _loc31_.m_sweep.c.y + _loc7_ * _loc4_ * _loc15_;
            _loc18_ = _loc31_.m_sweep.c.x + _loc5_ - _loc8_.m_sweep.c.x - _loc19_;
            _loc17_ = _loc31_.m_sweep.c.y + _loc3_ - _loc8_.m_sweep.c.y - _loc21_;
         }
         K1.col1.x = _loc6_ + _loc4_;
         K1.col2.x = 0;
         K1.col1.y = 0;
         K1.col2.y = _loc6_ + _loc4_;
         K2.col1.x = _loc12_ * _loc21_ * _loc21_;
         K2.col2.x = -_loc12_ * _loc19_ * _loc21_;
         K2.col1.y = -_loc12_ * _loc19_ * _loc21_;
         K2.col2.y = _loc12_ * _loc19_ * _loc19_;
         K3.col1.x = _loc11_ * _loc3_ * _loc3_;
         K3.col2.x = -_loc11_ * _loc5_ * _loc3_;
         K3.col1.y = -_loc11_ * _loc5_ * _loc3_;
         K3.col2.y = _loc11_ * _loc5_ * _loc5_;
         K.SetM(K1);
         K.AddM(K2);
         K.AddM(K3);
         K.Solve(tImpulse,-_loc18_,-_loc17_);
         _loc13_ = tImpulse.x;
         _loc15_ = tImpulse.y;
         _loc8_.m_sweep.c.x = _loc8_.m_sweep.c.x - _loc8_.m_invMass * _loc13_;
         _loc8_.m_sweep.c.y = _loc8_.m_sweep.c.y - _loc8_.m_invMass * _loc15_;
         _loc8_.m_sweep.a = _loc8_.m_sweep.a - _loc8_.m_invI * (_loc19_ * _loc15_ - _loc21_ * _loc13_);
         _loc31_.m_sweep.c.x = _loc31_.m_sweep.c.x + _loc31_.m_invMass * _loc13_;
         _loc31_.m_sweep.c.y = _loc31_.m_sweep.c.y + _loc31_.m_invMass * _loc15_;
         _loc31_.m_sweep.a = _loc31_.m_sweep.a + _loc31_.m_invI * (_loc5_ * _loc15_ - _loc3_ * _loc13_);
         _loc8_.SynchronizeTransform();
         _loc31_.SynchronizeTransform();
         return _loc14_ <= 0.005 && _loc22_ <= 0.0349065850398866;
      }
   }
}
