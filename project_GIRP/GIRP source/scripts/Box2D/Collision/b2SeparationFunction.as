package Box2D.Collision
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   
   class b2SeparationFunction
   {
      
      public static const e_points:int = 1;
      
      public static const e_faceA:int = 2;
      
      public static const e_faceB:int = 4;
       
      
      public var m_proxyA:b2DistanceProxy;
      
      public var m_proxyB:b2DistanceProxy;
      
      public var m_type:int;
      
      public var m_localPoint:b2Vec2;
      
      public var m_axis:b2Vec2;
      
      function b2SeparationFunction()
      {
         m_localPoint = new b2Vec2();
         m_axis = new b2Vec2();
         super();
      }
      
      public function Initialize(param1:b2SimplexCache, param2:b2DistanceProxy, param3:b2Transform, param4:b2DistanceProxy, param5:b2Transform) : void
      {
         var _loc24_:* = null;
         var _loc32_:* = null;
         var _loc31_:* = null;
         var _loc22_:* = null;
         var _loc14_:* = null;
         var _loc12_:* = null;
         var _loc28_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc33_:* = null;
         var _loc25_:* = null;
         var _loc29_:* = NaN;
         var _loc26_:Number = NaN;
         var _loc17_:* = null;
         var _loc6_:* = null;
         var _loc16_:* = null;
         var _loc7_:* = null;
         var _loc23_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc30_:* = null;
         var _loc21_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc27_:* = NaN;
         m_proxyA = param2;
         m_proxyB = param4;
         var _loc8_:int = param1.count;
         b2Settings.b2Assert(0 < _loc8_ && _loc8_ < 3);
         if(_loc8_ == 1)
         {
            m_type = 1;
            _loc24_ = m_proxyA.GetVertex(param1.indexA[0]);
            _loc22_ = m_proxyB.GetVertex(param1.indexB[0]);
            _loc25_ = _loc24_;
            _loc33_ = param3.R;
            _loc28_ = param3.position.x + (_loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y);
            _loc34_ = param3.position.y + (_loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y);
            _loc25_ = _loc22_;
            _loc33_ = param5.R;
            _loc13_ = param5.position.x + (_loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y);
            _loc15_ = param5.position.y + (_loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y);
            m_axis.x = _loc13_ - _loc28_;
            m_axis.y = _loc15_ - _loc34_;
            m_axis.Normalize();
         }
         else if(param1.indexB[0] == param1.indexB[1])
         {
            m_type = 2;
            _loc32_ = m_proxyA.GetVertex(param1.indexA[0]);
            _loc31_ = m_proxyA.GetVertex(param1.indexA[1]);
            _loc22_ = m_proxyB.GetVertex(param1.indexB[0]);
            m_localPoint.x = 0.5 * (_loc32_.x + _loc31_.x);
            m_localPoint.y = 0.5 * (_loc32_.y + _loc31_.y);
            m_axis = b2Math.CrossVF(b2Math.SubtractVV(_loc31_,_loc32_),1);
            m_axis.Normalize();
            _loc25_ = m_axis;
            _loc33_ = param3.R;
            _loc9_ = _loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y;
            _loc10_ = _loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y;
            _loc25_ = m_localPoint;
            _loc33_ = param3.R;
            _loc28_ = param3.position.x + (_loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y);
            _loc34_ = param3.position.y + (_loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y);
            _loc25_ = _loc22_;
            _loc33_ = param5.R;
            _loc13_ = param5.position.x + (_loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y);
            _loc15_ = param5.position.y + (_loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y);
            _loc29_ = Number((_loc13_ - _loc28_) * _loc9_ + (_loc15_ - _loc34_) * _loc10_);
            if(_loc29_ < 0)
            {
               m_axis.NegativeSelf();
            }
         }
         else if(param1.indexA[0] == param1.indexA[0])
         {
            m_type = 4;
            _loc14_ = m_proxyB.GetVertex(param1.indexB[0]);
            _loc12_ = m_proxyB.GetVertex(param1.indexB[1]);
            _loc24_ = m_proxyA.GetVertex(param1.indexA[0]);
            m_localPoint.x = 0.5 * (_loc14_.x + _loc12_.x);
            m_localPoint.y = 0.5 * (_loc14_.y + _loc12_.y);
            m_axis = b2Math.CrossVF(b2Math.SubtractVV(_loc12_,_loc14_),1);
            m_axis.Normalize();
            _loc25_ = m_axis;
            _loc33_ = param5.R;
            _loc9_ = _loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y;
            _loc10_ = _loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y;
            _loc25_ = m_localPoint;
            _loc33_ = param5.R;
            _loc13_ = param5.position.x + (_loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y);
            _loc15_ = param5.position.y + (_loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y);
            _loc25_ = _loc24_;
            _loc33_ = param3.R;
            _loc28_ = param3.position.x + (_loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y);
            _loc34_ = param3.position.y + (_loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y);
            _loc29_ = Number((_loc28_ - _loc13_) * _loc9_ + (_loc34_ - _loc15_) * _loc10_);
            if(_loc29_ < 0)
            {
               m_axis.NegativeSelf();
            }
         }
         else
         {
            _loc32_ = m_proxyA.GetVertex(param1.indexA[0]);
            _loc31_ = m_proxyA.GetVertex(param1.indexA[1]);
            _loc14_ = m_proxyB.GetVertex(param1.indexB[0]);
            _loc12_ = m_proxyB.GetVertex(param1.indexB[1]);
            _loc17_ = b2Math.MulX(param3,_loc24_);
            _loc6_ = b2Math.MulMV(param3.R,b2Math.SubtractVV(_loc31_,_loc32_));
            _loc16_ = b2Math.MulX(param5,_loc22_);
            _loc7_ = b2Math.MulMV(param5.R,b2Math.SubtractVV(_loc12_,_loc14_));
            _loc23_ = _loc6_.x * _loc6_.x + _loc6_.y * _loc6_.y;
            _loc19_ = _loc7_.x * _loc7_.x + _loc7_.y * _loc7_.y;
            _loc30_ = b2Math.SubtractVV(_loc7_,_loc6_);
            _loc21_ = _loc6_.x * _loc30_.x + _loc6_.y * _loc30_.y;
            _loc18_ = _loc7_.x * _loc30_.x + _loc7_.y * _loc30_.y;
            _loc20_ = _loc6_.x * _loc7_.x + _loc6_.y * _loc7_.y;
            _loc11_ = _loc23_ * _loc19_ - _loc20_ * _loc20_;
            _loc29_ = 0;
            if(_loc11_ != 0)
            {
               _loc29_ = Number(b2Math.Clamp((_loc20_ * _loc18_ - _loc21_ * _loc19_) / _loc11_,0,1));
            }
            _loc27_ = Number((_loc20_ * _loc29_ + _loc18_) / _loc19_);
            if(_loc27_ < 0)
            {
               _loc27_ = 0;
               _loc29_ = Number(b2Math.Clamp((_loc20_ - _loc21_) / _loc23_,0,1));
            }
            _loc24_ = new b2Vec2();
            _loc24_.x = _loc32_.x + _loc29_ * (_loc31_.x - _loc32_.x);
            _loc24_.y = _loc32_.y + _loc29_ * (_loc31_.y - _loc32_.y);
            _loc22_ = new b2Vec2();
            _loc22_.x = _loc14_.x + _loc29_ * (_loc12_.x - _loc14_.x);
            _loc22_.y = _loc14_.y + _loc29_ * (_loc12_.y - _loc14_.y);
            if(_loc29_ == 0 || _loc29_ == 1)
            {
               m_type = 4;
               m_axis = b2Math.CrossVF(b2Math.SubtractVV(_loc12_,_loc14_),1);
               m_axis.Normalize();
               m_localPoint = _loc22_;
               _loc25_ = m_axis;
               _loc33_ = param5.R;
               _loc9_ = _loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y;
               _loc10_ = _loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y;
               _loc25_ = m_localPoint;
               _loc33_ = param5.R;
               _loc13_ = param5.position.x + (_loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y);
               _loc15_ = param5.position.y + (_loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y);
               _loc25_ = _loc24_;
               _loc33_ = param3.R;
               _loc28_ = param3.position.x + (_loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y);
               _loc34_ = param3.position.y + (_loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y);
               _loc26_ = (_loc28_ - _loc13_) * _loc9_ + (_loc34_ - _loc15_) * _loc10_;
               if(_loc29_ < 0)
               {
                  m_axis.NegativeSelf();
               }
            }
            else
            {
               m_type = 2;
               m_axis = b2Math.CrossVF(b2Math.SubtractVV(_loc31_,_loc32_),1);
               m_localPoint = _loc24_;
               _loc25_ = m_axis;
               _loc33_ = param3.R;
               _loc9_ = _loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y;
               _loc10_ = _loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y;
               _loc25_ = m_localPoint;
               _loc33_ = param3.R;
               _loc28_ = param3.position.x + (_loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y);
               _loc34_ = param3.position.y + (_loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y);
               _loc25_ = _loc22_;
               _loc33_ = param5.R;
               _loc13_ = param5.position.x + (_loc33_.col1.x * _loc25_.x + _loc33_.col2.x * _loc25_.y);
               _loc15_ = param5.position.y + (_loc33_.col1.y * _loc25_.x + _loc33_.col2.y * _loc25_.y);
               _loc26_ = (_loc13_ - _loc28_) * _loc9_ + (_loc15_ - _loc34_) * _loc10_;
               if(_loc29_ < 0)
               {
                  m_axis.NegativeSelf();
               }
            }
         }
      }
      
      public function Evaluate(param1:b2Transform, param2:b2Transform) : Number
      {
         var _loc5_:* = null;
         var _loc8_:* = null;
         var _loc7_:* = null;
         var _loc4_:* = null;
         var _loc9_:* = null;
         var _loc10_:* = null;
         var _loc3_:Number = NaN;
         var _loc6_:* = null;
         switch(int(m_type) - 1)
         {
            case 0:
               _loc5_ = b2Math.MulTMV(param1.R,m_axis);
               _loc8_ = b2Math.MulTMV(param2.R,m_axis.GetNegative());
               _loc7_ = m_proxyA.GetSupportVertex(_loc5_);
               _loc4_ = m_proxyB.GetSupportVertex(_loc8_);
               _loc9_ = b2Math.MulX(param1,_loc7_);
               _loc10_ = b2Math.MulX(param2,_loc4_);
               _loc3_ = (_loc10_.x - _loc9_.x) * m_axis.x + (_loc10_.y - _loc9_.y) * m_axis.y;
               return _loc3_;
            case 1:
               _loc6_ = b2Math.MulMV(param1.R,m_axis);
               _loc9_ = b2Math.MulX(param1,m_localPoint);
               _loc8_ = b2Math.MulTMV(param2.R,_loc6_.GetNegative());
               _loc4_ = m_proxyB.GetSupportVertex(_loc8_);
               _loc10_ = b2Math.MulX(param2,_loc4_);
               _loc3_ = (_loc10_.x - _loc9_.x) * _loc6_.x + (_loc10_.y - _loc9_.y) * _loc6_.y;
               return _loc3_;
            default:
               b2Settings.b2Assert(false);
               return 0;
            case 3:
               _loc6_ = b2Math.MulMV(param2.R,m_axis);
               _loc10_ = b2Math.MulX(param2,m_localPoint);
               _loc5_ = b2Math.MulTMV(param1.R,_loc6_.GetNegative());
               _loc7_ = m_proxyA.GetSupportVertex(_loc5_);
               _loc9_ = b2Math.MulX(param1,_loc7_);
               _loc3_ = (_loc9_.x - _loc10_.x) * _loc6_.x + (_loc9_.y - _loc10_.y) * _loc6_.y;
               return _loc3_;
         }
      }
   }
}
