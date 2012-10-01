/**
 * Component.as
 * Keith Peters
 * version 0.9.10
 * 
 * Base class for all components
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
 * 
 * 
 * 
 * Components with text make use of the font PF Ronda Seven by Yuusuke Kamiyamane
 * This is a free font obtained from http://www.dafont.com/pf-ronda-seven.font
 */
 
package com.bit101.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.text.Font;

	[Event(name="resize", type="flash.events.Event")]
	[Event(name="draw", type="flash.events.Event")]
	public class Component extends Sprite
	{
		// NOTE: Flex 4 introduces DefineFont4, which is used by default and does not work in native text fillds.
		// Use the embedAsCFF="false" param to switch back to DefineFont4. In earlier Flex 4 SDKs this was cff="false".
		// So if you are using the Flex 3.x sdk compiler, switch the embed statment below to expose the correct version.
		
		// Flex 4.x sdk:
//		[Embed(source="/assets/pf_ronda_seven.ttf", embedAsCFF="false", fontName="PF Ronda Seven", mimeType="application/x-font")]
		// Flex 3.x sdk:
		
		
		[Embed(source = "C:/WINDOWS/fonts/arial.ttf", embedAsCFF="false", fontName = "EmbededFont", fontWeight = "normal", advancedAntiAliasing = "true", mimeType = "application/x-font", unicodeRange = "U+0020-007E,U+0400-04CE,U+2000-206F,U+20A0-20CF,U+2100-2183")] 
		public var ARIAL:Class;
		
		[Embed(source = "C:/WINDOWS/fonts/ariali.ttf", embedAsCFF="false", fontName = "EmbededFont", fontStyle='italic', advancedAntiAliasing = "true", mimeType = "application/x-font", unicodeRange = "U+0020-007E,U+0400-04CE,U+2000-206F,U+20A0-20CF,U+2100-2183")] 
		public var ARIALIT:Class;
		
		[Embed(source = "C:/WINDOWS/fonts/arialbd.ttf", embedAsCFF="false", fontName = "EmbededFont", fontWeight = "bold", advancedAntiAliasing = "true", mimeType = "application/x-font", unicodeRange = "U+0020-007E,U+0400-04CE,U+2000-206F,U+20A0-20CF,U+2100-2183")] 
		public var ARIALBT:Class;
		
		[Embed(source = "C:/WINDOWS/fonts/arialbi.ttf", embedAsCFF="false", fontName = "EmbededFont", fontStyle='italic', fontWeight = "bold", advancedAntiAliasing = "true", mimeType = "application/x-font", unicodeRange = "U+0020-007E,U+0400-04CE,U+2000-206F,U+20A0-20CF,U+2100-2183") ] 
		public var ARIALBTIT:Class;
		
		//[Embed(source = "/assets/OliverNormal.ttf", embedAsCFF="false", fontName = "EmbededFont", fontWeight = "normal", advancedAntiAliasing = "true", mimeType = "application/x-font-truetype")] 
		//public var Oliver:Class;
		//
		//[Embed(source = "/assets/OliverItalic.ttf", embedAsCFF="false", fontName = "EmbededFont", fontStyle='italic', advancedAntiAliasing = "true", mimeType = "application/x-font-truetype")] 
		//public var OliverItalic:Class;
		//
		//[Embed(source = "/assets/OliverBold.ttf", embedAsCFF="false", fontName = "EmbededFont", fontWeight = "bold", advancedAntiAliasing = "true", mimeType = "application/x-font-truetype")] 
		//public var OliverBold:Class;
		//
		//[Embed(source = "/assets/OliverBoldItalic.ttf", embedAsCFF="false", fontName = "EmbededFont", fontStyle='italic', fontWeight = "bold", advancedAntiAliasing = "true", mimeType = "application/x-font-truetype")] 
		//public var OliverBoldItalic:Class;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _minWidth:Number = 0;
		protected var _minHeight:Number = 0;
		protected var _tag:int = -1;
		protected var _enabled:Boolean = true;
		
		public static const DRAW:String = "draw";
		
		private var _fillByWidth:Boolean = false;
		private var _fillByHeight:Boolean = false;
		private var _fillTarget:DisplayObject = null;
		private var _fillTargerIsStage:Boolean = false;
		private var _fillWidthPath:Number = 0;
		private var _fillHeightPath:Number = 0;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this component.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function Component(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
		{
			move(xpos, ypos);
			init();
			if(parent != null)
			{
				parent.addChild(this);
			}
		}
		
		/**
		 * Initilizes the component.
		 */
		protected function init():void
		{
			addChildren();
			invalidate();
		}
		
		/**
		 * Overriden in subclasses to create child display objects.
		 */
		protected function addChildren():void
		{
			
		}
		
		/**
		 * DropShadowFilter factory method, used in many of the components.
		 * @param dist The distance of the shadow.
		 * @param knockout Whether or not to create a knocked out shadow.
		 */
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, Style.DROPSHADOW, 1, dist, dist, .3, 1, knockout);
		}
		
		/**
		 * Marks the component to be redrawn on the next frame.
		 */
		protected function invalidate():void
		{
//			draw();
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Utility method to set up usual stage align and scaling.
		 */
		public static function initStage(stage:Stage):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		/**
		 * Moves the component to the specified position.
		 * @param xpos the x position to move the component
		 * @param ypos the y position to move the component
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			x = Math.round(xpos);
			y = Math.round(ypos);
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		public function setSize(w:Number, h:Number):void
		{
			var resized:Boolean = false;
			
			if (w > minWidth)
			{
				_width = w;
				resized = true;
			}
			else 
			{
				if (_width != minWidth)
					resized = true;
				
				_width = minWidth;
			}
			
			if (h > minHeight)
			{
				_height = h;
				resized = true;
			}
			else 
			{
				if (_height != minHeight)
					resized = true;
				
				_height = minHeight;
			}
			
			if (resized)
			{
				dispatchEvent(new Event(Event.RESIZE));
				invalidate();
			}
		}
		
		public function setMinSize(w:Number, h:Number):void
		{
			var resized:Boolean = false;
			
			if (w != minWidth)
			{
				_minWidth = w;
				if(width < _minWidth)
					resized = true;
			}
			if (h != minHeight)
			{
				_minHeight = h;
				if(height < _minHeight)
					resized = true;
			}
				
			if (resized)
			{
				dispatchEvent(new Event(Event.RESIZE));
				invalidate();
			}
		}
		
		/**
		 * Abstract draw function.
		 */
		public function draw():void
		{
			dispatchEvent(new Event(Component.DRAW));
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called one frame after invalidate is called.
		 */
		protected function onInvalidate(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the width of the component.
		 */
		override public function set width(w:Number):void
		{
			var resized:Boolean = false;
			
			if (w >= minWidth)
			{
				_width = w;
				resized = true;
			}
				
			if (resized)
			{
				dispatchEvent(new Event(Event.RESIZE));
				invalidate();
			}
		}
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * Sets/gets the height of the component.
		 */
		override public function set height(h:Number):void
		{
			var resized:Boolean = false;
			
			if (h >= minHeight)
			{
				_height = h;
				resized = true;
			}
				
			if (resized)
			{
				dispatchEvent(new Event(Event.RESIZE));
				invalidate();
			}
		}
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * Sets/gets in integer that can identify the component.
		 */
		public function set tag(value:int):void
		{
			_tag = value;
		}
		public function get tag():int
		{
			return _tag;
		}
		
		/**
		 * Overrides the setter for x to always place the component on a whole pixel.
		 */
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		/**
		 * Overrides the setter for y to always place the component on a whole pixel.
		 */
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}

		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = mouseChildren = _enabled;
            tabEnabled = value;
			alpha = _enabled ? 1.0 : 0.5;
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function get minWidth():Number {	return _minWidth; }
		public function set minWidth(value:Number):void 
		{
			_minWidth = value;
		}
		
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(value:Number):void 
		{
			_minHeight = value;
		}
		
		public function fillStage(stage:Stage, fillByWidth:Boolean = true, fillByHeight:Boolean = true, fillWidthPath:Number = 0, fillHeightPath:Number = 0):void
		{
			_fillTargerIsStage = true;
			fill(stage, fillByWidth, fillByHeight, fillWidthPath, fillHeightPath);
		}
		
		public function fill(target:DisplayObject, fillByWidth:Boolean = true, fillByHeight:Boolean = true, fillWidthPath:Number = 0, fillHeightPath:Number = 0):void
		{
			_fillByWidth = fillByWidth;
			_fillByHeight = fillByHeight;
			_fillWidthPath = fillWidthPath;
			_fillHeightPath = fillHeightPath;
			_fillTarget = target;
			_fillTarget.addEventListener(Event.RESIZE, resetSizeAcordingToTarget);
			resetSizeAcordingToTarget();
		}
		
		public function resetFill():void
		{
			_fillByWidth = false;
			_fillByHeight = false;
			_fillTargerIsStage = false;
			_fillTarget.removeEventListener(Event.RESIZE, resetSizeAcordingToTarget);
		}
		
		private function resetSizeAcordingToTarget(e:Event = null):void 
		{
			
			var newWidth:Number = this.width;
			var newHeight:Number = this.height;
			
			if (_fillByWidth)
			{
				newWidth = _fillTarget.width;
				if (_fillTargerIsStage)
					newWidth = (_fillTarget as Stage).stageWidth;
					
				newWidth = newWidth + _fillWidthPath;
			}
				
			if (_fillByHeight)
			{
				newHeight = _fillTarget.height;
				if (_fillTargerIsStage)
					newHeight = (_fillTarget as Stage).stageHeight;
					
				newHeight = newHeight + _fillHeightPath;
			}
			
			if (newWidth != this.width || newHeight != this.height)
			{	
				setSize(newWidth, newHeight);
			}
		}

	}
}