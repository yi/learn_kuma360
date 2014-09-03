package
{
	import flash.geom.Point;
	import flash.geom.Vector3D;

	//
	public class BaseActor {

		//固有ID
		private static var UNIQUE:uint = 0 ;
		private var _id:uint = 0 ;

		//座標
		public var _pos:Vector3D = new Vector3D ;
		protected var _velocity:Vector3D = new Vector3D ;

		//描画用
		protected var _renderpos:Point = new Point ;
		protected var _shadowpos:Point = new Point ;

		public function BaseActor() {
			_id = UNIQUE ++ ;
		}

		public function get id ( ) :uint {
			return _id ;
		}

		public function get pos ( ) :Vector3D {
			return _pos ;
		}

	}
}