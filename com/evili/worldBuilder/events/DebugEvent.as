package com.evili.worldBuilder.events {
	import flash.events.Event;
	
	/** use this for passing debug traces from wherever
	 * 	they originate  to wherever 
	 *  they will be output on screen */
	public class DebugEvent extends Event {
		public static const DEBUG_MSG:String = "debugMsg";
		private var _msg:String;
		
		public function DebugEvent(type:String, msg:String)
		{
			super(type, bubbles, cancelable);
			_msg = msg
		}
		public function get msg():Object{
			return _msg;
		}
		
	}
}