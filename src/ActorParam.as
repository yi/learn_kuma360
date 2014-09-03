package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	//
	public class ActorParam extends BaseActor {

		//キャラクタのスケール
		protected const SCALE:Number = 1.5 ;

		//キャラクタの実サイズ
		protected var SIZE :int = 0 ;
		protected var _render_rect:Rectangle = null ;

		//画像
		protected var _img:BitmapData = null ;
		protected var _img_r:BitmapData = null ;
		protected var _shadow:BitmapData = null ;

		public function ActorParam ( B:Bitmap , C:ColorTransform , charctorSize:int ) {

			super ( ) ;

			SIZE = charctorSize * SCALE ;

			var M:Matrix = new Matrix ;
			var S:Sprite = new Sprite;
			var G:Graphics = S.graphics;
			var I:int = 0 ;
			var J:int = 0 ;

			var S1:Number = SIZE/4   * SCALE ;
			var S2:Number = SIZE/8   * SCALE ;
			var S3:Number = B.width  * SCALE ;
			var S4:Number = B.height * SCALE ;

			//スケーリング
			M.scale ( SCALE , SCALE ) ;

			//影
			G.beginFill ( 0 , .5 ) ;
			G.drawEllipse ( 0 , 0 , S1 , S2 ) ;
			G.endFill () ;
			_shadow = new BitmapData ( S1 , S2 , true , 0 ) ;
			_shadow.draw ( S ) ;

			//キャラクタ-
			_img = new BitmapData ( S3 , S4 , true , 0 ) ;
			_img.draw ( B , M , C ) ;

			//反転キャラクター
			_img_r = new BitmapData ( S3 , S4 , true , 0 ) ;
			for ( I = 0 ; I < S3 ; I += SIZE ) {
				for ( J = 0 ; J < SIZE ; ++ J ) {
					_img_r.copyPixels (
						_img ,
						new Rectangle ( I + J , 0 , 1 , S4 ) ,
						new Point ( I + SIZE - J , 0 )
					) ;
				}
			}

			//
			_pos.x = Math.random ( ) * 465 ;
			_pos.y = 0 ;
			_pos.z = Math.random ( ) * 100 + 300 ;

			_render_rect  = new Rectangle ( 0 , 0 , SIZE , SIZE ) ;

		}

		public function release ( ):void {

			_img.dispose ( ) ;
			_img = null ;

			_img_r.dispose ( ) ;
			_img_r = null ;

			_shadow.dispose ( ) ;
			_shadow = null ;

		}

	}

}