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

		/**
		 * 最大允许的宽度纵深
		 */
		public const ZMAX:int = 300 ;


		//アニメーションテーブル
		private var motionToAssetFrameIds:Array = null ;
		private var motionToWeight:Array = null ;
		private var motionToInputAllowance:Array = null ;
		private var $D:Array = null ;
		private var motionContinue:Array = null ;
		private var motionToHitDetection:Array = null ;

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

		// 跳跃管理
		private var _jump_state:Boolean = false;

		//攻撃管理
		private var _attack_state:int = 0 ; //連続技判定
		private var _attack_shake:int = 0 ;
		private var _hitRegist:Vector.<int> = new Vector.<int> ;

		//被ダメージ管理  伤害管理
		private var _damage_action:int = 0 ;
		private var _damage_shake:int = 0 ;

		//入力チェック用  输入检查
		private var _input_attack:int = 0 ;
		private var _input_jump  :int = 0 ;
		private var _inputLeft:int = 0 ;
		private var _inputRight:int = 0 ;
		private var _inputUp:int = 0 ;
		private var _inputDown:int = 0 ;
		private var _command1:int = 0 ;
		private var _command1CNT:int = 0 ;
		private var _command2:int = 0 ;
		private var _command2CNT:int = 0 ;
		private var _stepPower:Number = 0 ;
		private var _lastAtkChk:int = 0 ;

		private var _r:Rectangle = new Rectangle ( ) ;

		////////////////////////////////////
		public function CharctorBase ( srcCharacterAtlasBitmap:Bitmap , colorTransform:ColorTransform , _motionToAssetFrameIds:Array , _motionToWeight:Array , _motionToInputAllowance:Array , $$D:Array , _motionContinue:Array , _motionToHitDetection:Array ) {

			super ( srcCharacterAtlasBitmap , colorTransform , 64 ) ;

			motionToAssetFrameIds = _motionToAssetFrameIds ;
			motionToWeight = _motionToWeight ;
			motionToInputAllowance = _motionToInputAllowance ;
			$D = $$D ;
			motionContinue = _motionContinue ;
			motionToHitDetection = _motionToHitDetection ;

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


		/**
		 * 玩家操作输入
		 * @param keyA
		 * @param keyJ
		 * @param keyL
		 * @param keyR
		 * @param keyU
		 * @param keyD
		 *
		 */
		public function input (
			keyA:Boolean , //攻撃ボタン   攻击按钮
			keyJ:Boolean , //ジャンプボタン  跳转按钮
			keyL:Boolean , //左
			keyR:Boolean , //右
			keyU:Boolean , //上
			keyD:Boolean   //下
		):void {

			if ( keyA ) { ++ _input_attack ; } else { _input_attack = 0 ; }
			if ( keyJ ) { ++ _input_jump ; }   else { _input_jump = 0 ; }
			if ( keyL ) { ++ _inputLeft ; } else { _inputLeft = 0 ; }
			if ( keyR ) { ++ _inputRight ; } else { _inputRight = 0 ; }
			if ( keyU ) { ++ _inputUp ; } else { _inputUp = 0 ; }
			if ( keyD ) { ++ _inputDown ; } else { _inputDown = 0 ; }
			_target_x = _pos.x + ( (_inputLeft) ? -50 : 0 ) + ( (_inputRight) ? 50 : 0 ) + ( (_dirc)? -1 : 1 ) ;
			_target_z = _pos.z + ( (_inputUp) ? -50 : 0 ) + ( (_inputDown) ? 50 : 0 ) + ( (_dirc)? -1 : 1 ) ;

			//左方向ステップ////////////////////////////////////////////////
			++ _command1CNT;
			if ( 10 < _command1CNT ) { _command1 = 0 ; }
			if ( _input_jump == 1 && _command1 == 0 )                      { _command1 = 2 ; _command1CNT = 0; }
			if ( _inputLeft     == 1 && _command1 == 2 && _command1CNT < 10 ) { _command1 = 3 ; _command1CNT = 0; }

			//右方向ステップ////////////////////////////////////////////////
			++ _command2CNT;
			if ( 10 < _command2CNT ) { _command2 = 0 ; }
			if ( _input_jump == 1 && _command2 == 0 )                      { _command2 = 2 ; _command2CNT = 0; }
			if ( _inputRight     == 1 && _command2 == 2 && _command2CNT < 10 ) { _command2 = 3 ; _command2CNT = 0; }

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

			var isChecked:Boolean = true ;
			var currentInputAllowance:int = motionToInputAllowance[_action][_actionstep] ;
			var currentAction:int = _action;
			var currentActionStep:int = _actionstep;
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

				isChecked = false ;
				-- _damage_shake ;

				for ( I = 0 ; I < item.length ; ++ I ) {

					//石を持っていたら落としてしまう  持续僵直
					if ( item[J].isreservation ( id ) ) {
						item[J].drop ( _pos ) ;
						break;
					}

				}

			}

			if ( 0 < _attack_shake ) {
				isChecked = false ;
				-- _attack_shake ;
			}

			{//入力の反映

				if ( 1 & currentInputAllowance ) {

					X = _pos.x - _target_x ;
					Y = _pos.z - _target_z ;
					L = X * X + Y * Y ;
					_action = ( 10 * 10 < L ) ? 1 : 0 ;
					_attack_state = 0 ;

				}

				if ( 2 & currentInputAllowance ) {

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

				if ( 4 & currentInputAllowance ) {
					if ( _input_jump == 1 ) {
						_action = 2 ;
						_animwait = 0 ;
					}
				}

				if ( 8 & currentInputAllowance ) {

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

				if ( 16 & currentInputAllowance ) {

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

				if ( 32 & currentInputAllowance ) {
					//ブレーキ
					if ( _inputLeft ) { if ( 0 < _velocity.x ) _velocity.x *= .9 ; }
					if ( _inputRight ) { if ( _velocity.x < 0 ) _velocity.x *= .9 ; }
				}

				//強制動作
				if ( _damage_action ) {
					_action = _damage_action ;
					_damage_action = 0 ;
				}

				if ( currentAction != _action ) {
					_actionstep = 0 ;
					_animwait = 0 ;
				}

			}

			if ( isChecked )
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

				if ( motionToWeight[_action][_actionstep] <= _animwait ) {

					_animwait = 0 ;

					var jumpPower:Number = 0 ;
					if ( _inputLeft != 0 ) { jumpPower = -3; }
					if ( _inputRight != 0 ) { jumpPower =  3; }

					switch ( motionContinue[_action][_actionstep] ) {
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
						case 5: _dirc = ( _inputLeft ) ? true : ( (_inputRight) ? false : _dirc ) ; break;
						default: break;
					}

					if ( motionToAssetFrameIds[_action].length <= ++ _actionstep ) {
						_actionstep = 0 ;
					}

					while ( _hitRegist.length ) {
						_hitRegist.pop () ;
					}

				}

			}

			if ( isChecked && ( 1 & currentInputAllowance ) )
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

			if ( isChecked )
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

			_anim = motionToAssetFrameIds[_action][_actionstep] ;

		}

		////////////////////////////////////
		public function attackChk ( attacker:Hero , effect:Effect ):void {

			if ( this == attacker ) {
				return ;
			}

			if ( attacker._death ) {
				return ;
			}

			for each ( var N:int in _hitRegist ) {
				if ( N == attacker.id ) {
					return ;
				}
			}

			var temp:int = motionToHitDetection[_action][_actionstep] ;

			//弱い攻撃
			if ( temp == 1 ) {

				if ( _lastAtkChk == 0 ) {
					_lastAtkChk = 1 ;
				}

				var V1:Vector3D = _pos.subtract ( attacker._pos ) ;

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

					attacker.damage ( _dirc , _pos.z , 1 ) ;
					_hitRegist.push ( attacker.id ) ;
					effect.push ( attacker.pos.x , attacker.pos.z + attacker.pos.y ) ;

				}

			}

			//強い攻撃
			if ( temp == 2 ) {

				if ( _lastAtkChk == 0 ) {
					_lastAtkChk = 2 ;
				}

				var V2:Vector3D = _pos.subtract ( attacker._pos ) ;

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
					attacker.damage ( _dirc , _pos.z , 2 ) ;
					_hitRegist.push ( attacker.id ) ;
					effect.push ( attacker.pos.x , attacker.pos.z + attacker.pos.y ) ;

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
			_shadowpos.x = _pos.x - scaledSize/4/2 * SCALE ;
			_shadowpos.y = _pos.z - scaledSize/8/2 * SCALE ;
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
			_render_rect.x = Math.floor ( _anim % 8 ) * scaledSize ;
			_render_rect.y = Math.floor ( _anim / 8 ) * scaledSize ;

			_renderpos.x = _pos.x          - scaledSize /2 ;
			_renderpos.y = _pos.z + _pos.y - scaledSize ;

			if ( _damage_shake ) {
				_renderpos.x += Math.random() * 10 - 5 ;
				_renderpos.y += Math.random() * 10 - 5 ;
			}

			if ( _dirc ) {
				Global._canvas.copyPixels ( imgCharacterFlipped , _render_rect , _renderpos ) ;
			} else {
				Global._canvas.copyPixels ( imgCharacter   , _render_rect , _renderpos ) ;
			}

			_r.x = _renderpos.x ;
			_r.y = _renderpos.y + scaledSize ;
			_r.width = scaledSize ;
			_r.height = 5 ;
			Global._canvas.fillRect ( _r , 0x000000 ) ;

			_r.x = _renderpos.x + 1 ;
			_r.y = _renderpos.y + scaledSize + 1 ;
			_r.width = scaledSize - 2 ;
			_r.height = 5 - 2 ;
			Global._canvas.fillRect ( _r , 0xFF0000 ) ;

			_r.x = _renderpos.x + 1 ;
			_r.y = _renderpos.y + scaledSize + 1 ;
			_r.width = ( scaledSize * _hp / 10 ) - 2 ;
			_r.height = 5 - 2 ;
			Global._canvas.fillRect ( _r , 0x00FF00 ) ;

		}

	}
}