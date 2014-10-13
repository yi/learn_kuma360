package
{
	public class InputAllowance
	{
		//入力の許可  允许输入, bit_flag  1=移動 + 2=攻撃 + 4=ジャンプ + 8=投擲 + 16=ステップ + 32 = 慣性操作

		public static const NA:uint = 0;
		public static const MOVE:uint = 1;
		public static const ATTACK:uint = 2;
		public static const JUMP:uint = 4;
		public static const THROW:uint = 8;
		public static const STEP:uint = 16;
		public static const INERTIA:uint = 32;
	}
}