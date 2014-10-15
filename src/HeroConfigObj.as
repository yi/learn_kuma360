package
{
	public class HeroConfigObj
	{
		static private const CONFIG:Object = {
			"bnc": [
				{
					"af": 4,
					"lf": 2,
					"mr": 4
				},
				{
					"af": 5,
					"lf": 2,
					"ia": 34
				},
				{
					"af": 6,
					"lf": 5,
					"ia": 34
				},
				{
					"af": 7,
					"lf": 2,
					"ia": 34
				},
				{
					"af": 4,
					"lf": 5,
					"ia": 16,
					"mr": 2
				}
			],
			"pa2": [
				{
					"lf": 2,
					"af": 6
				},
				{
					"at": 1,
					"af": 13,
					"lf": 2,
					"ia": 2
				},
				{
					"af": 4,
					"lf": 5,
					"ia": 16,
					"mr": 2
				}
			],
			"jmp": [
				{
					"af": 4,
					"lf": 8,
					"ia": 16,
					"mr": 1
				},
				{
					"af": 5,
					"lf": 2,
					"ia": 2
				},
				{
					"af": 6,
					"lf": 5,
					"ia": 2
				},
				{
					"af": 7,
					"lf": 2,
					"ia": 2
				},
				{
					"af": 4,
					"lf": 5,
					"mr": 2
				}
			],
			"kkl": [
				{
					"af": 18,
					"lf": 15,
					"mr": 2
				}
			],
			"thr": [
				{
					"lf": 7,
					"af": 25
				},
				{
					"af": 26,
					"lf": 4,
					"mr": 3
				},
				{
					"at": 2,
					"af": 27,
					"lf": 12
				},
				{
					"af": 0,
					"lf": 5,
					"mr": 2
				}
			],
			"ph4": [
				{
					"lf": 3,
					"af": 10
				},
				{
					"lf": 3,
					"af": 11
				},
				{
					"at": 2,
					"af": 12,
					"lf": 7,
					"ia": 16
				},
				{
					"af": 12,
					"lf": 20,
					"ia": 16,
					"mr": 2
				}
			],
			"pck": [
				{
					"af": 24,
					"lf": 50,
					"mr": 2
				}
			],
			"kkm": [
				{
					"af": 17,
					"lf": 15,
					"mr": 2
				}
			],
			"kks": [
				{
					"af": 16,
					"lf": 15,
					"mr": 2
				}
			],
			"fal": [
				{
					"lf": 2,
					"af": 7
				},
				{
					"af": 4,
					"lf": 5,
					"mr": 2
				}
			],
			"idl": [
				{
					"af": 0,
					"lf": 8,
					"ia": 15
				},
				{
					"af": 1,
					"lf": 8,
					"ia": 15
				},
				{
					"af": 2,
					"lf": 8,
					"ia": 15
				},
				{
					"af": 3,
					"lf": 8,
					"ia": 15
				}
			],
			"ph3": [
				{
					"af": 29,
					"lf": 2,
					"mr": 5
				},
				{
					"at": 1,
					"af": 15,
					"lf": 2
				},
				{
					"af": 15,
					"lf": 22,
					"ia": 18,
					"mr": 2
				}
			],
			"knd": [
				{
					"lf": 9,
					"af": 19
				},
				{
					"lf": 9,
					"af": 20
				},
				{
					"lf": 9,
					"af": 21
				},
				{
					"lf": 9,
					"af": 22
				},
				{
					"af": 22,
					"lf": 15,
					"mr": 2
				}
			],
			"ph1": [
				{
					"af": 8,
					"lf": 3,
					"mr": 5
				},
				{
					"at": 1,
					"af": 9,
					"lf": 1
				},
				{
					"af": 9,
					"lf": 16,
					"ia": 18,
					"mr": 2
				}
			],
			"pa1": [
				{
					"lf": 2,
					"af": 6
				},
				{
					"at": 2,
					"af": 14,
					"lf": 2
				},
				{
					"af": 4,
					"lf": 5,
					"ia": 16,
					"mr": 2
				}
			],
			"run": [
				{
					"af": 32,
					"lf": 5,
					"ia": 15
				},
				{
					"af": 33,
					"lf": 5,
					"ia": 15
				},
				{
					"af": 34,
					"lf": 5,
					"ia": 15
				},
				{
					"af": 35,
					"lf": 5,
					"ia": 15
				},
				{
					"af": 36,
					"lf": 5,
					"ia": 15
				},
				{
					"af": 37,
					"lf": 5,
					"ia": 15
				}
			],
			"ph2": [
				{
					"af": 8,
					"lf": 3,
					"mr": 5
				},
				{
					"at": 1,
					"af": 9,
					"lf": 1
				},
				{
					"af": 9,
					"lf": 16,
					"ia": 2,
					"mr": 2
				}
			]
		};

		/*
		* af: assert frame
		* ia: InputAllowance
		* lf: last for (HERO_MOTION_TO_WEIGTH)
		* pc: PlayheadCondition($HERO_PLAYHEAD_CONDITION)
		* mr: motion recation ($HERO_MOTION_REACTIONS)
		* at: attack type ($HERO_HIT_DETECTIONS)
		**/


		static public const $ASSET_FRAME:String = "af";
		static public const $INPUT_ALLOWANCE:String = "ia";
		static public const $LAST_FOR:String = "lf";
		static public const $PLAYHEAD_CONDITION:String = "pc";
		static public const $MOTION_REACTION:String = "mr";
		static public const $ATTACK_TYPE:String = "at";

//		static private function getConfig(motionId:String, key:String):Object
//		{
//			if(CONFIG[motionId] == null) return null;
//			return CONFIG[motionId][key];
//		}

		static public function getConfigValue(motionId:String, key:String, frameId:int):int
		{
			var conf:Array = CONFIG[motionId];
			if(conf && conf.length > frameId)
			{
				return conf[frameId][key] || 0;
			}
			else
			{
				return 0;
			}
		}

		static public function countAssetFrame(motionId:String):uint
		{
			var conf:Array = CONFIG[motionId];
			if(conf)return conf.length
			else return 0;
		}

		static public function getAssetFrame(motionId:String, frameId:int):int
		{
			return getConfigValue(motionId, $ASSET_FRAME, frameId);
		}

		static public function getInputAllowance(motionId:String, frameId:int):int
		{
			return getConfigValue(motionId, $INPUT_ALLOWANCE, frameId);
		}

		static public function getLastFor(motionId:String, frameId:int):int
		{
			return getConfigValue(motionId, $LAST_FOR, frameId);
		}

		static public function getPlayheadCondition(motionId:String, frameId:int):int
		{
			return getConfigValue(motionId, $PLAYHEAD_CONDITION, frameId);
		}

		static public function getMotionReaction(motionId:String, frameId:int):int
		{
			return getConfigValue(motionId, $MOTION_REACTION, frameId);
		}

		static public function getAttackType(motionId:String, frameId:int):int
		{
			return getConfigValue(motionId, $ATTACK_TYPE, frameId);
		}


		static private function dump():void
		{
			var result:Object = {};
			for(var motionId:String in CONFIG)
			{
				var conf:Object = CONFIG[motionId];

				result[motionId] = [];
				var assetFrames:Array = conf[$ASSET_FRAME];
				var allowance:Array = conf[$INPUT_ALLOWANCE];
				var lastFor:Array = conf[$LAST_FOR];
				var motionReaction:Array = conf[$MOTION_REACTION];
				var attackType:Array = conf[$ATTACK_TYPE];

				for(var i:int = 0; i <  assetFrames.length; i++)
				{
					var piece:Object = {};
					piece[$ASSET_FRAME] = assetFrames[i];
					if(allowance[i] > 0) piece[$INPUT_ALLOWANCE] = allowance[i];
					if(lastFor[i]) piece[$LAST_FOR] = lastFor[i];
					if(motionReaction[i] > 0) piece[$MOTION_REACTION] = motionReaction[i];
					if(attackType[i]) piece[$ATTACK_TYPE] = attackType[i];
					result[motionId].push(piece);
				}
			}
			trace(JSON.stringify(result, null, 4));
		}

		dump();

	}
}
