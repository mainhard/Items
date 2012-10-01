package silin.audio.equalizers
{
	
	import flash.display.Shape;
	
	/**
	 * эквлайзер, полоски
	 * @author silin
	 */
	public class BandEqualizer extends Equalizer
	{
		/**
		 * максимальная высота полосок
		 */
		public var maxHeight:Number;
		/**
		 * минмиальная высота
		 */
		public var minHeight:Number;
		/**
		 * цвет заливки
		 */
		public var color:uint;
		/**
		 * ширина диапазона
		 */
		public var bandWidth:Number;
		/**
		 * промежуток
		 */
		public var gap:Number;
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxHeight		максимальная высота
		 * @param	minHeight		минимальная высота
		 * @param	bandWidth		ширина полосок
		 * @param	gap				промежуток
		 * @param	сolor			цвет полосок
		 *
		 */
		public function BandEqualizer(bands:uint = 8, omitFrames:Number = 4, maxHeight:Number = 50, minHeight:Number = 1, bandWidth:Number = 10, gap:Number = 1, color:uint = 0xC0C0C0)
		{
			
			super(bands, omitFrames);
			this.maxHeight = maxHeight;
			this.minHeight = minHeight;
			this.bandWidth = bandWidth;
			this.gap = gap;
			this.color = color;
		
		}
		
		protected override function render():void
		{
			
			graphics.clear();
			graphics.beginFill(color);
			
			for (var i:int = 0; i < bands; i++)
			{
				var h:Number = minHeight + (maxHeight - minHeight) * currValues[i];
				graphics.drawRect(i * bandWidth, maxHeight, bandWidth - gap, -h);
				
			}
			graphics.endFill();
			graphics.beginFill(color);
			if (minHeight)
			{
				graphics.drawRect(0, maxHeight, bands * bandWidth - gap, -minHeight);
			}
		
		}
	
	}
}

