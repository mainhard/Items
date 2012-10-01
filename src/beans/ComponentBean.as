package beans 
{
	/**
	 * ...
	 * @author VadimT
	 */
	public class ComponentBean 
	{
		private var _name:String = "unnamed";
		private var _typeId:String = "untypeIdd";
		private var _patchToXML:String = null;
		public function ComponentBean(name:String, typeId:String, patchToXML:String) 
		{
			this.name = name;
			this.typeId = typeId;
			this.patchToXML = patchToXML;
		}
		
		public function get name():String { return _name; }		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get typeId():String {	return _typeId; }		
		public function set typeId(value:String):void 
		{
			_typeId = value;
		}
		
		public function get patchToXML():String { return _patchToXML; }		
		public function set patchToXML(value:String):void 
		{
			_patchToXML = value;
		}
	}

}