package com.evili.worldBuilder.model
{
	/** this class stores all the information about a particular user's character -
	 * it's physical manifestation (visual) in the world - including
	 * its position, its "box" (any kind of sprite/movieclip), the user's
	 * netID and login name, etc */
	import com.friendsofed.isometric.IsoObject;
	import com.friendsofed.isometric.Point3D;
	import com.friendsofed.pathfinding.AStar;
	
	import flash.display.MovieClip;
	
	public class CharacterVO {
		/** the visual representation of the user in the world */
		///public var _box:DrawnIsoBox;
		public var _box:MovieClip;
		/** server's ID for this user */
		/** the isometric container for the character/avatar
		 *  allows us to import any old movie clip/character with walk cycle
		 *  put it inside an isometric container and control its movement on tiles*/
		public var _isoContainer:IsoObject;
		public var _netID:int;
		/** user's login name */
		public var _userName:String;
		/** the "color" of the avatar, set in color chooser on startup, or randomly generated */
		public var _userColor:uint;
		/** is this the "main" character? That is, the current client's avatar? */
		public var _isMain:Boolean;
		/** initial position of the avatar */
		public var _startPosition:Point3D;
		/** destination position (to be translated into a tile) for the avatar
		 *  eg, the tile the user clicked on */
		public var _destinationPosition:Point3D;
		/** the tile the character is presently "standing", or moving away from*/
		public var _currentTile:IsoObject;
		/** the next tile along the astar path the character is moving to*/
		public var _nextTile:IsoObject;
		/** the final tile in the path the character is moving to - eg, the tile that was clicked on */
		public var _destinationTile:IsoObject; 
		/** the path this character is currently following*/
		public var _astar:AStar;
		
		public function CharacterVO() {
		}

	}
}