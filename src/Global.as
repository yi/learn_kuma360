package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	///
	public class Global {
		public static var _key:Array = new Array ( 256 ) ;
		public static var _canvas:BitmapData = new BitmapData ( 465 , 465 , false , 0 ) ;


		[Embed(source="background.png")]
		private static var BMClass:Class;
		private static var BM:Bitmap = new BMClass();
		public static var _back:BitmapData = new BitmapData ( 465 , 465 , false , 0 ) ;
		_back.draw(new BMClass());
		public static var _world_shake:int = 0 ;
	}

}