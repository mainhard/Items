package  
{
	import com.bit101.components.List;
	import com.bit101.components.ListItem;
	import com.bit101.components.Window;
	import communication.CommunicationManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.UncaughtErrorEvent;
	import loaders.XMLLoader;
	/**
	 * ...
	 * @author VadimT
	 */
	public class Controller
	{
		private var _model:Model = null;
		private var _view:View = null;
		
		public function Controller() 
		{
			init();
		}
		
		private function init():void 
		{
			_model = new Model();
			_view = new View(_model);
			CommunicationManager.instance.dispatchEvent(new InternalEvent(InternalEvent.GET_MAIN_LAYER, _view.init));
			loadSetupXML();
			
		}
		
		private function loadSetupXML():void 
		{
			var xmlLoader:XMLLoader = new XMLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, onSetupXMLLoaded);
			xmlLoader.load(CApplication.SETUP_XML_URL);
			
		}
		
		private function onSetupXMLLoaded(e:Event):void 
		{
			_model.onSetupXMLLoaded((e.target as XMLLoader).dataXML);
			_view.createTypesContainer();
			initEventListeners();
		}
		
		private function initEventListeners():void 
		{
			for (var i:int = 0; i < _view.typeLists.length; i++) 
			{
				var list:List = _view.typeLists[i];
				list.addEventListener(MouseEvent.DOUBLE_CLICK, onItemClicked);
			}
		}
		
		private function onItemClicked(e:MouseEvent):void 
		{
			var clickedComponent:ListItem = e.target as ListItem;
			var selectedName:String = String(clickedComponent.data);
			openComponentDescription(selectedName);
		}
		
		private function openComponentDescription(componentName:String):void
		{
			var desctiptionPath:String = _model.getComponentPathByName(componentName);
			if (_model.desctiptions[desctiptionPath])
				createComponentDescriptionWindow(componentName, _model.desctiptions[desctiptionPath]);
			else {
				_model.loadingComponentName = componentName;
				doLoadDesctiptions(_model.getComponentPathByName(componentName));
			}
		}
		
		private function doLoadDesctiptions(pathToXNLFile:String ):void 
		{
			_view.showLoadingDialog();
			var xmlLoader:XMLLoader = new XMLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, onDescriptionLoaded);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onDescriptionLoadError);
			xmlLoader.load(pathToXNLFile);
		}
		
		private function onDescriptionLoadError(e:IOErrorEvent):void 
		{
			_view.showDialogWithOkButton(CApplication.MESSAGE_LOADING_ERROR);
		}
		
		private function onDescriptionLoaded(e:Event):void 
		{
			_model.onDescriptionLoaded((e.target as XMLLoader).dataXML);
			var componentName:String = _model.loadingComponentName;
			_view.hideLoadingDialog();
			createComponentDescriptionWindow(componentName, _model.desctiptions[componentName]);
		}
		
		private function createComponentDescriptionWindow(title:String, description:String):void
		{
			if (!_view.activateWindow(_view.getWindowByName(title)))
			{
				var newWindow:Window = _view.createWindow(title, description, onLinkPressed);
				newWindow.addEventListener(Event.CLOSE, onWindowClose);
				newWindow.addEventListener(Event.SELECT, onWindowSelected);
				newWindow.addEventListener(Event.RESIZE, onWindowResized);
			}
		}
		
		private function onWindowResized(e:Event):void 
		{
			_view.resetWindowContent(e.target as Window);
		}
		
		private function onLinkPressed(e:TextEvent):void 
		{
			openComponentDescription(e.text);
		}
		
		private function onWindowClose(e:Event):void 
		{
			var window:Window = e.target as Window;
			_view.closeWindow(window);
			_model.resetDesctiption(window.title);
		}
		
		private function onWindowSelected(e:Event):void 
		{
			_view.activateWindow(e.target as Window);
		}
		
		public function uncaughtErrorHandler(e:UncaughtErrorEvent):void 
		{
			//this suppresses the error dialoge
			e.preventDefault();
			
			if (e.error.errorID == 2000)
			{
				_view.showDialogWithOkButton(CApplication.MESSAGE_LOADING_PARTS_ERROR);
			}
			else
			{
				_view.showDialogWithOkButton(null, String(e.error));
			}
		}
	}
}