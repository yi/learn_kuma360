package
{
	public class HeroConfig
	{
		static private const CONFIG:Object = {};

		/*
		* af: assert frame
		* ia: InputAllowance
		* lf: last for (HERO_MOTION_TO_WEIGTH)
		* pc: PlayheadCondition($HERO_PLAYHEAD_CONDITION)
		* mr: motion recation ($HERO_MOTION_REACTIONS)
		* at: attack type ($HERO_HIT_DETECTIONS)
		**/


		// 站立
		CONFIG[Motions.STAND] = {
			af : [ 0 , 1 , 2 , 3 ] ,
			ia:	[ InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW] , //歩wpくく
			pc:    		[ 0 , 0 , 0 , 0 ] , //歩く
			mr:		[ 0 , 0 , 0 , 0 ] , //歩く
			at: 		[ 0 , 0 , 0 , 0 ] , //歩く
			lf: [ 8 , 8 , 8 , 8 ]  //歩く
		}
		//走る  行走
		CONFIG[Motions.RUN] =     {
			af :         [ 32 , 33 , 34 , 35 , 36 , 37 ] ,
			ia:	[ InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW, InputAllowance.MOVE_ATTACK_JUMP_THROW] , //走る
			pc:    		[ 0 , 0 , 0 , 0 , 0 , 0 ] , //走る
			mr:		[ 0 , 0 , 0 , 0 , 0 , 0 ] , //走る
			at: 		[ 0 , 0 , 0 , 0 , 0 , 0 ] , //走る
			lf:[ 5 , 5 , 5 , 5 , 5 , 5 ]  //走る
		}
		//飛ぶ  飞
		CONFIG[Motions.TAKE_OFF] = 	   {
			af :   [ 4 , 5 , 6 , 7 , 4 ] ,
			ia:	[ InputAllowance.BOUNCE, InputAllowance.ATTACK  , InputAllowance.ATTACK  , InputAllowance.ATTACK , 0 ] , //飛ぶ
			pc:    	[ 0 , PlayheadCondition.ONLY_IN_AIR , 0 , PlayheadCondition.ONLY_ON_GROUND , 0 ] , //飛ぶ
			mr:		[ 1 , 0 , 0 , 0 , 2 ] , //飛ぶ
			at: 		[ 0 , 0 , 0 , 0 , 0 ] , //飛ぶ
			lf: [ 8 , 2 , 5 , 2 , 5 ]  //飛ぶ
		}
		//パンチ 冲床
		CONFIG[Motions.PUNCH1] = 	  {
			af :   [ 8 , 9 , 9 ] ,
			ia:	[ 0 , 0 , InputAllowance.ATTACK_STEP ] , //パンチ
			pc:    		[ 0 , 0 , 0 ] , //パンチ
			mr:		[ 5 , 0 , 2 ] , //パンチ
			at: 		[ 0 , PunchType.S , 0 ] , //パンチ
			lf: [ 3 , 1 , 16 ]  //パンチ
		}
		//強いパンチ  强冲
		CONFIG[Motions.PUNCH4_COLLIDE] = {
			af :   [ 10 , 11 , 12 , 12 ] ,
			ia: 	[ 0 , 0 , InputAllowance.BOUNCE , InputAllowance.BOUNCE ] , //強いパンチ
			pc:	     	[ 0 , 0 , 0 , 0 ] , //強いパンチ
			mr:  	[ 0 , 0 , 0 , 2 ] , //強いパンチ
			at:   		[ 0 , 0 , PunchType.M , 0 ] , //強いパンチ
			lf: [ 3 , 3 , 7 , 20 ]  //強いパンチ
		}
		//ジャンプパンチ  跳转冲
		CONFIG[Motions.ATTACK_IN_AIR2] =  {
			af : [  6 , 13 , 4 ] ,
			ia:[ 0 , InputAllowance.ATTACK , InputAllowance.BOUNCE ] , //ジャンプパンチ
			pc:			[ 0 , PlayheadCondition.ONLY_ON_GROUND , 0 ] , //ジャンプパンチ
			mr:	[ 0 , 0 , 2 ] , //ジャンプパンチ
			at:[ 0 , PunchType.S , 0 ] , //ジャンプパンチ
			lf: [ 2 , 2 , 5 ]  //ジャンプパンチ
		}
		//ジャンプキック  跳踢
		CONFIG[Motions.ATTACK_IN_AIR1] = {
			af :  [  6 , 14 , 4 ] ,
			ia:    [ 0 , 0 , InputAllowance.BOUNCE ] , //ジャンプキック
			pc:	        [ 0 , PlayheadCondition.ONLY_ON_GROUND , 0 ] , //ジャンプキック
			mr:     [ 0 , 0 , 2 ] , //ジャンプキック
			at:    		[ 0 , PunchType.M , 0 ] , //ジャンプキック
			lf: [ 2 , 2 , 5 ]  //ジャンプキック
		}
		//キック  踢
		CONFIG[Motions.PUNCH3_KICK] =    {
			af :    [ 29 , 15 , 15 ] ,
			ia:     	[ 0 , 0 , InputAllowance.ATTACK_STEP ] , //キック
			pc:             [ 0 , 0 , 0 ] , //キック
			mr:       [ 5 , 0 , 2 ] , //キック
			at:     		[ 0 , PunchType.S , 0 ] , //キック
			lf:[ 2 , 2 , 22 ]  //キック
		}
		//弱ダメージ  微弱损伤
		CONFIG[Motions.KNOCKED_S] = 	{
			af :   [ 16 ] ,
			ia:[ 0 ] , //弱ダメージ
			pc:		     	[ 0 ] , //弱ダメージ
			mr:	[ 2 ] , //弱ダメージ
			at:	[ 0 ] , //弱ダメージ
			lf: [ 15 ]  //弱ダメージ
		}
		//中ダメージ  中等破坏
		CONFIG[Motions.KNOCKED_M] =   {
			af :     [ 17 ] ,
			ia:[ 0 ] , //中ダメージ
			pc:        		[ 0 ] , //中ダメージ
			mr:		[ 2 ] , //中ダメージ
			at:	[ 0 ] , //中ダメージ
			lf: [ 15 ]  //中ダメージ
		}
		//強ダメージ  强力损伤
		CONFIG[Motions.KNOCKED_L] =   {
			af :     [ 18 ] ,
			ia:[ 0 ] , //強ダメージ
			pc:        		[ 0 ] , //強ダメージ
			mr:		[ 2 ] , //強ダメージ
			at:	[ 0 ] , //強ダメージ
			lf: [ 15 ]  //強ダメージ
		}
		//ダウン  向下
		CONFIG[Motions.KNOCK_DOWN] = {
			af :      [ 19 , 20 , 21 , 22 , 22 ] ,
			ia:[ 0 , 0 , 0 , 0 , 0 ] , //ダウン
			pc:	       		[ 0 , 0 , 0 , 0 , PlayheadCondition.IS_ALIVE ] , //ダウン
			mr:[ 0 , 0 , 0 , 0 , 2 ] , //ダウン
			at:	[ 0 , 0 , 0 , 0 , 0 ] , //ダウン
			lf: [ 9 , 9 , 9 , 9 , 15 ]  //ダウン
		}
		//落下
		CONFIG[Motions.FALL] =     {
			af :      [ 7 , 4 ] ,
			ia:[ 0 , 0 ] , //落下
			pc:            		[ PlayheadCondition.ONLY_ON_GROUND , 0 ] , //落下
			mr:[ 0 , 2 ] , //落下
			at:	[ 0 , 0 ] , //落下
			lf: [ 2 , 5 ] //落下
		}
		//投擲
		CONFIG[Motions.THROW] =   {
			af :      [ 25 , 26 , 27 , 0 ] ,
			ia:[ 0 , 0 , 0 , 0 ] , //投擲
			pc:            		[ 0 , 0 , 0 , 0 ] , //投擲
			mr:[ 0 , 3 , 0 , 2 ] , //投擲
			at:	[ 0 , 0 , PunchType.M , 0 ] , //投擲
			lf: [ 7 , 4 , 12 , 5 ]  //投擲
		}
		//ステップ  突进
		CONFIG[Motions.BOUNCE] =  {
			af :    [ 4  ,  5 ,  6 ,  7 , 4 ] ,
			ia:[ 0 , InputAllowance.ATTACK_INERTIA , InputAllowance.ATTACK_INERTIA , InputAllowance.ATTACK_INERTIA , InputAllowance.BOUNCE ] , //ステップ
			pc:          		[ 0 , 0 , 0 , PlayheadCondition.ONLY_ON_GROUND , 0 ] , //ステップ
			mr:[ 4 , 0 , 0 , 0 , 2 ] , //ステップ
			at:[ 0 , 0 , 0 , 0 , 0 ] , //ステップ
			lf: [ 2 , 2 , 5 , 2 , 5 ]  //ステップ
		}
		//パンチ２段目 第二阶段冲
		CONFIG[Motions.PUNCH2] = 	{
			af :      [ 8 , 9 , 9 ] ,
			ia:[ 0 , 0 , InputAllowance.ATTACK ] , //パンチ２段目
			pc:	           		[ 0 , 0 , 0 ] , //パンチ２段目
			mr:	[ 5 , 0 , 2 ] , //パンチ２段目
			at:[ 0 , PunchType.S , 0 ] , //パンチ２段目
			lf: [ 3 , 1 , 16 ] //パンチ２段目
		}
		//石ひろい  宽阔的石板
		CONFIG[Motions.PICK_UP] =     {
			af :      [ 24 ] ,
			ia: [ 0 ] , //石ひろい
			pc:           		[ 0 ] , //石ひろい
			mr:	[ 2 ] , //石ひろい
			at:[ 0 ] , //石ひろい
			lf: [ 50 ]  //石ひろい
		}

		static public const $ASSET_FRAME:String = "af";
		static public const $INPUT_ALLOWANCE:String = "ia";
		static public const $LAST_FOR:String = "lf";
		static public const $PLAYHEAD_CONDITION:String = "pc";
		static public const $MOTION_REACTION:String = "mr";
		static public const $ATTACK_TYPE:String = "at";

		static private function getConfig(motionId:int, key:String):Object
		{
			if(CONFIG[motionId] == null) return null;
			return CONFIG[motionId][key];
		}

		static public function getConfigValue(motionId:int, key:String, frameId:int):int
		{
			var conf:Object = getConfig(motionId, key);
			if(conf) return conf[frameId] || 0
			else return 0
		}

		static public function getAssetFrame(motionId:int, frameId:int):int
		{
			return getConfigValue(motionId, $ASSET_FRAME, frameId);
		}

		static public function getInputAllowance(motionId:int, frameId:int):int
		{
			return getConfigValue(motionId, $INPUT_ALLOWANCE, frameId);
		}

		static public function getLastFor(motionId:int, frameId:int):int
		{
			return getConfigValue(motionId, $LAST_FOR, frameId);
		}

		static public function getPlayheadCondition(motionId:int, frameId:int):int
		{
			return getConfigValue(motionId, $PLAYHEAD_CONDITION, frameId);
		}

		static public function getMotionReaction(motionId:int, frameId:int):int
		{
			return getConfigValue(motionId, $MOTION_REACTION, frameId);
		}

		static public function getAttackType(motionId:int, frameId:int):int
		{
			return getConfigValue(motionId, $ATTACK_TYPE, frameId);
		}




	}
}
