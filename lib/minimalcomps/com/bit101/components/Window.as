/**
 * Window.as
 * Keith Peters
 * version 0.9.10
 * 
 * A draggable window. Can be used as a container for other components.
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
package com.bit101.components
{
	import com.bit101.components.Panel;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	[Event(name="select", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	[Event(name="resize", type="flash.events.Event")]
	public class Window extends Component
	{
		protected var _title:String;
		protected var _titleBar:Panel;
		protected var _titleLabel:Label;
		protected var _panel:Panel;
		protected var _color:int = -1;
		protected var _shadow:Boolean = true;
		protected var _draggable:Boolean = true;
		protected var _minimizeButton:Sprite;
		protected var _hasMinimizeButton:Boolean = false;
		protected var _minimized:Boolean = false;
		protected var _hasCloseButton:Boolean;
		protected var _closeButton:PushButton;
		protected var _grips:Shape;
		protected var _active:Boolean = false;
		
		protected var _downBar:Panel;
		protected var _resizeButton:Sprite;
		protected var _resizable:Boolean = false;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param title The string to display in the title bar.
		 */
		public function Window(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Window")
		{
			_title = title;
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			setSize(100, 100);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_titleBar = new Panel();
			_titleBar.filters = [];
			_titleBar.buttonMode = true;
			_titleBar.useHandCursor = true;
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			_titleBar.height = 20;
			super.addChild(_titleBar);
			_titleLabel = new Label(_titleBar.content, 5, 1, _title);
			
			_grips = new Shape();
			for(var i:int = 0; i < 4; i++)
			{
				_grips.graphics.lineStyle(1, 0xffffff, .55);
				_grips.graphics.moveTo(0, 3 + i * 4);
				_grips.graphics.lineTo(100, 3 + i * 4);
				_grips.graphics.lineStyle(1, 0, .125);
				_grips.graphics.moveTo(0, 4 + i * 4);
				_grips.graphics.lineTo(100, 4 + i * 4);
			}
			_titleBar.content.addChild(_grips);
			_grips.visible = false;
			
			_panel = new Panel(null, 0, 20);
			//_panel.fill(this, true, true, 0, -20);
			_panel.visible = !_minimized;
			super.addChild(_panel);
			
			_minimizeButton = new Sprite();
			_minimizeButton.graphics.beginFill(0, 0);
			_minimizeButton.graphics.drawRect(-10, -10, 20, 20);
			_minimizeButton.graphics.endFill();
			_minimizeButton.graphics.beginFill(0, .35);
			_minimizeButton.graphics.moveTo(-5, -3);
			_minimizeButton.graphics.lineTo(5, -3);
			_minimizeButton.graphics.lineTo(0, 4);
			_minimizeButton.graphics.lineTo(-5, -3);
			_minimizeButton.graphics.endFill();
			_minimizeButton.x = 10;
			_minimizeButton.y = 10;
			_minimizeButton.useHandCursor = true;
			_minimizeButton.buttonMode = true;
			_minimizeButton.addEventListener(MouseEvent.CLICK, onMinimize);
			
			_closeButton = new PushButton(null, 86, 5, "x", onClose);
			_closeButton.setSize(13, 13);
			
			filters = [getShadow(4, false)];
			_downBar = new Panel(null, 0, _panel.y + _panel.height);
			_downBar.setSize(0, 0);
			
			_resizeButton = new Sprite();
			_resizeButton.graphics.beginFill(0, 0);
			_resizeButton.graphics.drawRect(-0, -0, 5, 5);
			_resizeButton.graphics.endFill();
			_resizeButton.graphics.beginFill(0, .35);
			_resizeButton.graphics.moveTo(5, 0);
			_resizeButton.graphics.lineTo(5, 5);
			_resizeButton.graphics.lineTo(0, 5);
			_resizeButton.graphics.lineTo(5, 0);
			_resizeButton.graphics.endFill();
			_resizeButton.x = _width-6;
			_resizeButton.y = _downBar.y + 1;
			_resizeButton.useHandCursor = true;
			_resizeButton.buttonMode = true;
			_resizeButton.addEventListener(MouseEvent.MOUSE_DOWN, startResize);
		}
		
		private var _startResizeX:Number = 0;
		private var _startResizeY:Number = 0;
		private function startResize(e:MouseEvent):void 
		{
			_startResizeX = e.stageX;
			_startResizeY = e.stageY;
			_resizeButton.addEventListener(MouseEvent.MOUSE_UP, onStopResize);
			_resizeButton.startDrag();
			
		}
		
		private function onStopResize(e:MouseEvent):void 
		{
			_resizeButton.stopDrag();
			setSize(width + e.stageX - _startResizeX, height + e.stageY - _startResizeY);
			_resizeButton.removeEventListener(MouseEvent.MOUSE_UP, onStopResize);
			draw();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Overridden to add new child to content.
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			content.addChild(child);
			return child;
		}
		
		/**
		 * Access to super.addChild
		 */
		public function addRawChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			return child;
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			setAcliveTitle();
			_panel.color = _color;
			_titleBar.width = width;
			_titleBar.draw();
			_titleLabel.x = _hasMinimizeButton ? 20 : 5;
			_closeButton.x = _width - 14;
			_grips.x = _titleLabel.x + _titleLabel.width;
			if(_hasCloseButton)
			{
				_grips.width = _closeButton.x - _grips.x - 2;
			}
			else
			{
				_grips.width = _width - _grips.x - 2;
			}
			
			_panel.setSize(_width, _height - 20 - downBar.height);
			_panel.draw();
			
			if (resizable)
			{
				_downBar.y = _panel.y + _panel.height;
				_downBar.setSize(_width, 7);
				_downBar.draw();
				
				_resizeButton.y = _downBar.y + 1;
				_resizeButton.x = _width - 6;
			}
			else
			{
				_downBar.setSize(0, 0);
			}
			
			
		}
		
		private function setAcliveTitle():void 
		{
			if(active)
				_titleBar.color = Style.WINDOW_ACTIVE;
			else
				_titleBar.color = _color;
		}


		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseDown handler. Starts a drag.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoDown(event:MouseEvent):void
		{
			if(_draggable)
			{
				this.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
				moveToTop();
			}
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function moveToTop():void
		{
			parent.addChild(this); // move to top
			stage.focus = this;
			draw();
		}
		
		/**
		 * Internal mouseUp handler. Stops the drag.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoUp(event:MouseEvent):void
		{
			this.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function onMinimize(event:MouseEvent):void
		{
			minimized = !minimized;
		}
		
		protected function onClose(event:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets whether or not this Window will have a drop shadow.
		 */
		public function set shadow(b:Boolean):void
		{
			_shadow = b;
			if(_shadow)
			{
				filters = [getShadow(4, false)];
			}
			else
			{
				filters = [];
			}
		}
		public function get shadow():Boolean
		{
			return _shadow;
		}
		
		/**
		 * Gets / sets the background color of this panel.
		 */
		public function set color(c:int):void
		{
			_color = c;
			invalidate();
		}
		public function get color():int
		{
			return _color;
		}
		
		/**
		 * Gets / sets the title shown in the title bar.
		 */
		public function set title(t:String):void
		{
			_title = t;
			_titleLabel.text = _title;
		}
		public function get title():String
		{
			return _title;
		}
		
		/**
		 * Container for content added to this panel. This is just a reference to the content of the internal Panel, which is masked, so best to add children to content, rather than directly to the window.
		 */
		public function get content():DisplayObjectContainer
		{
			return _panel.content;
		}
		
		public function get contentContainer():DisplayObjectContainer
		{
			return _panel;
		}
		
		/**
		 * Sets / gets whether or not the window will be draggable by the title bar.
		 */
		public function set draggable(b:Boolean):void
		{
			_draggable = b;
			_titleBar.buttonMode = _draggable;
			_titleBar.useHandCursor = _draggable;
		}
		public function get draggable():Boolean
		{
			return _draggable;
		}
		
		/**
		 * Gets / sets whether or not the window will show a minimize button that will toggle the window open and closed. A closed window will only show the title bar.
		 */
		public function set hasMinimizeButton(b:Boolean):void
		{
			_hasMinimizeButton = b;
			if(_hasMinimizeButton)
			{
				super.addChild(_minimizeButton);
			}
			else if(contains(_minimizeButton))
			{
				removeChild(_minimizeButton);
			}
			invalidate();
		}
		public function get hasMinimizeButton():Boolean
		{
			return _hasMinimizeButton;
		}
		
		/**
		 * Gets / sets whether the window is closed. A closed window will only show its title bar.
		 */
		public function set minimized(value:Boolean):void
		{
			_minimized = value;
//			_panel.visible = !_minimized;
			if(_minimized)
			{
				if(contains(_panel)) removeChild(_panel);
				_minimizeButton.rotation = -90;
			}
			else
			{
				if(!contains(_panel)) super.addChild(_panel);
				_minimizeButton.rotation = 0;
			}
			resizable = _resizable;
			dispatchEvent(new Event(Event.RESIZE));
		}
		public function get minimized():Boolean
		{
			return _minimized;
		}
		
		/**
		 * Gets the height of the component. A minimized window's height will only be that of its title bar.
		 */
		override public function get height():Number
		{
			if(contains(_panel))
			{
				return super.height;
			}
			else
			{
				return 20;
			}
		}

		/**
		 * Sets / gets whether or not the window will display a close button.
		 * Close button merely dispatches a CLOSE event when clicked. It is up to the developer to handle this event.
		 */
		public function set hasCloseButton(value:Boolean):void
		{
			_hasCloseButton = value;
			if(_hasCloseButton)
			{
				_titleBar.content.addChild(_closeButton);
			}
			else if(_titleBar.content.contains(_closeButton))
			{
				_titleBar.content.removeChild(_closeButton);
			}
			invalidate();
		}
		public function get hasCloseButton():Boolean
		{
			return _hasCloseButton;
		}

		/**
		 * Returns a reference to the title bar for customization.
		 */
		public function get titleBar():Panel
		{
			return _titleBar;
		}
		public function set titleBar(value:Panel):void
		{
			_titleBar = value;
		}

		/**
		 * Returns a reference to the shape showing the grips on the title bar. Can be used to do custom drawing or turn them invisible.
		 */		
		public function get grips():Shape
		{
			return _grips;
		}
		
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function set active(value:Boolean):void 
		{
			_active = value;
			if (_active == true)
				dispatchEvent(new Event(Event.ACTIVATE));
		}
		
		public function get resizable():Boolean 
		{
			return _resizable;
		}
		
		public function set resizable(value:Boolean):void 
		{
			_resizable = value;
			
			if (_resizable && !_minimized)
			{
				_downBar.setSize(0, 0);
				super.addChild(_downBar);
				super.addChild(_resizeButton);
			}
			else
			{
				
				if (super.getChildByName(_downBar.name))
					super.removeChild(_downBar);
				if (super.getChildByName(_resizeButton.name))
					super.getChildIndex(_resizeButton);
			}
			draw();
		}
		
		public function get downBar():Panel 
		{
			return _downBar;
		}
		
		public function set downBar(value:Panel):void 
		{
			_downBar = value;
		}
	}
}