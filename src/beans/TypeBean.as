package beans
{
	/**
	 * ...
	 * @author VadimT
	 */
	public class TypeBean 
	{
		private var _name:String = "unnamed";
		private var _id:String = "noid";
		
		public function TypeBean(name:String, id:String) 
		{
			this.name = name;
			this.id = id;
		}
		
		public function get name():String { return _name; }		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get id():String {	return _id; }		
		public function set id(value:String):void 
		{
			_id = value;
		}		
	}

}