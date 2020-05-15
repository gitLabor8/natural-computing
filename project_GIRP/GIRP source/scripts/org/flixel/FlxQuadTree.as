package org.flixel
{
   import org.flixel.data.FlxList;
   
   public class FlxQuadTree extends FlxRect
   {
      
      public static var quadTree:FlxQuadTree;
      
      public static var bounds:FlxRect;
      
      public static var divisions:uint;
      
      public static const A_LIST:uint = 0;
      
      public static const B_LIST:uint = 1;
      
      protected static var _min:uint;
      
      protected static var _o:FlxObject;
      
      protected static var _ol:Number;
      
      protected static var _ot:Number;
      
      protected static var _or:Number;
      
      protected static var _ob:Number;
      
      protected static var _oa:uint;
      
      protected static var _oc:Function;
       
      
      protected var _canSubdivide:Boolean;
      
      protected var _headA:FlxList;
      
      protected var _tailA:FlxList;
      
      protected var _headB:FlxList;
      
      protected var _tailB:FlxList;
      
      protected var _nw:FlxQuadTree;
      
      protected var _ne:FlxQuadTree;
      
      protected var _se:FlxQuadTree;
      
      protected var _sw:FlxQuadTree;
      
      protected var _l:Number;
      
      protected var _r:Number;
      
      protected var _t:Number;
      
      protected var _b:Number;
      
      protected var _hw:Number;
      
      protected var _hh:Number;
      
      protected var _mx:Number;
      
      protected var _my:Number;
      
      public function FlxQuadTree(param1:Number, param2:Number, param3:Number, param4:Number, param5:FlxQuadTree = null)
      {
         var _loc7_:* = null;
         var _loc6_:* = null;
         super(param1,param2,param3,param4);
         _tailA = new FlxList();
         _headA = new FlxList();
         _tailB = new FlxList();
         _headB = new FlxList();
         if(param5 != null)
         {
            if(param5._headA.object != null)
            {
               _loc7_ = param5._headA;
               while(_loc7_ != null)
               {
                  if(_tailA.object != null)
                  {
                     _loc6_ = _tailA;
                     _tailA = new FlxList();
                     _loc6_.next = _tailA;
                  }
                  _tailA.object = _loc7_.object;
                  _loc7_ = _loc7_.next;
               }
            }
            if(param5._headB.object != null)
            {
               _loc7_ = param5._headB;
               while(_loc7_ != null)
               {
                  if(_tailB.object != null)
                  {
                     _loc6_ = _tailB;
                     _tailB = new FlxList();
                     _loc6_.next = _tailB;
                  }
                  _tailB.object = _loc7_.object;
                  _loc7_ = _loc7_.next;
               }
            }
         }
         else
         {
            _min = (width + height) / (2 * divisions);
         }
         _canSubdivide = width > _min || height > _min;
         _nw = null;
         _ne = null;
         _se = null;
         _sw = null;
         _l = x;
         _r = x + width;
         _hw = width / 2;
         _mx = _l + _hw;
         _t = y;
         _b = y + height;
         _hh = height / 2;
         _my = _t + _hh;
      }
      
      public function add(param1:FlxObject, param2:uint) : void
      {
         var _loc6_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = 0;
         _oa = param2;
         if(param1._group)
         {
            _loc6_ = uint(0);
            _loc5_ = (param1 as FlxGroup).members;
            _loc3_ = uint(_loc5_.length);
            while(_loc6_ < _loc3_)
            {
               _loc4_ = _loc5_[_loc6_++] as FlxObject;
               if(_loc4_ != null && _loc4_.exists)
               {
                  if(_loc4_._group)
                  {
                     add(_loc4_,param2);
                  }
                  else if(_loc4_.solid)
                  {
                     _o = _loc4_;
                     _ol = _o.x;
                     _ot = _o.y;
                     _or = _o.x + _o.width;
                     _ob = _o.y + _o.height;
                     addObject();
                  }
               }
            }
         }
         if(param1.solid)
         {
            _o = param1;
            _ol = _o.x;
            _ot = _o.y;
            _or = _o.x + _o.width;
            _ob = _o.y + _o.height;
            addObject();
         }
      }
      
      protected function addObject() : void
      {
         if(!_canSubdivide || _l >= _ol && _r <= _or && _t >= _ot && _b <= _ob)
         {
            addToList();
            return;
         }
         if(_ol > _l && _or < _mx)
         {
            if(_ot > _t && _ob < _my)
            {
               if(_nw == null)
               {
                  _nw = new FlxQuadTree(_l,_t,_hw,_hh,this);
               }
               _nw.addObject();
               return;
            }
            if(_ot > _my && _ob < _b)
            {
               if(_sw == null)
               {
                  _sw = new FlxQuadTree(_l,_my,_hw,_hh,this);
               }
               _sw.addObject();
               return;
            }
         }
         if(_ol > _mx && _or < _r)
         {
            if(_ot > _t && _ob < _my)
            {
               if(_ne == null)
               {
                  _ne = new FlxQuadTree(_mx,_t,_hw,_hh,this);
               }
               _ne.addObject();
               return;
            }
            if(_ot > _my && _ob < _b)
            {
               if(_se == null)
               {
                  _se = new FlxQuadTree(_mx,_my,_hw,_hh,this);
               }
               _se.addObject();
               return;
            }
         }
         if(_or > _l && _ol < _mx && _ob > _t && _ot < _my)
         {
            if(_nw == null)
            {
               _nw = new FlxQuadTree(_l,_t,_hw,_hh,this);
            }
            _nw.addObject();
         }
         if(_or > _mx && _ol < _r && _ob > _t && _ot < _my)
         {
            if(_ne == null)
            {
               _ne = new FlxQuadTree(_mx,_t,_hw,_hh,this);
            }
            _ne.addObject();
         }
         if(_or > _mx && _ol < _r && _ob > _my && _ot < _b)
         {
            if(_se == null)
            {
               _se = new FlxQuadTree(_mx,_my,_hw,_hh,this);
            }
            _se.addObject();
         }
         if(_or > _l && _ol < _mx && _ob > _my && _ot < _b)
         {
            if(_sw == null)
            {
               _sw = new FlxQuadTree(_l,_my,_hw,_hh,this);
            }
            _sw.addObject();
         }
      }
      
      protected function addToList() : void
      {
         var _loc1_:* = null;
         if(_oa == 0)
         {
            if(_tailA.object != null)
            {
               _loc1_ = _tailA;
               _tailA = new FlxList();
               _loc1_.next = _tailA;
            }
            _tailA.object = _o;
         }
         else
         {
            if(_tailB.object != null)
            {
               _loc1_ = _tailB;
               _tailB = new FlxList();
               _loc1_.next = _tailB;
            }
            _tailB.object = _o;
         }
         if(!_canSubdivide)
         {
            return;
         }
         if(_nw != null)
         {
            _nw.addToList();
         }
         if(_ne != null)
         {
            _ne.addToList();
         }
         if(_se != null)
         {
            _se.addToList();
         }
         if(_sw != null)
         {
            _sw.addToList();
         }
      }
      
      public function overlap(param1:Boolean = true, param2:Function = null) : Boolean
      {
         var _loc3_:* = null;
         _oc = param2;
         var _loc4_:Boolean = false;
         if(param1)
         {
            _oa = 1;
            if(_headA.object != null)
            {
               _loc3_ = _headA;
               while(_loc3_ != null)
               {
                  _o = _loc3_.object;
                  if(_o.exists && _o.solid && overlapNode())
                  {
                     _loc4_ = true;
                  }
                  _loc3_ = _loc3_.next;
               }
            }
            _oa = 0;
            if(_headB.object != null)
            {
               _loc3_ = _headB;
               while(_loc3_ != null)
               {
                  _o = _loc3_.object;
                  if(_o.exists && _o.solid)
                  {
                     if(_nw != null && _nw.overlapNode())
                     {
                        _loc4_ = true;
                     }
                     if(_ne != null && _ne.overlapNode())
                     {
                        _loc4_ = true;
                     }
                     if(_se != null && _se.overlapNode())
                     {
                        _loc4_ = true;
                     }
                     if(_sw != null && _sw.overlapNode())
                     {
                        _loc4_ = true;
                     }
                  }
                  _loc3_ = _loc3_.next;
               }
            }
         }
         else if(_headA.object != null)
         {
            _loc3_ = _headA;
            while(_loc3_ != null)
            {
               _o = _loc3_.object;
               if(_o.exists && _o.solid && overlapNode(_loc3_.next))
               {
                  _loc4_ = true;
               }
               _loc3_ = _loc3_.next;
            }
         }
         if(_nw != null && _nw.overlap(param1,_oc))
         {
            _loc4_ = true;
         }
         if(_ne != null && _ne.overlap(param1,_oc))
         {
            _loc4_ = true;
         }
         if(_se != null && _se.overlap(param1,_oc))
         {
            _loc4_ = true;
         }
         if(_sw != null && _sw.overlap(param1,_oc))
         {
            _loc4_ = true;
         }
         return _loc4_;
      }
      
      protected function overlapNode(param1:FlxList = null) : Boolean
      {
         var _loc2_:* = null;
         var _loc4_:Boolean = false;
         var _loc3_:* = param1;
         if(_loc3_ == null)
         {
            if(_oa == 0)
            {
               _loc3_ = _headA;
            }
            else
            {
               _loc3_ = _headB;
            }
         }
         if(_loc3_.object != null)
         {
            while(_loc3_ != null)
            {
               _loc2_ = _loc3_.object;
               if(_o === _loc2_ || !_loc2_.exists || !_o.exists || !_loc2_.solid || !_o.solid || _o.x + _o.width < _loc2_.x + FlxU.roundingError || _o.x + FlxU.roundingError > _loc2_.x + _loc2_.width || _o.y + _o.height < _loc2_.y + FlxU.roundingError || _o.y + FlxU.roundingError > _loc2_.y + _loc2_.height)
               {
                  _loc3_ = _loc3_.next;
               }
               else
               {
                  if(_oc == null)
                  {
                     _o.kill();
                     _loc2_.kill();
                     _loc4_ = true;
                  }
                  else if(_oc(_o,_loc2_))
                  {
                     _loc4_ = true;
                  }
                  _loc3_ = _loc3_.next;
               }
            }
         }
         return _loc4_;
      }
   }
}
