package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	///
	public class Global {
		public static var _key:Array = new Array ( 256 ) ;
		public static var _canvas:BitmapData = new BitmapData ( 465 , 465 , false , 0 ) ;

		/**
		 * (error)
		 */
		private static var onComplete:Function ;
		public static function init(handler:Function):void
		{
			onComplete = handler;
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			loader.load(new URLRequest("assets/background.png"));
		}
		private static function errorHandler(e:IOErrorEvent):void
		{
			onComplete(e.text);
		}
		public static var _back:BitmapData = new BitmapData ( 465 , 465 , false , 0 ) ;
		private static function completeHandler(e:Event):void
		{
			var li:LoaderInfo = e.target as LoaderInfo;
			_back = Bitmap(li.content).bitmapData;
			onComplete();
		}
//		[Embed(source="background.png")]
//		private static var BMClass:Class;
//		private static var BM:Bitmap = new BMClass();
//		_back.draw(new BMClass());
		public static var _world_shake:int = 0 ;
	}

}