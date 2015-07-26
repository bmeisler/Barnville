package com.evili.Shell
{
	import flash.display.Sprite;

	public class ContainerBG extends Sprite{
		public function ContainerBG() {
			super();
		}
		public function draw(fillColor:Number, xPos:int, yPos:int, w:int, h:int):void{
			graphics.lineStyle(3, 0xeeeeee, 1);
			graphics.beginFill(fillColor, 1);
			graphics.drawRoundRect(xPos, yPos, w, h, 15, 15);
			graphics.endFill();
		}
		
	}
}