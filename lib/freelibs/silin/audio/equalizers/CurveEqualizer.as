package silin.audio.equalizers
{
	
	/**
	 * эквалайзер, заливка по огибающей
	 * @author silin
	 */
	public class CurveEqualizer extends Equalizer
	{
		/**
		 * максимальная высота
		 */
		public var maxHeight:Number;
		/**
		 * минимальная высота
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
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxHeight		максимальная высота
		 * @param	minHeight		минимальная высота 
		 * @param	bandWidth		ширина дипазона
		 * @param	color			цвет заливки
		 */
		public function CurveEqualizer(bands:uint = 8, omitFrames:Number = 4, maxHeight:Number = 50, 
		minHeight:Number=1, bandWidth:Number = 10, color:uint = 0xC0C0C0)
		{
			super(bands, omitFrames);
			this.maxHeight = maxHeight;
			this.minHeight = minHeight;
			this.bandWidth = bandWidth;
			this.color = color;
		}
		
		protected override function render():void
		{
			
			graphics.clear();
			graphics.beginFill(color);
			
			graphics.moveTo(0, maxHeight - minHeight);
			for (var i:int = 0; i < bands; i++)
			{
				var cX:Number = (i + 0.5) * bandWidth;
				var cY:Number = maxHeight - currValues[i] * (maxHeight-minHeight) - minHeight;
				var pX:Number = (i + 1) * bandWidth;
				var pY:Number = maxHeight - minHeight;
				if (i < bands - 1)
				{
					pY -= (currValues[i] + currValues[i + 1]) * 0.5 * (maxHeight - minHeight);
				}
				graphics.curveTo(cX, cY, pX, pY);
			}
			graphics.lineTo(pX, maxHeight);
			graphics.lineTo(0, maxHeight);
		}
	
	}

}