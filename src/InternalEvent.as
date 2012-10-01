package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author VadimT
	 */
	public class InternalEvent extends Event 
	{
		public static const GET_MAIN_LAYER:String = "GET_MAIN_LAYER";
		
		private var _params:Array = null;
		private var _callBack:Function = null;
		
		public function InternalEvent(type:String, callBack:Function = null, ...args) 
		{
			super(type, false, false);
			this.params = args;
			this.callBack = callBack;
		}
		
		public function get params():Array { return _params; }
		public function set params(value:Array):void 
		{
			_params = value;
		}
		
		public function get callBack():Function { return _callBack;	}		
		public function set callBack(value:Function):void 
		{
			_callBack = value;
		}
		
		override public function clone():Event 
		{
			return new InternalEvent(this.type, this.callBack, this.params);
		}
		
	}

}