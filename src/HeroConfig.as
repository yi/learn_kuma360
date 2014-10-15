package
{
	public class HeroConfig
	{
		static private const CONFIG:Object = {};

		// 站立
		CONFIG[Motions.STAND] = {
			assetFrames : [ 0 , 1 , 2 , 3 ]
		}
		//走る  行走
		CONFIG[Motions.RUN] =     {
			assetFrames :         [ 32 , 33 , 34 , 35 , 36 , 37 ]
		}
		//飛ぶ  飞
		CONFIG[Motions.TAKE_OFF] = 	   {
			assetFrames :   [ 4 , 5 , 6 , 7 , 4 ]
		}

		CONFIG[Motions.PUNCH1] = 	  {
			assetFrames :   [ 8 , 9 , 9 ]  //パンチ 冲床
		}
		CONFIG[Motions.PUNCH4_COLLIDE] = {
			assetFrames :   [ 10 , 11 , 12 , 12 ]  //強いパンチ  强冲
		}
		CONFIG[Motions.ATTACK_IN_AIR2] =  {
			assetFrames : [  6 , 13 , 4 ]  //ジャンプパンチ  跳转冲
		}
		CONFIG[Motions.ATTACK_IN_AIR1] = {
			assetFrames :  [  6 , 14 , 4 ]  //ジャンプキック  跳踢
		}
		CONFIG[Motions.PUNCH3_KICK] =    {
			assetFrames :    [ 29 , 15 , 15 ]  //キック  踢
		}
		CONFIG[Motions.KNOCKED_S] = 	{
			assetFrames :   [ 16 ]  //弱ダメージ  微弱损伤
		}
		CONFIG[Motions.KNOCKED_M] =   {
			assetFrames :     [ 17 ]  //中ダメージ  中等破坏
		}
		CONFIG[Motions.KNOCKED_L] =   {
			assetFrames :     [ 18 ]  //強ダメージ  强力损伤
		}
		CONFIG[Motions.KNOCK_DOWN] = {
			assetFrames :      [ 19 , 20 , 21 , 22 , 22 ]  //ダウン  向下
		}
		CONFIG[Motions.FALL] =     {
			assetFrames :      [ 7 , 4 ] //落下
		}
		CONFIG[Motions.THROW] =   {
			assetFrames :      [ 25 , 26 , 27 , 0 ]  //投擲
		}
		CONFIG[Motions.BOUNCE] =  {
			assetFrames :    [ 4  ,  5 ,  6 ,  7 , 4 ]  //ステップ  突进
		}
		CONFIG[Motions.PUNCH2] = 	{
			assetFrames :      [ 8 , 9 , 9 ]  //パンチ２段目 第二阶段冲
		}

		CONFIG[Motions.PICK_UP] =     {
			assetFrames :      [ 24 ]  //石ひろい  宽阔的石板
		}

		static public function getAssetFrame(motionId:int, frameId:int):int
		{
			if(CONFIG[motionId] == null) return -1;
			return CONFIG[motionId][frameId] || -1;
		}
	}
}