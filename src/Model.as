package  
{
	import beans.ComponentBean;
	import beans.DescriptionBaen;
	import beans.TypeBean;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import utils.StringUtil;
	import utils.XMLUtil;
	/**
	 * ...
	 * @author VadimT
	 */
	public class Model 
	{
		private var _componentDescriptionLoading:String;
		private var _types:Vector.<TypeBean> = null;
		private var _components:Vector.<ComponentBean> = null;
		private var _desctiptions:Dictionary = null;
		private var _texts:Dictionary = null;
		private var _isDebug:Boolean = true;
		private var _colors:Dictionary = null;
		
		public function Model() 
		{
		}
		
		public function onSetupXMLLoaded(dataXML:XML):void 
		{
			var typesNodes:Array = XMLUtil.xmlListToArrayOfXML(dataXML.types.type as XMLList);
			_types = new Vector.<TypeBean>();
			for (var i:int = 0; i < typesNodes.length; i++) 
			{
				_types.push(new TypeBean(typesNodes[i].@name, typesNodes[i].@id));
			}
			
			
			var componentsNodes:Array = XMLUtil.xmlListToArrayOfXML(dataXML.components.component as XMLList);
			var defaultPathToXML:String = String(dataXML.components.@defaultPathToXML);
			_components = new Vector.<ComponentBean>();
			for (i = 0; i < componentsNodes.length; i++) 
			{
				var componentName:String = String(componentsNodes[i].@name);
				var typeId:String = String(componentsNodes[i].@typeId);
				var pathToXML:String = componentsNodes[i].@pathToXML;
				
				if (!pathToXML || pathToXML == ''){
					pathToXML = defaultPathToXML.toString();
				}
				
				pathToXML = StringUtil.replace(pathToXML, CApplication.REPLACE_COMPONENT_NAME, componentName);
				pathToXML = StringUtil.replace(pathToXML, CApplication.REPLACE_COMPONENT_TYPE, typeId);
				_components.push(new ComponentBean(componentName, typeId, pathToXML));
			}
			
			var textsNodes:Array = XMLUtil.xmlListToArrayOfXML(dataXML.texts.text as XMLList);
			_texts = new Dictionary;
			for (i = 0; i < textsNodes.length; i++) 
			{
				_texts[String(textsNodes[i].@name)] = String(textsNodes[i].@value);
			}
			
			var colorsNodes:Array = XMLUtil.xmlListToArrayOfXML(dataXML.colors.color as XMLList);
			_colors = new Dictionary;
			for (i = 0; i < colorsNodes.length; i++) 
			{
				_colors[String(colorsNodes[i].@name)] = String(colorsNodes[i].@value);
			}
			
			var debugString:String = String(dataXML.debug.@value);
			_isDebug = debugString == "true"?true:false;
		}
		
		public function get types():Vector.<TypeBean> { return _types; }
		public function get components():Vector.<ComponentBean> { return _components; }
		public function get desctiptions():Dictionary 
		{ 
			if (!_desctiptions)
				_desctiptions = new Dictionary();
				
			return _desctiptions;	
		}
		
		public function get loadingComponentName():String { 	return _componentDescriptionLoading; }
		public function set loadingComponentName(value:String):void 
		{
			_componentDescriptionLoading = value;
		}
		
		public function get isDebug():Boolean 
		{
			return _isDebug;
		}
		
		public function getTypeIdByTypeName(name:String):String
		{
			var result:String = null;
			for (var i:int = 0; i < _types.length; i++) 
			{
				if (_types[i].name == name)
				{
					result = _types[i].id;
					break;
				}
			}
			
			return result;
		}
		
		public function getComponentsByTypeId(typeId:String):Vector.<ComponentBean>
		{
			var result:Vector.<ComponentBean> = new Vector.<ComponentBean>();
			for (var i:int = 0; i < components.length; i++) 
			{
				if (components[i].typeId == typeId)
				{
					result.push(components[i]);
				}
			}
			
			return result;
		}
		
		public function getComponentPathByName(componentName:String):String 
		{
			var result:String = null;
			
			for (var i:int = 0; i < components.length; i++) 
			{
				if (components[i].name == componentName)
				{
					result = components[i].patchToXML;
					break;
				}
			}
			
			return result;
		}
		
		public function getComponentTypeIdByName(componentName:String):String 
		{
			var result:String = null;
			
			for (var i:int = 0; i < components.length; i++) 
			{
				if (components[i].name == componentName)
				{
					result = components[i].typeId;
					break;
				}
			}
			
			return result;
		}
		
		public function onDescriptionLoaded(dataXML:XML):void 
		{
			desctiptions[_componentDescriptionLoading] = prepareDescription(_componentDescriptionLoading, dataXML.content);
		}
		
		private function prepareDescription(componentName:String, description:String):String 
		{
			var result:String = description;
			result = StringUtil.replace(result, '\n', '');
			
			//replace colors
			for (var i:* in _colors) 
			{
				result = StringUtil.replace(result, i, _colors[i]);
			}
			
			result = StringUtil.replace(result, CApplication.REPLACE_COMPONENT_NAME, componentName);
			result = StringUtil.replace(result, CApplication.REPLACE_COMPONENT_TYPE, getComponentTypeIdByName(componentName));
			
			return result;
		}
		
		public function resetDesctiption(componentName:String):void
		{
			if (!isDebug)
				return;
			
			desctiptions[componentName] = null;
			delete(desctiptions[componentName]);
		}
		
		public function getTextByName(textName:String):String 
		{
			var result:String = _texts[textName];
			
			if (!result)
				result = "No textValue for textName -> " + textName;
				
			return result;
		}
		
	}

}