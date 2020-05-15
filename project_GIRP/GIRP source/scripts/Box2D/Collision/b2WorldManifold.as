package Box2D.Collision
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2WorldManifold
   {
       
      
      public var m_normal:b2Vec2;
      
      public var m_points:Vector.<b2Vec2>;
      
      public function b2WorldManifold()
      {
         var _loc1_:int = 0;
         m_normal = new b2Vec2();
         super();
         m_points = new Vector.<b2Vec2>(2);
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            m_points[_loc1_] = new b2Vec2();
            _loc1_++;
         }
      }
      
      public function Initialize(param1:b2Manifold, param2:b2Transform, param3:Number, param4:b2Transform, param5:Number) : void
      {
         var _loc23_:int = 0;
         var _loc22_:* = null;
         var _loc25_:* = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc16_:Number = NaN;
         if(param1.m_pointCount == 0)
         {
            return;
         }
         loop2:
         switch(int(param1.m_type) - 1)
         {
            case 0:
               _loc25_ = param2.R;
               _loc22_ = param1.m_localPoint;
               _loc24_ = param2.position.x + _loc25_.col1.x * _loc22_.x + _loc25_.col2.x * _loc22_.y;
               _loc26_ = param2.position.y + _loc25_.col1.y * _loc22_.x + _loc25_.col2.y * _loc22_.y;
               _loc25_ = param4.R;
               _loc22_ = param1.m_points[0].m_localPoint;
               _loc10_ = param4.position.x + _loc25_.col1.x * _loc22_.x + _loc25_.col2.x * _loc22_.y;
               _loc11_ = param4.position.y + _loc25_.col1.y * _loc22_.x + _loc25_.col2.y * _loc22_.y;
               _loc19_ = _loc10_ - _loc24_;
               _loc18_ = _loc11_ - _loc26_;
               _loc12_ = _loc19_ * _loc19_ + _loc18_ * _loc18_;
               if(_loc12_ > Number.MIN_VALUE * Number.MIN_VALUE)
               {
                  _loc15_ = Math.sqrt(_loc12_);
                  m_normal.x = _loc19_ / _loc15_;
                  m_normal.y = _loc18_ / _loc15_;
               }
               else
               {
                  m_normal.x = 1;
                  m_normal.y = 0;
               }
               _loc6_ = _loc24_ + param3 * m_normal.x;
               _loc7_ = _loc26_ + param3 * m_normal.y;
               _loc17_ = _loc10_ - param5 * m_normal.x;
               _loc16_ = _loc11_ - param5 * m_normal.y;
               m_points[0].x = 0.5 * (_loc6_ + _loc17_);
               m_points[0].y = 0.5 * (_loc7_ + _loc16_);
               break;
            case 1:
               _loc25_ = param2.R;
               _loc22_ = param1.m_localPlaneNormal;
               _loc8_ = _loc25_.col1.x * _loc22_.x + _loc25_.col2.x * _loc22_.y;
               _loc9_ = _loc25_.col1.y * _loc22_.x + _loc25_.col2.y * _loc22_.y;
               _loc25_ = param2.R;
               _loc22_ = param1.m_localPoint;
               _loc13_ = param2.position.x + _loc25_.col1.x * _loc22_.x + _loc25_.col2.x * _loc22_.y;
               _loc14_ = param2.position.y + _loc25_.col1.y * _loc22_.x + _loc25_.col2.y * _loc22_.y;
               m_normal.x = _loc8_;
               m_normal.y = _loc9_;
               _loc23_ = 0;
               while(_loc23_ < param1.m_pointCount)
               {
                  _loc25_ = param4.R;
                  _loc22_ = param1.m_points[_loc23_].m_localPoint;
                  _loc21_ = param4.position.x + _loc25_.col1.x * _loc22_.x + _loc25_.col2.x * _loc22_.y;
                  _loc20_ = param4.position.y + _loc25_.col1.y * _loc22_.x + _loc25_.col2.y * _loc22_.y;
                  m_points[_loc23_].x = _loc21_ + 0.5 * (param3 - (_loc21_ - _loc13_) * _loc8_ - (_loc20_ - _loc14_) * _loc9_ - param5) * _loc8_;
                  m_points[_loc23_].y = _loc20_ + 0.5 * (param3 - (_loc21_ - _loc13_) * _loc8_ - (_loc20_ - _loc14_) * _loc9_ - param5) * _loc9_;
                  _loc23_++;
               }
               break;
            default:
               _loc25_ = param2.R;
               _loc22_ = param1.m_localPlaneNormal;
               _loc8_ = _loc25_.col1.x * _loc22_.x + _loc25_.col2.x * _loc22_.y;
               _loc9_ = _loc25_.col1.y * _loc22_.x + _loc25_.col2.y * _loc22_.y;
               _loc25_ = param2.R;
               _loc22_ = param1.m_localPoint;
               _loc13_ = param2.position.x + _loc25_.col1.x * _loc22_.x + _loc25_.col2.x * _loc22_.y;
               _loc14_ = param2.position.y + _loc25_.col1.y * _loc22_.x + _loc25_.col2.y * _loc22_.y;
               m_normal.x = _loc8_;
               m_normal.y = _loc9_;
               _loc23_ = 0;
               while(_loc23_ < param1.m_pointCount)
               {
                  _loc25_ = param4.R;
                  _loc22_ = param1.m_points[_loc23_].m_localPoint;
                  _loc21_ = param4.position.x + _loc25_.col1.x * _loc22_.x + _loc25_.col2.x * _loc22_.y;
                  _loc20_ = param4.position.y + _loc25_.col1.y * _loc22_.x + _loc25_.col2.y * _loc22_.y;
                  m_points[_loc23_].x = _loc21_ + 0.5 * (param3 - (_loc21_ - _loc13_) * _loc8_ - (_loc20_ - _loc14_) * _loc9_ - param5) * _loc8_;
                  m_points[_loc23_].y = _loc20_ + 0.5 * (param3 - (_loc21_ - _loc13_) * _loc8_ - (_loc20_ - _loc14_) * _loc9_ - param5) * _loc9_;
                  _loc23_++;
               }
               break;
            case 3:
               _loc25_ = param4.R;
               _loc22_ = param1.m_localPlaneNormal;
               _loc8_ = _loc25_.col1.x * _loc22_.x + _loc25_.col2.x * _loc22_.y;
               _loc9_ = _loc25_.col1.y * _loc22_.x + _loc25_.col2.y * _loc22_.y;
               _loc25_ = param4.R;
               _loc22_ = param1.m_localPoint;
               _loc13_ = param4.position.x + _loc25_.col1.x * _loc22_.x + _loc25_.col2.x * _loc22_.y;
               _loc14_ = param4.position.y + _loc25_.col1.y * _loc22_.x + _loc25_.col2.y * _loc22_.y;
               m_normal.x = -_loc8_;
               m_normal.y = -_loc9_;
               _loc23_ = 0;
               while(true)
               {
                  if(_loc23_ >= param1.m_pointCount)
                  {
                     break loop2;
                  }
                  _loc25_ = param2.R;
                  _loc22_ = param1.m_points[_loc23_].m_localPoint;
                  _loc21_ = param2.position.x + _loc25_.col1.x * _loc22_.x + _loc25_.col2.x * _loc22_.y;
                  _loc20_ = param2.position.y + _loc25_.col1.y * _loc22_.x + _loc25_.col2.y * _loc22_.y;
                  m_points[_loc23_].x = _loc21_ + 0.5 * (param5 - (_loc21_ - _loc13_) * _loc8_ - (_loc20_ - _loc14_) * _loc9_ - param3) * _loc8_;
                  m_points[_loc23_].y = _loc20_ + 0.5 * (param5 - (_loc21_ - _loc13_) * _loc8_ - (_loc20_ - _loc14_) * _loc9_ - param3) * _loc9_;
                  _loc23_++;
               }
         }
      }
   }
}
