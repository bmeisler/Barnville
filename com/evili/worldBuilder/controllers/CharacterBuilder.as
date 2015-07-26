package com.evili.worldBuilder.controllers
{
	import com.evili.utils.ColorHelper;
	import com.evili.utils.Map;
	import com.evili.utils.NumberHelper;
	import com.evili.worldBuilder.model.CharacterVO;
	import com.evili.worldBuilder.model.ModelLocator;
	import com.evili.worldBuilder.modules.LabelMaker;
	//import com.evili.worldBuilder.server.Server;
	import com.friendsofed.isometric.DrawnIsoBox;
	import com.friendsofed.isometric.IsoObject;
	import com.friendsofed.isometric.IsoWorld;
	import com.friendsofed.isometric.Point3D;
	
	import com.evili.worldBuilder.model.User;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	//import it.gotoandplay.smartfoxserver.data.User;

	public class CharacterBuilder extends EventDispatcher
	{
		//private var _server:Server
		/** controls adding avatars, tiles, avatar movemement, etc. Manages the world */
		private var _isoWorld:IsoWorld;
		//used for movement, should be in ModelLocator
		private var speed:Number = 20;
		
		//used to keep track of which user's avatar we're trying to place in the world
		private var _currentUser:User;
		
		//retrieved from SFServerClient
		public var _myUserId:int;
		public var _myUserName:String
		//set by color chooser
		private var _myUserColor:uint;

		
		///private var _debugModule:DebugModule;
		
		public function CharacterBuilder(currentUser:User,  isoWorld:IsoWorld, myUserId:int, myUserName:String, myUserColor:uint)
		{
			_currentUser = currentUser;
			
			_isoWorld = isoWorld
			_myUserId = myUserId;
			_myUserName = myUserName;
			///_myUserColor = ModelLocator.getInstance()._myUserColor;
			_myUserColor = myUserColor;
			
			
		}
		/** We need to draw (and add to the world view, eg the grid) every user's
		 *  character/avatar that is not *already* on the grid. We test this by keeping track of local
		 *  user's characters via a Map stored in the ModelLocator, currentUserSettingsMap
		 *  There is a separate currentUserSettingsMap for every room
		 */
		public function addAllCharacters():void{
			/*
			var userList:Array = _server._userList as Array;
			var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			for each(var user:User in userList){
				//NOTE: *** Fix this - shouldn't have to store this as a proprty variable
				_currentUser = user;
				var userName:String = user.getName();
				var userId:int = user.getId();
				var characterVO:CharacterVO = currentUserSettingsMap.getValue(userId.toString()) as CharacterVO;
				if (characterVO == null){
					addCharacter(user);
				}
			} 
			*/
			addCharacter(_currentUser);
		}
		
		/** used to add a single character, as they enter the room */
		public function addCharacter(user:User):void{
			//NOTE: *** Fix this - shouldn't have to store this as a proprty variable
			_currentUser = user;
			var boxColor:uint;
			var startTile:IsoObject;
			var boxPosition:Point3D;
			var randomTile:IsoObject
			///var userVariables:Array = user.getVariables();
			trace("CharacterBuilder:::addCharacter::_myUserColor: " + _myUserColor);
			//main character has not been added yet to any room,- add it to a random position!
			//if ((user.getName() == _myUserName) && (userVariables.boxColor == null)){
				while (randomTile == null){
					randomTile = _isoWorld._grid.getRandomWalkableTile();
				}
				boxPosition = randomTile.position;
				if (_myUserColor != 0){
					boxColor = _myUserColor;
				}else{
					boxColor = ColorHelper.getRandomColor(NumberHelper.randomRange(255), NumberHelper.randomRange(255), NumberHelper.randomRange(255));
				}
				createCharacter(randomTile, boxPosition, boxColor, user);
				///setUserVars(user.getName(), boxPosition.x, boxPosition.z, boxColor, _server._currentRoom.getId());
			//load other characters in room, or re-load main character in a different room
			//main character has not yet been added to THIS room - add it to a random position
		
		/*}else if ((user.getName() == _myUserName) && userVariables.roomId != _server._currentRoom.getId()){
				while (randomTile == null){
					randomTile = _isoWorld._grid.getRandomWalkableTile();
				}
				boxPosition = randomTile.position;
				if (userVariables.boxColor != null){
					boxColor = userVariables.boxColor;
				}else{
					boxColor = ColorHelper.getRandomColor(NumberHelper.randomRange(255), NumberHelper.randomRange(255), NumberHelper.randomRange(255));
				}
				createCharacter(randomTile, boxPosition, boxColor, user);
				setUserVars(user.getName(), boxPosition.x, boxPosition.z, boxColor, _server._currentRoom.getId());
			}else {
				//other character has not been added anywhere yet - wait for him to be added in his own view
				if (userVariables.boxColor == null){
					_isoWorld.addEventListener(Event.ENTER_FRAME, onCheckCharacterStatus);
				//other character has not been added to this room yet
				}else if (userVariables.roomId != _server._currentRoom.getId()){
					_isoWorld.addEventListener(Event.ENTER_FRAME, onCheckRoomStatus);
				}else{
					boxPosition = new Point3D(userVariables.x, 0, userVariables.z);
					boxColor = userVariables.boxColor;
					startTile = _isoWorld._grid.findTile(boxPosition);
					createCharacter(startTile, boxPosition, boxColor, user);
				}
			}
				*/
		}
		/** creates a character - a DrawnIsoBox, or could be any sprite - and assigns it a random tile as
		 *  its initial position, a color, saves info about its name, etc */
		private function createCharacter(tile:IsoObject, position:Point3D, color:int, user:User):void{
			var _cellSize:Number = ModelLocator.getInstance()._cellSize;
			var boxPosition:Point3D = position;
			var boxColor:uint = color;
			var startTile:IsoObject = tile;
			//attempt to make avatars "respect" each other
			startTile.walkable = false;
			var userName:String = user.getName();
			var userID:int = user.getId();
			var characterStyle:String = ModelLocator.getInstance()._characterStyle;
			var box:MovieClip;
			if (characterStyle == "box"){
				box = new DrawnIsoBox(_cellSize, boxColor, 20);
			}else if (characterStyle == "animation"){
				box = new AnimatedCharacter();
				///box.scaleX = 0.5;
				///box.scaleY = 0.5;
				box.scaleX = 1.5;
				box.scaleY = 1.5;
				box.gotoAndStop("down");
				//NOTE:*** temp hack to show avatar color
				/* var head:MovieClip = new MovieClip();
				trace("CharacterBuilder:::createCharacter::boxColor: " + boxColor);
				head.graphics.beginFill(boxColor);
				head.graphics.drawCircle(0, 0, 19);
				head.graphics.endFill();
				box.addChild(head);
				
				head.y = -66; */
			}
			var isoContainer:IsoObject = new IsoObject(_cellSize);
			isoContainer.position = boxPosition;
			isoContainer.addChild(box);
			//HACK to position current "walker" - farmerboy
			box.x-= 10;
			box.y +=5;
			if (ModelLocator.getInstance()._showCharacterName == true){
				var labelMaker:LabelMaker = new LabelMaker(userName);
				var labelContainer:Sprite = labelMaker.makeLabel();
				isoContainer.addChild(labelContainer);
			}
			//save local data in value object
			var characterVO:CharacterVO = new CharacterVO();
			characterVO._box = box;
			characterVO._isoContainer = isoContainer;
			characterVO._userName = user.getName();
			characterVO._netID = user.getId();
			characterVO._startPosition = boxPosition;
			if (user.getName() == _myUserName){
				characterVO._isMain = true;
				_isoWorld.addMainCharacterToWorld(isoContainer, user.getId());
				///_debugModule.showDebugMsg("added main character for user " + user.getName() + " to the world at position: " + box.position.x + ", " + box.position.z + "\n");
				////_debugModule.showDebugMsg("added main character for user " + user.getName() + " to the world at position: " + isoContainer.position.x + ", " + isoContainer.position.z + "\n");
			}else{
				characterVO._isMain = false;
				_isoWorld.addChildToWorld(isoContainer);
				///_debugModule.showDebugMsg("added " + user.getName() + "'s character to the world at position: " + box.position.x + ", " + box.position.z + "\n");
				///_debugModule.showDebugMsg("added main character for user " + user.getName() + " to the world at position: " + isoContainer.position.x + ", " + isoContainer.position.z + "\n");
			}
			///var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentRoomId:int = ModelLocator.getInstance()._currentRoomId;
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			currentUserSettingsMap.put(userID.toString(), characterVO);
		} 
		/** saves info about the current user's avatar on the server. Need this info
		 *  to properly redraw other user's characters/avatars in your view */
		private function setUserVars(userName:String, xPos:Number, zPos:Number, color:uint, roomId:int):void{
			var uVars:Object = new Object()
	 		uVars.myAvatar = userName;
	 		uVars.x = xPos;
			uVars.z = zPos;
	 		uVars.boxColor = color;
	 		uVars.roomId = roomId;
			///_server.smartFox.setUserVariables(uVars);
		}
		/** used to remove a single character, as they leave the room */
		public function removeCharacter(userID:int, userName:String):void{
			///var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentRoomId:int = ModelLocator.getInstance()._currentRoomId;
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(userID.toString()) as CharacterVO;
			//NOTE:*** CAUSING PROBLEMS WITH ROOM SWITCHING!!!
			//BREAKS if a user logs out!!!
			///if (characterVO != null){
				//isoWorld.removeChildFromWorld(characterVO._box);
				//NOTE: *** breaking here with xml - need to add new rooms to map
				_isoWorld.removeChildFromWorld(characterVO._isoContainer);
				currentUserSettingsMap.remove(userID.toString());
				///_debugModule.showDebugMsg("Removed user " + userName + " from the world and the settings array");
			///}else{
				///_debugModule.showDebugMsg("User " + userName + " was previously removed from the world and the settings array");
			///}
		}
		/** called when a User does not have userVars set yet - we wait until it's loaded
		 *  before we try to draw the character onscreen
		 */
		private function onCheckCharacterStatus(e:Event):void{
			trace("Main:::onCheckCharacterStatus::checking...");
			var userVars:Array = _currentUser.getVariables();
			if (userVars.boxColor != null){
				_isoWorld.removeEventListener(Event.ENTER_FRAME, onCheckCharacterStatus);
				addCharacter(_currentUser);
			}
		}
		/** called when a user has not been added to the room yet
		 *  wait until the roomId has been set before drawing the avatar
		 */
		private function onCheckRoomStatus(e:Event):void{
			trace("Main:::onCheckRoomStatus::checking...");
			var userVars:Array = _currentUser.getVariables();
			///if (userVars.roomId == _server._currentRoom.getId()){
				///_isoWorld.removeEventListener(Event.ENTER_FRAME, onCheckRoomStatus);
				///addCharacter(_currentUser);
			///}
		}
	}
}