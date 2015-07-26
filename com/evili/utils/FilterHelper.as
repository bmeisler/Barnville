package com.evili.utils
{
	import flash.filters.*;
	public class FilterHelper{
		public function FilterHelper(){
		}
		
		public static function getGlowFilter():BitmapFilter{
			
			return new GlowFilter()
		}
		public static function getColoredGlowFilter(color:int):BitmapFilter{
			
			return new GlowFilter(color)
		}
		public static function getBevelFilter():BitmapFilter {
            var distance:Number       = 3;
            var angleInDegrees:Number = 45;
            var highlightColor:Number = 0xeeeeee;
            var highlightAlpha:Number = 0.8;
            var shadowColor:Number    = 0xcccccc;
            var shadowAlpha:Number    = 0.6;
            var blurX:Number          = 5;
            var blurY:Number          = 5;
            var strength:Number       = 5;
            var quality:Number        = BitmapFilterQuality.HIGH;
            var type:String           = BitmapFilterType.INNER;
            var knockout:Boolean      = false;

            return new BevelFilter(distance,
                                   angleInDegrees,
                                   highlightColor,
                                   highlightAlpha,
                                   shadowColor,
                                   shadowAlpha,
                                   blurX,
                                   blurY,
                                   strength,
                                   quality,
                                   type,
                                   knockout);
        }
		public static function getGradientGlowFilter():BitmapFilter {
	             var distance:Number  = 0;
	         var angleInDegrees:Number = 45;
	         var colors:Array     = [0xFFFFFF, 0xFF0000, 0xFFFF00, 0x00CCFF];
	         var alphas:Array     = [0, 1, 1, 1];
	         var ratios:Array     = [0, 63, 126, 255];
	         var blurX:Number     = 50;
	         var blurY:Number     = 50;
	         var strength:Number  = 2.5;
	         var quality:Number   = BitmapFilterQuality.HIGH;
	         var type:String      = BitmapFilterType.OUTER;
	         var knockout:Boolean = false;
            return new GradientGlowFilter(distance,
                                          angleInDegrees,
                                          colors,
                                          alphas,
                                          ratios,
                                          blurX,
                                          blurY,
                                          strength,
                                          quality,
                                          type,
                                          knockout);
        }
        public static function getBlurFilter(col:Number=0x33CCFF):BitmapFilter {
            ///var color:Number = 0x33CCFF;
			var color:Number = col;
            var alpha:Number = 0.8;
            var blurX:Number = 35;
            var blurY:Number = 35;
            var strength:Number = 2;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;

            return new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout);
        }
		 public static function getDropShadowFilter():BitmapFilter {
            var color:Number = 0x000000;
            var angle:Number = 45;
            var alpha:Number = 0.8;
            var blurX:Number = 8;
            var blurY:Number = 8;
            var distance:Number = 15;
            var strength:Number = 0.65;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;
            return new DropShadowFilter(distance,
                                        angle,
                                        color,
                                        alpha,
                                        blurX,
                                        blurY,
                                        strength,
                                        quality,
                                        inner,
                                        knockout);
        }
	}
}