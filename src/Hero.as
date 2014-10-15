package
{
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;

	public
	//雑魚のモーション
	class Hero extends CharctorBase {

		//アニメパターン  动漫图案
		static private const $HERO_ASSET_FRAMES:Array = [];
		$HERO_ASSET_FRAMES[Motions.STAND] =               [ 0 , 1 , 2 , 3 ] ; //歩く  站立
		$HERO_ASSET_FRAMES[Motions.RUN] =                 [ 32 , 33 , 34 , 35 , 36 , 37 ] ; //走る  行走
		$HERO_ASSET_FRAMES[Motions.TAKE_OFF] = 	          [ 4 , 5 , 6 , 7 , 4 ] ; //飛ぶ  飞
		$HERO_ASSET_FRAMES[Motions.PUNCH1] = 	          [ 8 , 9 , 9 ] ; //パンチ 冲床
		$HERO_ASSET_FRAMES[Motions.PUNCH4_COLLIDE] = 	  [ 10 , 11 , 12 , 12 ] ; //強いパンチ  强冲
		$HERO_ASSET_FRAMES[Motions.ATTACK_IN_AIR2] =  	  [  6 , 13 , 4 ] ; //ジャンプパンチ  跳转冲
		$HERO_ASSET_FRAMES[Motions.ATTACK_IN_AIR1] = 	  [  6 , 14 , 4 ] ; //ジャンプキック  跳踢
		$HERO_ASSET_FRAMES[Motions.PUNCH3_KICK] =         [ 29 , 15 , 15 ] ; //キック  踢
		$HERO_ASSET_FRAMES[Motions.KNOCKED_S] = 		  [ 16 ] ; //弱ダメージ  微弱损伤
		$HERO_ASSET_FRAMES[Motions.KNOCKED_M] =           [ 17 ] ; //中ダメージ  中等破坏
		$HERO_ASSET_FRAMES[Motions.KNOCKED_L] =           [ 18 ] ; //強ダメージ  强力损伤
		$HERO_ASSET_FRAMES[Motions.KNOCK_DOWN] = 	      [ 19 , 20 , 21 , 22 , 22 ] ; //ダウン  向下
		$HERO_ASSET_FRAMES[Motions.FALL] =                [ 7 , 4 ] ;//落下
		$HERO_ASSET_FRAMES[Motions.THROW] =               [ 25 , 26 , 27 , 0 ] ; //投擲
		$HERO_ASSET_FRAMES[Motions.BOUNCE] =            [ 4  ,  5 ,  6 ,  7 , 4 ] ; //ステップ  突进
		$HERO_ASSET_FRAMES[Motions.PUNCH2] = 	          [ 8 , 9 , 9 ] ; //パンチ２段目 第二阶段冲
		$HERO_ASSET_FRAMES[Motions.PICK_UP] =             [ 24 ] ; //石ひろい  宽阔的石板

		//		//アニメパターン  动漫图案
		//		private const $HERO_ASSET_FRAMES:Array = [
		//			[ 0 , 1 , 2 , 3 ] ; //歩く  站立
		//			[ 32 , 33 , 34 , 35 , 36 , 37 ] ; //走る  行走
		//			[ 4 , 5 , 6 , 7 , 4 ] ; //飛ぶ  飞
		//			[ 8 , 9 , 9 ] ; //パンチ 冲床
		//			[ 10 , 11 , 12 , 12 ] ; //強いパンチ  强冲
		//			[  6 , 13 , 4 ] ; //ジャンプパンチ  跳转冲
		//			[  6 , 14 , 4 ] ; //ジャンプキック  跳踢
		//			[ 29 , 15 , 15 ] ; //キック  踢
		//			[ 16 ] ; //弱ダメージ  微弱损伤
		//			[ 17 ] ; //中ダメージ  中等破坏
		//			[ 18 ] ; //強ダメージ  强力损伤
		//			[ 19 , 20 , 21 , 22 , 22 ] ; //ダウン  向下
		//			[ 7 , 4 ] ,//落下
		//			[ 25 , 26 , 27 , 0 ] ; //投擲
		//			[ 4  ,  5 ,  6 ,  7 , 4 ] ; //ステップ  步骤
		//			[ 8 , 9 , 9 ] ; //パンチ２段目 第二阶段冲
		//			[ 24 ] ; //石ひろい  宽阔的石板
		//		];

		//ウェイト  重量 持续播放帧
		static private const $HERO_MOTION_TO_WEIGTH:Array = [];
		$HERO_MOTION_TO_WEIGTH[Motions.STAND] =                 [ 8 , 8 , 8 , 8 ] ; //歩く
		$HERO_MOTION_TO_WEIGTH[Motions.RUN] =                   [ 5 , 5 , 5 , 5 , 5 , 5 ] ; //走る
		$HERO_MOTION_TO_WEIGTH[Motions.TAKE_OFF] = 	            [ 8 , 2 , 5 , 2 , 5 ] ; //飛ぶ
		$HERO_MOTION_TO_WEIGTH[Motions.PUNCH1] = 	              [ 3 , 1 , 16 ] ; //パンチ
		$HERO_MOTION_TO_WEIGTH[Motions.PUNCH4_COLLIDE] = 	      	[ 3 , 3 , 7 , 20 ] ; //強いパンチ
		$HERO_MOTION_TO_WEIGTH[Motions.ATTACK_IN_AIR2] =  	[ 2 , 2 , 5 ] ; //ジャンプパンチ
		$HERO_MOTION_TO_WEIGTH[Motions.ATTACK_IN_AIR1] = 	          	[ 2 , 2 , 5 ] ; //ジャンプキック
		$HERO_MOTION_TO_WEIGTH[Motions.PUNCH3_KICK] =                	[ 2 , 2 , 22 ] ; //キック
		$HERO_MOTION_TO_WEIGTH[Motions.KNOCKED_S] = 		      	[ 15 ] ; //弱ダメージ
		$HERO_MOTION_TO_WEIGTH[Motions.KNOCKED_M] =           	[ 15 ] ; //中ダメージ
		$HERO_MOTION_TO_WEIGTH[Motions.KNOCKED_L] =           	[ 15 ] ; //強ダメージ
		$HERO_MOTION_TO_WEIGTH[Motions.KNOCK_DOWN] = 	        	[ 9 , 9 , 9 , 9 , 15 ] ; //ダウン
		$HERO_MOTION_TO_WEIGTH[Motions.FALL] =                	[ 2 , 5 ] ;//落下
		$HERO_MOTION_TO_WEIGTH[Motions.THROW] =               	[ 7 , 4 , 12 , 5 ] ; //投擲
		$HERO_MOTION_TO_WEIGTH[Motions.BOUNCE] =            	[ 2 , 2 , 5 , 2 , 5 ] ; //ステップ
		$HERO_MOTION_TO_WEIGTH[Motions.PUNCH2] = 	            	[ 3 , 1 , 16 ] ;//パンチ２段目
		$HERO_MOTION_TO_WEIGTH[Motions.PICK_UP] =            	[ 50 ] ; //石ひろい

		//		private const $HERO_MOTION_TO_WEIGTH:Array = [
		//			[ 8 , 8 , 8 , 8 ] ; //歩く
		//			[ 5 , 5 , 5 , 5 , 5 , 5 ] ; //走る
		//			[ 8 , 2 , 5 , 2 , 5 ] ; //飛ぶ
		//			[ 3 , 1 , 16 ] ; //パンチ
		//			[ 3 , 3 , 7 , 20 ] ; //強いパンチ
		//			[ 2 , 2 , 5 ] ; //ジャンプパンチ
		//			[ 2 , 2 , 5 ] ; //ジャンプキック
		//			[ 2 , 2 , 22 ] ; //キック
		//			[ 15 ] ; //弱ダメージ
		//			[ 15 ] ; //中ダメージ
		//			[ 15 ] ; //強ダメージ
		//			[ 9 , 9 , 9 , 9 , 15 ] ; //ダウン
		//			[ 2 , 5 ] ,//落下
		//			[ 7 , 4 , 12 , 5 ] ; //投擲
		//			[ 2 , 2 , 5 , 2 , 5 ] ; //ステップ
		//			[ 3 , 1 , 16 ] ,//パンチ２段目
		//			[ 50 ] ; //石ひろい
		//		] ;

		//入力の許可  允许输入, bit_flag  1=移動 + 2=攻撃 + 4=ジャンプ + 8=投擲 + 16=ステップ + 32 = 慣性操作
		static private const $HERO_INPUT_ALLOWANCE:Array = [];
		$HERO_INPUT_ALLOWANCE[Motions.STAND] =              		[ InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW] ; //歩wpくく
		$HERO_INPUT_ALLOWANCE[Motions.RUN] =                		[ InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW] ; //走る
		$HERO_INPUT_ALLOWANCE[Motions.TAKE_OFF] = 	         		[ InputAllowance.BOUNCE, InputAllowance.ATTACK  , InputAllowance.ATTACK  , InputAllowance.ATTACK , 0 ] ; //飛ぶ
		$HERO_INPUT_ALLOWANCE[Motions.PUNCH1] = 	           		[ 0 , 0 , InputAllowance.ATTACK_STEP ] ; //パンチ
		$HERO_INPUT_ALLOWANCE[Motions.PUNCH4_COLLIDE] = 	     	[ 0 , 0 , InputAllowance.BOUNCE , InputAllowance.BOUNCE ] ; //強いパンチ
		$HERO_INPUT_ALLOWANCE[Motions.ATTACK_IN_AIR2] = 			[ 0 , InputAllowance.ATTACK , InputAllowance.BOUNCE ] ; //ジャンプパンチ
		$HERO_INPUT_ALLOWANCE[Motions.ATTACK_IN_AIR1] = 	        [ 0 , 0 , InputAllowance.BOUNCE ] ; //ジャンプキック
		$HERO_INPUT_ALLOWANCE[Motions.PUNCH3_KICK] =               	[ 0 , 0 , InputAllowance.ATTACK_STEP ] ; //キック
		$HERO_INPUT_ALLOWANCE[Motions.KNOCKED_S] = 		     		[ 0 ] ; //弱ダメージ
		$HERO_INPUT_ALLOWANCE[Motions.KNOCKED_M] =          		[ 0 ] ; //中ダメージ
		$HERO_INPUT_ALLOWANCE[Motions.KNOCKED_L] =          		[ 0 ] ; //強ダメージ
		$HERO_INPUT_ALLOWANCE[Motions.KNOCK_DOWN] = 	       		[ 0 , 0 , 0 , 0 , 0 ] ; //ダウン
		$HERO_INPUT_ALLOWANCE[Motions.FALL] =               		[ 0 , 0 ] ; //落下
		$HERO_INPUT_ALLOWANCE[Motions.THROW] =              		[ 0 , 0 , 0 , 0 ] ; //投擲
		$HERO_INPUT_ALLOWANCE[Motions.BOUNCE] =           			[ 0 , InputAllowance.ATTACK_INERTIA , InputAllowance.ATTACK_INERTIA , InputAllowance.ATTACK_INERTIA , InputAllowance.BOUNCE ] ; //ステップ
		$HERO_INPUT_ALLOWANCE[Motions.PUNCH2] = 	           		[ 0 , 0 , InputAllowance.ATTACK ] ; //パンチ２段目
		$HERO_INPUT_ALLOWANCE[Motions.PICK_UP] =           			[ 0 ] ; //石ひろい

		//アニメーションの条件 0=ウェイト 1=_velocity.yが+方向 2=地面に接地 3=体力が0だとアニメーション終了。
		//动画的条件  0=重量  1=_velocity.yが+方向 2=地面上的地 3=耐力动画到底是0
		static	private const $HERO_PLAYHEAD_CONDITION:Array = [];
		$HERO_PLAYHEAD_CONDITION[Motions.STAND] =              		[ 0 , 0 , 0 , 0 ] ; //歩く
		$HERO_PLAYHEAD_CONDITION[Motions.RUN] =                		[ 0 , 0 , 0 , 0 , 0 , 0 ] ; //走る
		$HERO_PLAYHEAD_CONDITION[Motions.TAKE_OFF] = 	         	[ 0 , PlayheadCondition.ONLY_IN_AIR , 0 , PlayheadCondition.ONLY_ON_GROUND , 0 ] ; //飛ぶ
		$HERO_PLAYHEAD_CONDITION[Motions.PUNCH1] = 	           		[ 0 , 0 , 0 ] ; //パンチ
		$HERO_PLAYHEAD_CONDITION[Motions.PUNCH4_COLLIDE] = 	     	[ 0 , 0 , 0 , 0 ] ; //強いパンチ
		$HERO_PLAYHEAD_CONDITION[Motions.ATTACK_IN_AIR2] = 			[ 0 , PlayheadCondition.ONLY_ON_GROUND , 0 ] ; //ジャンプパンチ
		$HERO_PLAYHEAD_CONDITION[Motions.ATTACK_IN_AIR1] = 	        [ 0 , PlayheadCondition.ONLY_ON_GROUND , 0 ] ; //ジャンプキック
		$HERO_PLAYHEAD_CONDITION[Motions.PUNCH3_KICK] =             [ 0 , 0 , 0 ] ; //キック
		$HERO_PLAYHEAD_CONDITION[Motions.KNOCKED_S] = 		     	[ 0 ] ; //弱ダメージ
		$HERO_PLAYHEAD_CONDITION[Motions.KNOCKED_M] =          		[ 0 ] ; //中ダメージ
		$HERO_PLAYHEAD_CONDITION[Motions.KNOCKED_L] =          		[ 0 ] ; //強ダメージ
		$HERO_PLAYHEAD_CONDITION[Motions.KNOCK_DOWN] = 	       		[ 0 , 0 , 0 , 0 , PlayheadCondition.IS_ALIVE ] ; //ダウン
		$HERO_PLAYHEAD_CONDITION[Motions.FALL] =               		[ PlayheadCondition.ONLY_ON_GROUND , 0 ] ; //落下
		$HERO_PLAYHEAD_CONDITION[Motions.THROW] =              		[ 0 , 0 , 0 , 0 ] ; //投擲
		$HERO_PLAYHEAD_CONDITION[Motions.BOUNCE] =           		[ 0 , 0 , 0 , PlayheadCondition.ONLY_ON_GROUND , 0 ] ; //ステップ
		$HERO_PLAYHEAD_CONDITION[Motions.PUNCH2] = 	           		[ 0 , 0 , 0 ] ; //パンチ２段目
		$HERO_PLAYHEAD_CONDITION[Motions.PICK_UP] =           		[ 0 ] ; //石ひろい


		//アニメーション切り替わりの際の特殊動作ＩＤ 1=ジャンプ 2=[歩くor落下]状態に戻る 3=飛び道具発生 4=ステップ移動 5=振り向き判定
		// 在动画切换专项行动的ID  1= 跳转  2= 回到状态[歩くor落下] 3=新一代导弹 4=步进运动 5=判决转身
		static private const $HERO_MOTION_REACTIONS:Array = [];
		$HERO_MOTION_REACTIONS[Motions.STAND] =              		[ 0 , 0 , 0 , 0 ] ; //歩く
		$HERO_MOTION_REACTIONS[Motions.RUN] =                		[ 0 , 0 , 0 , 0 , 0 , 0 ] ; //走る
		$HERO_MOTION_REACTIONS[Motions.TAKE_OFF] = 	         		[ 1 , 0 , 0 , 0 , 2 ] ; //飛ぶ
		$HERO_MOTION_REACTIONS[Motions.PUNCH1] = 	           		[ 5 , 0 , 2 ] ; //パンチ
		$HERO_MOTION_REACTIONS[Motions.PUNCH4_COLLIDE] = 	     	[ 0 , 0 , 0 , 2 ] ; //強いパンチ
		$HERO_MOTION_REACTIONS[Motions.ATTACK_IN_AIR2] = 			[ 0 , 0 , 2 ] ; //ジャンプパンチ
		$HERO_MOTION_REACTIONS[Motions.ATTACK_IN_AIR1] = 	        [ 0 , 0 , 2 ] ; //ジャンプキック
		$HERO_MOTION_REACTIONS[Motions.PUNCH3_KICK] =               [ 5 , 0 , 2 ] ; //キック
		$HERO_MOTION_REACTIONS[Motions.KNOCKED_S] = 		     	[ 2 ] ; //弱ダメージ
		$HERO_MOTION_REACTIONS[Motions.KNOCKED_M] =          		[ 2 ] ; //中ダメージ
		$HERO_MOTION_REACTIONS[Motions.KNOCKED_L] =          		[ 2 ] ; //強ダメージ
		$HERO_MOTION_REACTIONS[Motions.KNOCK_DOWN] = 	       		[ 0 , 0 , 0 , 0 , 2 ] ; //ダウン
		$HERO_MOTION_REACTIONS[Motions.FALL] =               		[ 0 , 2 ] ; //落下
		$HERO_MOTION_REACTIONS[Motions.THROW] =              		[ 0 , 3 , 0 , 2 ] ; //投擲
		$HERO_MOTION_REACTIONS[Motions.BOUNCE] =           		[ 4 , 0 , 0 , 0 , 2 ] ; //ステップ
		$HERO_MOTION_REACTIONS[Motions.PUNCH2] = 	           		[ 5 , 0 , 2 ] ; //パンチ２段目
		$HERO_MOTION_REACTIONS[Motions.PICK_UP] =           		[ 2 ] ; //石ひろい

		//攻撃判定
		static private const $HERO_HIT_DETECTIONS:Array = [];
		$HERO_HIT_DETECTIONS[Motions.STAND] =              		[ 0 , 0 , 0 , 0 ] ; //歩く
		$HERO_HIT_DETECTIONS[Motions.RUN] =                		[ 0 , 0 , 0 , 0 , 0 , 0 ] ; //走る
		$HERO_HIT_DETECTIONS[Motions.TAKE_OFF] = 	         		[ 0 , 0 , 0 , 0 , 0 ] ; //飛ぶ
		$HERO_HIT_DETECTIONS[Motions.PUNCH1] = 	           		[ 0 , PunchType.S , 0 ] ; //パンチ
		$HERO_HIT_DETECTIONS[Motions.PUNCH4_COLLIDE] = 	     		[ 0 , 0 , PunchType.M , 0 ] ; //強いパンチ
		$HERO_HIT_DETECTIONS[Motions.ATTACK_IN_AIR2] = 		[ 0 , PunchType.S , 0 ] ; //ジャンプパンチ
		$HERO_HIT_DETECTIONS[Motions.ATTACK_IN_AIR1] = 	         		[ 0 , PunchType.M , 0 ] ; //ジャンプキック
		$HERO_HIT_DETECTIONS[Motions.PUNCH3_KICK] =               		[ 0 , PunchType.S , 0 ] ; //キック
		$HERO_HIT_DETECTIONS[Motions.KNOCKED_S] = 		     		[ 0 ] ; //弱ダメージ
		$HERO_HIT_DETECTIONS[Motions.KNOCKED_M] =          		[ 0 ] ; //中ダメージ
		$HERO_HIT_DETECTIONS[Motions.KNOCKED_L] =          		[ 0 ] ; //強ダメージ
		$HERO_HIT_DETECTIONS[Motions.KNOCK_DOWN] = 	       		[ 0 , 0 , 0 , 0 , 0 ] ; //ダウン
		$HERO_HIT_DETECTIONS[Motions.FALL] =               		[ 0 , 0 ] ; //落下
		$HERO_HIT_DETECTIONS[Motions.THROW] =              		[ 0 , 0 , PunchType.M , 0 ] ; //投擲
		$HERO_HIT_DETECTIONS[Motions.BOUNCE] =           		[ 0 , 0 , 0 , 0 , 0 ] ; //ステップ
		$HERO_HIT_DETECTIONS[Motions.PUNCH2] = 	           		[ 0 , PunchType.S , 0 ] ; //パンチ２段目
		$HERO_HIT_DETECTIONS[Motions.PICK_UP] =           		[ 0 ] ; //石ひろい

		public function Hero ( srcCharacterAtlasBitmap:Bitmap , colorTransform:ColorTransform = null ) :void {
			super ( srcCharacterAtlasBitmap , colorTransform , $HERO_ASSET_FRAMES , $HERO_MOTION_TO_WEIGTH , $HERO_INPUT_ALLOWANCE , $HERO_PLAYHEAD_CONDITION , $HERO_MOTION_REACTIONS , $HERO_HIT_DETECTIONS ) ;
		}

	}
}
