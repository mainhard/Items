/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package controls
{
	import com.bit101.components.Style;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	
	public class SearchPanel {
		private static var _shadow:Boolean = true;
		private static var _hintBody:Sprite=new Sprite();
		private static var _tf:TextField = new TextField();
		private static var _stage:DisplayObjectContainer;
		private static var _timerOff:Timer = new Timer(10000, 1);
		private static var _doSearchFunction:Function = null;
		

		/**
		 * не конструктор, экземпляры не создаем
		 */
		public function SearchPanel():void 
		{
			trace ("Hint is a static class and should not be instantiated. Use Hint.register()");
		}
		
		public static var FORMAT:TextFormat=new TextFormat(
							Style.fontName,	//font
							11,			//size
							0x333333,	//color
							null, null, null, null, null, null,
							2, 1,		//margins
							null,		//indent
							0			//leading
							);
		 /**
		  * привязка к базовому контейнеру, обязательный метод
		  * @param	stage 		
		  */
		public static function register(stage:DisplayObjectContainer, doSearchFunction:Function, positionX:Number = 0, positionY:Number = 0):void
		{
			if (!_stage)
			{
				_hintBody.addChild(_tf);
				
				_tf.autoSize = TextFieldAutoSize.LEFT;
				_tf.selectable=true;
				_tf.background=true;
				_tf.backgroundColor = Style.INPUT_TEXT;
				_tf.border = true;
				_tf.borderColor = Style.BACKGROUND;
				_tf.type = TextFieldType.INPUT;
				_tf.addEventListener(TextEvent.TEXT_INPUT, show);
				_tf.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				_tf.addEventListener(Event.CHANGE, resetTimer);
				//_tf.addEventListener(MouseEvent.CLICK, clear);
				_tf.setTextFormat(FORMAT);
				_timerOff.addEventListener(TimerEvent.TIMER, clear);
				
				shadow = _shadow;
				
				_hintBody.mouseEnabled = false;
				_hintBody.mouseEnabled = false;
			}
			else
			{
				clear();
				if (_hintBody.parent) 
					_stage.removeChild(_hintBody);
			}
			
			_hintBody.x = positionX;
			_hintBody.y = positionY;
			_doSearchFunction = doSearchFunction;
			_stage = stage;
			if(_stage && _stage.stage)
				_stage.stage.focus = _tf;
			
		}
		
		static private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.ESCAPE){
				clear();
			}
			else if (e.keyCode == Keyboard.F3 && _tf.text.length > 0) {
				_doSearchFunction.call(null, _tf.text, true);
				resetTimer();
			}
				
		}
		
		private static function clear(evnt:Event=null):void	
		{
			_tf.text = "";
			_tf.visible = false;
			_timerOff.stop();
			if(_stage && _stage.stage)
				_stage.stage.focus = _tf;
		}
		
		private static function show(e:TextEvent):void
		{
			if (!_stage)
			{
				trace("SearchPanel: no register");
				return;
			}
			
			if (!_tf.visible)
			{
				clear();
				_tf.visible = true;
				add();
			}
			
			if (_doSearchFunction != null && _tf.text.length > 0)
				_doSearchFunction.call(null, _tf.text+e.text);
				
			resetTimer();
		}
		
		static private function resetTimer(e:Event = null):void 
		{
			_timerOff.stop();
			_timerOff.start();
		}
		
		private static function add():void
		{
			_stage.addChild(_hintBody);
			_timerOff.start();
		}
		
		/**
		 * задержка выключения (default=2000)
		 */
		public static function get delayOff():int
		{
			return _timerOff.delay;
		}
		public static function set delayOff(value:int):void 
		{
			_timerOff.delay = value;
		}
		
		/**
		 * нужна ли тень
		 */
		public static function get shadow():Boolean
		{
			return _shadow;
		}
		public static function set shadow(value:Boolean):void 
		{
			_shadow = value;
			_hintBody.filters = _shadow ? [new DropShadowFilter(3, 45, 0x333333, 0.5)] : [];
		}
	}
}

