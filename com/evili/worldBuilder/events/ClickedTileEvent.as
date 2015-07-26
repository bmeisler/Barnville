package com.evili.worldBuilder.events {
	import com.friendsofed.isometric.IsoObject;
	import com.friendsofed.isometric.Point3D;
	
	import flash.events.Event;
	
	/** called whenever a client clicks on a tile in their world - already exists as a UserEvent
	 *  but want it available for other purposes, eg, showing a message */
	public class ClickedTileEvent extends Event {
		public static const CLICKED_TILE:String = "clickedTile";
		public static const CLICKED_DRAWN_TILE:String = "clickedDrawnTile";
		public static const CLICKED_GRAPHIC_TILE:String = "clickedGraphicTile";
		///private var _userID:int;
		/** position that user clicked */
		private var _destinationPosition:Point3D;
		/**actual tile clicked on*/
		private var _tile:IsoObject;
		/** for graphic tiles, the class from the swc */
		private var _classRef:Class;
		
		//public function ClickedTileEvent(type:String, userID:int, destinationPosition:Point3D, tile:IsoObject, classRef:Class=null)
		public function ClickedTileEvent(type:String, destinationPosition:Point3D, tile:IsoObject, classRef:Class=null)
		{
			super(type, bubbles, cancelable);
			///_userID = userID;
			_destinationPosition = destinationPosition;
			_tile = tile;
			_classRef = classRef;
		}
		/*public function get userID():Object{
			return _userID;
		}*/
		public function get destinationPosition():Point3D{
			return _destinationPosition;
		}
		public function get tile():IsoObject{
			return _tile;
		}
		public function get classRef():Class{
			return _classRef;
		}
		
	}
}