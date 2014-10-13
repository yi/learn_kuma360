package
{
	public class PlayheadCondition
	{
		//动画的条件  0=nomal  1=_velocity.yが+方向 2=地面上的地 3=耐力动画到底是0
		public static const WHATEVER:uint = 0;
		public static const ONLY_IN_AIR:uint = 1;
		public static const ONLY_ON_GROUND:uint = 2;
		public static const IS_ALIVE:uint = 3;
	}
}