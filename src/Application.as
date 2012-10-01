package 
{
	//import com.demonsters.debugger.MonsterDebugger;
	import com.flashdynamix.utils.SWFProfiler;
	import communication.CommunicationManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.UncaughtErrorEvent;
	import InternalEvent;

	/**
	 * ...
	 * @author VadimT
	 */
	[Frame(factoryClass="ApplicationPreloader")]
	public class Application extends Sprite 
	{

		private var controller:Controller = null;
		public function Application()
		{
			preInit();
		}
		
		private function preInit():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//MonsterDebugger.initialize(this);
			//MonsterDebugger.trace(this, "Hello World!");
			CommunicationManager.instance.addEventListener(InternalEvent.GET_MAIN_LAYER, onGetMainLayer);
			SWFProfiler.init(this.stage, this);
			controller = new Controller();
			this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, controller.uncaughtErrorHandler);
		}
		
		private function onGetMainLayer(e:InternalEvent):void 
		{
			e.callBack(this);
		}
	}
}