package com.evili.worldBuilder.model
{
	import com.friendsofed.isometric.Point3D;

	/** information about the actual tile - its row and column, what kind of object is currently on it, if
	 *  it's being "occupied" by a multi-tile object that started somewhere else, like a barn for instance */
	public class TileVO
	{
		public var _col:Number;
		public var _row:Number;
		public var _elevation:Number;
		public var _walkable:String;
		public var _tileClassName:String;
		public var _tileClass:Class;
		public var _furnitureClassName:String;
		public var _furnitureClass:Class;
		/** does another tile "jut out" over this one? If so, we need to know if eg a large building overlaps this tile
		 *  so that if we click on it, we can take the action associated with the building, and not this actual tile*/
		public var _occupiedBy:String;
		/** what's the ID of the occupying tile, so we can perform the correct action for the occupier,
		 *  if we click on this occupied tile*/
		public var _occupierID:int;
		/** has the object occupying this tile matured?*/
		public var _grown:Boolean = false;
		/** what's the 3D point position of this tile?*/
		public var _position:Point3D;
		/** has this crop or animal been watered or fed*/
		public var _isFed:Boolean = false;
		/** if an animal, has it been petted/loved up? */
		public var _isLoved:Boolean = false;

		public function TileVO(tileObject:Object = null)
		{
			if (tileObject != null){
				_col = tileObject._col;
				_row = tileObject._row;
				_elevation = tileObject._elevation;
				_walkable = tileObject._walkable;
				_tileClassName = tileObject._tileClassName;
				_tileClass = tileObject._tileClass as Class;
				_furnitureClassName = tileObject._furnitureClassName;
				_furnitureClass = tileObject._furnitureClass as Class;
				_occupiedBy = tileObject._occupiedBy;
				_occupierID = tileObject._occupierID;
				_grown = tileObject._grown;
				_position = tileObject._position;
				_isFed = tileObject._isFed;
				_isLoved = tileObject._isLoved;
			}
		}
	}
}
