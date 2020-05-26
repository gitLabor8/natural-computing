package Box2D.Collision
{
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   
   public class b2DynamicTree
   {
       
      
      private var m_root:b2DynamicTreeNode;
      
      private var m_freeList:b2DynamicTreeNode;
      
      private var m_path:uint;
      
      private var m_insertionCount:int;
      
      public function b2DynamicTree()
      {
         super();
         m_root = null;
         m_freeList = null;
         m_path = 0;
         m_insertionCount = 0;
      }
      
      public function CreateProxy(param1:b2AABB, param2:*) : b2DynamicTreeNode
      {
         var _loc3_:b2DynamicTreeNode = AllocateNode();
         var _loc5_:* = 0.1;
         var _loc4_:* = 0.1;
         _loc3_.aabb.lowerBound.x = param1.lowerBound.x - _loc5_;
         _loc3_.aabb.lowerBound.y = param1.lowerBound.y - _loc4_;
         _loc3_.aabb.upperBound.x = param1.upperBound.x + _loc5_;
         _loc3_.aabb.upperBound.y = param1.upperBound.y + _loc4_;
         _loc3_.userData = param2;
         InsertLeaf(_loc3_);
         return _loc3_;
      }
      
      public function DestroyProxy(param1:b2DynamicTreeNode) : void
      {
         RemoveLeaf(param1);
         FreeNode(param1);
      }
      
      public function MoveProxy(param1:b2DynamicTreeNode, param2:b2AABB, param3:b2Vec2) : Boolean
      {
         b2Settings.b2Assert(param1.IsLeaf());
         if(param1.aabb.Contains(param2))
         {
            return false;
         }
         RemoveLeaf(param1);
         var _loc5_:Number = 0.1 + 2 * (param3.x > 0?param3.x:Number(-param3.x));
         var _loc4_:Number = 0.1 + 2 * (param3.y > 0?param3.y:Number(-param3.y));
         param1.aabb.lowerBound.x = param2.lowerBound.x - _loc5_;
         param1.aabb.lowerBound.y = param2.lowerBound.y - _loc4_;
         param1.aabb.upperBound.x = param2.upperBound.x + _loc5_;
         param1.aabb.upperBound.y = param2.upperBound.y + _loc4_;
         InsertLeaf(param1);
         return true;
      }
      
      public function Rebalance(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc3_:* = null;
         var _loc2_:* = 0;
         if(m_root == null)
         {
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < param1)
         {
            _loc3_ = m_root;
            _loc2_ = uint(0);
            while(_loc3_.IsLeaf() == false)
            {
               _loc3_ = !!(m_path >> _loc2_ & 1)?_loc3_.child2:_loc3_.child1;
               _loc2_ = uint(_loc2_ + 1 & 31);
            }
            m_path = m_path + 1;
            RemoveLeaf(_loc3_);
            InsertLeaf(_loc3_);
            _loc4_++;
         }
      }
      
      public function GetFatAABB(param1:b2DynamicTreeNode) : b2AABB
      {
         return param1.aabb;
      }
      
      public function GetUserData(param1:b2DynamicTreeNode) : *
      {
         return param1.userData;
      }
      
      public function Query(param1:Function, param2:b2AABB) : void
      {
         var _loc3_:* = null;
         var _loc5_:Boolean = false;
         if(m_root == null)
         {
            return;
         }
         var _loc6_:Vector.<b2DynamicTreeNode> = new Vector.<b2DynamicTreeNode>();
         var _loc4_:int = 0;
         _loc4_++;
         _loc6_[_loc4_] = m_root;
         while(_loc4_ > 0)
         {
            _loc4_--;
            _loc3_ = _loc6_[_loc4_];
            if(_loc3_.aabb.TestOverlap(param2))
            {
               if(_loc3_.IsLeaf())
               {
                  _loc5_ = param1(_loc3_);
                  if(!_loc5_)
                  {
                     return;
                  }
               }
               else
               {
                  _loc4_++;
                  _loc6_[_loc4_] = _loc3_.child1;
                  _loc4_++;
                  _loc6_[_loc4_] = _loc3_.child2;
               }
            }
         }
      }
      
      public function RayCast(param1:Function, param2:b2RayCastInput) : void
      {
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc12_:* = null;
         var _loc4_:* = null;
         var _loc9_:* = null;
         var _loc7_:Number = NaN;
         var _loc10_:* = null;
         if(m_root == null)
         {
            return;
         }
         var _loc6_:b2Vec2 = param2.p1;
         var _loc5_:b2Vec2 = param2.p2;
         var _loc14_:b2Vec2 = b2Math.SubtractVV(_loc6_,_loc5_);
         _loc14_.Normalize();
         var _loc11_:b2Vec2 = b2Math.CrossFV(1,_loc14_);
         var _loc13_:b2Vec2 = b2Math.AbsV(_loc11_);
         var _loc8_:Number = param2.maxFraction;
         var _loc15_:b2AABB = new b2AABB();
         _loc17_ = _loc6_.x + _loc8_ * (_loc5_.x - _loc6_.x);
         _loc18_ = _loc6_.y + _loc8_ * (_loc5_.y - _loc6_.y);
         _loc15_.lowerBound.x = Math.min(_loc6_.x,_loc17_);
         _loc15_.lowerBound.y = Math.min(_loc6_.y,_loc18_);
         _loc15_.upperBound.x = Math.max(_loc6_.x,_loc17_);
         _loc15_.upperBound.y = Math.max(_loc6_.y,_loc18_);
         var _loc16_:Vector.<b2DynamicTreeNode> = new Vector.<b2DynamicTreeNode>();
         var _loc3_:int = 0;
         _loc3_++;
         _loc16_[_loc3_] = m_root;
         while(_loc3_ > 0)
         {
            _loc3_--;
            _loc12_ = _loc16_[_loc3_];
            if(_loc12_.aabb.TestOverlap(_loc15_) != false)
            {
               _loc4_ = _loc12_.aabb.GetCenter();
               _loc9_ = _loc12_.aabb.GetExtents();
               _loc7_ = Math.abs(_loc11_.x * (_loc6_.x - _loc4_.x) + _loc11_.y * (_loc6_.y - _loc4_.y)) - _loc13_.x * _loc9_.x - _loc13_.y * _loc9_.y;
               if(_loc7_ <= 0)
               {
                  if(_loc12_.IsLeaf())
                  {
                     _loc10_ = new b2RayCastInput();
                     _loc10_.p1 = param2.p1;
                     _loc10_.p2 = param2.p2;
                     _loc10_.maxFraction = param2.maxFraction;
                     _loc8_ = param1(_loc10_,_loc12_);
                     if(_loc8_ == 0)
                     {
                        return;
                     }
                     _loc17_ = _loc6_.x + _loc8_ * (_loc5_.x - _loc6_.x);
                     _loc18_ = _loc6_.y + _loc8_ * (_loc5_.y - _loc6_.y);
                     _loc15_.lowerBound.x = Math.min(_loc6_.x,_loc17_);
                     _loc15_.lowerBound.y = Math.min(_loc6_.y,_loc18_);
                     _loc15_.upperBound.x = Math.max(_loc6_.x,_loc17_);
                     _loc15_.upperBound.y = Math.max(_loc6_.y,_loc18_);
                  }
                  else
                  {
                     _loc3_++;
                     _loc16_[_loc3_] = _loc12_.child1;
                     _loc3_++;
                     _loc16_[_loc3_] = _loc12_.child2;
                  }
               }
            }
         }
      }
      
      private function AllocateNode() : b2DynamicTreeNode
      {
         var _loc1_:* = null;
         if(m_freeList)
         {
            _loc1_ = m_freeList;
            m_freeList = _loc1_.parent;
            _loc1_.parent = null;
            _loc1_.child1 = null;
            _loc1_.child2 = null;
            return _loc1_;
         }
         return new b2DynamicTreeNode();
      }
      
      private function FreeNode(param1:b2DynamicTreeNode) : void
      {
         param1.parent = m_freeList;
         m_freeList = param1;
      }
      
      private function InsertLeaf(param1:b2DynamicTreeNode) : void
      {
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         m_insertionCount = m_insertionCount + 1;
         if(m_root == null)
         {
            m_root = param1;
            m_root.parent = null;
            return;
         }
         var _loc2_:b2Vec2 = param1.aabb.GetCenter();
         var _loc4_:* = m_root;
         if(_loc4_.IsLeaf() == false)
         {
            do
            {
               _loc8_ = _loc4_.child1;
               _loc9_ = _loc4_.child2;
               _loc5_ = Math.abs((_loc8_.aabb.lowerBound.x + _loc8_.aabb.upperBound.x) / 2 - _loc2_.x) + Math.abs((_loc8_.aabb.lowerBound.y + _loc8_.aabb.upperBound.y) / 2 - _loc2_.y);
               _loc7_ = Math.abs((_loc9_.aabb.lowerBound.x + _loc9_.aabb.upperBound.x) / 2 - _loc2_.x) + Math.abs((_loc9_.aabb.lowerBound.y + _loc9_.aabb.upperBound.y) / 2 - _loc2_.y);
               if(_loc5_ < _loc7_)
               {
                  _loc4_ = _loc8_;
               }
               else
               {
                  _loc4_ = _loc9_;
               }
            }
            while(_loc4_.IsLeaf() == false);
            
         }
         var _loc3_:b2DynamicTreeNode = _loc4_.parent;
         var _loc6_:* = AllocateNode();
         _loc6_.parent = _loc3_;
         _loc6_.userData = null;
         _loc6_.aabb.Combine(param1.aabb,_loc4_.aabb);
         if(_loc3_)
         {
            if(_loc4_.parent.child1 == _loc4_)
            {
               _loc3_.child1 = _loc6_;
            }
            else
            {
               _loc3_.child2 = _loc6_;
            }
            _loc6_.child1 = _loc4_;
            _loc6_.child2 = param1;
            _loc4_.parent = _loc6_;
            param1.parent = _loc6_;
            while(!_loc3_.aabb.Contains(_loc6_.aabb))
            {
               _loc3_.aabb.Combine(_loc3_.child1.aabb,_loc3_.child2.aabb);
               _loc6_ = _loc3_;
               _loc3_ = _loc3_.parent;
               if(!_loc3_)
               {
                  break;
               }
            }
         }
         else
         {
            _loc6_.child1 = _loc4_;
            _loc6_.child2 = param1;
            _loc4_.parent = _loc6_;
            param1.parent = _loc6_;
            m_root = _loc6_;
         }
      }
      
      private function RemoveLeaf(param1:b2DynamicTreeNode) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(param1 == m_root)
         {
            m_root = null;
            return;
         }
         var _loc5_:b2DynamicTreeNode = param1.parent;
         var _loc2_:b2DynamicTreeNode = _loc5_.parent;
         if(_loc5_.child1 == param1)
         {
            _loc3_ = _loc5_.child2;
         }
         else
         {
            _loc3_ = _loc5_.child1;
         }
         if(_loc2_)
         {
            if(_loc2_.child1 == _loc5_)
            {
               _loc2_.child1 = _loc3_;
            }
            else
            {
               _loc2_.child2 = _loc3_;
            }
            _loc3_.parent = _loc2_;
            FreeNode(_loc5_);
            while(_loc2_)
            {
               _loc4_ = _loc2_.aabb;
               _loc2_.aabb = b2AABB.Combine(_loc2_.child1.aabb,_loc2_.child2.aabb);
               if(!_loc4_.Contains(_loc2_.aabb))
               {
                  _loc2_ = _loc2_.parent;
                  continue;
               }
               break;
            }
         }
         else
         {
            m_root = _loc3_;
            _loc3_.parent = null;
            FreeNode(_loc5_);
         }
      }
   }
}
