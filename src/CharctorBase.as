package
{
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	//
	public class CharctorBase extends ActorParam implements Iactor {

		public static const WAIT_TO_REVIVE:uint = 60;

		public static var _end:Boolean = false ;

		public static var _score:uint = 0 ;

		////////////////////////////////////
		public function CharctorBase ( srcCharacterAtlasBitmap:Bitmap , colorTransform:ColorTransform , _motionToAssetFrameIds:Array , _motionToWeight:Array , _motionToInputAllowance:Array , _playheadCondition:Array , _motionContinue:Array , _motionToHitDetection:Array ) {

			super ( srcCharacterAtlasBitmap , colorTransform , 64 ) ;

			motionToAssetFrameIds = _motionToAssetFrameIds ;
			motionToWeight = _motionToWeight ;
			motionToInputAllowance = _motionToInputAllowance ;
			playheadCondition = _playheadCondition ;
			motionContinue = _motionContinue ;
			motionToHitDetection = _motionToHitDetection ;

			_hp = 10 ;
			isDead = false ;
			countAfterDeath = 0 ;
			input ( false , false , false , false , false , false ) ;

		}

		/**
		 * 最大允许的宽度纵深
		 */
		public static const ZMAX:int = 300 ;
		public static const XMAX:int = 465 ;
		public static const YMAX:int = 465 ;

		public var isDead:Boolean = false ;
		private var playheadCondition:Array = null ;
		private var _action:int = 0 ;
		private var _actionstep:int = 0 ;

		//アニメーション用 动画用
		private var _anim:int = 0 ;

		// 在当前的动作帧上停留了多少次
		private var frameWaitCount:int = 0 ;

		private var _attack_shake:int = 0 ;

		//攻撃管理
		private var _attack_state:int = 0 ; //連続技判定
		private var _commandLeft:int = 0 ;
		private var _commandLeftCNT:int = 0 ;
		private var _commandRight:int = 0 ;
		private var _commandRightCNT:int = 0 ;

		//被ダメージ管理  伤害管理
		private var _damage_action:int = 0 ;
		private var _damage_shake:int = 0 ;
		private var countAfterDeath:int = 0;
		private var _isFlipX:Boolean = false;
		private var _hitRegist:Vector.<int> = new Vector.<int> ;

		//体力
		private var _hp:int = 0 ;

		private var _inputDown:int = 0 ;
		private var _inputLeft:int = 0 ;
		private var _inputRight:int = 0 ;
		private var _inputUp:int = 0 ;

		// 攻击按钮持续按下次数 入力チェック用  输入检查
		private var _input_attack:int = 0 ;

		//入力用
		private var _input_damage:Boolean = false ;

		// 跳跃按钮持续按下次数 入力チェック用  输入检查
		private var _input_jump  :int = 0 ;

		// 跳跃管理
		private var _jump_state:Boolean = false;

		// 上一次攻击检查时候检查出来的攻击类型
		private var _lastAtkChk:int = 0 ;

		private var _r:Rectangle = new Rectangle ( ) ;
		private var _speed:Number = 0 ;


		private var bonceSpeed:Number = 0 ;
		private var _target_x:int = 0 ;
		private var _target_z:int = 0 ;
		private var motionContinue:Array = null ;


		//アニメーションテーブル
		private var motionToAssetFrameIds:Array = null ;
		private var motionToHitDetection:Array = null ;
		private var motionToInputAllowance:Array = null ;
		private var motionToWeight:Array = null ;

		/**
		 * 攻击判定
		 * @param attacker
		 * @param effect
		 */
		public function attackChk ( attacker:Hero , effect:Effect ):void {

			if ( this == attacker ) return ;

			if ( attacker.isDead ) return ;


			for each ( var N:int in _hitRegist ) {
				// 在一个计算周期里面一个人只能被同一个人攻击一次
				if ( N == attacker.id ) {
					return ;
				}
			}

			var punchType:int = motionToHitDetection[_action][_actionstep] ;

			//弱い攻撃
			if ( punchType == PunchType.S ) {

				if ( _lastAtkChk == 0 ) {
					_lastAtkChk = 1 ;
				}

				var V1:Vector3D = _pos.subtract ( attacker._pos ) ;

				if ( _isFlipX ) {
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

					attacker.damage ( _isFlipX , _pos.z , punchType ) ;
					_hitRegist.push ( attacker.id ) ;
					effect.push ( attacker.pos.x , attacker.pos.z + attacker.pos.y ) ;

				}

			}

			//強い攻撃
			if ( punchType == PunchType.M ) {

				if ( _lastAtkChk == 0 ) {
					_lastAtkChk = 2 ;
				}

				var V2:Vector3D = _pos.subtract ( attacker._pos ) ;

				if ( _isFlipX ) {
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
					attacker.damage ( _isFlipX , _pos.z , punchType ) ;
					_hitRegist.push ( attacker.id ) ;
					effect.push ( attacker.pos.x , attacker.pos.z + attacker.pos.y ) ;

				}

			}

		}

		////////////////////////////////////
		/**
		 * 被伤害
		 * @param isFlipX   打击者是否是 x 镜像
		 * @param z			打击者的 z 坐标
		 * @param punchType 打击类型
		 */
		public function damage ( isFlipX:Boolean , z:int , punchType:int ) :void {

			_pos.z = z ;
			_velocity.z = 0 ;

			switch(punchType)
			{
				case PunchType.S:
				{
					_velocity.x = ((isFlipX)? -1 : 1) * PunchType.getSpeedPowerXByType(punchType) ;
					_velocity.y = 0 ;
					// _damage_shake = 20 ;
					_damage_shake = PunchType.getDamageShakeByType(punchType);
					_damage_action = Motions.getRandomDamageMotion();
					break;
				}
				case PunchType.M:
				{
					_velocity.x = ((isFlipX)? -1 : 1) * PunchType.getSpeedPowerXByType(punchType) ;
					// _velocity.x = (isFlipX)? -3 : 3 ;
					_velocity.y = -2 ;
					// _damage_shake = 5 ;
					_damage_shake = PunchType.getDamageShakeByType(punchType);
					_damage_action = Motions.KNOCK_DOWN ;
					break;
				}
				case PunchType.L:
				{
					_velocity.x = ((isFlipX)? -1 : 1) * PunchType.getSpeedPowerXByType(punchType) ;
					// _velocity.x = (isFlipX)? -3 : 3 ;
					_velocity.y = -2 ;
					// _damage_shake = 8 ;
					_damage_shake = PunchType.getDamageShakeByType(punchType);
					_damage_action = Motions.KNOCK_DOWN ;
					_hp = 0 ;
					Global._world_shake = 10 ;
					break;
				}
				default:
				{
					throw(new Error("uknown punchType:"+punchType));
				}
			}

			trace("[CharctorBase.damage] punchType:"+punchType+"; _damage_shake:"+_damage_shake + "; _velocity.x:"+_velocity.x);

			//死亡チェック
			if ( -- _hp <= 0 ) {
				isDead = true ;
				countAfterDeath = 0 ;
				_damage_action = Motions.KNOCK_DOWN ;
				if ( _end == false ) {
					++ _score ;
				}
			}
		}

		////////////////////////////////////
		public function getDeath ( ) :Boolean {
			return isDead ;
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
			_target_x = _pos.x + ( (_inputLeft) ? -50 : 0 ) + ( (_inputRight) ? 50 : 0 ) + ( (_isFlipX)? -1 : 1 ) ;
			_target_z = _pos.z + ( (_inputUp) ? -50 : 0 ) + ( (_inputDown) ? 50 : 0 ) + ( (_isFlipX)? -1 : 1 ) ;

			// 向左突进 搓键
			++ _commandLeftCNT;
			if ( 10 < _commandLeftCNT ) {
				_commandLeft = 0 ;
			}
			if ( _input_jump == 1 && _commandLeft == 0 ){
				_commandLeft = 2 ;
				_commandLeftCNT = 0;
			}
			if ( _inputLeft     == 1 && _commandLeft == 2 && _commandLeftCNT < 10 ) {
				_commandLeft = 3 ;
				_commandLeftCNT = 0;
			}

//			trace("[CharctorBase.input] _command1CNT:"+_command1CNT+"; _command1:"+_command1);

			// 向右突进 搓键
			++ _commandRightCNT;
			if ( 10 < _commandRightCNT ){
				_commandRight = 0 ;
			}

			if ( _input_jump == 1 && _commandRight == 0 ){
				_commandRight = 2 ; _commandRightCNT = 0;
			}
			if ( _inputRight     == 1 && _commandRight == 2 && _commandRightCNT < 10 ) {
				_commandRight = 3 ; _commandRightCNT = 0;
			}

//			trace("[CharctorBase.input] _command2CNT:"+_command2CNT+"; _command2:"+_command2);
//			trace("[CharctorBase.input] ------------------------------------------");
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
				if ( _target_z < ZMAX ) _target_z = ZMAX;
				if ( _target_x > XMAX ) _target_x = XMAX;
				if ( _target_z > 465 ) _target_z = 465;
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
		public function render ( ):void {

			if ( isDead ) {
				if ( countAfterDeath % 10 < 5 ) {
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

			if ( _isFlipX ) {
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

		////////////////////////////////////
		public function render_shadow ( ):void {
			_shadowpos.x = _pos.x - scaledSize/4/2 * SCALE ;
			_shadowpos.y = _pos.z - scaledSize/8/2 * SCALE ;
			Global._canvas.copyPixels ( _shadow , _shadow.rect , _shadowpos ) ;
		}


		////////////////////////////////////
		public function setDie ( ) :void {
			if ( isDead == false ) {
				isDead = true ;
				countAfterDeath = 0 ;
				_damage_action = 11 ;
				_hp = 0 ;
			}
		}

		// 复活重生
		public function revive():void{
			// 死亡足够长时间以后，从高处掉落下来重生
			_hp = 10 ;
			isDead = false ;
			countAfterDeath = 0 ;

			_pos.x = Math.random() * 465 ;
			_pos.y = -500 ;
			_pos.z = 365 ;
			_velocity.y = 0 ;

			_action = Motions.FALL ;
		}


		public function dropItem(items:Vector.<Item>):void{

			// 被打击时候掉落已经拾取的道具
			for ( var i:int = 0 ; i < items.length ; ++ i ) {

				//石を持っていたら落としてしまう  持续僵直
				if ( items[i].isreservation ( id ) ) {
					items[i].drop ( _pos ) ;
					break;
				}
			}
		}

		////////////////////////////////////
		public function update ( items:Vector.<Item> , mainHero:CharctorBase ):void {

			var isResponsible:Boolean = true ;  /* true: 可操控， false: 僵直 */
			var currentInputAllowance:int = motionToInputAllowance[_action][_actionstep] ;
			var currentAction:int = _action;
			var currentActionStep:int = _actionstep;

			var X:Number = 0 ;
			var Y:Number = 0 ;
			var L:Number = 0 ;
			var I:int = 0 ;

			if(isDead && WAIT_TO_REVIVE < ++ countAfterDeath && this != mainHero ) revive();

			if ( 0 < _damage_shake ) { /* 处理被打僵直 */
				isResponsible = false ;
				-- _damage_shake ;
				dropItem(items);
			}

			if ( 0 < _attack_shake ) { /* 处理出拳僵直 */
				isResponsible = false ;
				-- _attack_shake ;
			}

			{// 处理玩家

				// if ( 1 & currentInputAllowance ) {
				if ( InputAllowance.MOVE & currentInputAllowance ) {

					X = _pos.x - _target_x ;
					Y = _pos.z - _target_z ;
					L = X * X + Y * Y ;
					_action = ( 10 * 10 < L ) ? Motions.RUN : Motions.STAND ;
					_attack_state = 0 ;

				}

				// if ( 2 & currentInputAllowance ) {
				if ( InputAllowance.ATTACK & currentInputAllowance ) {

					if ( _input_attack == 1 ) {

						//最後の攻撃判定が誰にもヒットしていない場合、連続技判定をリセットする
						// If the judgment of the attack last not hit anyone, I want to reset the continuous maneuver checks
						if ( _lastAtkChk != -1 ) {
							_attack_state = 0 ;
						}

						_lastAtkChk = 0 ;

						if ( _jump_state ) {

							switch ( _attack_state ) {
								case 1 : _attack_state = 2 ;  _action = Motions.ATTACK_IN_AIR1 ; frameWaitCount = 0 ; break ;
								default: _attack_state = 1 ;  _action = Motions.ATTACK_IN_AIR2 ; frameWaitCount = 0 ; break ;
							}

						} else {

							switch ( _attack_state ) {
								case 0 : _attack_state = 0 ; _action = Motions.PUNCH1 ; frameWaitCount = 0 ; /*連打キャンセル*/_actionstep= 0;  break ;
								case 1 : _attack_state = 2 ; _action = Motions.PUNCH2 ; frameWaitCount = 0 ; break ;
								case 2 : _attack_state = 3 ; _action = Motions.PUNCH3_KICK ; frameWaitCount = 0 ; break ;
								case 3 : _attack_state = 4 ; _action = Motions.PUNCH4_COLLIDE ; frameWaitCount = 0 ; break ;
							}
						}

					}

				}

				// if ( 4 & currentInputAllowance ) {
				if ( InputAllowance.JUMP & currentInputAllowance ) {
					if ( _input_jump == 1 ) {
						// _action = 2 ;
						_action = Motions.TAKE_OFF ;
						frameWaitCount = 0 ;
					}
				}

				// if ( 8 & currentInputAllowance ) {
				if ( InputAllowance.THROW & currentInputAllowance ) {

					if ( _input_attack == 1 ) {

						var J:int = 0 ;

						if ( _attack_state == 0 && _jump_state == 0 ) {

							for ( J = 0 ; J < items.length ; ++ J ) {

								//石を持っていたら投げる  Throw if you have a stone
								if ( items[J].isreservation ( id ) ) {
									// _action = 13 ;
									_action = Motions.THROW ;
									frameWaitCount = 0 ;
									break;
								}

								//足元に石があると拾う  I pick up that there is a stone at the feet
								if ( items[J].chk_distance ( _pos ) ) {
									items[J].reservation ( id ) ;
									_action = Motions.PICK_UP ;
									frameWaitCount = 0 ;
									break;
								}
							}

						}

					}

				}

				// if ( 16 & currentInputAllowance ) {
				if ( InputAllowance.BOUNCE & currentInputAllowance ) {

					if ( _commandLeft == 3 ) {
						_commandLeft = 0 ;
						// _action = 14 ;
						_action = Motions.BOUNCE ;
						frameWaitCount = 0 ;
						bonceSpeed = -4 ;
						_attack_shake = 0;
						_attack_state = 0;
					}

					if ( _commandRight == 3 ) {
						_commandRight = 0 ;
						// _action = 14 ;
						_action = Motions.BOUNCE ;
						frameWaitCount = 0 ;
						bonceSpeed = 4 ;
						_attack_shake = 0;
						_attack_state = 0;
					}

				}

				// if ( 32 & currentInputAllowance ) {
				if ( InputAllowance.INERTIA & currentInputAllowance ) {
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
					frameWaitCount = 0 ;
				}

			}

			if ( isResponsible )
			{//アニメーション   Animation

				var TD:int = playheadCondition[_action][_actionstep];
				switch ( TD ) {

					// case 0 :
					case PlayheadCondition.WHATEVER :
						++ frameWaitCount;
						break ;

					// case 1 :
					case PlayheadCondition.ONLY_IN_AIR :
						if ( 0 < _velocity.y ) {
							++ frameWaitCount ;
						}
						break ;

					// case 2:
					case PlayheadCondition.ONLY_ON_GROUND:
						if ( false == _jump_state ) {
							++ frameWaitCount ;
						}
						break;

					// case 3:
					case PlayheadCondition.IS_ALIVE:
						if ( 0 < _hp ) {
							++ frameWaitCount;
						}
						break;
				}

				if ( motionToWeight[_action][_actionstep] <= frameWaitCount ) {

					frameWaitCount = 0 ;

					var jumpPower:Number = 0 ;
					if ( _inputLeft != 0 ) { jumpPower = -3; }
					if ( _inputRight != 0 ) { jumpPower =  3; }

					switch ( motionContinue[_action][_actionstep] ) {
						case 1: _velocity.y = -5 ; _velocity.x = jumpPower; break;
						case 2: _action = ( _jump_state) ? Motions.FALL : Motions.STAND ; break ;
						case 3:
						{
							for ( var P:int = 0 ; P < items.length ; ++ P ) {
								if ( items[P].isreservation (id) ) {
									items[P].have ( _pos , new Vector3D ( ( _isFlipX) ? -8 : 8 , -3 , 0 ) , _isFlipX ) ;
								}
							}
						}
							break;
						case 4: _velocity.y = -2 ; _velocity.x = bonceSpeed; break;
						case 5: _isFlipX = ( _inputLeft ) ? true : ( (_inputRight) ? false : _isFlipX ) ; break;
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

			if ( isResponsible && ( InputAllowance.MOVE & currentInputAllowance ) )
			{//加速

				_isFlipX = ( _target_x < _pos.x ) ;

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

			if ( isResponsible )
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
	}
}