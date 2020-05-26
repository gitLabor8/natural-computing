package
{
   import org.flixel.FlxG;
   import org.flixel.FlxSave;
   import org.flixel.FlxSprite;
   import org.flixel.FlxState;
   import org.flixel.FlxText;
   
   public class LoseState extends FlxState
   {
       
      
      private var _timer:Number;
      
      private var _played1:Boolean;
      
      private var _played2:Boolean;
      
      private var _played3:Boolean;
      
      private var LoseGfx:Class;
      
      private var save:FlxSave;
      
      private var _hiScore:Number;
      
      private var _hiScoreText:FlxText;
      
      public function LoseState(param1:Number)
      {
         LoseGfx = Lose_png$4a74a186f3fc1d2289a72ae88acc4cba1746161344;
         super();
         _timer = 0;
         _played1 = false;
         _played2 = false;
         _played3 = false;
         var _loc2_:FlxSprite = new FlxSprite(0,0,LoseGfx);
         add(_loc2_);
         _hiScoreText = new FlxText(6,6,200,"NEW HIGH SCORE: " + param1.toFixed(1) + " SECONDS",true);
         _hiScoreText.setFormat("NES",8,16777215,"left",0);
         _hiScoreText.shadow = 1;
         add(_hiScoreText);
         save = new FlxSave();
         save.bind("highScore");
         if(save.read("highScore"))
         {
            _hiScore = save.read("highScore") as Number;
         }
         else
         {
            _hiScore = 0;
         }
         if(param1 == _hiScore)
         {
            _hiScoreText.text = "NEW RECORD: " + Math.floor(param1 / 60) + "m" + (param1 % 60).toFixed(1) + "s";
         }
         else
         {
            _hiScoreText.text = "YOUR TIME:" + Math.floor(param1 / 60) + "m" + (param1 % 60).toFixed(1) + "s";
         }
         FlxG.playMusic(Assets.AmbientSnd,0.4,689953);
         FlxG.music.fadeIn(2);
      }
      
      override public function update() : void
      {
         _timer = _timer + FlxG.elapsed;
         super.update();
         if(_timer > 0.2 && !_played1)
         {
            _played1 = true;
            FlxG.play(Assets.GullSnd,1,false);
         }
         if(_timer > 1.2 && !_played2)
         {
            _played2 = true;
            FlxG.play(Assets.GullSnd,0.5,false);
         }
         if(_timer > 2.2 && !_played3)
         {
            _played3 = true;
            FlxG.play(Assets.GullSnd,0.25,false);
         }
         if(_timer > 1 && FlxG.keys.SPACE)
         {
            Restart();
         }
      }
      
      private function Restart() : void
      {
         FlxG.fade.start(4278190080,1,onFade);
      }
      
      private function onFade() : void
      {
         FlxG.state = new PlayState();
      }
   }
}
