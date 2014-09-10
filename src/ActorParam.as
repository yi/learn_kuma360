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

	// 这个类实现演员的逐帧绘制 和 出生点定位
	public class ActorParam extends BaseActor {

		//キャラクタのスケール  图像素材到实际人物的缩放
		protected const SCALE:Number = 1.5 ;

		//キャラクタの実サイズ  字符的实际尺寸
		protected var scaledSize :int = 0 ;
		protected var _render_rect:Rectangle = null ;

		//画像
		protected var imgCharacter:BitmapData = null ;
		protected var imgCharacterFlipped:BitmapData = null ;
		protected var _shadow:BitmapData = null ;

		public function ActorParam ( srcCharacterAtlasBitmap:Bitmap , colorTransform:ColorTransform , charctorSize:int ) {

			super ( ) ;

			scaledSize = charctorSize * SCALE ;

			var scaleMatrix:Matrix = new Matrix ;
			var sprite:Sprite = new Sprite;
			var graphic:Graphics = sprite.graphics;
			var I:int = 0 ;
			var J:int = 0 ;

			var oneForthOfSize:Number = scaledSize/4   * SCALE ;
			var oneEighthOfSize:Number = scaledSize/8   * SCALE ;
			var scaledWidth:Number = srcCharacterAtlasBitmap.width  * SCALE ;
			var scaleHeight:Number = srcCharacterAtlasBitmap.height * SCALE ;

			//スケーリング
			scaleMatrix.scale ( SCALE , SCALE ) ;

			//影
			graphic.beginFill ( 0 , .5 ) ;
			graphic.drawEllipse ( 0 , 0 , oneForthOfSize , oneEighthOfSize ) ;
			graphic.endFill () ;
			_shadow = new BitmapData ( oneForthOfSize , oneEighthOfSize , true , 0 ) ;
			_shadow.draw ( sprite ) ;

			// 绘制人物
			imgCharacter = new BitmapData ( scaledWidth , scaleHeight , true , 0 ) ;
			imgCharacter.draw ( srcCharacterAtlasBitmap , scaleMatrix , colorTransform ) ;

			// 绘制 人物的镜像
			imgCharacterFlipped = new BitmapData ( scaledWidth , scaleHeight , true , 0 ) ;
			for ( I = 0 ; I < scaledWidth ; I += scaledSize ) {
				for ( J = 0 ; J < scaledSize ; ++ J ) {
					imgCharacterFlipped.copyPixels (
						imgCharacter ,
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

			imgCharacter.dispose ( ) ;
			imgCharacter = null ;

			imgCharacterFlipped.dispose ( ) ;
			imgCharacterFlipped = null ;

			_shadow.dispose ( ) ;
			_shadow = null ;

		}

	}

}