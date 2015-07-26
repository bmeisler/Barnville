package com.evili.utils
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;



	public class CustomButton extends SimpleButton{
	    private var upColor:uint   = 0xFFCC00;
	    private var overColor:uint = 0xCCFF00;
	    private var downColor:uint = 0x00CCFF;
	    private var numButtonWidth:Number = 100;
		private var numButtonHeight:Number = 50;
		private var _fontSize:uint;
	
	    public function CustomButton(w:uint, h:uint, label:String, fontSize:uint) {
	    	numButtonWidth = w;
	    	numButtonHeight = h;
	    	_fontSize = fontSize;
	        downState      =  drawButtonState(downColor, label);
	        overState      =  drawButtonState(overColor, label);
	        upState        =  drawButtonState(upColor, label);
	        hitTestState   =  drawButtonState(upColor, label);
	        //hitTestState.x = -(size / 4);
	        //hitTestState.y = hitTestState.x;
	        useHandCursor  = true; 
	    }
	    /** draw the button states and add a label 
	    *  hard coding colors, fonts, sizes, etc - should get from ModelLocator
	    * */
	    private function drawButtonState(rgb:uint, s:String):Sprite {
			var sprite:Sprite = new Sprite();
			sprite.graphics.lineStyle(2,0x33621E,1);
			sprite.graphics.beginFill(rgb);
			sprite.graphics.drawRoundRect(0, 0, numButtonWidth, numButtonHeight,10,10);
			
			var label:TextField = new TextField();
        	label.text = s;
        	var format:TextFormat = new TextFormat("Arial",_fontSize, 0x009922, true);
        	label.setTextFormat(format);
        	label.x = (numButtonWidth/2) - (label.textWidth/2) - 2;
        	label.y = numButtonHeight/2 - label.textHeight/2 - 2;
        	
        	sprite.addChild(label);
			return sprite;
		}
	}

}
