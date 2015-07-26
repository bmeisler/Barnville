package com.evili.worldBuilder.modules
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Shape;
	
	public class LabelMaker
	{
		private var _labelText:String;
		public function LabelMaker(s:String)
		{
			_labelText = s;
		}
		public function makeLabel():Sprite{
			var label:TextField = new TextField();
            label.x = 0;
            label.y = 0;
            label.width = 25;
            label.height = 15;
            label.autoSize = 'left';
            label.antiAliasType = flash.text.AntiAliasType.ADVANCED;
            label.selectable = false;
            label.multiline = true;
            label.text = _labelText;
            var shadow:Shape  = new Shape();
        	var bg:Shape     = new Shape();
        	reset_bg(label, bg, shadow);
        	var containerClip:Sprite = new Sprite();
        	containerClip.addChild(shadow);
        	containerClip.addChild(bg);
        	containerClip.addChild(label);
        	return containerClip;
		}
		private function reset_bg(label:TextField, bg:Shape, shadow:Shape):void {
            var l:Number = label.x;
            var t:Number = label.y;
            var w:Number = label.textWidth + 12;
            var h:Number = label.textHeight + 4;
			var opacity:Number = 0.6;
            bg.graphics.clear();
            bg.graphics.lineStyle(0, 0x333333, opacity);
            bg.graphics.beginFill(0xFFFFCC, opacity);
            bg.graphics.drawRect(l, t, w, h);
            bg.graphics.endFill();

            shadow.graphics.clear();
            shadow.graphics.beginFill(0x000000, opacity / 2);
            shadow.graphics.drawRect(l + 3, t + 3, w, h);
            shadow.graphics.endFill();
        }
	}
}