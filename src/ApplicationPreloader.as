package 
{
	import com.bit101.components.ProgressBar;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author VadimT
	 */
	public class ApplicationPreloader extends MovieClip 
	{
		
		private var progressBar:ProgressBar = null;
		public function ApplicationPreloader() 
		{
			init();
		}
		
		private function init():void 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			progressBar = new ProgressBar(this, stage.stageWidth / 2, stage.stageHeight / 2);
			progressBar.draw();
			progressBar.maximum = 100;
			progressBar.value = 0;
		}
		
		
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			var currentPercentLoaded:Number = Math.floor( e.bytesLoaded / e.bytesTotal * 100);
			progressBar.value = currentPercentLoaded;
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			progressBar.value = 100;
			this.removeChild(progressBar)
			progressBar = null;
			
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Application") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}