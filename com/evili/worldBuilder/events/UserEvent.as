package com.evili.worldBuilder.events {
	import flash.events.Event;
	
	//import it.gotoandplay.smartfoxserver.data.User;
	import com.evili.worldBuilder.model.User;
	
	/** all-purpose event class for passing User data */
	public class UserEvent extends Event {
		public static const RECEIVED_PUBLIC_MESSAGE:String = "receivedPublicMessage";
		public static const RECEIVED_PRIVATE_MESSAGE:String = "receivedPrivateMessage";
		public static const SENT_PUBLIC_MESSAGE:String = "sentPublicMessage";
		
		public static const LEAVES_ROOM:String = "leavesRoom";
		
		public var _user:User;
		public var _msg:String;
		
		public function UserEvent(type:String, user:User, msg:String="")
		{
			super(type, bubbles, cancelable);
			_user = user;
			_msg = msg;
		}
		public function get userId():Object{
			var userId:int = _user.getId();
			return userId;
		}
		public function get userName():Object{
			var userName:String = _user.getName();
			return userName;
		}
		
	}
}