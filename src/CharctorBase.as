package
{
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	//
	public class CharctorBase extends ActorParam implements Iactor {

		public static const WAIT_TO_REVIVE:uint = 60;

		public static const XMAX:int = 465 ;

		public static const YMAX:int = 465 ;

		public static const ZMAX:int = 300 ;

		public static const TARGET_OFFSET:int = 50 ;

		public static var _end:Boolean = false ;

		public static var _score:uint = 0 ;

		/* 命中检查时候的x坐标补偿值 */
		public static const HIT_CHECK_X_ADJUST:int = 8;

		/* 命中检查的最大允许距离 */
		public static const HIT_DETECT_MAX_DISTANCE:int = 30;

		/* 距离移动目标点的判定的 最小距离 */
		public static const MIN_DISTANCE_TO_TARGET:int = 10


		////////////////////////////////////
		public function CharctorBase ( srcCharacterAtlasBitmap:Bitmap , colorTransform:ColorTransform ){

			super ( srcCharacterAtlasBitmap , colorTransform , 64 ) ;
			hp = 10 ;
			isDead = false ;
			countAfterDeath = 0 ;
			input ( false , false , false , false , false , false ) ;
		}

		public var isDead:Boolean = false ;
		private var motion:String = Motion.STAND ;
		private var motionStep:int = 0 ;

		//アニメーション用 动画用
		private var assetFrame:int = 0 ;

		private var shakeWhenAttack:int = 0 ;

		//攻撃管理
		private var attackState:int = 0 ; //連続技判定
		private var commandLeft:int = 0 ;
		private var commandLeftCNT:int = 0 ;
		private var commandRight:int = 0 ;
		private var commandRightCNT:int = 0 ;

		//被ダメージ管理  伤害管理
		private var motionWhenDamag:String;
		private var shakeWhenDamage:int = 0 ;
		private var hitRegister:Vector.<int> = new Vector.<int> ;

		//体力
		private var hp:int = 0 ;

		private var inputDown:int = 0 ;
		private var inputLeft:int = 0 ;
		private var inputRight:int = 0 ;
		private var inputUp:int = 0 ;

		// 攻击按钮持续按下次数 入力チェック用  输入检查
		private var inputAttack:int = 0 ;

		// 跳跃按钮持续按下次数 入力チェック用  输入检查
		private var inputJump  :int = 0 ;
		private var isFlipX:Boolean = false;

		// 跳跃管理
		private var isInAir:Boolean = false;

		// 上一次攻击检查时候检查出来的攻击类型
		private var isLastAttackHit:Boolean = false;

		private var _r:Rectangle = new Rectangle ( ) ;

		private var speed:Number = 0 ;
		private var targetX:int = 0 ;
		private var targetZ:int = 0 ;

		/* 平跳突进的速度 */
		private var bonceSpeed:Number = 0 ;

		private var countAfterDeath:int = 0;

		// 在当前的动作帧上停留了多少次
		private var frameWaitCount:int = 0 ;

		/**
		 * 攻击判定
		 * @param attacker
		 * @param effect
		 */
		public function attackChk ( attacker:Hero , effect:Effect ):void {

			if ( this == attacker ) return ;

			if ( attacker.isDead ) return ;


			for each ( var N:int in hitRegister ) {
				// 在一个计算周期里面一个人只能被同一个人攻击一次
				if ( N == attacker.id ) {
					return ;
				}
			}

			var diff:Vector3D;
			// var punchType:int = motionToHitDetection[_action][_actionstep] ;
			var punchType:int = HeroConfigObj.getAttackType(motion, motionStep);
//				motionToHitDetection[_action][_actionstep] ;

			//弱い攻撃
			if ( punchType == PunchType.S ) {

//				if ( _lastAtkChk == 0 ) {_lastAtkChk = 1 ;}
				// isLastAttackHit = false;

				diff = _pos.subtract ( attacker._pos ) ;

				if ( isFlipX ) {
					diff.x -= HIT_CHECK_X_ADJUST * SCALE ;
				} else {
					diff.x += HIT_CHECK_X_ADJUST * SCALE ;
				}

				if ( diff.length < HIT_DETECT_MAX_DISTANCE ) {
					/* 攻击命中 */
					isLastAttackHit = true ;

					if ( attackState == AttackState.NA ) {
						attackState = AttackState.FIRST ;
					}

					if ( _pos.y != 0 ) {
						shakeWhenAttack = 11 ;
					} else {
						shakeWhenAttack = 5 ;
					}

					attacker.damage ( isFlipX , _pos.z , punchType ) ;
					hitRegister.push ( attacker.id ) ;
					effect.push ( attacker.pos.x , attacker.pos.z + attacker.pos.y ) ;

				}

			}

			//強い攻撃
			if ( punchType == PunchType.M ) {

//				if ( _lastAtkChk == 0 ) {_lastAtkChk = 2 ;}
				// isLastAttackHit = false;

				diff = _pos.subtract ( attacker._pos ) ;

				if ( isFlipX ) {
					diff.x -= HIT_CHECK_X_ADJUST * 2 * SCALE ;
				} else {
					diff.x += HIT_CHECK_X_ADJUST * 2 * SCALE ;
				}

				if ( diff.length < HIT_DETECT_MAX_DISTANCE ) {

					isLastAttackHit = true ;

					if ( attackState == AttackState.NA ) {
						attackState = AttackState.FIRST ;
					}

					shakeWhenAttack = 15 ;
					attacker.damage ( isFlipX , _pos.z , punchType ) ;
					hitRegister.push ( attacker.id ) ;
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
			velocity.z = 0 ;

			switch(punchType)
			{
				case PunchType.S:
				{
					velocity.x = ((isFlipX)? -1 : 1) * PunchType.getSpeedPowerXByType(punchType) ;
					velocity.y = 0 ;
					// _damage_shake = 20 ;
					shakeWhenDamage = PunchType.getDamageShakeByType(punchType);
					motionWhenDamag = Motion.getRandomDamageMotion();
					break;
				}
				case PunchType.M:
				{
					velocity.x = ((isFlipX)? -1 : 1) * PunchType.getSpeedPowerXByType(punchType) ;
					// _velocity.x = (isFlipX)? -3 : 3 ;
					velocity.y = -2 ;
					// _damage_shake = 5 ;
					shakeWhenDamage = PunchType.getDamageShakeByType(punchType);
					motionWhenDamag = Motion.KNOCK_DOWN ;
					break;
				}
				case PunchType.L:
				{
					velocity.x = ((isFlipX)? -1 : 1) * PunchType.getSpeedPowerXByType(punchType) ;
					// _velocity.x = (isFlipX)? -3 : 3 ;
					velocity.y = -2 ;
					// _damage_shake = 8 ;
					shakeWhenDamage = PunchType.getDamageShakeByType(punchType);
					motionWhenDamag = Motion.KNOCK_DOWN ;
					hp = 0 ;
					Global._world_shake = 10 ;
					break;
				}
				default:
				{
					throw(new Error("uknown punchType:"+punchType));
				}
			}

			// trace("[CharctorBase.damage] punchType:"+punchType+"; _damage_shake:"+_damage_shake + "; _velocity.x:"+_velocity.x);

			//死亡チェック
			if ( -- hp <= 0 ) {
				isDead = true ;
				countAfterDeath = 0 ;
				motionWhenDamag = Motion.KNOCK_DOWN ;
				if ( _end == false ) {
					++ _score ;
				}
			}
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
			attack:Boolean , //攻撃ボタン   攻击按钮
			jump:Boolean , //ジャンプボタン  跳转按钮
			right:Boolean , //左
			keyR:Boolean , //右
			up:Boolean , //上
			down:Boolean   //下
		):void {

			if ( attack ) { ++ inputAttack ; } else { inputAttack = 0 ; }
			if ( jump ) { ++ inputJump ; }   else { inputJump = 0 ; }
			if ( right ) { ++ inputLeft ; } else { inputLeft = 0 ; }
			if ( keyR ) { ++ inputRight ; } else { inputRight = 0 ; }
			if ( up ) { ++ inputUp ; } else { inputUp = 0 ; }
			if ( down ) { ++ inputDown ; } else { inputDown = 0 ; }

			targetX = _pos.x + ( (inputLeft) ? - TARGET_OFFSET : 0 ) + ( (inputRight) ? TARGET_OFFSET : 0 ) + ( (isFlipX)? -1 : 1 ) ;
			targetZ = _pos.z + ( (inputUp) ? -TARGET_OFFSET : 0 ) + ( (inputDown) ? TARGET_OFFSET : 0 ) + ( (isFlipX)? -1 : 1 ) ;

			// 向左突进 搓键
			++ commandLeftCNT;
			if ( 10 < commandLeftCNT ) {
				commandLeft = 0 ;
			}
			if ( inputJump == 1 && commandLeft == 0 ){
				commandLeft = 2 ;
				commandLeftCNT = 0;
			}
			if ( inputLeft     == 1 && commandLeft == 2 && commandLeftCNT < 10 ) {
				commandLeft = 3 ;
				commandLeftCNT = 0;
			}

			// 向右突进 搓键
			++ commandRightCNT;
			if ( 10 < commandRightCNT ){
				commandRight = 0 ;
			}

			if ( inputJump == 1 && commandRight == 0 ){
				commandRight = 2 ; commandRightCNT = 0;
			}
			if ( inputRight     == 1 && commandRight == 2 && commandRightCNT < 10 ) {
				commandRight = 3 ; commandRightCNT = 0;
			}

//			trace("[CharctorBase.input] _command2CNT:"+_command2CNT+"; _command2:"+_command2);
//			trace("[CharctorBase.input] ------------------------------------------");
		}

		////////////////////////////////////
		public function inputAuto ( ):void {

			inputAttack = ( Math.random() < 0.04)?1:0 ;
			inputJump   = ( Math.random() < 0.01)?1:0 ;

			var V:Vector3D = _pos.clone() ;
			V.x -= targetX ;
			V.z -= targetZ ;
			if ( V.length < 20 * SCALE ) {
				targetX = targetX + ( Math.random() * 6 - 3 ) * 8 ;
				targetZ = targetZ + ( Math.random() * 6 - 3 ) * 8 ;
				if ( targetX < 0 )   targetX = 0;
				if ( targetZ < ZMAX ) targetZ = ZMAX;
				if ( targetX > XMAX ) targetX = XMAX;
				if ( targetZ > 465 ) targetZ = 465;
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
				velocity.x = V.x * 1 ;
				velocity.z = V.z * 1 ;
			}

		}

		////////////////////////////////////
		public function render ( ):void {

			if ( isDead ) {
				if ( countAfterDeath % 10 < 5 ) {
					return ;
				}
			}

			assetFrame %= 40 ;
			_render_rect.x = Math.floor ( assetFrame % 8 ) * scaledSize ;
			_render_rect.y = Math.floor ( assetFrame / 8 ) * scaledSize ;

			_renderpos.x = _pos.x          - scaledSize /2 ;
			_renderpos.y = _pos.z + _pos.y - scaledSize ;

			if ( shakeWhenDamage ) {
				_renderpos.x += Math.random() * 10 - 5 ;
				_renderpos.y += Math.random() * 10 - 5 ;
			}

			if ( isFlipX ) {
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
			_r.width = ( scaledSize * hp / 10 ) - 2 ;
			_r.height = 5 - 2 ;
			Global._canvas.fillRect ( _r , 0x00FF00 ) ;

		}

		////////////////////////////////////
		public function render_shadow ( ):void {
			_shadowpos.x = _pos.x - scaledSize/4/2 * SCALE ;
			_shadowpos.y = _pos.z - scaledSize/8/2 * SCALE ;
			Global._canvas.copyPixels ( _shadow , _shadow.rect , _shadowpos ) ;
		}

		// 复活重生
		public function revive():void{
			// 死亡足够长时间以后，从高处掉落下来重生
			hp = 10 ;
			isDead = false ;
			countAfterDeath = 0 ;

			_pos.x = Math.random() * 465 ;
			_pos.y = -500 ;
			_pos.z = 365 ;
			velocity.y = 0 ;

			motion = Motion.FALL ;
		}


		////////////////////////////////////
		public function setDie ( ) :void {
			if ( isDead == false ) {
				isDead = true ;
				countAfterDeath = 0 ;
				motionWhenDamag = Motion.KNOCK_DOWN ;
				hp = 0 ;
			}
		}

		////////////////////////////////////
		public function update ( items:Vector.<Item> , mainHero:CharctorBase ):void {

			var isResponsible:Boolean = true ;  /* true: 可操控， false: 僵直 */
//			var currentInputAllowance:int = motionToInputAllowance[_action][_actionstep] ;
			var currentInputAllowance:int = HeroConfigObj.getInputAllowance(motion, motionStep);
//				motionToInputAllowance[_action][_actionstep] ;
			var currentAction:String = motion;
			var currentActionStep:int = motionStep;

			var X:Number = 0 ;
			var Y:Number = 0 ;
			var L:Number = 0 ;
			var I:int = 0 ;

			// if(isDead && WAIT_TO_REVIVE < ++ countAfterDeath && this != mainHero ) revive();
			if(isDead && WAIT_TO_REVIVE < ++ countAfterDeath ) revive();

			if ( 0 < shakeWhenDamage ) { /* 处理被打僵直 */
				isResponsible = false ;
				-- shakeWhenDamage ;
				dropItem(items);
			}

			if ( 0 < shakeWhenAttack ) { /* 处理出拳僵直 */
				isResponsible = false ;
				-- shakeWhenAttack ;
			}

			{// 处理玩家

				// if ( 1 & currentInputAllowance ) {
				if ( InputAllowance.MOVE & currentInputAllowance ) {

					X = _pos.x - targetX ;
					Y = _pos.z - targetZ ;
					L = X * X + Y * Y ;
					motion = ( 10 * 10 < L ) ? Motion.RUN : Motion.STAND ;
					attackState = AttackState.NA ;

				}

				// if ( 2 & currentInputAllowance ) {
				if ( InputAllowance.ATTACK & currentInputAllowance ) {

					if ( inputAttack == 1 ) {

						//最後の攻撃判定が誰にもヒットしていない場合、連続技判定をリセットする
						// If the judgment of the attack last not hit anyone, I want to reset the continuous maneuver checks
						if ( isLastAttackHit != true ) {
							attackState = AttackState.NA ;
						}

						isLastAttackHit = false;

						if ( isInAir ) {

							switch ( attackState ) {
								case AttackState.FIRST :
									attackState = AttackState.SECOND ;
									motion = Motion.ATTACK_IN_AIR1 ;
									frameWaitCount = 0 ;
									break ;

								default:
									attackState = AttackState.FIRST ;
									motion = Motion.ATTACK_IN_AIR2 ;
									frameWaitCount = 0 ;
									break ;
							}

						} else {

							switch ( attackState ) {
								case AttackState.NA :
									attackState = AttackState.NA;
									motion = Motion.PUNCH1 ;
									frameWaitCount = 0 ; /*連打キャンセル*/
									motionStep= 0;
									break ;

								case AttackState.FIRST :
									attackState = AttackState.SECOND ;
									motion = Motion.PUNCH2 ;
									frameWaitCount = 0 ;
									break ;

								case AttackState.SECOND :
									attackState = AttackState.THIRD;
									motion = Motion.PUNCH3_KICK ;
									frameWaitCount = 0 ;
									break ;

								case AttackState.THIRD :
									attackState = AttackState.FORTH ;
									motion = Motion.PUNCH4_COLLIDE ;
									frameWaitCount = 0 ;
									break ;
							}
						}

					}

				}

				// if ( 4 & currentInputAllowance ) {
				if ( InputAllowance.JUMP & currentInputAllowance ) {
					if ( inputJump == 1 ) {
						// _action = 2 ;
						motion = Motion.TAKE_OFF ;
						frameWaitCount = 0 ;
					}
				}

				// if ( 8 & currentInputAllowance ) {
				if ( InputAllowance.THROW & currentInputAllowance ) {

					if ( inputAttack == 1 ) {

						var J:int = 0 ;

						if ( attackState == AttackState.NA && isInAir == 0 ) {

							for ( J = 0 ; J < items.length ; ++ J ) {

								//石を持っていたら投げる  Throw if you have a stone
								if ( items[J].isreservation ( id ) ) {
									// _action = 13 ;
									motion = Motion.THROW ;
									frameWaitCount = 0 ;
									break;
								}

								//足元に石があると拾う  I pick up that there is a stone at the feet
								if ( items[J].chk_distance ( _pos ) ) {
									items[J].reservation ( id ) ;
									motion = Motion.PICK_UP ;
									frameWaitCount = 0 ;
									break;
								}
							}

						}

					}

				}

				// if ( 16 & currentInputAllowance ) {
				if ( InputAllowance.BOUNCE & currentInputAllowance ) {

					if ( commandLeft == 3 ) {
						commandLeft = 0 ;
						// _action = 14 ;
						motion = Motion.BOUNCE ;
						frameWaitCount = 0 ;
						bonceSpeed = -4 ;
						shakeWhenAttack = 0;
						attackState = 0;
					}

					if ( commandRight == 3 ) {
						commandRight = 0 ;
						// _action = 14 ;
						motion = Motion.BOUNCE ;
						frameWaitCount = 0 ;
						bonceSpeed = 4 ;
						shakeWhenAttack = 0;
						attackState = 0;
					}

				}

				// if ( 32 & currentInputAllowance ) {
				if ( InputAllowance.INERTIA & currentInputAllowance ) {
					//ブレーキ
					if ( inputLeft ) { if ( 0 < velocity.x ) velocity.x *= .9 ; }
					if ( inputRight ) { if ( velocity.x < 0 ) velocity.x *= .9 ; }
				}

				//強制動作
				if ( motionWhenDamag ) {
					motion = motionWhenDamag ;
					motionWhenDamag = null ;
				}

				if ( currentAction != motion ) {
					motionStep = 0 ;
					frameWaitCount = 0 ;
				}

			}

			if ( isResponsible )
			{//アニメーション   Animation

//				var TD:int = playheadCondition[_action][_actionstep];
				var playheadCondition:int = HeroConfigObj.getPlayheadCondition(motion, motionStep);
				switch ( playheadCondition ) {

					// case 0 :
					case PlayheadCondition.WHATEVER :
						++ frameWaitCount;
						break ;

					// case 1 :
					case PlayheadCondition.ONLY_IN_AIR :
						if ( 0 < velocity.y ) {
							++ frameWaitCount ;
						}
						break ;

					// case 2:
					case PlayheadCondition.ONLY_ON_GROUND:
						if ( false == isInAir ) {
							++ frameWaitCount ;
						}
						break;

					// case 3:
					case PlayheadCondition.IS_ALIVE:
						if ( 0 < hp ) {
							++ frameWaitCount;
						}
						break;
				}

				// if ( motionToWeight[_action][_actionstep] <= frameWaitCount )
				var lf:uint = HeroConfigObj.getLastFor(motion, motionStep);
//				trace("[CharctorBase.update] _action:"+_action +"; actionstep:"+_actionstep+"; last for:"+lf+"; playheadCondition:"+playheadCondition+"; frameWaitCount:"+frameWaitCount);
				if ( lf <= frameWaitCount )
				{
					/* 要换帧了 */
					frameWaitCount = 0 ;

					var jumpPower:Number = 0 ;
					if ( inputLeft != 0 ) { jumpPower = -3; }
					if ( inputRight != 0 ) { jumpPower =  3; }

					// switch ( motionReaction[_action][_actionstep] ) {
					switch ( HeroConfigObj.getMotionReaction(motion , motionStep) ) {
						case MotionReaction.JUMP:
							velocity.y = -5 ;
							velocity.x = jumpPower;
							break;
						case MotionReaction.FALL:
							motion = ( isInAir) ? Motion.FALL : Motion.STAND ;
							break ;
						case MotionReaction.THROW:
						{
							for ( var P:int = 0 ; P < items.length ; ++ P ) {
								if ( items[P].isreservation (id) ) {
									items[P].have ( _pos , new Vector3D ( ( isFlipX) ? -HIT_CHECK_X_ADJUST : HIT_CHECK_X_ADJUST , -3 , 0 ) , isFlipX ) ;
								}
							}
						}
							break;
						case MotionReaction.BOUNCE:
							velocity.y = -2 ;
							velocity.x = bonceSpeed;
							break;

						case MotionReaction.TURN:
							isFlipX = ( inputLeft ) ? true : ( (inputRight) ? false : isFlipX ) ;
							break;
						default: break;
					}

//					if ( motionToAssetFrameIds[_action].length <= ++ _actionstep ) {
					if ( HeroConfigObj.countAssetFrame(motion) <= ++ motionStep ) {
						motionStep = 0 ;
					}

					while ( hitRegister.length ) {
						hitRegister.pop () ;
					}

				}

			}

			if ( isResponsible && ( InputAllowance.MOVE & currentInputAllowance ) )
			{//加速

				isFlipX = ( targetX < _pos.x ) ;

				var ty:Number = velocity.y;
				velocity.y = 0 ;

				X = ( targetX - _pos.x ) ;
				Y = ( targetZ - _pos.z ) ;
				L = X * X + Y * Y ;
				if ( MIN_DISTANCE_TO_TARGET * MIN_DISTANCE_TO_TARGET < L ) {
					velocity.x += X * .004 ;
					velocity.z += Y * .004 ;
				}

				speed = velocity.length ;
				speed = ( 2 < speed )? 2 : speed ;

				velocity.normalize ( ) ;
				velocity.scaleBy ( speed ) ;

				velocity.y = ty ;

			}

			if ( isResponsible )
			{//移動

				_pos.x += velocity.x * SCALE ;
				_pos.y += velocity.y * SCALE ;
				_pos.z += velocity.z * SCALE *.5 ;
				velocity.y += .2 ;

				if ( false == isInAir ) {
					velocity.x *= .9 ;
					velocity.z *= .9 ;
				}

				if ( 0 <= _pos.y ) {
					_pos.y = 0 ;
					isInAir = false ;
				} else {
					isInAir = true ;
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

				if ( XMAX < _pos.x ) {
					_pos.x = XMAX ;
				}

			}

			// _anim = motionToAssetFrameIds[_action][_actionstep] ;
			assetFrame = HeroConfigObj.getAssetFrame(motion, motionStep) ;

		}
	}
}