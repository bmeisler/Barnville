package com.evili.worldBuilder.events {
	import flash.events.Event;
	
	/** all-purpose event class for passing data in the form of
	 * a generic object when an event is completed */
	public class UserLeavesRoomEvent extends Event {
		public static const LEAVES_ROOM:String = "leavesRoom";
		private var _userID:int;
		private var _userName:String;
		
		public function UserLeavesRoomEvent(type:String, userID:int, userName:String)
		{
			super(type, bubbles, cancelable);
			_userID = userID;
			_userName = userName;
		}
		public function get userID():Object{
			return _userID;
		}
		public function get userName():Object{
			return _userName;
		}
		
	}
}