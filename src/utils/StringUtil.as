package utils 
{
	/**
	 * ...
	 * @author VadimT
	 */
	public class StringUtil 
	{
		
		public static function replace(source:String, what:String, to:String):String
		{
			return source.split(what).join(to);
		}
		
	}

}