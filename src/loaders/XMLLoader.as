package loaders 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author orneon
	 */
	public class XMLLoader extends EventDispatcher
	{
		/// @eventType	flash.events.Event.COMPLETE
		[Event(name="complete", type="flash.events.Event")] 
		/// @eventType	flash.events.IOErrorEvent.IO_ERROR
		[Event(name="ioError", type="flash.events.IOErrorEvent")] 
		
		private var _loader:URLLoader = null;
		private var _dataXML:XML = null;
		
		public function XMLLoader() 
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		private function onError(e:IOErrorEvent = null):void 
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		public function load(url:String):void
		{
			if(url)
				_loader.load(new URLRequest(url));
			else
				onError();
		}
		
		private function onComplete(e:Event):void 
		{
			dataXML = new XML(_loader.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get dataXML():XML { return _dataXML; }
		public function set dataXML(value:XML):void 
		{
			_dataXML = value;
		}
		
	}
	
}