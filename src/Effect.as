package
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public
	class Effect {

		private var _img:BitmapData = null ;
		private var _V:Vector.<Object> = new Vector.<Object> ;

		////////////////////////////////////
		public function Effect() {

			_img = new BitmapData ( 100 , 100 , true , 0 ) ;

			var S:Sprite = new Sprite ;
			var G:Graphics = S.graphics ;
			var M:Matrix = new Matrix ;
			M.createGradientBox ( 100 , 100 , 0 , 0 , 0 ) ;
			G.lineStyle ( 1 ) ;
			G.lineGradientStyle ( "radial" , [ 0xFFFFFF , 0xFFA020 ] , [ 1 , 0 ] , [ 0 , 255 ] , M ) ;
			for ( var I:int = 0 ; I < 50 ; ++ I ) {
				G.moveTo ( 100/2 , 100/2 ) ;
				var R:Number = I / 50 * 360 * Math.PI / 180 ;
				G.lineTo ( Math.cos ( R ) * 100/2 + 100/2 , Math.sin ( R ) * 100/2 + 100/2 ) ;
			}
			S.filters = [ new BlurFilter ] ;
			_img.draw ( S ) ;

		}

		////////////////////////////////////
		public function release ( ) :void {
			_img.dispose ( ) ;
			_img = null ;
		}

		////////////////////////////////////
		public function push ( x:int , y:int ) :void {
			_V.push ( { P:new Point ( x - _img.width * .5 , y - _img.height ) , T:6 } ) ;
		}

		////////////////////////////////////
		public function update () :void {
			for ( var I:int = 0 ; I < _V.length ; ++ I ) {
				if ( -- _V[I].T < 0 ) {
					_V.splice ( I , 1 ) ;
				}
			}
		}

		////////////////////////////////////
		public function render ( ) :void {
			for each ( var O:Object in _V ) {
				Global._canvas.copyPixels ( _img , _img.rect , O.P ) ;
			}
		}

	}


}