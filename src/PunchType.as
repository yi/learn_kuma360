package
{
	public class PunchType
	{
		public static const NONE:uint = 0;
		public static const S:uint = 1;
		public static const M:uint = 2;
		public static const L:uint = 3;

		public static function getDamageShakeByType(type):uint{
			return type == S ? 20 : type == M ? 5 : type == L ? 8 : 0;
		}


		public static function getSpeedPowerXByType(type):uint{
			return type == S ? 1 : type == M ? 3 : type == L ? 3 : 0;
		}

	}
}