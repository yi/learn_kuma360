/**
 * Copyright kuma360 ( http://wonderfl.net/user/kuma360 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/A2p6
 */

package
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;

	[SWF(width = 465 , height = 465 , backgroundColor = '#FFFFFF' , frameRate = '60')]
	public class Main extends Sprite {

		private var _sceneManager:SceneManager ;

		public function Main() {

			//入力用
			var I:int = 0 ;
			for ( I = 0; I < 256; ++I ) { Global._key[I] = false; }
			stage.addEventListener( KeyboardEvent.KEY_DOWN, function ( E:KeyboardEvent ):void { Global._key[ E.keyCode ] = true;  } );
			stage.addEventListener( KeyboardEvent.KEY_UP  , function ( E:KeyboardEvent ):void { Global._key[ E.keyCode ] = false; } );

			//ゲーム開始
			_sceneManager = new SceneManager ;
			addChild ( _sceneManager ) ;

		}

	}

}







