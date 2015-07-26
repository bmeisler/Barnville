package com.evili.worldBuilder.events {
	import flash.events.Event;
	
	/** all-purpose event class for passing data in the form of
	 * a generic object when an event is completed */
	public class DataEvent extends Event {
		public static const DATA_COMPLETE:String = "dataComplete";
		public static const ITEM_DATA_COMPLETE:String = "itemDataComplete";
		public static const UPDATE_USER_VARS:String = "updateUserVars";
		public static const LOGGED_IN:String = "loggedIn";
		public static const SET_COLOR:String = "setColor";
		public static const PATH_MOVEMENT:String = "pathMovement";
		public static const PURCHASE_ITEM:String = "purchaseItem";
		public static const STATUS_UPDATE:String = "statusUpdate";
		
		private var _data:Object;
		
		public function DataEvent(type:String, o:Object=null)
		{
			super(type, bubbles, cancelable);
			_data = o;
		}
		public function get data():Object{
			return _data;
		}
		/* override public function clone():Event{
			return new DataEvent(type, o);
		}; */

		
	}
}