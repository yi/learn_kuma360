package
{
	public class Motions
	{
		public static const STAND:String = "idl";
		public static const RUN:String = "run";
		public static const TAKE_OFF:String = "jmp";
		public static const PUNCH1:String = "ph1";
		public static const PUNCH4_COLLIDE:String = "ph4";
		public static const ATTACK_IN_AIR2:String = "pa2";
		public static const ATTACK_IN_AIR1:String = "pa1";
		public static const PUNCH3_KICK:String = "ph3";
		public static const KNOCKED_S:String = "kks";
		public static const KNOCKED_M:String = "kkm";
		public static const KNOCKED_L:String = "kkl";
		public static const KNOCK_DOWN:String = "knd";
		public static const FALL:String = "fal";
		public static const THROW:String = "thr";
		public static const BOUNCE:String = "bnc";
		public static const PUNCH2:String = "ph2";
		public static const PICK_UP:String = "pck";

		public static const DAMAGE_MOTIONS:Array = [KNOCKED_S, KNOCKED_M, KNOCKED_L];

		public static function getRandomDamageMotion():String{
			return DAMAGE_MOTIONS[DAMAGE_MOTIONS.length * Math.random() >> 0];
		}


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


	}
}