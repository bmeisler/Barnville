package com.evili.worldBuilder.events {
	import flash.events.Event;
	
	public class LoginEvent extends Event {
		public static const LOGIN:String = "login";
		
		public var _userName:String;
		public var _password:String;
		
		public function LoginEvent(type:String, userName:String, password:String) {
			super(type, bubbles, cancelable);
			_userName = userName;
			_password = password;
		}
	}
}