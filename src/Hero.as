package
{
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;

	public
	//雑魚のモーション
	class Hero extends CharctorBase {

		//アニメパターン  动漫图案
		static private const $HERO_ASSET_FRAMES:Array = [];
		$HERO_ASSET_FRAMES[Motions.STAND] = [ 0 , 1 , 2 , 3 ] ; //歩く  站立
		$HERO_ASSET_FRAMES[Motions.RUN] = [ 32 , 33 , 34 , 35 , 36 , 37 ] ; //走る  行走
		$HERO_ASSET_FRAMES[Motions.TAKE_OFF] = 	[ 4 , 5 , 6 , 7 , 4 ] ; //飛ぶ  飞
		$HERO_ASSET_FRAMES[Motions.PUNCH] = 	[ 8 , 9 , 9 ] ; //パンチ 冲床
		$HERO_ASSET_FRAMES[Motions.QIANG_CHONG$] = 	[ 10 , 11 , 12 , 12 ] ; //強いパンチ  强冲
		$HERO_ASSET_FRAMES[Motions.TIAO_ZHUANG_CHONG$] = [  6 , 13 , 4 ] ; //ジャンプパンチ  跳转冲
		$HERO_ASSET_FRAMES[Motions.TIAO_TI$] = 	[  6 , 14 , 4 ] ; //ジャンプキック  跳踢
		$HERO_ASSET_FRAMES[Motions.KICK] = [ 29 , 15 , 15 ] ; //キック  踢
	    $HERO_ASSET_FRAMES[Motions.KNOCKED_S] = 		[ 16 ] ; //弱ダメージ  微弱损伤
		$HERO_ASSET_FRAMES[Motions.KNOCKED_M] = [ 17 ] ; //中ダメージ  中等破坏
		$HERO_ASSET_FRAMES[Motions.KNOCKED_L] = [ 18 ] ; //強ダメージ  强力损伤
		$HERO_ASSET_FRAMES[Motions.XIANG_XIA$] = 	[ 19 , 20 , 21 , 22 , 22 ] ; //ダウン  向下
		$HERO_ASSET_FRAMES[Motions.FALL] = [ 7 , 4 ] ;//落下
		$HERO_ASSET_FRAMES[Motions.THROW] = [ 25 , 26 , 27 , 0 ] ; //投擲
		$HERO_ASSET_FRAMES[Motions.BU_ZHOU$] = [ 4  ,  5 ,  6 ,  7 , 4 ] ; //ステップ  步骤
		$HERO_ASSET_FRAMES[Motions.PUNCH2] = 	[ 8 , 9 , 9 ] ; //パンチ２段目 第二阶段冲
		$HERO_ASSET_FRAMES[Motions.SHI_BAN$] = [ 24 ] ; //石ひろい  宽阔的石板

//		//アニメパターン  动漫图案
//		private const $HERO_ASSET_FRAMES:Array = [
//			[ 0 , 1 , 2 , 3 ] , //歩く  站立
//			[ 32 , 33 , 34 , 35 , 36 , 37 ] , //走る  行走
//			[ 4 , 5 , 6 , 7 , 4 ] , //飛ぶ  飞
//			[ 8 , 9 , 9 ] , //パンチ 冲床
//			[ 10 , 11 , 12 , 12 ] , //強いパンチ  强冲
//			[  6 , 13 , 4 ] , //ジャンプパンチ  跳转冲
//			[  6 , 14 , 4 ] , //ジャンプキック  跳踢
//			[ 29 , 15 , 15 ] , //キック  踢
//			[ 16 ] , //弱ダメージ  微弱损伤
//			[ 17 ] , //中ダメージ  中等破坏
//			[ 18 ] , //強ダメージ  强力损伤
//			[ 19 , 20 , 21 , 22 , 22 ] , //ダウン  向下
//			[ 7 , 4 ] ,//落下
//			[ 25 , 26 , 27 , 0 ] , //投擲
//			[ 4  ,  5 ,  6 ,  7 , 4 ] , //ステップ  步骤
//			[ 8 , 9 , 9 ] , //パンチ２段目 第二阶段冲
//			[ 24 ] , //石ひろい  宽阔的石板
//		];

		//ウェイト  重量
		private const $HERO_MOTION_TO_WEIGTH:Array = [
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

		//入力の許可  允许输入, bit_flag  1=移動 + 2=攻撃 + 4=ジャンプ + 8=投擲 + 16=ステップ + 32 = 慣性操作
		private const $HERO_INPUT_ALLOWANCE:Array = [
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
		//动画的条件  0=重量  1=_velocity.yが+方向 2=地面上的地 3=耐力动画到底是0
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
		// 在动画切换专项行动的ID  1= 跳转  2= 回到状态[歩くor落下] 3=新一代导弹 4=步进运动 5=判决转身
		private const $HERO_MOTION_CONTINUE_SETTINGS:Array = [
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
		private const $HERO_HIT_DETECTIONS:Array = [
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

		public function Hero ( srcCharacterAtlasBitmap:Bitmap , colorTransform:ColorTransform = null ) :void {
			super ( srcCharacterAtlasBitmap , colorTransform , $HERO_ASSET_FRAMES , $HERO_MOTION_TO_WEIGTH , $HERO_INPUT_ALLOWANCE , $HERO_D , $HERO_MOTION_CONTINUE_SETTINGS , $HERO_HIT_DETECTIONS ) ;
		}

	}
}
