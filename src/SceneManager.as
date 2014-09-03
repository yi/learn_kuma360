package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;

	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.tweens.ITween;

	public
	//シーン管理
	class SceneManager extends Sprite {

		private var _step:int = 0 ;
		private var _scene:SceneBase = null ;
		public static var _next:SceneBase = null ;

		public function SceneManager ( ) {
			_next = new SceneBattle ;
			addEventListener ( Event.ENTER_FRAME , run ) ;
		}

		private function run ( e:Event ):void {

			if ( null == _scene ) {

				_scene = _next ;
				stage.addChild ( _scene ) ;
				_scene.alpha = 0 ;

				_next = null ;
				_step = 0 ;

			} else {

				switch ( _step ) {
					case 0:
					{
						_step = 1 ;

						BetweenAS3.to ( _scene , { alpha:1 } , .5 ).play() ;

						_scene.init ();

					}
						break ;

					case 1:
					{

						_scene.core () ;
						if ( _next ) {
							_step = 2 ;
						}

					}
						break ;

					case 2:
					{
						_step = 3 ;

						_scene.filters = [ new BlurFilter ( 10, 10 ) ] ;
						var it:ITween = BetweenAS3.to ( _scene , { alpha:0 } , .5 ) ;

						it.addEventListener (
							Event.COMPLETE ,
							function ( e:Event ) :void {
								it.removeEventListener ( Event.COMPLETE , arguments.callee ) ;
								_step = 4;
							}
						);

						it.play() ;

					}
						break;

					case 3:
					{
						//待ち
					}
						break ;

					case 4:
					{
						_scene.release ( ) ;

						stage.removeChild ( _scene ) ;
						_scene = null ;

					}
						break ;

				}

			}

		}

	}
}