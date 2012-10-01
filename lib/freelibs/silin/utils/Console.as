/*
 
  The MIT License, 
 
  Copyright (c) 2011. silin (http://silin.su#AS3)
 
*/
package silin.utils 
{
	
	import flash.display.*;
	import flash.external.*;
	import flash.text.*;
	/**
	 * отладочная утилита; <br/>
	 * лог в тектфилд и/или консоль FireBug и/или стандартный трейс; <br/>
	 * для вывода в текстфилд необходим  вызов Console.register() 
	 * @author silin
	 */
	public class Console
	{
		
		public static const TRACE:int = 1;
		public static const PANEL:int = 2;
		public static const FIREBUG:int = 4;
		/**
		 * получатели вывода: Console.TRACE | Console.PANEL | Console.FIREBUG
		 */
		private static var _output:int = PANEL;
		/**
		 * формат обычного вывода
		 */
		public static var normalTextFormat:TextFormat = new TextFormat("_sans", 11, 0x404040);
		/**
		 * формат выделенного вывода
		 */
		public static var markTextFormat:TextFormat = new TextFormat("_sans", 11, 0xCC0000);
		private static var _win:Window;
		
		/**
		 * не конструктор, экземпляры не создаем
		 */
		public function Console()
		{
			throw(new Error("Console is a static class and should not be instantiated."))
		}

		public static function clear():void
		{
			_win.tf.text = "";
		}
		/**
		 * выодит arg в консоль FireBug, тектфилд или стандартный трейс<br/>
		 * в зависимости от состояния output<br/>
		 * если mark truе, выделят красным
		 * @param	arg
		 * @param	mark
		 */
		public static function log(arg:Object, mark:Boolean=false):void
		{
			if (!output) return;
			
			//дублируем в trace
			if (output & TRACE) 
			{
				trace(arg);
			}
			
			var str:String = arg ? arg.toString() : "";
			//вывод в тестфилд
			if (_win && (output & PANEL))
			{
				var b:int = _win.tf.text.length;
				_win.tf.appendText(str + "\n");
				var e:int = _win.tf.text.length;
				_win.tf.scrollV = _win.tf.maxScrollV;
				_win.tf.setTextFormat(mark ? markTextFormat : normalTextFormat, b, e);
			}
			
			//вывод в консоль FireBug
			if (ExternalInterface.available && (output & FIREBUG))
			{
				if (mark)
				{
					ExternalInterface.call( 'function(val){ console.warn(val);}', str);
				}else
				{
					ExternalInterface.call( 'function(val){ console.log(val);}', str)
				}
			}
		}
		
		
		/**
		 * привязка к stage, нужна для вывода в пвнель;<br/>
		 * здесь же задаем размеры панели
		 * @param	stage
		 * @param	width
		 * @param	height
		 */
		public static function register(stage:Stage, width:Number = 240, height:Number = 320):void
		{
			if (_win) return;
			
			_win = new Window(width, height);
			stage.addChild(_win);
			
			output |= PANEL;//включаем вывод в тектфилд 
			
		}
		
		
		/**
		 * куда выводить лог:  TRACE | PANEL | FIREBUG
		 */
		static public function get output():int { return _output; }
		static public function set output(value:int):void 
		{
			_output = value;
			//прячем окно, если нет вывода в текстфилд
			if (_win)
			{
				_win.visible = Boolean(_output & PANEL);
			}
			
			
		}
		/**
		 * текст шапки
		 */
		static public function get caption():String { return _win.caption.text; }
		static public function set caption(value:String):void 
		{
			_win.caption.text = value;
		}
		
		
		/**
		 * размещение панели (TR,TL,BR,BL)
		 */
		public static function set align(value:String):void 
		{
			if(_win)
			switch(value)
			{
				case StageAlign.BOTTOM_LEFT:
				{
					_win.y = _win.stage.stageHeight - _win.height - 1;
				}
				break;
				case StageAlign.TOP_RIGHT:
				{
					
					_win.x = _win.stage.stageWidth - _win.width - 1;
				}
				break;
				case StageAlign.BOTTOM_RIGHT: 
				{
					_win.y = _win.stage.stageHeight - _win.height - 1;
					_win.x = _win.stage.stageWidth - _win.width - 1;
				}
				break;
				default: {
					_win.x = 1;
					_win.y = 1;
				}
				
			}
		}
		
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
import flash.display.*;
import flash.events.*;
import flash.text.*;
import flash.ui.*;
import silin.utils.*;
class Window extends Sprite
{
	
	public const barHeight:Number = 20;
	public var tf:TextField = new TextField();
	public const caption:TextField = new TextField();
	
	private const _bar:Sprite = new Sprite();
	private const _closeBut:Sprite = new Sprite();
	private const _body:Sprite = new Sprite();
	
	public function Window(width:Number, height:Number)
	{
		x = 10;
		y = 10;
		
		
		_body.graphics.clear();
		_body.graphics.lineStyle(0, 0x808080);
		_body.graphics.beginFill(0xFFFFFF, 0.75);
		_body.graphics.drawRect(0, 0, width, height);
		_body.graphics.endFill();
		
		_bar.graphics.lineStyle(0, 0x808080);
		_bar.graphics.beginFill(0xEEEEEE);
		_bar.graphics.drawRect(0, 0, width, barHeight);
		_bar.graphics.endFill();
		_bar.buttonMode = true;
		
		_closeBut.graphics.lineStyle(0, 0x808080);
		_closeBut.graphics.beginFill(0xDDDDDD);
		_closeBut.graphics.drawRect(0, 0, barHeight, barHeight);
		_closeBut.graphics.endFill();
		_closeBut.buttonMode = true;
		_closeBut.x = width - barHeight;
		
		
		tf.width = width;
		tf.height = height-barHeight;
		tf.y = barHeight;
		tf.multiline = true;
		
		caption.width = width - barHeight;
		caption.height = barHeight;
		caption.selectable = false;
		var fmt:TextFormat = new TextFormat("_sans", 11, 0x000000);
		fmt.align = TextFormatAlign.CENTER;
		caption.defaultTextFormat = fmt;
		_bar.addChild(caption);
		
		
		addChild(_body);
		addChild(tf);
		addChild(_bar);
		_bar.addChild(_closeBut);
		
		_bar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		_closeBut.addEventListener(MouseEvent.CLICK, onCloseButClick);
		
		var consolMenu:ContextMenu = new ContextMenu();
		
		var clearItem:ContextMenuItem = new ContextMenuItem("clear output");
		clearItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onClearItem);
		consolMenu.hideBuiltInItems();
		consolMenu.customItems = [clearItem];
		_bar.contextMenu = consolMenu;
		
	}
	
	private function onClearItem(event:ContextMenuEvent):void 
	{
		Console.clear();
	}
	
	
	
	private function onCloseButClick(evnt:MouseEvent):void 
	{
		tf.visible = !tf.visible;
		_body.visible = tf.visible;
		
		
	}
	
	private function onMouseDown(evnt:MouseEvent):void 
	{
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		parent.addChild(this);
	}
	
	private function onMouseUp(evnt:MouseEvent):void 
	{
		stopDrag();
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
}