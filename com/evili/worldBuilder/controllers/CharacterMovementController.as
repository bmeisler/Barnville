package com.evili.worldBuilder.controllers {
	/** coordinates movement of avatars on the grid using astar pathfinding
	 *  create a new instance of this class for every avatar that moves */
	 
	 	import caurina.transitions.Tweener;
	 	
	 	import com.evili.utils.DataTimer;
	 	import com.evili.utils.Map;
	 	import com.evili.worldBuilder.events.DataEvent;
	 	import com.evili.worldBuilder.model.CharacterVO;
	 	import com.evili.worldBuilder.model.ModelLocator;
	 	///import com.friendsofed.isometric.DrawnIsoTile;
	 	import com.friendsofed.isometric.IsoObject;
	 	import com.friendsofed.isometric.IsoWorld;
	 	import com.friendsofed.pathfinding.AStar;
	 	import com.friendsofed.pathfinding.Grid;
	 	
	 	import flash.display.DisplayObject;
	 	import flash.display.MovieClip;
	 	import flash.events.Event;
	 	import flash.events.EventDispatcher;
	 	import flash.events.TimerEvent;
	 	import flash.utils.Timer;
		
	public class CharacterMovementController extends EventDispatcher{
		
		/** hash map of all paths being used, with avatar userId used as the key, astar as the value
		 *  allows us to have multiple simulataneous astar paths */
		private var _pathsMap:Map = new Map();
		/** hash map of all timers being used, with avatar userId used as the key, the timer as the value
		 *  need to kill the timer for the avatar, as well as its astar path, when stopping movement */
		private var _timersMap:Map = new Map();
		/** use this grid to hold all the tiles created */
		public var _grid:Grid;
		/** instance of the main world
		 *  NOTE: *** should use event dispatchers to send this info rather than public functions!!!*/
		private var _world:IsoWorld;
		
		/**no doubt a better way to handle this - use xdiff and zdiff between current
		 * and next tiles to determine character direction*/
		private var _xDiff:int;
		private var _zDiff:int;
		
		public function CharacterMovementController(grid:Grid, world:IsoWorld) {
			_grid = grid;
			_world = world;
		}
		/**
		 * Creates an instance of AStar and uses it to find a path.
		 * We re-create the astar on every tile, to compensate for other avatar's movements
		 * 
		 */
		public function findPath(startTile:IsoObject, destinationTile:IsoObject, userId:int):void
		{
			if (destinationTile == null || startTile == null){
				return;
			}
			trace("CharacterMovementController:::findPath::clickedTile: " + destinationTile.position.x + ", " + destinationTile.position.y);
			var movementMethod:String = ModelLocator.getInstance()._movementMethod;
			///var currentRoomId:int = ModelLocator.getInstance()._currentRoomId();
			var currentRoomId:int = 1;
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(userId.toString()) as CharacterVO;
			trace("CharacterMovementController:::findPath::movementMethod: " + movementMethod);
			if (movementMethod == "walk"){
				 var _astar:AStar = new AStar();
				/// _pathsMap.put(userId.toString(), _astar);
				_astar.setNodes(startTile._node, destinationTile._node);
				if(_astar.findPath(_grid))
				{
					startTile.walkable = true;
					destinationTile.walkable = false;
					if (ModelLocator.getInstance()._showPath == true && ModelLocator.getInstance()._graphicsMode == "wireframe"){
						showVisited(_astar);
						showPath(_astar);
					}
	
					characterVO._astar = _astar;
					characterVO._currentTile = startTile;
					characterVO._destinationTile = destinationTile; 
					
					var avatarSpeed:Number = ModelLocator.getInstance()._timerSpeed;
					var myTimer:Timer;
					myTimer = new DataTimer(avatarSpeed, _astar.path.length, userId);
					_timersMap.put(userId.toString(), myTimer);
	           		myTimer.addEventListener("timer", moveAlongPath);
	            	myTimer.start(); 

	            	/* 
	            	NOTE:*** attempt to use ENTER_FRAME event instead of a timer - MUCH
	            	MORE difficult to pass information!!!

	            	moveAlongPath(characterVO);*/
				}
			}else if (movementMethod == "transport"){
					startTransport(characterVO);
			}
		}
		
		/* private function moveAlongPath(characterVO:CharacterVO):void{
			//NOTE:*** need to make the PREVIOUS destinationTile walkable, and the current one non-walkable
			
			
			///var characterVO:CharacterVO = e.data as CharacterVO;
			///_characterVO = characterVO;
			///var destinationTile:DrawnIsoTile;
			///var userId:int = e.data as int;
			var userId:int = characterVO._netID;
			///var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			///var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			///var characterVO:CharacterVO = currentUserSettingsMap.getValue(userId.toString()) as CharacterVO;
			//NOTE:*** can cause a dialog box error if leave a room while moving - ERROR TRAP NEEDED!!!
			var character:MovieClip = characterVO._box;
			var currentIsoContainer:IsoObject = characterVO._isoContainer;
			///var _astar:AStar = this._pathsMap.getValue(userId.toString()) as AStar;
			var astar:AStar = characterVO._astar;
			//NOTE: *** _pathNum should probably be stored elsewhere...
			if (astar == null){
				///var myTimer:Timer = e.target as Timer;
				///myTimer.stop();
				//this._pathsMap.remove(userId.toString());
				characterVO._astar = null;
				return;
			}
			astar._pathNum++;
			var pathNum:int = astar._pathNum;
			var movementMethod:String = ModelLocator.getInstance()._movementMethod;
			
			///var character:MovieClip;
			//haven't reached end of path yet
			if (pathNum < astar.path.length){
				///characterVO._currentTile = astar.path[pathNum-1]._owner as DrawnIsoTile;
				characterVO._nextTile = astar.path[pathNum]._owner as DrawnIsoTile;
				///var pathLength:int = astar.path.length;
				///characterVO._destinationTile = astar.path[pathLength -1]._owner as DrawnIsoTile;
			
				var cellSize:int = ModelLocator.getInstance()._cellSize;
				var _xDiff:int = characterVO._nextTile.position.x - characterVO._currentTile.position.x;
				var _zDiff:int = characterVO._nextTile.position.z - characterVO._currentTile.position.z;
				if (_xDiff != 0){
					_xDiff/cellSize;
				}
				if (_zDiff != 0){
					_zDiff/cellSize;
				}
				var direction:int = Math.floor((Math.PI + Math.atan2(_zDiff, _xDiff))/(Math.PI/4))%8;
				trace("CharacterMovementController:::moveAlongPath::currentTile: " + characterVO._currentTile.position.x + ", " + characterVO._currentTile.position.z);
   				trace("CharacterMovementController:::moveAlongPath::nextTile: " + characterVO._nextTile.position.x + ", " + characterVO._nextTile.position.z);
   				
				trace("CharacterMovementController:::moveAlongPath::direction: " + direction);
				trace("CharacterMovementController:::moveAlongPath::_xDiff: " + _xDiff);
				trace("CharacterMovementController:::moveAlongPath::_zDiff: " + _zDiff);
				if (characterVO._currentTile.position == characterVO._nextTile.position){
					return;
				}
				//NOTE:  Direction not accurate enough! Should just use _xDiff and _zDiff!!!
				var speed:int = ModelLocator.getInstance()._movementSpeed;
				currentIsoContainer.vx = 0;
				currentIsoContainer.vz = 0;
				if (_xDiff > 0){
					currentIsoContainer.vx = speed;
				}else if (_xDiff < 0){
					currentIsoContainer.vx = -speed;
				}else {
					currentIsoContainer.vx = 0;
				}
				if (_zDiff > 0){
					currentIsoContainer.vz = speed;
				}else if (_zDiff < 0){
					currentIsoContainer.vz = -speed;
				}else {
					currentIsoContainer.vz = 0;
				}
				trace("CharacterMovementController:::moveAlongPath::currentIsoContainer.vx: " + currentIsoContainer.vx);
				trace("CharacterMovementController:::moveAlongPath::currentIsoContainer.vz : " + currentIsoContainer.vz );
				
				//switch(direction){
					//case 0 :
					//currentIsoContainer.vx = -speed;
					//currentIsoContainer.vz = 0;
					//break;
					
					//case 1 :
					//currentIsoContainer.vx = -speed;
					//currentIsoContainer.vz = -speed;
					//break;
					
					//case 2 :
					//currentIsoContainer.vx = 0;
					///currentIsoContainer.vz = -speed;
					//break;
					
					//case 3 :
					//currentIsoContainer.vx = speed;
					//currentIsoContainer.vz = -speed;
					//break;
					
					//case 4 :
					//currentIsoContainer.vx = speed;
					//currentIsoContainer.vz = 0;
					//break;
					
					//case 5 :
					//currentIsoContainer.vx = speed;
					//currentIsoContainer.vz = speed;
					//break;
					
					//case 6 :
					//currentIsoContainer.vx = 0;
					//currentIsoContainer.vz = speed;
					//break;
					
					//case 7 :
					//currentIsoContainer.vx = -speed;
					//currentIsoContainer.vz = speed;
					//break;
				//}
				///characterVO._currentTile.walkable = true;
				//instantly moves avatar to next tile - for "transport" motion...
				///_nextTilePosition = characterVO._nextTile.position
				///characterVO._nextTile.walkable = false;
				if (movementMethod == "transport"){
					currentIsoContainer.position = characterVO._nextTile.position;
					_world.sort();
					if (userId == ModelLocator.getInstance()._mainCharacterId){
   						updateUserVars(characterVO._userName, characterVO._startPosition.x, characterVO._startPosition.z, characterVO._box.color);
   					}
				}else if (movementMethod == "walk"){
					currentIsoContainer.addEventListener(Event.ENTER_FRAME, onCharacterMove);
					if (ModelLocator.getInstance()._characterStyle == "animation"){
						characterWalk(character);
					}
				}
				
				
				
   				
				//NOTE: *** positioning is incorrect when stacking on tiles with height
				///_mainCharacter.position.y = destinationTile.height;
				///findPath(characterVO._nextTile, characterVO._destinationTile, userId);
				//we're at the end of the path
   			}else{
   				
   				characterVO._destinationTile = astar.path[pathNum-1]._owner as DrawnIsoTile;
   				trace("CharacterMovementController:::moveAlongPath::destinationTile: " + characterVO._destinationTile.position.x + ", " + characterVO._destinationTile.position.y);
   				//NOTE:*** CAN BREAK HERE!!! What to do? Generate new path? Try/Catch Statement?
   				///characterVO._destinationTile.walkable = false;
   				//NOTE: *** probably need to broadcast something here so that any other avatars in the process
   				//of moving, that have this tile in its path, will create a new path using the nearest
   				//walkable tile as a destination
				characterVO._startPosition = characterVO._destinationTile.position;
				character = characterVO._box;
				if (ModelLocator.getInstance()._characterStyle == "animation"){
					stopWalking(character);
					trace("CharacterMovementController:::moveAlongPath::character.currentframe: " + character.currentframe);
					///character.removeEventListener(Event.ENTER_FRAME, onCharacterWalk);
				}
				currentIsoContainer.removeEventListener(Event.ENTER_FRAME, onCharacterMove);
				///_currentIsoContainer.removeEventListener(Event.ENTER_FRAME, onCharacterSlide);
   				pathNum = 0;
   				//NOTE: *** PROBLEM HERE - when multiple users are involved, get a duplicate userVars
   				//SOLUTION: only send userVars if this instance is for the main character!
   				if (userId == ModelLocator.getInstance()._mainCharacterId){
   					updateUserVars(characterVO._userName, characterVO._startPosition.x, characterVO._startPosition.z, characterVO._box.color);
   				}
   				characterVO._astar = null;
   				///this._pathsMap.remove(userId.toString());
   			}
		} */
		/** stop character movement on present tile. Called when an avatar leaves a room
		 *  if a character is still moving when they leave a room, bad stuff happens - 
		 *  eg, they can end up on a tile that doesn't exist in the new room */
		public function stopCharacter(userId:int):void{	
			//var currentRoomId:int = ModelLocator.getInstance()._currentRoomId();
			var currentRoomId:int = 1;
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(userId.toString()) as CharacterVO;	
			///var _astar:AStar = this._pathsMap.getValue(userId.toString()) as AStar;
			var _astar:AStar = characterVO._astar;
			var myTimer:Timer = this._timersMap.getValue(userId.toString()) as Timer;
			if (myTimer != null){
				stopTimer(myTimer, userId);
			}
			//NOTE: *** this probably needs work, error checking, making sure destinationTile/ _astar.path[currentPathNum] exist, etc.
			if (_astar != null){
				var currentPathNum:int = _astar._pathNum;
				var destinationTile:IsoObject;
				var character:MovieClip = characterVO._box;
				var currentIsoContainer:IsoObject = characterVO._isoContainer;
				if (ModelLocator.getInstance()._characterStyle == "animation"){
					character.removeEventListener(Event.ENTER_FRAME, onCharacterWalk);
					stopWalking(character);
				}
				///currentIsoContainer.removeEventListener(Event.ENTER_FRAME, onCharacterMove);
				
				destinationTile = _astar.path[currentPathNum]._owner as IsoObject;
	   			destinationTile.walkable = false;
				characterVO._startPosition = destinationTile.position;
	   			updateWorlds(characterVO);
			}
		}
		///NEED a hashmap, with userId as key, of previous, next and destination tiles to keep track of movement/walking
		/** moves the mainCharacter along the path derived by AStar
		 *  called repeatedly */
		private function moveAlongPath(e:TimerEvent):void{
		///private function moveAlongPath(userId:int, clickedTile:DrawnIsoTile):void{
			//NOTE:*** need to make the PREVIOUS destinationTile walkable, and the current one non-walkable
			var destinationTile:IsoObject;
			var userId:int = e.target.data as int;
			///var currentRoomId:int = ModelLocator.getInstance()._currentRoomId();
			var currentRoomId:int = 1;
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(userId.toString()) as CharacterVO;
			//NOTE:*** can cause a dialog box error if leave a room while moving - ERROR TRAP NEEDED!!!
			var _currentIsoContainer:IsoObject = characterVO._isoContainer;
			///var _astar:AStar = this._pathsMap.getValue(userId.toString()) as AStar;
			var _astar:AStar = characterVO._astar;
			var myTimer:Timer = e.target as Timer;
			if (_astar == null){
				stopTimer(myTimer, userId);
				return;
			}
			_astar._pathNum++;
			var pathNum:int = _astar._pathNum;
			var movementMethod:String = ModelLocator.getInstance()._movementMethod;
			
			var character:MovieClip = characterVO._box;
			if (pathNum < _astar.path.length){
				characterVO._currentTile = _astar.path[pathNum-1]._owner as IsoObject;
				characterVO._nextTile = _astar.path[pathNum]._owner as IsoObject;
				var cellSize:int = ModelLocator.getInstance()._cellSize;
				_xDiff = characterVO._nextTile.position.x - characterVO._currentTile.position.x;
				_zDiff = characterVO._nextTile.position.z - characterVO._currentTile.position.z;
				if (_xDiff != 0){
					_xDiff/cellSize;
				}
				if (_zDiff != 0){
					_zDiff/cellSize;
				}
				 trace("CharacterMovementController:::moveAlongPath::nextTile: " + characterVO._nextTile.position.x + ", " + characterVO._nextTile.position.y);
				 
				_currentIsoContainer.position = characterVO._nextTile.position;
				//TEST******************
				//NOTE***SOLUTION TO HEIGHTS - MUST OFFSET BY THE HEIGHT HERE
				//AND*** MUST OFFSET THE TILE CLICK - THAT'LL BE HARDER!
				///_currentIsoContainer.y -=20;
				updateWorlds(characterVO);
				if (ModelLocator.getInstance()._characterStyle == "animation"){
					characterWalk(character);
				}
				/* if (movementMethod == "fly"){
					//create parabolic movement
				}else if (movementMethod == "walk"){
					_currentIsoContainer.position = characterVO._nextTile.position;
					updateWorlds(characterVO);
					if (ModelLocator.getInstance()._characterStyle == "animation"){
						characterWalk(character);
					}
	   				///findPath(characterVO._nextTile, characterVO._destinationTile, userId);
				}else if (movementMethod == "transport"){
					fadeOut(characterVO, myTimer);
				} */
				//NOTE: *** positioning is incorrect when stacking on tiles with height
				///_mainCharacter.position.y = destinationTile.height;
   			}else{	
   				destinationTile = _astar.path[pathNum-1]._owner as IsoObject;
   				trace("CharacterMovementController:::moveAlongPath::destinationTile: " + destinationTile.position.x + ", " + destinationTile.position.y);
				characterVO._startPosition = destinationTile.position;
				if (ModelLocator.getInstance()._characterStyle == "animation"){
					stopWalking(character);
					trace("CharacterMovementController:::moveAlongPath::character.currentframe: " + character.currentframe);
					character.removeEventListener(Event.ENTER_FRAME, onCharacterWalk);
				}
   				updateWorlds(characterVO);
   				stopTimer(myTimer, userId);
   				characterVO._astar = null;
   				///this._pathsMap.remove(userId.toString());
   			}
		}

		/** called at the end of every move to a new tile, updates users' info on all world instances, then does z-sort*/
		private function updateWorlds(characterVO:CharacterVO):void{
			characterVO._currentTile.walkable = true;
			characterVO._nextTile.walkable = false;
			var mainUserId:int = ModelLocator.getInstance()._mainCharacterId;
			if (characterVO._netID == mainUserId){
   				updateUserVars(characterVO._userName, characterVO._startPosition.x, characterVO._startPosition.z, characterVO._box.color);
   			}
			_world.sort();
		}
		/** stop the timer and remove it from the list of timers - called when a move is complete*/
		private function stopTimer(myTimer:Timer, userId:int):void{
			myTimer.stop();
			this._timersMap.remove(userId.toString());
		}
		/** called when we are in transport mode - fades character out, then sets final position*/
		private function startTransport(characterVO:CharacterVO):void{
			Tweener.addTween(characterVO._isoContainer, {alpha:0.25, time:0.25, transition:"linear", onComplete:completeTransport, onCompleteParams:[characterVO]});
		}
		private function completeTransport(characterVO:CharacterVO):void{
			trace("CharacterMovementController:::completeTransport::characterVO._destinationPosition: " + characterVO._destinationPosition.x + ", " + characterVO._destinationPosition.z);
			characterVO._isoContainer.position = characterVO._destinationPosition;
			Tweener.addTween(characterVO._isoContainer, {alpha:1.0, time:0.25, transition:"linear"});
			updateWorlds(characterVO);
		}
		/** called when we are in transport mode - fades character out, then sets final position*/
		/* private function fadeOut(characterVO:CharacterVO, myTimer:Timer):void{
			Tweener.addTween(characterVO._isoContainer, {alpha:0, time:0.25, transition:"linear", onComplete:setFinalPosition, onCompleteParams:[characterVO, myTimer]});
		}
		private function setFinalPosition(characterVO:CharacterVO, myTimer:Timer):void{
			characterVO._isoContainer.position = characterVO._destinationPosition;
			updateWorlds(characterVO);
			stopTimer(myTimer, characterVO._netID);
			characterVO._astar = null;
	   		///this._pathsMap.remove(characterVO._netID.toString());
			Tweener.addTween(characterVO._isoContainer, {alpha:1, time:0.25, transition:"linear"});
		} */
		/** controls character's movement from tile to tile*/
		/* private function onCharacterMove(event:Event):void
		{
			var currentIsoContainer:IsoObject = event.target as IsoObject;
			//let's find the CharacterVO info for the current moving container
			var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map
			for each (var charVO:CharacterVO in currentUserSettingsMap.map){
				var isoContainer:IsoObject = charVO._isoContainer;
				if (isoContainer == currentIsoContainer){
					var characterVO:CharacterVO = charVO;
					break;
				}
			}
			if (characterVO == null){
				return;
			}
			var nextTilePosition:Point3D = characterVO._nextTile.position;
			if (currentIsoContainer.x != nextTilePosition.x){
				currentIsoContainer.x += currentIsoContainer.vx;
			}
			currentIsoContainer.y += currentIsoContainer.vy;
			if (currentIsoContainer.z != nextTilePosition.z){
				currentIsoContainer.z += currentIsoContainer.vz;
			}

			
			trace("CharacterMovementController:::onCharacterMove::currentIsoContainer.position: " +currentIsoContainer.x + ", " + +currentIsoContainer.z);
			trace("CharacterMovementController:::onCharacterMove::nextTilePosition.x: " + nextTilePosition.x + ", " +  nextTilePosition.z);
			if (currentIsoContainer.x == nextTilePosition.x && currentIsoContainer.z == nextTilePosition.z){
				trace("reached next tile");
				currentIsoContainer.removeEventListener(Event.ENTER_FRAME, onCharacterMove);
				_world.sort();
				if (characterVO._netID == ModelLocator.getInstance()._mainCharacterId){
   					updateUserVars(characterVO._userName, characterVO._startPosition.x, characterVO._startPosition.z, characterVO._box.color);
   				}
   				//NOTE: *** Move to next tile w/o drawing a new path
   				///moveAlongPath(characterVO);
				///findPath(characterVO._nextTile, characterVO._destinationTile, characterVO._netID);
			}
		} */
		private function characterWalk(character:MovieClip):void{
			character.addEventListener(Event.ENTER_FRAME, onCharacterWalk);
			
		}
		/** controls the character's walk cycle */
		private function onCharacterWalk(e:Event):void{ // control movement
			trace("CharacterMovementController:::onCharacterWalk");
			var character:MovieClip = e.target as MovieClip;
				// get movement from key controls
				///character.gotoAndStop(7); // starting frame of character
			var move:Object = {x:0, y:0}; // directions of movement
			var speed:int = 3; // speed of movement
			
			if (_xDiff || _zDiff){ // if being moved in any direction
				// find frame, start at least on frame 9 (where movement clips are)
				// then find an angle from the keys being pressed (Math.atan2), divide this by
				// 8 directions (Math.PI/4) and make sure the value remains between 0-7 (%8)
				///var frame:int = 9 + Math.floor((Math.PI + Math.atan2(move.y, move.x))/(Math.PI/4))%8;
				var direction:int = Math.floor((Math.PI + Math.atan2(_zDiff, _xDiff))/(Math.PI/4))%8;
				trace("CharacterMovementController:::onCharacterWalk::direction: " + direction);
				var frame:int = 10 + direction;
				///var head:DisplayObject = character.removeChildAt(1);
				trace("CharacterMovementController:::onCharacterWalk::frame: " + frame);
				//NOTE:*** HACK - no frame 17 in my test movie - frame 9 should actually be direction 0, but it is direction 7
				//everything is off by 1...hmmm...
				if (frame == 17){ 
					frame = 9;
				}
				if (character.currentframe != frame){
					character.gotoAndStop(frame); // go to frame if not there already
					//character.gotoAndStop("down"); // go to frame if not there already
				} 
				
				trace("CharacterMovementController:::onCharacterWalk::character.currentframe: " + character.currentframe);
				
				
				
			}else if (character.currentframe > 8){ // if not being moved and on an animation frame
				character.gotoAndStop(character.currentframe - 8); // step back to the standing version of that frame
			}
			character.removeEventListener(Event.ENTER_FRAME, onCharacterWalk);
		}
		private function stopWalking(character:MovieClip):void{
			trace("CharacterMovementController:::stopWalking::character.currentframe: " + character.currentframe);
			var frame:int = 10 + Math.floor((Math.PI + Math.atan2(_zDiff, _xDiff))/(Math.PI/4))%8;
			if (frame == 17) frame = 9;
			//NOTE:*** for some reason, NOT getting a readout of character.currentFrame
			///if (character.currentframe > 8){ // if not being moved and on an animation frame
				character.gotoAndStop(frame - 8); // step back to the standing version of that frame */
			///}
		}
		private function updateUserVars(userName:String, xPos:Number, zPos:Number, color:uint):void{
			var uVars:Object = new Object()
	 		uVars.myAvatar = userName;
	 		uVars.x = xPos;
			uVars.z = zPos;
	 		uVars.boxColor = color;
	 		dispatchEvent(new DataEvent(DataEvent.UPDATE_USER_VARS, uVars));
			///_server.smartFox.setUserVariables(uVars);
		}
		/**
		 * Highlights all nodes that have been visited. For testing.
		 */
		private function showVisited(astar:AStar):void
		{
			var visited:Array = astar.visited;
			for(var i:int = 0; i < visited.length; i++)
			{
				///var tile:DrawnIsoTile = visited[i]._owner as DrawnIsoTile;
				///tile.draw(0xffcc00);
			}
		}
		
		/**
		 * Highlights the found path. For testing.
		 */
		private function showPath(astar:AStar):void
		{
			var path:Array = astar.path;
			for(var i:int = 0; i < path.length; i++)
			{
				////var tile:DrawnIsoTile = path[i]._owner as DrawnIsoTile;
				///tile.draw(0x00ccff);
			}
		}
		/**
		 * Finds the next node on the path and eases to it.
		 */
		/* private function onEnterFrame(event:Event):void
		{
			var destinationTile:DrawnIsoTile;
			var userId:String = e.target.data.toString();
			var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(userId) as CharacterVO;
			var _currentWalker:IsoObject = characterVO._box;
			var _astar:AStar = this._pathsMap.getValue(e.target.data.toString()) as AStar;
			//NOTE: *** _pathNum should probably be stored elsewhere...
			_astar._pathNum++;
			var pathNum:int = _astar._pathNum;
			
			
			if (pathNum < _astar.path.length){
				 destinationTile = _astar.path[pathNum]._owner as DrawnIsoTile;
				 //attempt to make avatars "respect" each other
				 //NOTE:*** need to make the PREVIOUS destinationTile walkable, and the current one non-walkable
				/// destinationTile.walkable = false;
				removeChildFromWorld(_currentWalker);
				//_world.removeChild(_currentWalker);
				addChildToWorld(_currentWalker);
				
				///_world.addChild(_currentWalker);
				//NOTE:depth not working!
				this.sort();
				_currentWalker.position = destinationTile.position;
				//NOTE: *** positioning is incorrect when stacking on tiles with height
				///_mainCharacter.position.y = destinationTile.height;
				
   			}else{
   				destinationTile = _astar.path[pathNum-1]._owner as DrawnIsoTile;
   				//NOTE:*** CAN BREAK HERE!!! What to do? Generate new path? Try/Catch Statement?
   				destinationTile.walkable = false;
   				//NOTE: *** probably need to broadcast something here so that any other avatars in the process
   				//of moving, that have this tile in its path, will create a new path using the nearest
   				//walkable tile as a destination
				characterVO._startPosition = destinationTile.position;
   				pathNum = 0;
   				//NOTE: *** PROBLEM HERE - when multiple users are involved, get a duplicate userVars
   				//SOLUTION: only send userVars if this instance is for the main character!
   				if (userId == this._mainUserId.toString()){
   					updateUserVars(characterVO._userName, characterVO._startPosition.x, characterVO._startPosition.z, characterVO._box.color);
   				}
   			} */
			
			
		/* 	var targetX:Number = _path[_index].x * _cellSize + _cellSize / 2;
			var targetY:Number = _path[_index].y * _cellSize + _cellSize / 2;
			var dx:Number = targetX - _player.x;
			var dy:Number = targetY - _player.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			if(dist < 1)
			{
				_index++;
				if(_index >= _path.length)
				{
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
			else
			{
				_player.x += dx * .5;
				_player.y += dy * .5;
			}
		} */
			
		/* private function onKeyDown(event:KeyboardEvent):void
		{
			var userId:int = e.target.data as int;
			var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(userId.toString()) as CharacterVO;
			var box:IsoObject = characterVO._box;
			
			switch(event.keyCode)
			{
				case Keyboard.UP :
				box.vx = -speed;
				box.vz = -speed;
				break;
				
				case Keyboard.DOWN :
				box.vx = speed;
				box.vz = speed;
				break;
				
				case Keyboard.LEFT :
				box.vz = speed;
				break;
				
				case Keyboard.RIGHT :
				box.vz = -speed;
				break;
				
				default :
				break;
				
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		} */
		
		/* private function onKeyUp(event:KeyboardEvent):void
		{
			var userId:int = e.target.data as int;
			var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(userId.toString()) as CharacterVO;
			var box:IsoObject = characterVO._box;
			
			box.vx = 0;
			box.vz = 0;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		} */
		
		/* private function onEnterFrame(event:Event):void
		{
			var userId:int = e.target.data as int;
			var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(userId.toString()) as CharacterVO;
			var box:IsoObject = characterVO._box;
			box.x += box.vx;
			box.y += box.vy;
			box.z += box.vz;
		} */
		/** immediately positions the box on the tile clicked on */
		/* private function onWorldClick(event:MouseEvent):void {
			//var box:DrawnIsoBox = new DrawnIsoBox(20, Math.random() * 0xffffff, 20);
			var pos:Point3D = IsoUtils.screenToIso(new Point(isoWorld.mouseX, isoWorld.mouseY));
			pos.x = Math.round(pos.x / 20) * 20;
			pos.y = Math.round(pos.y / 20) * 20;
			pos.z = Math.round(pos.z / 20) * 20;
			box.position = pos;
			isoWorld.addChild(box);
			//objectList.push(box);
			//sortList();
		} */
	}
}