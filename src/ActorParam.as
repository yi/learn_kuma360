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

		//キャラクタのスケール  图像素材到实际人物的缩放
		protected const SCALE:Number = 1.5 ;

		//キャラクタの実サイズ  字符的实际尺寸
		protected var scaledSize :int = 0 ;
		protected var _render_rect:Rectangle = null ;

		//画像
		protected var _img:BitmapData = null ;
		protected var _img_r:BitmapData = null ;
		protected var _shadow:BitmapData = null ;

		public function ActorParam ( B:Bitmap , C:ColorTransform , charctorSize:int ) {

			super ( ) ;

			scaledSize = charctorSize * SCALE ;

			var scaleMatrix:Matrix = new Matrix ;
			var sprite:Sprite = new Sprite;
			var graphic:Graphics = sprite.graphics;
			var I:int = 0 ;
			var J:int = 0 ;

			var oneForthOfSize:Number = scaledSize/4   * SCALE ;
			var oneEighthOfSize:Number = scaledSize/8   * SCALE ;
			var scaledWidth:Number = B.width  * SCALE ;
			var scaleHeight:Number = B.height * SCALE ;

			//スケーリング
			scaleMatrix.scale ( SCALE , SCALE ) ;

			//影
			graphic.beginFill ( 0 , .5 ) ;
			graphic.drawEllipse ( 0 , 0 , oneForthOfSize , oneEighthOfSize ) ;
			graphic.endFill () ;
			_shadow = new BitmapData ( oneForthOfSize , oneEighthOfSize , true , 0 ) ;
			_shadow.draw ( sprite ) ;

			// 绘制人物
			_img = new BitmapData ( scaledWidth , scaleHeight , true , 0 ) ;
			_img.draw ( B , scaleMatrix , C ) ;

			// 绘制 人物的镜像
			_img_r = new BitmapData ( scaledWidth , scaleHeight , true , 0 ) ;
			for ( I = 0 ; I < scaledWidth ; I += scaledSize ) {
				for ( J = 0 ; J < scaledSize ; ++ J ) {
					_img_r.copyPixels (
						_img ,
						new Rectangle ( I + J , 0 , 1 , scaleHeight ) ,
						new Point ( I + scaledSize - J , 0 )
					) ;
				}
			}

			// 随机出生点
			_pos.x = Math.random ( ) * 465 ;
			_pos.y = 0 ;
			_pos.z = Math.random ( ) * 100 + 300 ;

			_render_rect  = new Rectangle ( 0 , 0 , scaledSize , scaledSize ) ;

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