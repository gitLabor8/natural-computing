package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Mat33;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2Vec3;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2PrismaticJoint extends b2Joint
   {
       
      
      b2internal var m_localAnchor1:b2Vec2;
      
      b2internal var m_localAnchor2:b2Vec2;
      
      b2internal var m_localXAxis1:b2Vec2;
      
      private var m_localYAxis1:b2Vec2;
      
      private var m_refAngle:Number;
      
      private var m_axis:b2Vec2;
      
      private var m_perp:b2Vec2;
      
      private var m_s1:Number;
      
      private var m_s2:Number;
      
      private var m_a1:Number;
      
      private var m_a2:Number;
      
      private var m_K:b2Mat33;
      
      private var m_impulse:b2Vec3;
      
      private var m_motorMass:Number;
      
      private var m_motorImpulse:Number;
      
      private var m_lowerTranslation:Number;
      
      private var m_upperTranslation:Number;
      
      private var m_maxMotorForce:Number;
      
      private var m_motorSpeed:Number;
      
      private var m_enableLimit:Boolean;
      
      private var m_enableMotor:Boolean;
      
      private var m_limitState:int;
      
      public function b2PrismaticJoint(param1:b2PrismaticJointDef)
      {
         var _loc2_:* = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         m_localAnchor1 = new b2Vec2();
         m_localAnchor2 = new b2Vec2();
         m_localXAxis1 = new b2Vec2();
         m_localYAxis1 = new b2Vec2();
         m_axis = new b2Vec2();
         m_perp = new b2Vec2();
         m_K = new b2Mat33();
         m_impulse = new b2Vec3();
         super(param1);
         m_localAnchor1.SetV(param1.localAnchorA);
         m_localAnchor2.SetV(param1.localAnchorB);
         m_localXAxis1.SetV(param1.localAxisA);
         m_localYAxis1.x = -m_localXAxis1.y;
         m_localYAxis1.y = m_localXAxis1.x;
         m_refAngle = param1.referenceAngle;
         m_impulse.SetZero();
         m_motorMass = 0;
         m_motorImpulse = 0;
         m_lowerTranslation = param1.lowerTranslation;
         m_upperTranslation = param1.upperTranslation;
         m_maxMotorForce = param1.maxMotorForce;
         m_motorSpeed = param1.motorSpeed;
         m_enableLimit = param1.enableLimit;
         m_enableMotor = param1.enableMotor;
         m_limitState = 0;
         m_axis.SetZero();
         m_perp.SetZero();
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
         return new b2Vec2(param1 * (m_impulse.x * m_perp.x + (m_motorImpulse + m_impulse.z) * m_axis.x),param1 * (m_impulse.x * m_perp.y + (m_motorImpulse + m_impulse.z) * m_axis.y));
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return param1 * m_impulse.y;
      }
      
      public function GetJointTranslation() : Number
      {
         var _loc5_:* = null;
         var _loc6_:b2Body = m_bodyA;
         var _loc8_:b2Body = m_bodyB;
         var _loc4_:b2Vec2 = _loc6_.GetWorldPoint(m_localAnchor1);
         var _loc3_:b2Vec2 = _loc8_.GetWorldPoint(m_localAnchor2);
         var _loc9_:Number = _loc3_.x - _loc4_.x;
         var _loc7_:Number = _loc3_.y - _loc4_.y;
         var _loc1_:b2Vec2 = _loc6_.GetWorldVector(m_localXAxis1);
         var _loc2_:Number = _loc1_.x * _loc9_ + _loc1_.y * _loc7_;
         return _loc2_;
      }
      
      public function GetJointSpeed() : Number
      {
         var _loc17_:* = null;
         var _loc7_:b2Body = m_bodyA;
         var _loc18_:b2Body = m_bodyB;
         _loc17_ = _loc7_.m_xf.R;
         var _loc5_:* = Number(m_localAnchor1.x - _loc7_.m_sweep.localCenter.x);
         var _loc9_:Number = m_localAnchor1.y - _loc7_.m_sweep.localCenter.y;
         var _loc20_:Number = _loc17_.col1.x * _loc5_ + _loc17_.col2.x * _loc9_;
         _loc9_ = _loc17_.col1.y * _loc5_ + _loc17_.col2.y * _loc9_;
         _loc5_ = _loc20_;
         _loc17_ = _loc18_.m_xf.R;
         var _loc4_:* = Number(m_localAnchor2.x - _loc18_.m_sweep.localCenter.x);
         var _loc3_:Number = m_localAnchor2.y - _loc18_.m_sweep.localCenter.y;
         _loc20_ = _loc17_.col1.x * _loc4_ + _loc17_.col2.x * _loc3_;
         _loc3_ = _loc17_.col1.y * _loc4_ + _loc17_.col2.y * _loc3_;
         _loc4_ = _loc20_;
         var _loc14_:Number = _loc7_.m_sweep.c.x + _loc5_;
         var _loc19_:Number = _loc7_.m_sweep.c.y + _loc9_;
         var _loc16_:Number = _loc18_.m_sweep.c.x + _loc4_;
         var _loc15_:Number = _loc18_.m_sweep.c.y + _loc3_;
         var _loc11_:Number = _loc16_ - _loc14_;
         var _loc10_:Number = _loc15_ - _loc19_;
         var _loc2_:b2Vec2 = _loc7_.GetWorldVector(m_localXAxis1);
         var _loc1_:b2Vec2 = _loc7_.m_linearVelocity;
         var _loc8_:b2Vec2 = _loc18_.m_linearVelocity;
         var _loc12_:Number = _loc7_.m_angularVelocity;
         var _loc13_:Number = _loc18_.m_angularVelocity;
         var _loc6_:Number = _loc11_ * (-_loc12_ * _loc2_.y) + _loc10_ * (_loc12_ * _loc2_.x) + (_loc2_.x * (_loc8_.x + -_loc13_ * _loc3_ - _loc1_.x - -_loc12_ * _loc9_) + _loc2_.y * (_loc8_.y + _loc13_ * _loc4_ - _loc1_.y - _loc12_ * _loc5_));
         return _loc6_;
      }
      
      public function IsLimitEnabled() : Boolean
      {
         return m_enableLimit;
      }
      
      public function EnableLimit(param1:Boolean) : void
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
         m_enableLimit = param1;
      }
      
      public function GetLowerLimit() : Number
      {
         return m_lowerTranslation;
      }
      
      public function GetUpperLimit() : Number
      {
         return m_upperTranslation;
      }
      
      public function SetLimits(param1:Number, param2:Number) : void
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
         m_lowerTranslation = param1;
         m_upperTranslation = param2;
      }
      
      public function IsMotorEnabled() : Boolean
      {
         return m_enableMotor;
      }
      
      public function EnableMotor(param1:Boolean) : void
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
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
      
      public function SetMaxMotorForce(param1:Number) : void
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
         m_maxMotorForce = param1;
      }
      
      public function GetMotorForce() : Number
      {
         return m_motorImpulse;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc15_:* = null;
         var _loc21_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc7_:b2Body = m_bodyA;
         var _loc17_:b2Body = m_bodyB;
         m_localCenterA.SetV(_loc7_.GetLocalCenter());
         m_localCenterB.SetV(_loc17_.GetLocalCenter());
         var _loc13_:b2Transform = _loc7_.GetTransform();
         var _loc16_:b2Transform = _loc17_.GetTransform();
         _loc15_ = _loc7_.m_xf.R;
         var _loc6_:* = Number(m_localAnchor1.x - m_localCenterA.x);
         var _loc8_:Number = m_localAnchor1.y - m_localCenterA.y;
         _loc21_ = _loc15_.col1.x * _loc6_ + _loc15_.col2.x * _loc8_;
         _loc8_ = _loc15_.col1.y * _loc6_ + _loc15_.col2.y * _loc8_;
         _loc6_ = _loc21_;
         _loc15_ = _loc17_.m_xf.R;
         var _loc5_:* = Number(m_localAnchor2.x - m_localCenterB.x);
         var _loc4_:Number = m_localAnchor2.y - m_localCenterB.y;
         _loc21_ = _loc15_.col1.x * _loc5_ + _loc15_.col2.x * _loc4_;
         _loc4_ = _loc15_.col1.y * _loc5_ + _loc15_.col2.y * _loc4_;
         _loc5_ = _loc21_;
         var _loc12_:Number = _loc17_.m_sweep.c.x + _loc5_ - _loc7_.m_sweep.c.x - _loc6_;
         var _loc11_:Number = _loc17_.m_sweep.c.y + _loc4_ - _loc7_.m_sweep.c.y - _loc8_;
         m_invMassA = _loc7_.m_invMass;
         m_invMassB = _loc17_.m_invMass;
         m_invIA = _loc7_.m_invI;
         m_invIB = _loc17_.m_invI;
         m_axis.SetV(b2Math.MulMV(_loc13_.R,m_localXAxis1));
         m_a1 = (_loc12_ + _loc6_) * m_axis.y - (_loc11_ + _loc8_) * m_axis.x;
         m_a2 = _loc5_ * m_axis.y - _loc4_ * m_axis.x;
         m_motorMass = m_invMassA + m_invMassB + m_invIA * m_a1 * m_a1 + m_invIB * m_a2 * m_a2;
         if(m_motorMass > Number.MIN_VALUE)
         {
            m_motorMass = 1 / m_motorMass;
         }
         m_perp.SetV(b2Math.MulMV(_loc13_.R,m_localYAxis1));
         m_s1 = (_loc12_ + _loc6_) * m_perp.y - (_loc11_ + _loc8_) * m_perp.x;
         m_s2 = _loc5_ * m_perp.y - _loc4_ * m_perp.x;
         var _loc9_:Number = m_invMassA;
         var _loc10_:Number = m_invMassB;
         var _loc22_:Number = m_invIA;
         var _loc20_:Number = m_invIB;
         m_K.col1.x = _loc9_ + _loc10_ + _loc22_ * m_s1 * m_s1 + _loc20_ * m_s2 * m_s2;
         m_K.col1.y = _loc22_ * m_s1 + _loc20_ * m_s2;
         m_K.col1.z = _loc22_ * m_s1 * m_a1 + _loc20_ * m_s2 * m_a2;
         m_K.col2.x = m_K.col1.y;
         m_K.col2.y = _loc22_ + _loc20_;
         m_K.col2.z = _loc22_ * m_a1 + _loc20_ * m_a2;
         m_K.col3.x = m_K.col1.z;
         m_K.col3.y = m_K.col2.z;
         m_K.col3.z = _loc9_ + _loc10_ + _loc22_ * m_a1 * m_a1 + _loc20_ * m_a2 * m_a2;
         if(m_enableLimit)
         {
            _loc14_ = m_axis.x * _loc12_ + m_axis.y * _loc11_;
            if(b2Math.Abs(m_upperTranslation - m_lowerTranslation) < 2 * 0.005)
            {
               m_limitState = 3;
            }
            else if(_loc14_ <= m_lowerTranslation)
            {
               if(m_limitState != 1)
               {
                  m_limitState = 1;
                  m_impulse.z = 0;
               }
            }
            else if(_loc14_ >= m_upperTranslation)
            {
               if(m_limitState != 2)
               {
                  m_limitState = 2;
                  m_impulse.z = 0;
               }
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
         if(m_enableMotor == false)
         {
            m_motorImpulse = 0;
         }
         if(param1.warmStarting)
         {
            m_impulse.x = m_impulse.x * param1.dtRatio;
            m_impulse.y = m_impulse.y * param1.dtRatio;
            m_motorImpulse = m_motorImpulse * param1.dtRatio;
            _loc18_ = m_impulse.x * m_perp.x + (m_motorImpulse + m_impulse.z) * m_axis.x;
            _loc19_ = m_impulse.x * m_perp.y + (m_motorImpulse + m_impulse.z) * m_axis.y;
            _loc2_ = m_impulse.x * m_s1 + m_impulse.y + (m_motorImpulse + m_impulse.z) * m_a1;
            _loc3_ = m_impulse.x * m_s2 + m_impulse.y + (m_motorImpulse + m_impulse.z) * m_a2;
            _loc7_.m_linearVelocity.x = _loc7_.m_linearVelocity.x - m_invMassA * _loc18_;
            _loc7_.m_linearVelocity.y = _loc7_.m_linearVelocity.y - m_invMassA * _loc19_;
            _loc7_.m_angularVelocity = _loc7_.m_angularVelocity - m_invIA * _loc2_;
            _loc17_.m_linearVelocity.x = _loc17_.m_linearVelocity.x + m_invMassB * _loc18_;
            _loc17_.m_linearVelocity.y = _loc17_.m_linearVelocity.y + m_invMassB * _loc19_;
            _loc17_.m_angularVelocity = _loc17_.m_angularVelocity + m_invIB * _loc3_;
         }
         else
         {
            m_impulse.SetZero();
            m_motorImpulse = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc20_:* = null;
         var _loc17_:* = null;
         var _loc11_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc7_:* = null;
         var _loc15_:* = null;
         var _loc8_:b2Body = m_bodyA;
         var _loc21_:b2Body = m_bodyB;
         var _loc2_:b2Vec2 = _loc8_.m_linearVelocity;
         var _loc12_:Number = _loc8_.m_angularVelocity;
         var _loc9_:b2Vec2 = _loc21_.m_linearVelocity;
         var _loc13_:Number = _loc21_.m_angularVelocity;
         if(m_enableMotor && m_limitState != 3)
         {
            _loc16_ = m_axis.x * (_loc9_.x - _loc2_.x) + m_axis.y * (_loc9_.y - _loc2_.y) + m_a2 * _loc13_ - m_a1 * _loc12_;
            _loc14_ = m_motorMass * (m_motorSpeed - _loc16_);
            _loc19_ = m_motorImpulse;
            _loc18_ = param1.dt * m_maxMotorForce;
            m_motorImpulse = b2Math.Clamp(m_motorImpulse + _loc14_,-_loc18_,_loc18_);
            _loc14_ = m_motorImpulse - _loc19_;
            _loc23_ = _loc14_ * m_axis.x;
            _loc24_ = _loc14_ * m_axis.y;
            _loc4_ = _loc14_ * m_a1;
            _loc6_ = _loc14_ * m_a2;
            _loc2_.x = _loc2_.x - m_invMassA * _loc23_;
            _loc2_.y = _loc2_.y - m_invMassA * _loc24_;
            _loc12_ = _loc12_ - m_invIA * _loc4_;
            _loc9_.x = _loc9_.x + m_invMassB * _loc23_;
            _loc9_.y = _loc9_.y + m_invMassB * _loc24_;
            _loc13_ = _loc13_ + m_invIB * _loc6_;
         }
         var _loc5_:Number = m_perp.x * (_loc9_.x - _loc2_.x) + m_perp.y * (_loc9_.y - _loc2_.y) + m_s2 * _loc13_ - m_s1 * _loc12_;
         var _loc3_:Number = _loc13_ - _loc12_;
         if(m_enableLimit && m_limitState != 0)
         {
            _loc22_ = m_axis.x * (_loc9_.x - _loc2_.x) + m_axis.y * (_loc9_.y - _loc2_.y) + m_a2 * _loc13_ - m_a1 * _loc12_;
            _loc20_ = m_impulse.Copy();
            _loc17_ = m_K.Solve33(new b2Vec3(),-_loc5_,-_loc3_,-_loc22_);
            m_impulse.Add(_loc17_);
            if(m_limitState == 1)
            {
               m_impulse.z = b2Math.Max(m_impulse.z,0);
            }
            else if(m_limitState == 2)
            {
               m_impulse.z = b2Math.Min(m_impulse.z,0);
            }
            _loc11_ = -_loc5_ - (m_impulse.z - _loc20_.z) * m_K.col3.x;
            _loc10_ = -_loc3_ - (m_impulse.z - _loc20_.z) * m_K.col3.y;
            _loc7_ = m_K.Solve22(new b2Vec2(),_loc11_,_loc10_);
            _loc7_.x = _loc7_.x + _loc20_.x;
            _loc7_.y = _loc7_.y + _loc20_.y;
            m_impulse.x = _loc7_.x;
            m_impulse.y = _loc7_.y;
            _loc17_.x = m_impulse.x - _loc20_.x;
            _loc17_.y = m_impulse.y - _loc20_.y;
            _loc17_.z = m_impulse.z - _loc20_.z;
            _loc23_ = _loc17_.x * m_perp.x + _loc17_.z * m_axis.x;
            _loc24_ = _loc17_.x * m_perp.y + _loc17_.z * m_axis.y;
            _loc4_ = _loc17_.x * m_s1 + _loc17_.y + _loc17_.z * m_a1;
            _loc6_ = _loc17_.x * m_s2 + _loc17_.y + _loc17_.z * m_a2;
            _loc2_.x = _loc2_.x - m_invMassA * _loc23_;
            _loc2_.y = _loc2_.y - m_invMassA * _loc24_;
            _loc12_ = _loc12_ - m_invIA * _loc4_;
            _loc9_.x = _loc9_.x + m_invMassB * _loc23_;
            _loc9_.y = _loc9_.y + m_invMassB * _loc24_;
            _loc13_ = _loc13_ + m_invIB * _loc6_;
         }
         else
         {
            _loc15_ = m_K.Solve22(new b2Vec2(),-_loc5_,-_loc3_);
            m_impulse.x = m_impulse.x + _loc15_.x;
            m_impulse.y = m_impulse.y + _loc15_.y;
            _loc23_ = _loc15_.x * m_perp.x;
            _loc24_ = _loc15_.x * m_perp.y;
            _loc4_ = _loc15_.x * m_s1 + _loc15_.y;
            _loc6_ = _loc15_.x * m_s2 + _loc15_.y;
            _loc2_.x = _loc2_.x - m_invMassA * _loc23_;
            _loc2_.y = _loc2_.y - m_invMassA * _loc24_;
            _loc12_ = _loc12_ - m_invIA * _loc4_;
            _loc9_.x = _loc9_.x + m_invMassB * _loc23_;
            _loc9_.y = _loc9_.y + m_invMassB * _loc24_;
            _loc13_ = _loc13_ + m_invIB * _loc6_;
         }
         _loc8_.m_linearVelocity.SetV(_loc2_);
         _loc8_.m_angularVelocity = _loc12_;
         _loc21_.m_linearVelocity.SetV(_loc9_);
         _loc21_.m_angularVelocity = _loc13_;
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc16_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc33_:* = null;
         var _loc15_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc30_:* = null;
         var _loc8_:b2Body = m_bodyA;
         var _loc35_:b2Body = m_bodyB;
         var _loc31_:b2Vec2 = _loc8_.m_sweep.c;
         var _loc12_:Number = _loc8_.m_sweep.a;
         var _loc32_:b2Vec2 = _loc35_.m_sweep.c;
         var _loc13_:Number = _loc35_.m_sweep.a;
         var _loc21_:* = 0;
         var _loc25_:* = 0;
         var _loc34_:Boolean = false;
         var _loc14_:* = 0;
         var _loc27_:b2Mat22 = b2Mat22.FromAngle(_loc12_);
         var _loc11_:b2Mat22 = b2Mat22.FromAngle(_loc13_);
         _loc33_ = _loc27_;
         var _loc20_:* = Number(m_localAnchor1.x - m_localCenterA.x);
         var _loc22_:Number = m_localAnchor1.y - m_localCenterA.y;
         _loc15_ = _loc33_.col1.x * _loc20_ + _loc33_.col2.x * _loc22_;
         _loc22_ = _loc33_.col1.y * _loc20_ + _loc33_.col2.y * _loc22_;
         _loc20_ = _loc15_;
         _loc33_ = _loc11_;
         var _loc4_:* = Number(m_localAnchor2.x - m_localCenterB.x);
         var _loc3_:Number = m_localAnchor2.y - m_localCenterB.y;
         _loc15_ = _loc33_.col1.x * _loc4_ + _loc33_.col2.x * _loc3_;
         _loc3_ = _loc33_.col1.y * _loc4_ + _loc33_.col2.y * _loc3_;
         _loc4_ = _loc15_;
         var _loc28_:Number = _loc32_.x + _loc4_ - _loc31_.x - _loc20_;
         var _loc26_:Number = _loc32_.y + _loc3_ - _loc31_.y - _loc22_;
         if(m_enableLimit)
         {
            m_axis = b2Math.MulMV(_loc27_,m_localXAxis1);
            m_a1 = (_loc28_ + _loc20_) * m_axis.y - (_loc26_ + _loc22_) * m_axis.x;
            m_a2 = _loc4_ * m_axis.y - _loc3_ * m_axis.x;
            _loc6_ = m_axis.x * _loc28_ + m_axis.y * _loc26_;
            if(b2Math.Abs(m_upperTranslation - m_lowerTranslation) < 2 * 0.005)
            {
               _loc14_ = Number(b2Math.Clamp(_loc6_,-0.2,0.2));
               _loc21_ = Number(b2Math.Abs(_loc6_));
               _loc34_ = true;
            }
            else if(_loc6_ <= m_lowerTranslation)
            {
               _loc14_ = Number(b2Math.Clamp(_loc6_ - m_lowerTranslation + 0.005,-0.2,0));
               _loc21_ = Number(m_lowerTranslation - _loc6_);
               _loc34_ = true;
            }
            else if(_loc6_ >= m_upperTranslation)
            {
               _loc14_ = Number(b2Math.Clamp(_loc6_ - m_upperTranslation + 0.005,0,0.2));
               _loc21_ = Number(_loc6_ - m_upperTranslation);
               _loc34_ = true;
            }
         }
         m_perp = b2Math.MulMV(_loc27_,m_localYAxis1);
         m_s1 = (_loc28_ + _loc20_) * m_perp.y - (_loc26_ + _loc22_) * m_perp.x;
         m_s2 = _loc4_ * m_perp.y - _loc3_ * m_perp.x;
         var _loc10_:b2Vec3 = new b2Vec3();
         var _loc5_:Number = m_perp.x * _loc28_ + m_perp.y * _loc26_;
         var _loc7_:Number = _loc13_ - _loc12_ - m_refAngle;
         _loc21_ = Number(b2Math.Max(_loc21_,b2Math.Abs(_loc5_)));
         _loc25_ = Number(b2Math.Abs(_loc7_));
         if(_loc34_)
         {
            _loc23_ = m_invMassA;
            _loc24_ = m_invMassB;
            _loc39_ = m_invIA;
            _loc38_ = m_invIB;
            m_K.col1.x = _loc23_ + _loc24_ + _loc39_ * m_s1 * m_s1 + _loc38_ * m_s2 * m_s2;
            m_K.col1.y = _loc39_ * m_s1 + _loc38_ * m_s2;
            m_K.col1.z = _loc39_ * m_s1 * m_a1 + _loc38_ * m_s2 * m_a2;
            m_K.col2.x = m_K.col1.y;
            m_K.col2.y = _loc39_ + _loc38_;
            m_K.col2.z = _loc39_ * m_a1 + _loc38_ * m_a2;
            m_K.col3.x = m_K.col1.z;
            m_K.col3.y = m_K.col2.z;
            m_K.col3.z = _loc23_ + _loc24_ + _loc39_ * m_a1 * m_a1 + _loc38_ * m_a2 * m_a2;
            m_K.Solve33(_loc10_,-_loc5_,-_loc7_,-_loc14_);
         }
         else
         {
            _loc23_ = m_invMassA;
            _loc24_ = m_invMassB;
            _loc39_ = m_invIA;
            _loc38_ = m_invIB;
            _loc2_ = _loc23_ + _loc24_ + _loc39_ * m_s1 * m_s1 + _loc38_ * m_s2 * m_s2;
            _loc9_ = _loc39_ * m_s1 + _loc38_ * m_s2;
            _loc19_ = _loc39_ + _loc38_;
            m_K.col1.Set(_loc2_,_loc9_,0);
            m_K.col2.Set(_loc9_,_loc19_,0);
            _loc30_ = m_K.Solve22(new b2Vec2(),-_loc5_,-_loc7_);
            _loc10_.x = _loc30_.x;
            _loc10_.y = _loc30_.y;
            _loc10_.z = 0;
         }
         var _loc36_:Number = _loc10_.x * m_perp.x + _loc10_.z * m_axis.x;
         var _loc37_:Number = _loc10_.x * m_perp.y + _loc10_.z * m_axis.y;
         var _loc17_:Number = _loc10_.x * m_s1 + _loc10_.y + _loc10_.z * m_a1;
         var _loc18_:Number = _loc10_.x * m_s2 + _loc10_.y + _loc10_.z * m_a2;
         _loc31_.x = _loc31_.x - m_invMassA * _loc36_;
         _loc31_.y = _loc31_.y - m_invMassA * _loc37_;
         _loc12_ = _loc12_ - m_invIA * _loc17_;
         _loc32_.x = _loc32_.x + m_invMassB * _loc36_;
         _loc32_.y = _loc32_.y + m_invMassB * _loc37_;
         _loc13_ = _loc13_ + m_invIB * _loc18_;
         _loc8_.m_sweep.a = _loc12_;
         _loc35_.m_sweep.a = _loc13_;
         _loc8_.SynchronizeTransform();
         _loc35_.SynchronizeTransform();
         return _loc21_ <= 0.005 && _loc25_ <= 0.0349065850398866;
      }
   }
}
