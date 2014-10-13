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
		$HERO_ASSET_FRAMES[Motions.PUNCH] = 	            [ 8 , 9 , 9 ] ; //パンチ 冲床
		$HERO_ASSET_FRAMES[Motions.QIANG_CHONG$] = 	      [ 10 , 11 , 12 , 12 ] ; //強いパンチ  强冲
		$HERO_ASSET_FRAMES[Motions.TIAO_ZHUANG_CHONG$] =  [  6 , 13 , 4 ] ; //ジャンプパンチ  跳转冲
		$HERO_ASSET_FRAMES[Motions.TIAO_TI$] = 	          [  6 , 14 , 4 ] ; //ジャンプキック  跳踢
		$HERO_ASSET_FRAMES[Motions.KICK] =                [ 29 , 15 , 15 ] ; //キック  踢
		$HERO_ASSET_FRAMES[Motions.KNOCKED_S] = 		      [ 16 ] ; //弱ダメージ  微弱损伤
		$HERO_ASSET_FRAMES[Motions.KNOCKED_M] =           [ 17 ] ; //中ダメージ  中等破坏
		$HERO_ASSET_FRAMES[Motions.KNOCKED_L] =           [ 18 ] ; //強ダメージ  强力损伤
		$HERO_ASSET_FRAMES[Motions.XIANG_XIA$] = 	        [ 19 , 20 , 21 , 22 , 22 ] ; //ダウン  向下
		$HERO_ASSET_FRAMES[Motions.FALL] =                [ 7 , 4 ] ;//落下
		$HERO_ASSET_FRAMES[Motions.THROW] =               [ 25 , 26 , 27 , 0 ] ; //投擲
		$HERO_ASSET_FRAMES[Motions.BU_ZHOU$] =            [ 4  ,  5 ,  6 ,  7 , 4 ] ; //ステップ  步骤
		$HERO_ASSET_FRAMES[Motions.PUNCH2] = 	            [ 8 , 9 , 9 ] ; //パンチ２段目 第二阶段冲
		$HERO_ASSET_FRAMES[Motions.SHI_BAN$] =            [ 24 ] ; //石ひろい  宽阔的石板

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

		//ウェイト  重量
		static private const $HERO_MOTION_TO_WEIGTH:Array = [];
		$HERO_MOTION_TO_WEIGTH[Motions.STAND] =                 [ 8 , 8 , 8 , 8 ] ; //歩く
		$HERO_MOTION_TO_WEIGTH[Motions.RUN] =                   [ 5 , 5 , 5 , 5 , 5 , 5 ] ; //走る
		$HERO_MOTION_TO_WEIGTH[Motions.TAKE_OFF] = 	            [ 8 , 2 , 5 , 2 , 5 ] ; //飛ぶ
		$HERO_MOTION_TO_WEIGTH[Motions.PUNCH] = 	              [ 3 , 1 , 16 ] ; //パンチ
		$HERO_MOTION_TO_WEIGTH[Motions.QIANG_CHONG$] = 	      	[ 3 , 3 , 7 , 20 ] ; //強いパンチ
		$HERO_MOTION_TO_WEIGTH[Motions.TIAO_ZHUANG_CHONG$] =  	[ 2 , 2 , 5 ] ; //ジャンプパンチ
		$HERO_MOTION_TO_WEIGTH[Motions.TIAO_TI$] = 	          	[ 2 , 2 , 5 ] ; //ジャンプキック
		$HERO_MOTION_TO_WEIGTH[Motions.KICK] =                	[ 2 , 2 , 22 ] ; //キック
		$HERO_MOTION_TO_WEIGTH[Motions.KNOCKED_S] = 		      	[ 15 ] ; //弱ダメージ
		$HERO_MOTION_TO_WEIGTH[Motions.KNOCKED_M] =           	[ 15 ] ; //中ダメージ
		$HERO_MOTION_TO_WEIGTH[Motions.KNOCKED_L] =           	[ 15 ] ; //強ダメージ
		$HERO_MOTION_TO_WEIGTH[Motions.XIANG_XIA$] = 	        	[ 9 , 9 , 9 , 9 , 15 ] ; //ダウン
		$HERO_MOTION_TO_WEIGTH[Motions.FALL] =                	[ 2 , 5 ] ;//落下
		$HERO_MOTION_TO_WEIGTH[Motions.THROW] =               	[ 7 , 4 , 12 , 5 ] ; //投擲
		$HERO_MOTION_TO_WEIGTH[Motions.BU_ZHOU$] =            	[ 2 , 2 , 5 , 2 , 5 ] ; //ステップ
		$HERO_MOTION_TO_WEIGTH[Motions.PUNCH2] = 	            	[ 3 , 1 , 16 ] ;//パンチ２段目
		$HERO_MOTION_TO_WEIGTH[Motions.SHI_BAN$] =            	[ 50 ] ; //石ひろい

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
		$HERO_INPUT_ALLOWANCE[Motions.STAND] =              	[ 15, 15, 15, 15] ; //歩wpくく
		$HERO_INPUT_ALLOWANCE[Motions.RUN] =                		[ 15, 15, 15, 15, 15, 15] ; //走る
		$HERO_INPUT_ALLOWANCE[Motions.TAKE_OFF] = 	         		[ 16, 2 , 2 , 2 , 0 ] ; //飛ぶ
		$HERO_INPUT_ALLOWANCE[Motions.PUNCH] = 	           		[ 0 , 0 , 18 ] ; //パンチ
		$HERO_INPUT_ALLOWANCE[Motions.QIANG_CHONG$] = 	     		[ 0 , 0 , 16 , 16 ] ; //強いパンチ
		$HERO_INPUT_ALLOWANCE[Motions.TIAO_ZHUANG_CHONG$] = 		[ 0 , 2 , 16 ] ; //ジャンプパンチ
		$HERO_INPUT_ALLOWANCE[Motions.TIAO_TI$] = 	         		[ 0 , 0 , 16 ] ; //ジャンプキック
		$HERO_INPUT_ALLOWANCE[Motions.KICK] =               		[ 0 , 0 , 18 ] ; //キック
		$HERO_INPUT_ALLOWANCE[Motions.KNOCKED_S] = 		     		[ 0 ] ; //弱ダメージ
		$HERO_INPUT_ALLOWANCE[Motions.KNOCKED_M] =          		[ 0 ] ; //中ダメージ
		$HERO_INPUT_ALLOWANCE[Motions.KNOCKED_L] =          		[ 0 ] ; //強ダメージ
		$HERO_INPUT_ALLOWANCE[Motions.XIANG_XIA$] = 	       		[ 0 , 0 , 0 , 0 , 0 ] ; //ダウン
		$HERO_INPUT_ALLOWANCE[Motions.FALL] =               		[ 0 , 0 ] ; //落下
		$HERO_INPUT_ALLOWANCE[Motions.THROW] =              		[ 0 , 0 , 0 , 0 ] ; //投擲
		$HERO_INPUT_ALLOWANCE[Motions.BU_ZHOU$] =           		[ 0 , 34 , 34 , 34 , 16 ] ; //ステップ
		$HERO_INPUT_ALLOWANCE[Motions.PUNCH2] = 	           		[ 0 , 0 , 2 ] ; //パンチ２段目
		$HERO_INPUT_ALLOWANCE[Motions.SHI_BAN$] =           		[ 0 ] ; //石ひろい

		//アニメーションの条件 0=ウェイト 1=_velocity.yが+方向 2=地面に接地 3=体力が0だとアニメーション終了。
		//动画的条件  0=重量  1=_velocity.yが+方向 2=地面上的地 3=耐力动画到底是0
		static	private const $HERO_D:Array = [];
		$HERO_D[Motions.STAND] =              		[ 0 , 0 , 0 , 0 ] ; //歩く
		$HERO_D[Motions.RUN] =                		[ 0 , 0 , 0 , 0 , 0 , 0 ] ; //走る
		$HERO_D[Motions.TAKE_OFF] = 	         		[ 0 , 1 , 0 , 2 , 0 ] ; //飛ぶ
		$HERO_D[Motions.PUNCH] = 	           		[ 0 , 0 , 0 ] ; //パンチ
		$HERO_D[Motions.QIANG_CHONG$] = 	     		[ 0 , 0 , 0 , 0 ] ; //強いパンチ
		$HERO_D[Motions.TIAO_ZHUANG_CHONG$] = 		[ 0 , 2 , 0 ] ; //ジャンプパンチ
		$HERO_D[Motions.TIAO_TI$] = 	         		[ 0 , 2 , 0 ] ; //ジャンプキック
		$HERO_D[Motions.KICK] =               		[ 0 , 0 , 0 ] ; //キック
		$HERO_D[Motions.KNOCKED_S] = 		     		[ 0 ] ; //弱ダメージ
		$HERO_D[Motions.KNOCKED_M] =          		[ 0 ] ; //中ダメージ
		$HERO_D[Motions.KNOCKED_L] =          		[ 0 ] ; //強ダメージ
		$HERO_D[Motions.XIANG_XIA$] = 	       		[ 0 , 0 , 0 , 0 , 3 ] ; //ダウン
		$HERO_D[Motions.FALL] =               		[ 2 , 0 ] ; //落下
		$HERO_D[Motions.THROW] =              		[ 0 , 0 , 0 , 0 ] ; //投擲
		$HERO_D[Motions.BU_ZHOU$] =           		[ 0 , 0 , 0 , 2 , 0 ] ; //ステップ
		$HERO_D[Motions.PUNCH2] = 	           		[ 0 , 0 , 0 ] ; //パンチ２段目
		$HERO_D[Motions.SHI_BAN$] =           		[ 0 ] ; //石ひろい


		//アニメーション切り替わりの際の特殊動作ＩＤ 1=ジャンプ 2=[歩くor落下]状態に戻る 3=飛び道具発生 4=ステップ移動 5=振り向き判定
		// 在动画切换专项行动的ID  1= 跳转  2= 回到状态[歩くor落下] 3=新一代导弹 4=步进运动 5=判决转身
		static private const $HERO_MOTION_CONTINUE_SETTINGS:Array = [];
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.STAND] =              		[ 0 , 0 , 0 , 0 ] ; //歩く
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.RUN] =                		[ 0 , 0 , 0 , 0 , 0 , 0 ] ; //走る
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.TAKE_OFF] = 	         		[ 1 , 0 , 0 , 0 , 2 ] ; //飛ぶ
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.PUNCH] = 	           		[ 5 , 0 , 2 ] ; //パンチ
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.QIANG_CHONG$] = 	     		[ 0 , 0 , 0 , 2 ] ; //強いパンチ
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.TIAO_ZHUANG_CHONG$] = 		[ 0 , 0 , 2 ] ; //ジャンプパンチ
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.TIAO_TI$] = 	         		[ 0 , 0 , 2 ] ; //ジャンプキック
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.KICK] =               		[ 5 , 0 , 2 ] ; //キック
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.KNOCKED_S] = 		     		[ 2 ] ; //弱ダメージ
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.KNOCKED_M] =          		[ 2 ] ; //中ダメージ
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.KNOCKED_L] =          		[ 2 ] ; //強ダメージ
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.XIANG_XIA$] = 	       		[ 0 , 0 , 0 , 0 , 2 ] ; //ダウン
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.FALL] =               		[ 0 , 2 ] ; //落下
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.THROW] =              		[ 0 , 3 , 0 , 2 ] ; //投擲
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.BU_ZHOU$] =           		[ 4 , 0 , 0 , 0 , 2 ] ; //ステップ
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.PUNCH2] = 	           		[ 5 , 0 , 2 ] ; //パンチ２段目
		$HERO_MOTION_CONTINUE_SETTINGS[Motions.SHI_BAN$] =           		[ 2 ] ; //石ひろい

		//攻撃判定
		static private const $HERO_HIT_DETECTIONS:Array = [];
		$HERO_HIT_DETECTIONS[Motions.STAND] =              		[ 0 , 0 , 0 , 0 ] ; //歩く
		$HERO_HIT_DETECTIONS[Motions.RUN] =                		[ 0 , 0 , 0 , 0 , 0 , 0 ] ; //走る
		$HERO_HIT_DETECTIONS[Motions.TAKE_OFF] = 	         		[ 0 , 0 , 0 , 0 , 0 ] ; //飛ぶ
		$HERO_HIT_DETECTIONS[Motions.PUNCH] = 	           		[ 0 , 1 , 0 ] ; //パンチ
		$HERO_HIT_DETECTIONS[Motions.QIANG_CHONG$] = 	     		[ 0 , 0 , 2 , 0 ] ; //強いパンチ
		$HERO_HIT_DETECTIONS[Motions.TIAO_ZHUANG_CHONG$] = 		[ 0 , 1 , 0 ] ; //ジャンプパンチ
		$HERO_HIT_DETECTIONS[Motions.TIAO_TI$] = 	         		[ 0 , 2 , 0 ] ; //ジャンプキック
		$HERO_HIT_DETECTIONS[Motions.KICK] =               		[ 0 , 1 , 0 ] ; //キック
		$HERO_HIT_DETECTIONS[Motions.KNOCKED_S] = 		     		[ 0 ] ; //弱ダメージ
		$HERO_HIT_DETECTIONS[Motions.KNOCKED_M] =          		[ 0 ] ; //中ダメージ
		$HERO_HIT_DETECTIONS[Motions.KNOCKED_L] =          		[ 0 ] ; //強ダメージ
		$HERO_HIT_DETECTIONS[Motions.XIANG_XIA$] = 	       		[ 0 , 0 , 0 , 0 , 0 ] ; //ダウン
		$HERO_HIT_DETECTIONS[Motions.FALL] =               		[ 0 , 0 ] ; //落下
		$HERO_HIT_DETECTIONS[Motions.THROW] =              		[ 0 , 0 , 2 , 0 ] ; //投擲
		$HERO_HIT_DETECTIONS[Motions.BU_ZHOU$] =           		[ 0 , 0 , 0 , 0 , 0 ] ; //ステップ
		$HERO_HIT_DETECTIONS[Motions.PUNCH2] = 	           		[ 0 , 1 , 0 ] ; //パンチ２段目
		$HERO_HIT_DETECTIONS[Motions.SHI_BAN$] =           		[ 0 ] ; //石ひろい

		public function Hero ( srcCharacterAtlasBitmap:Bitmap , colorTransform:ColorTransform = null ) :void {
			super ( srcCharacterAtlasBitmap , colorTransform , $HERO_ASSET_FRAMES , $HERO_MOTION_TO_WEIGTH , $HERO_INPUT_ALLOWANCE , $HERO_D , $HERO_MOTION_CONTINUE_SETTINGS , $HERO_HIT_DETECTIONS ) ;
		}

	}
}
