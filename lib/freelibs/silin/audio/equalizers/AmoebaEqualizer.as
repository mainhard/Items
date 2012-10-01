package silin.audio.equalizers
{
	
	/**
	 * эквалайзер, что-то амебоподобное
	 * @author silin
	 */
	public class AmoebaEqualizer extends Equalizer
	{
		/**
		 * максимальный радиус
		 */
		public var maxRadius:Number;
		/**
		 * минмимальный радиус
		 */
		public var minRadius:Number;
		/**
		 * цвет заливки
		 */
		public var color:uint;
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxRadius		максимальный радиус
		 * @param	minRadius		минмимальный радиус
		 * @param	color			цвет заливки
		 */
		public function AmoebaEqualizer(bands:uint = 8, omitFrames:Number = 4, maxRadius:Number = 50, minRadius:Number = 1, color:uint = 0xC0C0C0)
		{
			super(bands, omitFrames);
			this.maxRadius = maxRadius;
			this.minRadius = minRadius;
			this.color = color;
		}
		
		protected override function render():void
		{
			var i:int;
			var del:Number = 1 / bands;
			var fi:Number = -2 * Math.PI / bands + del;
			var pX:Number = maxRadius + Math.cos(fi) * (minRadius + currValues[bands - 1] * maxRadius);
			var pY:Number = maxRadius + Math.sin(fi) * (minRadius + currValues[bands - 1] * maxRadius);
			
			graphics.clear();
			graphics.beginFill(color);
			graphics.moveTo(pX, pY);
			var k:Number = minRadius / maxRadius;
			for (i = 0; i < bands; i++)
			{
				
				fi = 2 * i * Math.PI / bands + del;
				
				pX = (1 + Math.cos(fi) * (k + (1 - k) * currValues[i])) * maxRadius;
				pY = (1 + Math.sin(fi) * (k + (1 - k) * currValues[i])) * maxRadius;
				
				//graphics.lineTo(pX, pY);
				graphics.curveTo(maxRadius, maxRadius, pX, pY);
			}
			
			graphics.endFill();
		}
	
	}

}