package com.evili.worldBuilder.modules
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import com.evili.Shell.ContainerBG;
	
	public class DebugModule extends Sprite {
		public var _debugText:TextField;
		private var _debugPanel:ContainerBG;
		
		public function DebugModule()
		{
			init();
		}
		private function init():void{
			_debugPanel = new ContainerBG();
			_debugPanel.draw(0xcccccc, 0, 0, 310, 600);
			addChild(_debugPanel);
			
			
			_debugText = new TextField();
			_debugText.selectable = false;
			_debugText.width = 300;
			_debugText.height = 580;
			_debugText.textColor = 0xff0000;
			_debugText.multiline = true;
			_debugText.wordWrap = true;
			
			_debugPanel.addChild(_debugText);
		}
		/** reciever for debug messages */
		public function showDebugMsg(msg:String):void{
			_debugText.appendText(msg + "\n");
		}
	}
}