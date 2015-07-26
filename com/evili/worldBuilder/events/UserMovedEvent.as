package com.evili.worldBuilder.events {
	import com.friendsofed.isometric.Point3D;
	
	import flash.events.Event;
	
	/** called whenever a client clicks on a tile in their world - we will
	 *  transmit this info to other views so we can move their avatars
	 *  simultaneously */
	public class UserMovedEvent extends Event {
		public static const MOVED:String = "moved";
		private var _userID:int;
		/** position that user clicked */
		private var _destinationPosition:Point3D;
		
		public function UserMovedEvent(type:String, userID:int, destinationPosition:Point3D)
		{
			super(type, bubbles, cancelable);
			_userID = userID;
			_destinationPosition = destinationPosition;
		}
		public function get userID():Object{
			return _userID;
		}
		public function get destinationPosition():Point3D{
			return _destinationPosition;
		}
		
	}
}