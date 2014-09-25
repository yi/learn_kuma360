package
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Vector3D;

	public


	//投擲アイテム
	class Item extends BaseActor implements Iactor {

		private const SIZE:int = 20 ;

		//画像
		private var _img:BitmapData = null ;
		private var _shadow:BitmapData = null ;

		//
		private var _manage_id:int = 0 ;
		private var _dirc:Boolean = false ;
		private var _timer:int = 0 ;
		private var _resavation:Boolean = false ;

		public function Item ( ) :void {

			super ( ) ;

			_resavation = false ;
			_manage_id = -1 ;
			_timer = 0 ;
			_dirc = false ;

			//描画用
			var S:Sprite = new Sprite ;
			var G:Graphics = S.graphics ;

			//石本体
			G.clear ( ) ;
			G.beginFill ( 0xFF9090 , 1 ) ;
			G.drawCircle ( SIZE/2 , SIZE/2 , SIZE/2 ) ;
			G.endFill ( ) ;
			_img = new BitmapData ( SIZE , SIZE , true , 0 ) ;
			_img.draw ( S ) ;

			//影
			G.clear ( ) ;
			G.beginFill ( 0 , .5 ) ;
			G.drawEllipse ( 0 , 0 , SIZE , SIZE/2 ) ;
			G.endFill () ;
			_shadow = new BitmapData ( SIZE , SIZE/2 , true , 0 ) ;
			_shadow.draw ( S ) ;

			//座標
			_pos.x = Math.random() * 465 ;
			_pos.y = 0 ;
			_pos.z = Math.random() * 100 + 300 ;
			_velocity.x = 0 ;
			_velocity.y = 0 ;
			_velocity.z = 0 ;

		}

		// 被别的玩家拾取了
		public function reservation ( manage_id:uint ) :void {
			_resavation = true ;
			_manage_id = manage_id ;
			_timer = 99999999 ;
		}

		public function isreservation ( manage_id:uint ):Boolean {
			if ( _resavation == false ) return false ;
			return _manage_id == manage_id ;
		}

		////////////////////////////////////
		public function have ( pos:Vector3D , velocty:Vector3D , Hdirc:Boolean ) :void {

			_resavation = false ;
			_timer = 50 ;
			_dirc = Hdirc ;

			//座標
			_pos.x = pos.x ;
			_pos.y = pos.y - 40 ;
			_pos.z = pos.z ;
			_velocity.x = velocty.x ;
			_velocity.y = velocty.y ;
			_velocity.z = velocty.z ;

		}

		////////////////////////////////////
		public function release ( ) :void {
			_img.dispose ( ) ;
			_img = null ;
		}

		////////////////////////////////////
		public function update ( ) :void {

			if ( _manage_id != -1 ) {

				-- _timer ;
				if ( _timer < 0 ) {
					_manage_id = -1 ;
				}

				_velocity.y = 0 ;

			} else {

				_resavation = false ;
				_velocity.y += .3 ;

			}

			_pos.x += _velocity.x ;
			_pos.y += _velocity.y ;
			_pos.z += _velocity.z * .5 ;

			if ( 0 < _pos.y ) {
				_pos.y = 0 ;
				_velocity.x *= .5 ;
				_velocity.z *= .5 ;
				_velocity.y = - _velocity.y * .2 ;
				_manage_id = -1 ;
			}

			if ( _pos.x < 10 ) {
				_pos.x = 10 ;
				_velocity.x = - _velocity.x * .2 ;
				_velocity.y = - 6 ;
				_manage_id = -1 ;
			}
			if ( 455 < _pos.x ) {
				_pos.x = 455 ;
				_velocity.x = - _velocity.x * .2 ;
				_velocity.y = - 6 ;
				_manage_id = -1 ;
			}
			if ( _pos.z < 300 ) {
				_pos.z = 300 ;
				_velocity.x = - _velocity.x * .2 ;
				_velocity.y = - 6 ;
				_manage_id = -1 ;
			}
			if ( 450 < _pos.z ) {
				_pos.z = 450 ;
				_velocity.x = - _velocity.x * .2 ;
				_velocity.y = - 6 ;
				_manage_id = -1 ;
			}

		}

		////////////////////////////////////
		public function render_shadow ( ):void {
			if ( _resavation == false ) {
				_shadowpos.x = _pos.x - SIZE/2   ;
				_shadowpos.y = _pos.z - SIZE/2/2 ;
				Global._canvas.copyPixels ( _shadow , _shadow.rect , _shadowpos ) ;
			}
		}

		////////////////////////////////////
		public function render ( ) :void {
			if ( _resavation == false ) {
				_renderpos.x = _pos.x          - SIZE/2 ;
				_renderpos.y = _pos.z + _pos.y - SIZE ;
				Global._canvas.copyPixels ( _img , _img.rect , _renderpos ) ;
			}
		}

		////////////////////////////////////
		public function attackChk ( e:Hero , effect:Effect ):void {

			if ( _manage_id == e.id ) {
				return ;
			}

			if ( _manage_id == -1 ) {
				return ;
			}

			if ( _resavation == true ) {
				return ;
			}

			var V:Vector3D = _pos.subtract ( e.pos ) ;
			V.y += 30 ;

			if ( V.length < 30 ) {

				_velocity.x = - _velocity.x * .2 ;
				_velocity.y = - 6 ;
				_manage_id = -1 ;

				e.damage ( _dirc , _pos.z , 3 ) ;
				effect.push ( e.pos.x , e.pos.z + e.pos.y ) ;

			}


		}

		////////////////////////////////////
		public function chk_distance ( pos:Vector3D ) :Boolean {

			if ( _manage_id != -1 ) {
				return false ;
			}

			var L:Number = Vector3D.distance(pos, _pos)
			// var L:Number = Math.sqrt ( ( pos.x - _pos.x ) * ( pos.x - _pos.x ) + ( pos.y - _pos.y ) * ( pos.y - _pos.y ) + ( pos.z - _pos.z ) * ( pos.z - _pos.z ) ) ;
			return ( L < 30 ) ;
		}

		////////////////////////////////////
		public function drop ( pos:Vector3D ) :void {
			_pos.x = pos.x ;
			_pos.y = pos.y - 40 ;
			_pos.z = pos.z ;
			_velocity.x = - _velocity.x * .2 ;
			_velocity.y = - 6 ;
			_manage_id = -1 ;
		}

	}

}