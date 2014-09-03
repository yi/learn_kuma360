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


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filters.BlurFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Vector3D;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.text.TextField;
import flash.text.TextFormat;

import org.libspark.betweenas3.BetweenAS3;
import org.libspark.betweenas3.tweens.ITween;



///
class Global {
	public static var _key:Array = new Array ( 256 ) ;
	public static var _canvas:BitmapData = new BitmapData ( 465 , 465 , false , 0 ) ;


	[Embed(source="background.png")]
	private static var BMClass:Class;
	private static var BM:Bitmap = new BMClass();
	public static var _back:BitmapData = new BitmapData ( 465 , 465 , false , 0 ) ;
	_back.draw(new BMClass());
	public static var _world_shake:int = 0 ;
}

//
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

//
interface Iactor {
	function render_shadow ( ) :void ;
	function render ( ) :void ;
	function get pos ( ) :Vector3D ;
}

//
class BaseActor {

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

//
class ActorParam extends BaseActor {

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

//
class CharctorBase extends ActorParam implements Iactor {

	//アニメーションテーブル
	private var $A:Array = null ;
	private var $B:Array = null ;
	private var $C:Array = null ;
	private var $D:Array = null ;
	private var $E:Array = null ;
	private var $F:Array = null ;

	//体力
	private var _hp:int = 0 ;
	private var _death:Boolean = false ;
	private var _death_cnt:int = 0;

	//アニメーション用
	private var _anim:int = 0 ;
	private var _animwait:int = 0 ;
	private var _action:int = 0 ;
	private var _actionstep:int = 0 ;
	private var _dirc:Boolean = false;

	//入力用
	private var _input_damage:Boolean = false ;
	private var _target_x:int = 0 ;
	private var _target_z:int = 0 ;
	private var _speed:Number = 0 ;

	//ジャンプ管理
	private var _jump_state:Boolean = false;

	//攻撃管理
	private var _attack_state:int = 0 ; //連続技判定
	private var _attack_shake:int = 0 ;
	private var _hitRegist:Vector.<int> = new Vector.<int> ;

	//被ダメージ管理
	private var _damage_action:int = 0 ;
	private var _damage_shake:int = 0 ;

	//入力チェック用
	private var _input_attack:int = 0 ;
	private var _input_jump  :int = 0 ;
	private var _inputL:int = 0 ;
	private var _inputR:int = 0 ;
	private var _inputU:int = 0 ;
	private var _inputD:int = 0 ;
	private var _command1:int = 0 ;
	private var _command1CNT:int = 0 ;
	private var _command2:int = 0 ;
	private var _command2CNT:int = 0 ;
	private var _stepPower:Number = 0 ;
	private var _lastAtkChk:int = 0 ;

	private var _r:Rectangle = new Rectangle ( ) ;

	////////////////////////////////////
	public function CharctorBase ( B:Bitmap , C:ColorTransform , $$A:Array , $$B:Array , $$C:Array , $$D:Array , $$E:Array , $$F:Array ) {

		super ( B , C , 64 ) ;

		$A = $$A ;
		$B = $$B ;
		$C = $$C ;
		$D = $$D ;
		$E = $$E ;
		$F = $$F ;

		_hp = 10 ;
		_death = false ;
		_death_cnt = 0 ;
		input ( false , false , false , false , false , false ) ;

	}


	////////////////////////////////////
	public function setDie ( ) :void {
		if ( _death == false ) {
			_death = true ;
			_death_cnt = 0 ;
			_damage_action = 11 ;
			_hp = 0 ;
		}
	}



	////////////////////////////////////
	public function input (
		keyA:Boolean , //攻撃ボタン
		keyJ:Boolean , //ジャンプボタン
		keyL:Boolean , //左
		keyR:Boolean , //右
		keyU:Boolean , //上
		keyD:Boolean   //下
	):void {

		if ( keyA ) { ++ _input_attack ; } else { _input_attack = 0 ; }
		if ( keyJ ) { ++ _input_jump ; }   else { _input_jump = 0 ; }
		if ( keyL ) { ++ _inputL ; } else { _inputL = 0 ; }
		if ( keyR ) { ++ _inputR ; } else { _inputR = 0 ; }
		if ( keyU ) { ++ _inputU ; } else { _inputU = 0 ; }
		if ( keyD ) { ++ _inputD ; } else { _inputD = 0 ; }
		_target_x = _pos.x + ( (_inputL) ? -50 : 0 ) + ( (_inputR) ? 50 : 0 ) + ( (_dirc)? -1 : 1 ) ;
		_target_z = _pos.z + ( (_inputU) ? -50 : 0 ) + ( (_inputD) ? 50 : 0 ) + ( (_dirc)? -1 : 1 ) ;

		//左方向ステップ////////////////////////////////////////////////
		++ _command1CNT;
		if ( 10 < _command1CNT ) { _command1 = 0 ; }
		if ( _input_jump == 1 && _command1 == 0 )                      { _command1 = 2 ; _command1CNT = 0; }
		if ( _inputL     == 1 && _command1 == 2 && _command1CNT < 10 ) { _command1 = 3 ; _command1CNT = 0; }

		//右方向ステップ////////////////////////////////////////////////
		++ _command2CNT;
		if ( 10 < _command2CNT ) { _command2 = 0 ; }
		if ( _input_jump == 1 && _command2 == 0 )                      { _command2 = 2 ; _command2CNT = 0; }
		if ( _inputR     == 1 && _command2 == 2 && _command2CNT < 10 ) { _command2 = 3 ; _command2CNT = 0; }

	}

	////////////////////////////////////
	public function inputAuto ( ):void {

		_input_attack = ( Math.random() < 0.04)?1:0 ;
		_input_jump   = ( Math.random() < 0.01)?1:0 ;

		var V:Vector3D = _pos.clone() ;
		V.x -= _target_x ;
		V.z -= _target_z ;
		if ( V.length < 20 * SCALE ) {
			_target_x = _target_x + ( Math.random() * 6 - 3 ) * 8 ;
			_target_z = _target_z + ( Math.random() * 6 - 3 ) * 8 ;
			if ( _target_x < 0 )   _target_x = 0;
			if ( _target_z < 300 ) _target_z = 300;
			if ( _target_x > 465 ) _target_x = 465;
			if ( _target_z > 465 ) _target_z = 465;
		}

	}

	////////////////////////////////////
	public function getDeath ( ) :Boolean {
		return _death ;
	}

	////////////////////////////////////
	public function update ( item:Vector.<Item> , mainHero:CharctorBase ):void {

		var CHK:Boolean = true ;
		var TC:int = $C[_action][_actionstep] ;
		var Ba:int = _action;
		var Bas:int = _actionstep;
		var X:Number = 0 ;
		var Y:Number = 0 ;
		var L:Number = 0 ;
		var I:int = 0 ;

		if ( _death ) {

			if ( 60 < ++ _death_cnt && this != mainHero ) {

				_hp = 10 ;
				_death = false ;
				_death_cnt = 0 ;

				_pos.x = Math.random() * 465 ;
				_pos.y = -500 ;
				_pos.z = 365 ;
				_velocity.y = 0 ;

				_action = 12 ;

			}

		}

		if ( 0 < _damage_shake ) {

			CHK = false ;
			-- _damage_shake ;

			for ( I = 0 ; I < item.length ; ++ I ) {

				//石を持っていたら落としてしまう
				if ( item[J].isreservation ( id ) ) {
					item[J].drop ( _pos ) ;
					break;
				}

			}

		}

		if ( 0 < _attack_shake ) {
			CHK = false ;
			-- _attack_shake ;
		}

		{//入力の反映

			if ( 1 & TC ) {

				X = _pos.x - _target_x ;
				Y = _pos.z - _target_z ;
				L = X * X + Y * Y ;
				_action = ( 10 * 10 < L ) ? 1 : 0 ;
				_attack_state = 0 ;

			}

			if ( 2 & TC ) {

				if ( _input_attack == 1 ) {

					//最後の攻撃判定が誰にもヒットしていない場合、連続技判定をリセットする
					if ( _lastAtkChk != -1 ) {
						_attack_state = 0 ;
					}

					_lastAtkChk = 0 ;

					if ( _jump_state ) {

						switch ( _attack_state ) {
							case 1 : _attack_state = 2 ;  _action = 6 ; _animwait = 0 ; break ;
							default: _attack_state = 1 ;  _action = 5 ; _animwait = 0 ; break ;
						}

					} else {

						switch ( _attack_state ) {
							case 0 : _attack_state = 0 ; _action = 3 ; _animwait = 0 ; /*連打キャンセル*/_actionstep= 0;  break ;
							case 1 : _attack_state = 2 ; _action =15 ; _animwait = 0 ; break ;
							case 2 : _attack_state = 3 ; _action = 7 ; _animwait = 0 ; break ;
							case 3 : _attack_state = 4 ; _action = 4 ; _animwait = 0 ; break ;
						}
					}

				}

			}

			if ( 4 & TC ) {
				if ( _input_jump == 1 ) {
					_action = 2 ;
					_animwait = 0 ;
				}
			}

			if ( 8 & TC ) {

				if ( _input_attack == 1 ) {

					var J:int = 0 ;

					if ( _attack_state == 0 && _jump_state == 0 ) {

						for ( J = 0 ; J < item.length ; ++ J ) {

							//石を持っていたら投げる
							if ( item[J].isreservation ( id ) ) {
								_action = 13 ;
								_animwait = 0 ;
								break;
							}

							//足元に石があると拾う
							if ( item[J].chk_distance ( _pos ) ) {
								item[J].reservation ( id ) ;
								_action = 16 ;
								_animwait = 0 ;
								break;
							}
						}

					}

				}

			}

			if ( 16 & TC ) {

				if ( _command1 == 3 ) {
					_command1 = 0 ;
					_action = 14 ;
					_animwait = 0 ;
					_stepPower = -4 ;
					_attack_shake = 0;
					_attack_state = 0;
				}

				if ( _command2 == 3 ) {
					_command2 = 0 ;
					_action = 14 ;
					_animwait = 0 ;
					_stepPower = 4 ;
					_attack_shake = 0;
					_attack_state = 0;
				}

			}

			if ( 32 & TC ) {
				//ブレーキ
				if ( _inputL ) { if ( 0 < _velocity.x ) _velocity.x *= .9 ; }
				if ( _inputR ) { if ( _velocity.x < 0 ) _velocity.x *= .9 ; }
			}

			//強制動作
			if ( _damage_action ) {
				_action = _damage_action ;
				_damage_action = 0 ;
			}

			if ( Ba != _action ) {
				_actionstep = 0 ;
				_animwait = 0 ;
			}

		}

		if ( CHK )
		{//アニメーション

			var TD:int = $D[_action][_actionstep];
			switch ( TD ) {

				case 0 :
					++ _animwait;
					break ;

				case 1 :
					if ( 0 < _velocity.y ) {
						++ _animwait ;
					}
					break ;

				case 2:
					if ( false == _jump_state ) {
						++ _animwait ;
					}
					break;

				case 3:
					if ( 0 < _hp ) {
						++ _animwait;
					}
					break;
			}

			if ( $B[_action][_actionstep] <= _animwait ) {

				_animwait = 0 ;

				var jumpPower:Number = 0 ;
				if ( _inputL != 0 ) { jumpPower = -3; }
				if ( _inputR != 0 ) { jumpPower =  3; }

				switch ( $E[_action][_actionstep] ) {
					case 1: _velocity.y = -5 ; _velocity.x = jumpPower; break;
					case 2: _action = ( _jump_state) ? 12 : 0 ; break ;
					case 3:
					{
						for ( var P:int = 0 ; P < item.length ; ++ P ) {
							if ( item[P].isreservation (id) ) {
								item[P].have ( _pos , new Vector3D ( ( _dirc) ? -8 : 8 , -3 , 0 ) , _dirc ) ;
							}
						}
					}
						break;
					case 4: _velocity.y = -2 ; _velocity.x = _stepPower; break;
					case 5: _dirc = ( _inputL ) ? true : ( (_inputR) ? false : _dirc ) ; break;
					default: break;
				}

				if ( $A[_action].length <= ++ _actionstep ) {
					_actionstep = 0 ;
				}

				while ( _hitRegist.length ) {
					_hitRegist.pop () ;
				}

			}

		}

		if ( CHK && ( 1 & TC ) )
		{//加速

			_dirc = ( _target_x < _pos.x ) ;

			var ty:Number = _velocity.y;
			_velocity.y = 0 ;

			X = ( _target_x - _pos.x ) ;
			Y = ( _target_z - _pos.z ) ;
			L = X * X + Y * Y ;
			if ( 10 * 10 < L ) {
				_velocity.x += X * .004 ;
				_velocity.z += Y * .004 ;
			}

			_speed = _velocity.length ;
			_speed = ( 2 < _speed )? 2 : _speed ;

			_velocity.normalize ( ) ;
			_velocity.scaleBy ( _speed ) ;

			_velocity.y = ty ;

		}

		if ( CHK )
		{//移動

			_pos.x += _velocity.x * SCALE ;
			_pos.y += _velocity.y * SCALE ;
			_pos.z += _velocity.z * SCALE *.5 ;
			_velocity.y += .2 ;

			if ( false == _jump_state ) {
				_velocity.x *= .9 ;
				_velocity.z *= .9 ;
			}

			if ( 0 <= _pos.y ) {
				_pos.y = 0 ;
				_jump_state = false ;
			} else {
				_jump_state = true ;
			}

			if ( _pos.z < ZMAX ) {
				_pos.z = ZMAX ;
			}

			if ( 465 < _pos.z ) {
				_pos.z = 465 ;
			}

			if ( _pos.x < 0 ) {
				_pos.x = 0 ;
			}

			if ( 465 < _pos.x ) {
				_pos.x = 465 ;
			}

		}

		_anim = $A[_action][_actionstep] ;

	}

	////////////////////////////////////
	public function attackChk ( e:Hero , effect:Effect ):void {

		if ( this == e ) {
			return ;
		}

		if ( e._death ) {
			return ;
		}

		for each ( var N:int in _hitRegist ) {
			if ( N == e.id ) {
				return ;
			}
		}

		var temp:int = $F[_action][_actionstep] ;

		//弱い攻撃
		if ( temp == 1 ) {

			if ( _lastAtkChk == 0 ) {
				_lastAtkChk = 1 ;
			}

			var V1:Vector3D = _pos.subtract ( e._pos ) ;

			if ( _dirc ) {
				V1.x -= 8 * SCALE ;
			} else {
				V1.x += 8 * SCALE ;
			}

			if ( V1.length < 30 ) {

				_lastAtkChk = -1 ;

				if ( _attack_state== 0 ) {
					_attack_state = 1 ;
				}

				if ( _pos.y != 0 ) {
					_attack_shake = 11 ;
				} else {
					_attack_shake = 5 ;
				}

				e.damage ( _dirc , _pos.z , 1 ) ;
				_hitRegist.push ( e.id ) ;
				effect.push ( e.pos.x , e.pos.z + e.pos.y ) ;

			}

		}

		//強い攻撃
		if ( temp == 2 ) {

			if ( _lastAtkChk == 0 ) {
				_lastAtkChk = 2 ;
			}

			var V2:Vector3D = _pos.subtract ( e._pos ) ;

			if ( _dirc ) {
				V2.x -= 16 * SCALE ;
			} else {
				V2.x += 16 * SCALE ;
			}

			if ( V2.length < 30 ) {

				_lastAtkChk = -1 ;

				if ( _attack_state== 0 ) {
					_attack_state = 1 ;
				}

				_attack_shake = 15 ;
				e.damage ( _dirc , _pos.z , 2 ) ;
				_hitRegist.push ( e.id ) ;
				effect.push ( e.pos.x , e.pos.z + e.pos.y ) ;

			}

		}

	}

	////////////////////////////////////
	public function damage ( Hdirc:Boolean , z:int , type:int ) :void {

		_pos.z = z ;
		_velocity.z = 0 ;

		//ノックバック弱
		if ( type == 1 ) {
			_velocity.x = (Hdirc)? -1 : 1 ;
			_velocity.y = 0 ;
			_damage_shake = 20 ;
			_damage_action = 8 + Math.floor ( Math.random() * 3 ) ;
		}

		//ノックバック強
		if ( type == 2 ) {
			_velocity.x = (Hdirc)? -3 : 3 ;
			_velocity.y = -2 ;
			_damage_shake = 5 ;
			_damage_action = 11 ;
		}

		//石ヒット
		if ( type == 3 ) {
			_velocity.x = (Hdirc)? -3 : 3 ;
			_velocity.y = -2 ;
			_damage_shake = 8 ;
			_damage_action = 11 ;
			_hp = 0 ;
			Global._world_shake = 10 ;
		}

		//死亡チェック
		if ( -- _hp <= 0 ) {
			_death = true ;
			_death_cnt = 0 ;
			_damage_action = 11 ;
			if ( _end == false ) {
				++ _score ;
			}
		}
	}

	////////////////////////////////////
	public function moveChk ( e:Hero ):void {

		if ( this == e ) {
			return ;
		}

		var V:Vector3D = _pos.subtract ( e._pos ) ;
		if ( V.length < 10 * SCALE ) {
			V.normalize();
			_velocity.x = V.x * 1 ;
			_velocity.z = V.z * 1 ;
		}

	}

	////////////////////////////////////
	public function render_shadow ( ):void {
		_shadowpos.x = _pos.x - SIZE/4/2 * SCALE ;
		_shadowpos.y = _pos.z - SIZE/8/2 * SCALE ;
		Global._canvas.copyPixels ( _shadow , _shadow.rect , _shadowpos ) ;
	}

	////////////////////////////////////
	public function render ( ):void {

		if ( _death ) {
			if ( _death_cnt % 10 < 5 ) {
				return ;
			}
		}

		_anim %= 40 ;
		_render_rect.x = Math.floor ( _anim % 8 ) * SIZE ;
		_render_rect.y = Math.floor ( _anim / 8 ) * SIZE ;

		_renderpos.x = _pos.x          - SIZE /2 ;
		_renderpos.y = _pos.z + _pos.y - SIZE ;

		if ( _damage_shake ) {
			_renderpos.x += Math.random() * 10 - 5 ;
			_renderpos.y += Math.random() * 10 - 5 ;
		}

		if ( _dirc ) {
			Global._canvas.copyPixels ( _img_r , _render_rect , _renderpos ) ;
		} else {
			Global._canvas.copyPixels ( _img   , _render_rect , _renderpos ) ;
		}

		_r.x = _renderpos.x ;
		_r.y = _renderpos.y + SIZE ;
		_r.width = SIZE ;
		_r.height = 5 ;
		Global._canvas.fillRect ( _r , 0x000000 ) ;

		_r.x = _renderpos.x + 1 ;
		_r.y = _renderpos.y + SIZE + 1 ;
		_r.width = SIZE - 2 ;
		_r.height = 5 - 2 ;
		Global._canvas.fillRect ( _r , 0xFF0000 ) ;

		_r.x = _renderpos.x + 1 ;
		_r.y = _renderpos.y + SIZE + 1 ;
		_r.width = ( SIZE * _hp / 10 ) - 2 ;
		_r.height = 5 - 2 ;
		Global._canvas.fillRect ( _r , 0x00FF00 ) ;

	}

}

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

		var common:Boolean = false ;
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

		var L:Number = Math.sqrt ( ( pos.x - _pos.x ) * ( pos.x - _pos.x ) + ( pos.y - _pos.y ) * ( pos.y - _pos.y ) + ( pos.z - _pos.z ) * ( pos.z - _pos.z ) ) ;
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

//シーンの基礎
class SceneBase extends Sprite {
	public function init( ):void { } ;
	public function core( ):void { } ;
	public function release( ):void { } ;
}

//戦闘シーン
class SceneBattle extends SceneBase {

	private var _rendering_container:Vector.<Iactor> = new Vector.<Iactor> ( ) ;
	private var _h:Vector.<Hero> = null ;
	private var _i:Vector.<Item> = null ;
	private var _mainHero:Hero = null ;
	private var _effect:Effect = null ;
	private var _scoreText:TextField = new TextField ;

	//宣伝用//////////////////////
	//	private var _S0:PushButton ;
	//	private var _S1:PushButton ;
	/////////////////////////////

	private var _limit:int = 0 ;

	////////////////////////////////////
	public function SceneBattle ( ) {

		_limit = 4000 ;

		//キャラクター用
		_h = new Vector.<Hero>;

		//アイテム用
		_i = new Vector.<Item>;
		_i.push ( new Item ( ) ) ;

		//ヒットマーク用
		_effect = new Effect ;

		//キャラクタ画像読み込み(雑魚)
		var L:Loader = new Loader;
		L.contentLoaderInfo.addEventListener ( Event.COMPLETE, compLoad ) ;
		L.contentLoaderInfo.addEventListener ( IOErrorEvent.IO_ERROR , function ():void { } ) ;
		L.load ( new URLRequest ( FILENAME ) , new LoaderContext ( true ) ) ;

		addChild ( new Bitmap ( Global._canvas ) ) ;

		//送信ボタン////////////////////////////////////////////////////

		_score = 0 ;
		_scoreText.autoSize = "left" ;
		_scoreText.defaultTextFormat = new TextFormat ( null , 50 , 0x000000 ) ;
		_scoreText.text = _score.toString () ;
		addChild ( _scoreText ) ;

		//		_S0 = new PushButton ( this, 465-100 , 0, "Ad:kuma-flashgame" ) ;
		//		_S0.addEventListener ( MouseEvent.CLICK , function ( ) :void { var url:URLRequest = new URLRequest ( "http://kuma-flashgame.blogspot.com/" ) ; navigateToURL ( url ) ; } ) ;

		//		_S1 = new PushButton ( this , 0 , 0 , "Tweet" );
		//		_S1.x = ( 465 - _S1.width  ) / 2 ;
		//		_S1.y = ( 465 - _S1.height ) / 2 ;
		//		_S1.visible = false ;
		//		_S1.addEventListener ( MouseEvent.CLICK , function ():void { navigateToURL ( new URLRequest ( "http://twitter.com/home?status=" + escapeMultiByte ( "【" + _score + "人葬りました。】http://wonderfl.net/c/A2p6 #ZAKOgame2" ) ) ); } ) ;

		//////////////////////////////////////////////////////////

		var B:BitmapData = Global._back ;

		//キャラクタ画像読み込み(雑魚)
		B.fillRect ( new Rectangle ( 0 ,    0 , B.width , B.height ) , 0x91ACCE ) ;
		B.fillRect ( new Rectangle ( 0 , ZMAX , B.width , B.height ) , 0x75D36D ) ;

//		var L2:Loader = new Loader;
//		L2.contentLoaderInfo.addEventListener ( Event.COMPLETE, compLoad2 ) ;
//		L2.contentLoaderInfo.addEventListener ( IOErrorEvent.IO_ERROR , function ():void { } ) ;
//		L2.load ( new URLRequest ( FILENAME2 ) , new LoaderContext ( true ) ) ;

	}

//	public function compLoad2 ( e:Event ) :void {
//		var B:Bitmap = e.target.content as Bitmap ;
//		Global._back.draw ( B ) ;
//	}

	////////////////////////////////////
	public override function release ( ) :void {

		//		_S1 = null ;

		_effect.release ( ) ;

		for each ( var H:Hero in _h ) {
			H.release ( ) ;
		}

		for each ( var I:Item in _i ) {
			I.release ( ) ;
		}

	}

	////////////////////////////////////
	private function compLoad( e:Event ):void {

		var B:Bitmap = e.target.content as Bitmap ;

		_mainHero = new Hero ( B ) ;
		_h.push ( _mainHero ) ;

		_h.push ( new Hero ( B , new ColorTransform ( .4 , 1 , .4 , 1 ) ) ) ;
		_h.push ( new Hero ( B , new ColorTransform (  1 , 1 , .2 , 1 ) ) ) ;
		_h.push ( new Hero ( B , new ColorTransform ( .2 , .2,  1 , 1 ) ) ) ;
		_h.push ( new Hero ( B , new ColorTransform (  1 , .2,  1 , 1 ) ) ) ;

	}

	////////////////////////////////////
	public override function core ( ):void {

		var TH1:Hero ;
		var TH2:Hero ;
		var ITEM:Item ;
		var SB:Iactor ;

		//背景
		if ( 0 < Global._world_shake ) {
			-- Global._world_shake ;
			Global._canvas.copyPixels (
				Global._back ,
				Global._back.rect ,
				new Point ( Math.random ( ) * 10 - 5 , Math.random ( ) * 10 - 5 )
			) ;
		} else {
			Global._canvas.copyPixels (
				Global._back ,
				Global._back.rect ,
				ZERO_POINT
			) ;
		}

		if ( _mainHero == null ) {
			return ;
		}

		//アイテム更新
		for each ( ITEM in _i ) {
			ITEM.update ( ) ;
		}

		//入力
		for each ( TH1 in _h ) {
			if ( TH1 == _mainHero ) {
				_mainHero.input (
					Global._key[90] ,
					Global._key[88] ,
					Global._key[37] ,
					Global._key[39] ,
					Global._key[38] ,
					Global._key[40]
				) ;
			} else {
				TH1.inputAuto() ;
			}
		}

		//更新
		for each ( TH1 in _h ) {
			TH1.update ( _i , _mainHero ) ;
		}

		//攻撃判定1
		for each ( TH1 in _h ) {
			_mainHero.attackChk ( TH1 , _effect ) ;
		}

		//攻撃判定2
		for each ( TH1 in _h ) {
			TH1.attackChk ( _mainHero , _effect ) ;
		}

		//アイテムの攻撃判定
		for each ( ITEM in _i ) {
			for each ( TH1 in _h ) {
				ITEM.attackChk ( TH1 , _effect ) ;
			}
		}

		//移動判定
		for each ( TH1 in _h ) {
			for each ( TH2 in _h ) {
				TH1.moveChk ( TH2 ) ;
			}
		}


		//描画順決定
		_rendering_container = _rendering_container.concat ( _h ) ;
		_rendering_container = _rendering_container.concat ( _i ) ;
		_rendering_container.sort ( function ( A:Iactor , B:Iactor ) :Number { return A.pos.z - B.pos.z ; } ) ;

		//影描画
		for each ( SB in _rendering_container ) {
			SB.render_shadow ( ) ;
		}

		//描画
		for each ( SB in _rendering_container ) {
			SB.render ( ) ;
		}

		while ( _rendering_container.length ) {
			_rendering_container.pop ( ) ;
		}

		_effect.update ( ) ;
		_effect.render ( ) ;

		-- _limit ;
		if ( _limit <= 0 ) {
			_limit = 0 ;
			_mainHero.setDie ( ) ;
		}

		_scoreText.text = _limit.toString () ;
		if ( _mainHero.getDeath ( ) ) {
			_end = true ;
			//			_S1.visible = true ;
		}

	}


}

//雑魚のモーション
class Hero extends CharctorBase {

	//アニメパターン
	private const $HERO_A:Array = [
		[ 0 , 1 , 2 , 3 ] , //歩く
		[ 32 , 33 , 34 , 35 , 36 , 37 ] , //走る
		[ 4 , 5 , 6 , 7 , 4 ] , //飛ぶ
		[ 8 , 9 , 9 ] , //パンチ
		[ 10 , 11 , 12 , 12 ] , //強いパンチ
		[  6 , 13 , 4 ] , //ジャンプパンチ
		[  6 , 14 , 4 ] , //ジャンプキック
		[ 29 , 15 , 15 ] , //キック
		[ 16 ] , //弱ダメージ
		[ 17 ] , //中ダメージ
		[ 18 ] , //強ダメージ
		[ 19 , 20 , 21 , 22 , 22 ] , //ダウン
		[ 7 , 4 ] ,//落下
		[ 25 , 26 , 27 , 0 ] , //投擲
		[ 4  ,  5 ,  6 ,  7 , 4 ] , //ステップ
		[ 8 , 9 , 9 ] , //パンチ２段目
		[ 24 ] , //石ひろい
	];

	//ウェイト
	private const $HERO_B:Array = [
		[ 8 , 8 , 8 , 8 ] , //歩く
		[ 5 , 5 , 5 , 5 , 5 , 5 ] , //走る
		[ 8 , 2 , 5 , 2 , 5 ] , //飛ぶ
		[ 3 , 1 , 16 ] , //パンチ
		[ 3 , 3 , 7 , 20 ] , //強いパンチ
		[ 2 , 2 , 5 ] , //ジャンプパンチ
		[ 2 , 2 , 5 ] , //ジャンプキック
		[ 2 , 2 , 22 ] , //キック
		[ 15 ] , //弱ダメージ
		[ 15 ] , //中ダメージ
		[ 15 ] , //強ダメージ
		[ 9 , 9 , 9 , 9 , 15 ] , //ダウン
		[ 2 , 5 ] ,//落下
		[ 7 , 4 , 12 , 5 ] , //投擲
		[ 2 , 2 , 5 , 2 , 5 ] , //ステップ
		[ 3 , 1 , 16 ] ,//パンチ２段目
		[ 50 ] , //石ひろい
	] ;

	//入力の許可 1=移動 + 2=攻撃 + 4=ジャンプ + 8=投擲 + 16=ステップ + 32 = 慣性操作
	private const $HERO_C:Array = [
		[ 15, 15, 15, 15] , //歩く
		[ 15, 15, 15, 15, 15, 15] , //走る
		[ 16, 2 , 2 , 2 , 0 ] , //飛ぶ
		[ 0 , 0 , 18 ] , //パンチ
		[ 0 , 0 , 16 , 16 ] , //強いパンチ
		[ 0 , 2 , 16 ] , //ジャンプパンチ
		[ 0 , 0 , 16 ] , //ジャンプキック
		[ 0 , 0 , 18 ] , //キック
		[ 0 ] , //弱ダメージ
		[ 0 ] , //中ダメージ
		[ 0 ] , //強ダメージ
		[ 0 , 0 , 0 , 0 , 0 ] , //ダウン
		[ 0 , 0 ] ,//落下
		[ 0 , 0 , 0 , 0 ] , //投擲
		[ 0 , 34 , 34 , 34 , 16 ] , //ステップ
		[ 0 , 0 , 2 ] , //パンチ２段目
		[ 0 ] , //石ひろい
	] ;

	//アニメーションの条件 0=ウェイト 1=_velocity.yが+方向 2=地面に接地 3=体力が0だとアニメーション終了。
	private const $HERO_D:Array = [
		[ 0 , 0 , 0 , 0 ] , //歩く
		[ 0 , 0 , 0 , 0 , 0 , 0 ] , //走る
		[ 0 , 1 , 0 , 2 , 0 ] , //飛ぶ
		[ 0 , 0 , 0 ] , //パンチ
		[ 0 , 0 , 0 , 0 ] , //強いパンチ
		[ 0 , 2 , 0 ] , //ジャンプパンチ
		[ 0 , 2 , 0 ] , //ジャンプキック
		[ 0 , 0 , 0 ] , //キック
		[ 0 ] , //弱ダメージ
		[ 0 ] , //中ダメージ
		[ 0 ] , //強ダメージ
		[ 0 , 0 , 0 , 0 , 3 ] , //ダウン
		[ 2 , 0 ] ,//落下
		[ 0 , 0 , 0 , 0 ] , //投擲
		[ 0 , 0 , 0 , 2 , 0 ] , //ステップ
		[ 0 , 0 , 0 ] , //パンチ２段目
		[ 0 ] , //石ひろい
	] ;

	//アニメーション切り替わりの際の特殊動作ＩＤ 1=ジャンプ 2=[歩くor落下]状態に戻る 3=飛び道具発生 4=ステップ移動 5=振り向き判定
	private const $HERO_E:Array = [
		[ 0 , 0 , 0 , 0 ] , //歩く
		[ 0 , 0 , 0 , 0 , 0 , 0 ] , //走る
		[ 1 , 0 , 0 , 0 , 2 ] , //飛ぶ
		[ 5 , 0 , 2 ] , //パンチ
		[ 0 , 0 , 0 , 2 ] , //強いパンチ
		[ 0 , 0 , 2 ] , //ジャンプパンチ
		[ 0 , 0 , 2 ] , //ジャンプキック
		[ 5 , 0 , 2 ] , //キック
		[ 2 ] , //弱ダメージ
		[ 2 ] , //中ダメージ
		[ 2 ] , //強ダメージ
		[ 0 , 0 , 0 , 0 , 2 ] , //ダウン
		[ 0 , 2 ] ,//落下
		[ 0 , 3 , 0 , 2 ] , //投擲
		[ 4 , 0 , 0 , 0 , 2 ] , //ステップ
		[ 5 , 0 , 2 ] ,//パンチ２段目
		[ 2 ] , //石ひろい
	] ;

	//攻撃判定
	private const $HERO_F:Array = [
		[ 0 , 0 , 0 , 0 ] , //歩く
		[ 0 , 0 , 0 , 0 , 0 , 0 ] , //走る
		[ 0 , 0 , 0 , 0 , 0 ] , //飛ぶ
		[ 0 , 1 , 0 ] , //パンチ
		[ 0 , 0 , 2 , 0 ] , //強いパンチ
		[ 0 , 1 , 0 ] , //ジャンプパンチ
		[ 0 , 2 , 0 ] , //ジャンプキック
		[ 0 , 1 , 0 ] , //キック
		[ 0 ] , //弱ダメージ
		[ 0 ] , //中ダメージ
		[ 0 ] , //強ダメージ
		[ 0 , 0 , 0 , 0 , 0 ] , //ダウン
		[ 0 , 0 ] ,//落下
		[ 0 , 0 , 2 , 0 ] , //投擲
		[ 0 , 0 , 0 , 0 , 0 ] , //ステップ
		[ 0 , 1 , 0 ] ,//パンチ２段目
		[ 0 ] , //石ひろい
	] ;

	public function Hero ( B:Bitmap , C:ColorTransform = null ) :void {
		super ( B , C , $HERO_A , $HERO_B , $HERO_C , $HERO_D , $HERO_E , $HERO_F ) ;
	}

}

////////////////////////////////////
const FILENAME:String = "actor.png" ;
//const FILENAME2:String = "http://assets.wonderfl.net/images/related_images/3/37/37b4/37b4ec1f74efac5568eedd817dab449d42ff1eb4" ;
const ZERO_POINT:Point = new Point ( 0 , 0 ) ;
const ZMAX:int = 300 ;
var _score:uint = 0 ;
var _end:Boolean = false ;
