package silin.audio.equalizers
{
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * эквлайзер, непонятная фигура
	 * @author silin
	 */
	public class CrystalEqualizer extends Equalizer
	{
		/**
		 * максимальный радиус
		 */
		public var maxRadius:Number;
		/**
		 * цвет заливки
		 */
		public var color:uint;
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxRadius		максимальный радус
		 * @param	color			цвет заливки
		 */
		public function CrystalEqualizer(bands:uint = 8, omitFrames:Number = 4, maxRadius:Number = 50, color:uint = 0xC0C0C0)
		{
			
			super(bands, omitFrames);
			this.maxRadius = maxRadius;
			this.color = color;
		
		}
		
		protected override function render():void
		{
			
			var i:int;
			
			var k:Number = Math.PI * 2 / bands;
			var tmp:Vector.<Point> = new Vector.<Point>(bands, true);
			for (i = 0; i < bands; i++)
			{
				var fi:Number = i * k;
				var pX:Number = maxRadius * (1 + Math.sin(fi) * currValues[i]);
				var pY:Number = maxRadius * (1 + Math.cos(fi) * currValues[i]);
				tmp[i] = new Point(pX, pY);
			}
			
			graphics.clear();
			graphics.beginFill(color);
			graphics.moveTo(tmp[0].x, tmp[0].y);
			
			var d:int = 3;
			for (i = 0; i < bands; i++)
			{
				var p1:Point = tmp[i];
				var p2:Point = tmp[(i + d) % bands];
				graphics.lineTo(p1.x, p1.y);
				graphics.lineTo(p2.x, p2.y);
			}
			
			graphics.endFill();
		}
	
	}
}

