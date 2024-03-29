package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public
	//戦闘シーン
	class SceneBattle extends SceneBase {

		private var _rendering_container:Vector.<Iactor> = new Vector.<Iactor> ( ) ;
		private var heroes:Vector.<Hero> = null ;
		private var items:Vector.<Item> = null ;
		private var _mainHero:Hero = null ;
		private var _effect:Effect = null ;
		private var _scoreText:TextField = new TextField ;


//		[Embed(source="actor.png")]
//		private static var BMPActorClass:Class;
//		private static var BMActor:Bitmap = new BMPActorClass();
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
			loader.load(new URLRequest("assets/actor.png"));
		}
		public static var BMActor:Bitmap ;
		private static function errorHandler(e:IOErrorEvent):void
		{
			onComplete(e.text);
		}
		private static function completeHandler(e:Event):void
		{
			var li:LoaderInfo = e.target as LoaderInfo;
			BMActor = Bitmap(li.content);
			onComplete();
		}


		////////////////////////////////////
//		public static const FILENAME:String = "actor.png" ;
		//const FILENAME2:String = "http://assets.wonderfl.net/images/related_images/3/37/37b4/37b4ec1f74efac5568eedd817dab449d42ff1eb4" ;
		public static const ZERO_POINT:Point = new Point ( 0 , 0 ) ;
		public static const ZMAX:int = 300 ;
		public static var _score:uint = 0 ;
		public static var _end:Boolean = false ;

		//宣伝用//////////////////////
		//	private var _S0:PushButton ;
		//	private var _S1:PushButton ;
		/////////////////////////////

		private var _limit:int = 0 ;

		////////////////////////////////////
		public function SceneBattle ( ) {

			_limit = 40000 ;

			//キャラクター用
			heroes = new Vector.<Hero>;
			_mainHero = new Hero ( BMActor ) ;
			heroes.push ( _mainHero ) ;

			heroes.push ( new Hero ( BMActor , new ColorTransform ( .4 , 1 , .4 , 1 ) ) ) ;
			heroes.push ( new Hero ( BMActor , new ColorTransform (  1 , 1 , .2 , 1 ) ) ) ;
			heroes.push ( new Hero ( BMActor , new ColorTransform ( .2 , .2,  1 , 1 ) ) ) ;
			heroes.push ( new Hero ( BMActor , new ColorTransform (  1 , .2,  1 , 1 ) ) ) ;

			//アイテム用
			items = new Vector.<Item>;
			items.push ( new Item ( ) ) ;

			//ヒットマーク用 Hit Mark
			_effect = new Effect ;

			addChild ( new Bitmap ( Global._canvas ) ) ;

			//送信ボタン////////////////////////////////////////////////////

			_score = 0 ;
			_scoreText.autoSize = "left" ;
			_scoreText.defaultTextFormat = new TextFormat ( null , 50 , 0x000000 ) ;
			_scoreText.text = _score.toString () ;
			addChild ( _scoreText ) ;

			var B:BitmapData = Global._back ;

			//キャラクタ画像読み込み(雑魚)  Character image loading (small fish)
//			B.fillRect ( new Rectangle ( 0 ,    0 , B.width , B.height ) , 0x91ACCE ) ;
//			B.fillRect ( new Rectangle ( 0 , ZMAX , B.width , B.height ) , 0x75D36D ) ;

			//		var L2:Loader = new Loader;
			//		L2.contentLoaderInfo.addEventListener ( Event.COMPLETE, compLoad2 ) ;
			//		L2.contentLoaderInfo.addEventListener ( IOErrorEvent.IO_ERROR , function ():void { } ) ;
			//		L2.load ( new URLRequest ( FILENAME2 ) , new LoaderContext ( true ) ) ;

		}

		////////////////////////////////////
		public override function release ( ) :void {

			//		_S1 = null ;

			_effect.release ( ) ;

			for each ( var hero:Hero in heroes ) {
				hero.release ( ) ;
			}

			for each ( var item:Item in items ) {
				item.release ( ) ;
			}

		}

		////////////////////////////////////
		public override function core ( ):void {

			var hero1:Hero ;
			var hero2:Hero ;
			var item:Item ;
			var renderableObject:Iactor ;
			Global._canvas.fillRect(Global._canvas.rect,0);
			//背景
			if ( 0 < Global._world_shake ) {
				-- Global._world_shake ;
				Global._canvas.copyPixels (
					Global._back ,
					Global._back.rect ,
					new Point ( Math.random ( ) * 10 - 5 , Math.random ( ) * 10 - 5 )
				) ;
			} else {
				Global._canvas.copyPixels (
					Global._back ,
					Global._back.rect ,
					ZERO_POINT
				) ;
			}

			if ( _mainHero == null ) {
				return ;
			}

			//アイテム更新 更新道具状态
			for each ( item in items ) {
				item.update ( ) ;
			}

			// 角色操作输入
			for each ( hero1 in heroes ) {
				if ( hero1 == _mainHero ) {
					_mainHero.input (
						Global._key[90] ,
						Global._key[88] ,
						Global._key[37] ,
						Global._key[39] ,
						Global._key[38] ,
						Global._key[40]
					) ;
				} else {
					hero1.inputAuto() ;
				}
			}

			//更新
			for each ( hero1 in heroes ) {
				hero1.update ( items , _mainHero ) ;
			}

			//攻撃判定1  玩家所操作的角色的攻击判断
			for each ( hero1 in heroes ) {
				_mainHero.attackChk ( hero1 , _effect ) ;
			}

			//攻撃判定2  敌人攻击玩家控制的角色
			for each ( hero1 in heroes ) {
				hero1.attackChk ( _mainHero , _effect ) ;
			}

			//アイテムの攻撃判定  投掷道具攻击人
			for each ( item in items ) {
				for each ( hero1 in heroes ) {
					item.attackChk ( hero1 , _effect ) ;
				}
			}

			//移動判定
			for each ( hero1 in heroes ) {
				for each ( hero2 in heroes ) {
					hero1.moveChk ( hero2 ) ;
				}
			}


			//描画順決定
			_rendering_container = _rendering_container.concat ( heroes ) ;
			_rendering_container = _rendering_container.concat ( items ) ;
			_rendering_container.sort ( function ( A:Iactor , B:Iactor ) :Number { return A.pos.z - B.pos.z ; } ) ;

			//影描画
			for each ( renderableObject in _rendering_container ) {
				renderableObject.render_shadow ( ) ;
			}

			//描画
			for each ( renderableObject in _rendering_container ) {
				renderableObject.render ( ) ;
			}

			while ( _rendering_container.length ) {
				_rendering_container.pop ( ) ;
			}

			_effect.update ( ) ;
			_effect.render ( ) ;

			-- _limit ;
			if ( _limit <= 0 ) {
				_limit = 0 ;
				_mainHero.setDie ( ) ;
			}

			_scoreText.text = _limit.toString () ;
			if ( _mainHero.getDeath ( ) ) {
				_end = true ;
				//			_S1.visible = true ;
			}

		}


	}


}