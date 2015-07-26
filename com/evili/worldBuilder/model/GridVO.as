package com.evili.worldBuilder.model
{
	/** this class stores all the information about a particular room's map
	 *  which tiles to use, when to use graphic tiles, bg and fg images, etc*/

	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class GridVO {
		/** offset for the room, if any*/
		public var _origin:Point;
		/** the name of this room*/
		public var _roomName:String;
		/** the fg image, and position data, if any*/
		public var _fgImage:Object;
		/** the bg image, and position data, if any*/
		public var _bgImage:Object;
		/**number of rows in the room*/
		public var _numRows:uint;
		/**number of cols in the room*/
		public var _numCols:uint;
		/**information about the floor tiles, including col and row position, graphic info and elevation*/
		public var _floorData:Array;
		/**information about furniture*/
		public var _furnitureData:Array;
		/**information about characters*/
		public var _characterData:Array;
		
		public function GridVO(savedObject:Object = null) {
			if (savedObject != null){
				_origin = new Point(savedObject._origin.x, savedObject._origin.y);
				_roomName = savedObject._roomName;
				_fgImage = savedObject._fgImage;
				_bgImage = savedObject._bgImage;
				_floorData = savedObject._floorData;
				_numCols = savedObject._numCols;
				_numRows = savedObject._numRows;
			}
		}

	}
}