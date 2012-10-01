package silin.audio.equalizers
{
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * эквлайзер, звезда
	 * @author silin
	 */
	public class StarEqualizer extends Equalizer
	{
		/**
		 * максимальная высота лучей
		 */
		public var maxRadius:Number;
		public var minRadius:Number;
		public var color:uint;
		public var rayThickness:Number = 4;
		
		/**
		 *
		 * @param	bands			число диапазонов
		 * @param	omitFrames		такт ENTER_FRAME, на котором считаем
		 * @param	maxRadius		максимальный радус
		 * @param	minRadius		минмиальный радиус
		 * @param	color			цвет заливки
		 */
		public function StarEqualizer(bands:uint = 8, omitFrames:Number = 4, maxRadius:Number = 50, minRadius:Number = 1, color:uint = 0xC0C0C0)
		{
			
			super(bands, omitFrames);
			this.maxRadius = maxRadius;
			this.minRadius = minRadius;
			this.color = color;
		
		}
		
		protected override function render():void
		{
			
			graphics.clear();
			graphics.beginFill(color);
			var k:Number = Math.PI * 2 / bands;
			var base:Number = minRadius * Math.sin(k / 2);
			if (base < rayThickness)
			{
				base = rayThickness;
			}
			
			var r:Number = minRadius * Math.cos(k / 2);
			
			for (var i:int = 0; i < bands; i++)
			{
				//if (!currValues[i]) continue;
				
				var fi:Number = i * k;
				var raySin:Number = Math.sin(fi);
				var rayCos:Number = Math.cos(fi);
				var baseSin:Number = Math.sin(fi + Math.PI * 0.5);
				var baseCos:Number = Math.cos(fi + Math.PI * 0.5);
				
				var iX:Number = maxRadius + r * rayCos;
				var iY:Number = maxRadius + r * raySin;
				//vertices
				var aX:Number = iX - base * baseCos;
				var aY:Number = iY - base * baseSin;
				var bX:Number = iX + base * baseCos;
				var bY:Number = iY + base * baseSin;
				var cX:Number = maxRadius + (r + (maxRadius - r) * currValues[i]) * rayCos;
				var cY:Number = maxRadius + (r + (maxRadius - r) * currValues[i]) * raySin;
				
				i ? graphics.lineTo(aX, aY) : graphics.moveTo(aX, aY);
				
				graphics.lineTo(cX, cY);
				graphics.lineTo(bX, bY);
			}
			graphics.endFill();
		}
	
	}
}

