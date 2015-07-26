package com.evili.utils
{
	public class MyMath
	{
		public function MyMath()
		{
		}

		public static function factorial(index:uint) : uint {
			var total:uint = index;
			if(index > 0){
				total += MyMath.factorial(index - 1);
			}
			return total;
		}
	}
}