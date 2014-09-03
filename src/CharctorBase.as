package
{
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;



	//
	public class CharctorBase extends ActorParam implements Iactor {

		public static var _score:uint = 0 ;
		public static var _end:Boolean = false ;

		public const ZMAX:int = 300 ;


		//アニメーションテーブル
		private var $A:Array = null ;
		private var $B:Array = null ;
		private var $C:Array = null ;
		private var $D:Array = null ;
		private var $E:Array = null ;
		private var $F:Array = null ;

		//体力
		private var _hp:int = 0 ;
		public var _death:Boolean = false ;
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
}