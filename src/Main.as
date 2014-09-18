/**
 * Copyright kuma360 ( http://wonderfl.net/user/kuma360 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/A2p6
 */

package
{
	import com.bit101.components.HSlider;
	import com.bit101.components.NumericStepper;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	[SWF(width = 465 , height = 465 , backgroundColor = '#FFFFFF' , frameRate = '60')]
	public class Main extends Sprite
	{

		private var _sceneManager:SceneManager;

		public function Main()
		{

			//入力用
			var I:int = 0;
			for (I = 0 ; I < 256 ; ++I)
			{
				Global._key[I] = false;
			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN , function(E:KeyboardEvent):void
			{
				Global._key[E.keyCode] = true;
			});
			stage.addEventListener(KeyboardEvent.KEY_UP , function(E:KeyboardEvent):void
			{
				Global._key[E.keyCode] = false;
			});

			Global.init(init1);

		}
		private function changeSpHandler(e:Event):void
		{
			var hs:NumericStepper = e.target as NumericStepper;
			Global.MAX_SPEED = hs.value;
		}

		private function init1(err:String=null):void
		{
			if (err)
				showErr(err);
			else
				SceneBattle.init(start);
		}

		private function showErr(err:String):void
		{
			var tf:TextField = new TextField;
			tf.text = err;
			tf.autoSize = 'left';
			tf.defaultTextFormat = new TextFormat(null , 40 , 0xff0000);
			addChild(tf);
		}

		private function start(err:String=null):void
		{
			if (err)
			{
				showErr(err);
				return
			}
			trace('[Main::start]:err',err);
			//ゲーム開始
			_sceneManager = new SceneManager;
			addChild(_sceneManager);

			var ns:NumericStepper = new NumericStepper(this,10,10,changeSpHandler);
			ns.step = 1;
			ns.value = 2;
		}

	}

}







