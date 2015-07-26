package com.evili.utils
{
	
	public class NumberHelper{
		public function NumberHelper(){
		}
		/** generates a random number within the specified range */
        public static function randomRange(max:Number, min:Number = 0):uint
		{
		     return Math.floor(Math.random() * (max - min) + min);
		}
	}
}