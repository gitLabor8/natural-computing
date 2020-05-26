package Box2D.Collision
{
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Sweep;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.b2Settings;
   
   public class b2TimeOfImpact
   {
      
      private static var b2_toiCalls:int = 0;
      
      private static var b2_toiIters:int = 0;
      
      private static var b2_toiMaxIters:int = 0;
      
      private static var b2_toiRootIters:int = 0;
      
      private static var b2_toiMaxRootIters:int = 0;
      
      private static var s_cache:b2SimplexCache = new b2SimplexCache();
      
      private static var s_distanceInput:b2DistanceInput = new b2DistanceInput();
      
      private static var s_xfA:b2Transform = new b2Transform();
      
      private static var s_xfB:b2Transform = new b2Transform();
      
      private static var s_fcn:b2SeparationFunction = new b2SeparationFunction();
      
      private static var s_distanceOutput:b2DistanceOutput = new b2DistanceOutput();
       
      
      public function b2TimeOfImpact()
      {
         super();
      }
      
      public static function TimeOfImpact(param1:b2TOIInput) : Number
      {
         var _loc9_:int = 0;
         _loc9_ = 1000;
         var _loc5_:Number = NaN;
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc6_:* = NaN;
         var _loc13_:* = NaN;
         var _loc18_:* = NaN;
         var _loc20_:int = 0;
         var _loc19_:Number = NaN;
         var _loc2_:Number = NaN;
         b2_toiCalls = b2_toiCalls + 1;
         var _loc15_:b2DistanceProxy = param1.proxyA;
         var _loc16_:b2DistanceProxy = param1.proxyB;
         var _loc3_:b2Sweep = param1.sweepA;
         var _loc4_:b2Sweep = param1.sweepB;
         b2Settings.b2Assert(_loc3_.t0 == _loc4_.t0);
         b2Settings.b2Assert(1 - _loc3_.t0 > Number.MIN_VALUE);
         var _loc14_:Number = _loc15_.m_radius + _loc16_.m_radius;
         var _loc11_:Number = param1.tolerance;
         var _loc10_:* = 0;
         var _loc17_:int = 0;
         var _loc12_:* = 0;
         s_cache.count = 0;
         s_distanceInput.useRadii = false;
         while(true)
         {
            _loc3_.GetTransform(s_xfA,_loc10_);
            _loc4_.GetTransform(s_xfB,_loc10_);
            s_distanceInput.proxyA = _loc15_;
            s_distanceInput.proxyB = _loc16_;
            s_distanceInput.transformA = s_xfA;
            s_distanceInput.transformB = s_xfB;
            b2Distance.Distance(s_distanceOutput,s_cache,s_distanceInput);
            if(s_distanceOutput.distance <= 0)
            {
               _loc10_ = 1;
               break;
            }
            s_fcn.Initialize(s_cache,_loc15_,s_xfA,_loc16_,s_xfB);
            _loc5_ = s_fcn.Evaluate(s_xfA,s_xfB);
            if(_loc5_ <= 0)
            {
               _loc10_ = 1;
               break;
            }
            if(_loc17_ == 0)
            {
               if(_loc5_ > _loc14_)
               {
                  _loc12_ = Number(b2Math.Max(_loc14_ - _loc11_,0.75 * _loc14_));
               }
               else
               {
                  _loc12_ = Number(b2Math.Max(_loc5_ - _loc11_,0.02 * _loc14_));
               }
            }
            if(_loc5_ - _loc12_ < 0.5 * _loc11_)
            {
               if(_loc17_ == 0)
               {
                  _loc10_ = 1;
                  break;
               }
               break;
            }
            _loc7_ = _loc10_;
            _loc8_ = _loc10_;
            _loc6_ = 1;
            _loc13_ = _loc5_;
            _loc3_.GetTransform(s_xfA,_loc6_);
            _loc4_.GetTransform(s_xfB,_loc6_);
            _loc18_ = Number(s_fcn.Evaluate(s_xfA,s_xfB));
            if(_loc18_ >= _loc12_)
            {
               _loc10_ = 1;
               break;
            }
            _loc20_ = 0;
            while(true)
            {
               if(_loc20_ & 1)
               {
                  _loc19_ = _loc8_ + (_loc12_ - _loc13_) * (_loc6_ - _loc8_) / (_loc18_ - _loc13_);
               }
               else
               {
                  _loc19_ = 0.5 * (_loc8_ + _loc6_);
               }
               _loc3_.GetTransform(s_xfA,_loc19_);
               _loc4_.GetTransform(s_xfB,_loc19_);
               _loc2_ = s_fcn.Evaluate(s_xfA,s_xfB);
               if(b2Math.Abs(_loc2_ - _loc12_) < 0.025 * _loc11_)
               {
                  _loc7_ = _loc19_;
                  break;
               }
               if(_loc2_ > _loc12_)
               {
                  _loc8_ = _loc19_;
                  _loc13_ = _loc2_;
               }
               else
               {
                  _loc6_ = _loc19_;
                  _loc18_ = _loc2_;
               }
               _loc20_++;
               b2_toiRootIters = b2_toiRootIters + 1;
               if(_loc20_ != 50)
               {
                  continue;
               }
               break;
            }
            b2_toiMaxRootIters = b2Math.Max(b2_toiMaxRootIters,_loc20_);
            if(_loc7_ >= (1 + 100 * Number.MIN_VALUE) * _loc10_)
            {
               _loc10_ = _loc7_;
               _loc17_++;
               b2_toiIters = b2_toiIters + 1;
               if(_loc17_ != 1000)
               {
                  continue;
               }
               break;
            }
            break;
         }
         b2_toiMaxIters = b2Math.Max(b2_toiMaxIters,_loc17_);
         return _loc10_;
      }
   }
}
