 package com.evili.worldBuilder.model
{
	import com.evili.utils.Map;
	
	import flash.display.MovieClip;
	import flash.net.SharedObject;
	
	
	public class ModelLocator{
		private static var _instance:ModelLocator = null;
		public var _myUserName:String;
		public var _myUserId:int;
		/** size of tiles in the grid*/
		public var _cellSize:Number = 20;
		/** color of the tiles in the grid */
		public var _cellColor:uint = 0x00ccff;
		/** number of rows in the grid */
		public var _numRows:Number = 19;
		/** number of columns in the grid */
		public var _numCols:Number = 19;
		/** show the A* searched tiles (yellow) and the path tiles (cyan) - for testing */
		public var _showPath:Boolean = false;
		/** width of the stage*/
		public var stageWidth:uint = 800;
		public var stageHeight:uint = 600;
		/** width of the container that holds the actual room/grids */
		public var _worldContainerWidth:int = 800;
		/** height of the container that holds the actual room/grids */
		public var _worldContainerHeight:int = 600;
		/** list of existing users' settings (value object) in the current room, by userId (key)*/
		///public var _currentUserSettingsMap:Map;
		/** list of currentUserSettingsMaps (value) by room (key)*/
		public var _currentRoomUserSettingsMap:Map;
		/** default color of chat bubbles*/
		public var _chatBubbleColor:uint = 0xffffff;
		/** maximum time in ms a chat bubble is allowed to exist */
		public var _maxBubbleLifeTime:Number = 10000;//5000;
		/** minimum time in ms a chat bubble must exist */
		public var _minBubbleLifeTime:Number = 2000;
		/** method of characters moving on screen 
		 *  options include "fly" - a parabolic movement from first tile to last tile, above the grid - TO BE IMPLMENTED
		 * "walk" - moving one tile at a time, with walk cycle if appropriate
		 * "transport" - instantly move from first tile to last tile, should have fade in/fade out*/
		public var _movementMethod:String = "walk";
		/** transition style if using a Caurina transition to move avatar, eg "fly" */
		public var _transitionStyle:String = "linear";
		/** speed avatar moves, in ms 
		 *  NOTE: need to divide by 1000 for Caurina*/
		public var _timerSpeed:Number = 250;
		/** speed avatar moves in, in pixels - MUST evenly divide into _cellSize!*/
		public var _movementSpeed:int = 5;
		/** do we need to log in or not?*/
		public var _showLoginPanel:Boolean = false;
		/** do we see the trace panel or not? */
		public var _showDebugPanel:Boolean = false;
		/** do we show messages or not?*/
		public var _showMessages:Boolean = true;
		/**how often do we show a "spam" or random general message, in ms?*/
		public var _spamFrequency:int = 60000;
		/** do we add avatars or not? For testing*/
		public var _showAvatar:Boolean = true;
		/** show row and column numbers for tiles? FOR TESTING*/
		public var _showCoords:Boolean = false;
		/** userId for this client, eg the main character */
		/** for demo/debugging, use wireframe. - shows individual tiles on grid
		 *  "graphics" will import tile graphics, bg graphics, etc*/
		public var _graphicsMode:String = "wireframe";
		/** do we show the background default tiles or not? Or only tiles that have graphics/colors? */
		public var _showGrid:Boolean = false;
		/** do we show the bg image or not - good for demo */
		public var _showBg:Boolean = false;
		/** use an xml file to make map, or built-in simple grid - for testing*/
		public var _useXMLMap:Boolean = true;
		public var _mainCharacterId:int;
		/** what style avatar? "box" or "animation"? */
		public var _characterStyle:String = "animation";
		/** which SmartFox zone do we log into? */
		public var _zone:String = "miniPeeps";
		/** color for avatar selected on startup*/
		public var _myUserColor:uint;
		/** use this to wait for xml loading while logging in */
		public var _ready:Boolean = false;
		/** for local purposes/easy games - use without SmartFox server?*/
		public var _useServer:Boolean = false;
		
		/**NOTE: create a ROOM object!!!! not using a server - have a single room only*/
		public var _currentRoomName:String = "SingleRoom";
		/**not using a server - have a single room id only*/
		public var _currentRoomId:int = 1;
		
		/** which item from the store is selected?*/
		public var _selectedItem:MovieClip;
		/** better - use this instead - all item info for selected store item*/
		public var _selectedItemVO:ItemVO;
		
		/** use this to save state, remember where users placed icons, score, etc */
		public var _mySO:SharedObject;
		/** for debugging - use sharedObject or not?*/
		public var _useSharedObject:Boolean = false;
		/** contains all info from (originally) xml file, or sharedObject, once saved, about the tiles */
		public var _gridVO:GridVO;
		/** user clicked on the bulldozer - go into destroy mode*/
		public var _destroyMode:Boolean = false;
		
		/** amount of farmbucks you have*/
		public var _farmBucks:int = 5000;
		/** information about all objects that can be placed on tiles, eg, price of a cow, number of tiles covered, direction, sound associated, etc*/
		public var _itemsArray:Array;
		/** how often do we give you points for being alive?*/
		public var _scoreTimer:uint = 5000;
		/** is the "actions" menu open? Hack to ignore clicks*/
		public var _isActionsMenuOpen:Boolean = false;
		/** is the selected item being moved (as opposed to bought - actions are 95% the same, just costs less to move, and original needs to be deleted)*/
		public var _isMoved:Boolean = false;
		/** keep track of the cursor */
		public var _cursor_mc:MovieClip;
		
		/** is there an outhouse available?*/
		public var _isOuthouse:Boolean;
		/** should we randomly add a rattlesnake?*/
		public var _addRattlesnake:Boolean = false;
		/** have we already added a rattlesnake?*/
		public var _isRattlesnake:Boolean = false;
		/** show the character's name or not? Important when mulitple characters are onscreen, turn off for single character play*/
		public var _showCharacterName:Boolean = false;
		/** play the BG music and go insane?*/
		public var _playBGMusic:Boolean = true;
		/** have we showed the plowing message yet?*/
		public var _hasShowedPlowMessage:Boolean = false;
		
		
		public function ModelLocator(){
		}
		
		/**ensures class is a singleton */
		static public function getInstance():ModelLocator{
			if (_instance == null){
				_instance = new ModelLocator();
			}
			return _instance;
		}
	}
}