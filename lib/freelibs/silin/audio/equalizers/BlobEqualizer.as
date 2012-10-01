package silin.audio.equalizers
{
	import flash.geom.Point;
	
	/**
	 * эквалайзер, клякса
	 * @author silin
	 */
	public class BlobEqualizer extends Equalizer
	{
		/**
		 * цвет заливки
		 */
		public var color:uint;
		/**
		 * минимальный радиус
		 */
		public var minRadius:Number;
		/**
		 * максимальный радиус
		 */
		public var maxRadius:Number;
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxRadius		максимальный радиус
		 * @param	minRadius		минимальный радиус
		 * @param	color			цвет заливки
		 */
		public function BlobEqualizer(bands:uint = 8, omitFrames:Number = 4, maxRadius:Number = 50, minRadius:Number = 1, color:uint = 0xC0C0C0)
		{
			super(bands, omitFrames);
			this.maxRadius = maxRadius;
			this.minRadius = minRadius;
			this.color = color;
		}
		
		protected override function render():void
		{
			var i:int;
			var pX:Number;
			var pY:Number;
			var cX:Number;
			var cY:Number;
			var fi:Number;
			var cicle:Vector.<Point> = new Vector.<Point>(bands + 1, true);
			
			graphics.clear();
			graphics.beginFill(color);
			var k:Number = minRadius / maxRadius;
			for (i = 0; i < bands; i++)
			{
				fi = 2 * i * Math.PI / bands;
				pX = (1 + Math.cos(fi) * (k + (1 - k) * currValues[i])) * maxRadius;
				pY = (1 + Math.sin(fi) * (k + (1 - k) * currValues[i])) * maxRadius;
				
				cicle[i] = new Point(pX, pY);
			}
			cicle[i] = cicle[0];
			pX = 0.5 * (cicle[0].x + cicle[bands - 1].x);
			pY = 0.5 * (cicle[0].y + cicle[bands - 1].y);
			graphics.moveTo(pX, pY);
			for (i = 0; i < bands; i++)
			{
				cX = cicle[i].x;
				cY = cicle[i].y;
				pX = 0.5 * (cicle[i].x + cicle[i + 1].x);
				pY = 0.5 * (cicle[i].y + cicle[i + 1].y);
				graphics.curveTo(cX, cY, pX, pY);
			}
			graphics.endFill();
		}
	
	}

}