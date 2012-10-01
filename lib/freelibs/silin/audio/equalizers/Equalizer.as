package silin.audio.equalizers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	/**
	 * расчет  спектра (SoundMixer.computeSpectrum)  <br/>
	 * наследуется от Sprite, но сам визуального представления не имеет <br/>
	 * @author silin
	 */
	public class Equalizer extends Sprite
	{
		/**
		 * через сколько тактов enterFrame пересчитывать спектр
		 */
		public var omitFrames:uint = 4;
		private var _bands:uint = 8;
		
		private var targValues:Vector.<Number>;
		protected var currValues:Vector.<Number>;
		
		private var bandDataLength:uint;
		private var frameCounter:uint = 0;
		
		private var _running:Boolean = false;
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 */
		public function Equalizer(bands:uint = 8, omitFrames:Number = 4)
		{
			
			this.bands = bands;
			this.omitFrames = omitFrames;
			bandDataLength = Math.floor(256 / bands);
			targValues = new Vector.<Number>(bands, true);
			currValues = new Vector.<Number>(bands, true);
			
			start();
		}
		
		private function onEnterFrame(event:Event):void
		{
			var i:int = 0;
			var tmp:Number;
			frameCounter++;
			if (frameCounter % omitFrames == 0)
			{
				
				var bytes:ByteArray = new ByteArray();
				SoundMixer.computeSpectrum(bytes, true, bandDataLength);
				
				for (i = 0; i < bands; i++)
				{
					bytes.position = i * bandDataLength * 4;
					tmp = bytes.readFloat();
					bytes.position = 1024 + i * bandDataLength * 4;
					tmp += bytes.readFloat();
					tmp *= 0.5;
					targValues[i] = tmp;
				}
			}
			for (i = 0; i < bands; i++)
			{
				currValues[i] += (targValues[i] - currValues[i]) / omitFrames;
			}
			render();
		}
		
		/**
		 * вывода результатов счета, заглушка для наследников
		 */
		protected function render():void
		{
		}
		
		/**
		 * стартует счет
		 */
		public function start():void
		{
			_running = true;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * останавливает счет, обнуляет данные
		 */
		public function stop():void
		{
			_running = false;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			for (var i:int = 0; i < bands; i++)
			{
				currValues[i] = 0;
				targValues[i] = 0;
			}
		}
		
		/**
		 * true если обсчет включен
		 */
		public function get running():Boolean
		{
			return _running;
		}
		/**
		 * число диапазонов
		 */
		public function get bands():uint
		{
			return _bands;
		}
		
		public function set bands(value:uint):void
		{
			_bands = value;
			bandDataLength = Math.floor(256 / bands);
			targValues = new Vector.<Number>(_bands, true);
			currValues = new Vector.<Number>(_bands, true);
		}
	
	}

}