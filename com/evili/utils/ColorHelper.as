package com.evili.utils
{
	
	public class ColorHelper{
		public function ColorHelper(){
		}
		public static function getRandomColor(red:uint, green:uint, blue:uint):uint {
            var color24:uint = red << 16 | green << 8 | blue;
            return color24;
        }
	}
}