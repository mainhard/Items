package utils 
{
	/**
	 * ...
	 * @author Orneon
	 */
	public class XMLUtil
	{
		
		public static function xmlListToArrayOfXML(xmlList:XMLList):Array
		{
			var result:Array = new Array();
			
			if (xmlList.length() == 1)
				result.push(xmlList);
			else
				for (var i:int = 0; i < xmlList.length(); i++) 
					result.push(xmlList[i]);
			
			return result;
		}
	}

}