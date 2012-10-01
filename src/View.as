package  
{
	import beans.ComponentBean;
	import com.bit101.components.Accordion;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.ListItem;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.Text;
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Dictionary;
	import silin.utils.Alert;
	/**
	 * ...
	 * @author VadimT
	 */
	public class View 
	{
		static public const DESCRIPTION_AREA:String = "descriptionArea";
		static private const APP_WIDTH:Number = 800;
		static private const APP_HEIGHT:Number = 600;
		static private const RIGHT_PANEL_WIDTH:Number = 110;
		private var _model:Model = null;		
		private var _contentContainer:DisplayObjectContainer = null;
		private var _windowsContainer:DisplayObjectContainer = null;
		private var _typesContainer:Accordion = null;
		private var _mainPanel:Panel = null;
		private var _typeLists:Vector.<List> = null;
		private var _windowsList:Vector.<Window> = null;
		private var _activeWindow:Window = null;
		
		public function View(model:Model) 
		{
			_model = model;
		}
		
		public function get typeLists():Vector.<List> 
		{	
			if (!_typeLists)
				_typeLists = new Vector.<List>();
			return _typeLists;	
		}
		
		public function get windowsList():Vector.<Window> 
		{
			if (!_windowsList)
				_windowsList = new Vector.<Window>();
				
			return _windowsList;
		}
		
		public function init(mainLayer:DisplayObjectContainer):void 
		{
			Style.setStyle(Style.DARK);
			initMainPanel(mainLayer);
			_contentContainer = _mainPanel.content;
			_windowsContainer =  initWindowPanel(mainLayer, _contentContainer).content;
			Alert.register(_mainPanel.stage);
			
		}
		
		private function initWindowPanel(mainLayer:DisplayObjectContainer, contentContainer:DisplayObjectContainer):Panel 
		{
			var windowPanel:Panel = new Panel(contentContainer, RIGHT_PANEL_WIDTH, 0);
			windowPanel.fillStage(mainLayer.stage, true, true, ( -1) * RIGHT_PANEL_WIDTH);
			return windowPanel;
		}
		
		private function initMainPanel(mainLayer:DisplayObjectContainer):void 
		{
			mainLayer.stage.stageFocusRect = false;
			_mainPanel = new Panel(mainLayer, 0, 0);
			_mainPanel.setSize(mainLayer.stage.stageWidth, mainLayer.stage.stageHeight);
			_mainPanel.fillStage(mainLayer.stage);
		}
		
		public function createTypesContainer():void 
		{
			_typesContainer = new Accordion(_contentContainer, 0, 0);
			
			for (var i:int = 0; i < _model.types.length; i++) 
			{
				_typesContainer.addWindow(_model.types[i].name);
			}
			
			_typesContainer.setSize(RIGHT_PANEL_WIDTH, _contentContainer.height);
			_typesContainer.fill(_mainPanel, false);
			fielComponentToTypesContainer();
		}
		
		private function fielComponentToTypesContainer():void 
		{
			var window:Window = null;
			for (var i:int = 0; i < _typesContainer.windows.length; i++) 
			{
				window = _typesContainer.windows[i];
				createWindowContentForType(window, _model.getComponentsByTypeId(_model.getTypeIdByTypeName(window.title)));
			}
		}
		
		private function createWindowContentForType(parentWindow:Window, components:Vector.<ComponentBean>):void
		{
			if (components.length == 0)
				return;
				
			var listItems:Array = new Array();
			
			for (var i:int = 0; i < components.length; i++) 
			{
				var componentBean:ComponentBean = components[i];
				listItems.push(componentBean.name);
			}
			
			var listContent:List = new List(parentWindow.content, 0, 0, listItems, true);
			listContent.fill(parentWindow.contentContainer);
			listContent.enableSearchByKeyDown = true;
			listContent.draw();
			typeLists.push(listContent);
		}
		
		public function createWindow(windowName:String, desctiption:String, linkPressedCallBack:Function):Window
		{
			var window:Window = new Window(_windowsContainer, _windowsList.length*20, _windowsList.length*20, windowName);
			window.hasCloseButton = true;
			window.hasMinimizeButton = true;
			window.setSize(400, 400);
			window.setMinSize(400, 200);
			window.resizable = true;
			
			var descriptionContainer:TextArea = new TextArea(window.content);
			descriptionContainer.name = DESCRIPTION_AREA;
			descriptionContainer.fill(window, true, true, 0, (-1)* (window.titleBar.height+window.downBar.height));
			descriptionContainer.html = true;
			descriptionContainer.textField.addEventListener(TextEvent.LINK, linkPressedCallBack);
			descriptionContainer.editable = false;
			descriptionContainer.text = desctiption;
			descriptionContainer.textField.filters = [new DropShadowFilter()];
			descriptionContainer.enableSearch = true;
			descriptionContainer.draw();
			windowsList.push(window);
			activateWindow(window);
			
			return window;
		}
		
		public function closeWindow(window:Window):void 
		{
			removeWindow(window);
			if (_windowsList.length > 0)
				activateWindow(_windowsList[_windowsList.length - 1]);
		}
		
		public function showLoadingDialog():void 
		{
			Alert.message(_model.getTextByName(CApplication.MESSAGE_LOADING));
		}
		
		public function hideLoadingDialog():void 
		{
			Alert.clear();
		}
		
		public function showDialogWithOkButton(messageId:String, message:String = null):void 
		{
			if(messageId)
				Alert.show(_model.getTextByName(messageId));
			else if(message)
				Alert.show(message);
		}
		
		public function activateWindow(window:Window):Boolean 
		{
			if (window)
			{
				setActiveWindow(window);
				window.moveToTop();
				return true;
			}
			return false;
		}
		
		private function setActiveWindow(window:Window):void 
		{
			if (_activeWindow)
			{
				_activeWindow.active = false;
				_activeWindow.draw();
			}
				
			_activeWindow = window;
			_activeWindow.active = true;
		}
		
		public function getWindowByName(windowName:String):Window
		{
			var result:Window = null;
			for (var i:int = 0; i < windowsList.length; i++) 
			{
				var window:Window = windowsList[i];
				if (window.title == windowName)
				{
					result = window;
					break;
				}
			}
			
			return result;
		}
		
		public function resetWindowContent(window:Window):void 
		{
			var textArea:TextArea = window.content.getChildByName(DESCRIPTION_AREA) as TextArea;
			if (textArea)
			{
				textArea.text = _model.desctiptions[window.title];
				textArea.draw();
			}
		}
		
		private function removeWindow(window:Window):void
		{
			var deletedIndex:int = windowsList.indexOf(window, 0);
			if (deletedIndex > -1)
				windowsList.splice(deletedIndex, 1);
			
			_windowsContainer.removeChild(window);
			if (_activeWindow == window)
				_activeWindow = null;
		}
	}
}