package communication
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author VadimT
	 */
	public class CommunicationManager extends EventDispatcher 
	{
		private static var _instance:CommunicationManager = null;
		[Event (name="GET_MAIN_LAYER", type="InternalEvent")]
		public function CommunicationManager() 
		{
			super(null);
		}
		
		public static function get instance():CommunicationManager 
		{ 
			if (!_instance)
			{
				_instance = new CommunicationManager();
			}
			
			return _instance; 
		}
	}
}