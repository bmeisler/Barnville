package com.evili.worldBuilder.controllers {
	
	import com.evili.utils.Map;
	import com.evili.worldBuilder.events.ClickedTileEvent;
	import com.evili.worldBuilder.events.UserEvent;
	import com.evili.worldBuilder.model.CharacterVO;
	import com.evili.worldBuilder.model.ModelLocator;
	import com.evili.worldBuilder.model.User;
	import com.evili.worldBuilder.modules.TextBubbleController;
	import com.friendsofed.isometric.IsoUtils;
	import com.friendsofed.isometric.IsoWorld;
	import com.friendsofed.isometric.Point3D;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	public class MessageController {
		/** can show multiple text bubbles simultaensously with multiple tbcontrollers*/
		public var tbController:TextBubbleController;
		public var spamTbController:TextBubbleController;
		public var statusTbController:TextBubbleController;
		public var genericTbController:TextBubbleController;
		///private var _shell:Shell;
		
		public function MessageController() {
			///_shell = shell;
		}
		public function createTextBubbleController(isoWorld:IsoWorld, world:Sprite):void{
			this.tbController = new TextBubbleController(world);
			this.spamTbController = new TextBubbleController(world);
			this.genericTbController = new TextBubbleController(world);
			this.statusTbController = new TextBubbleController(world);
			this.setBordersForTextBubbleController(isoWorld, 350, 15, 900, 600);
		}
		/**
		 * @param x 
		 * @param y 
		 * @param width 
		 * @param height 
		 */	
		private function setBordersForTextBubbleController(isoWorld:IsoWorld, x:Number, y:Number, width:Number, height:Number):void{
			var p:Point = new Point(x, y);		
			isoWorld.localToGlobal(p);
			this.tbController.setBorders( p.x, p.y, width, height );
			this.spamTbController.setBorders( p.x, p.y, width, height );
			this.statusTbController.setBorders( p.x, p.y, width, height );
			this.genericTbController.setBorders( p.x, p.y, width, height );
		}
		/** receives private messages sent by another user and prints them
		 */
		 public function onReceivedPrivateMessage(e:UserEvent):void{
		 	var msg:String = e._msg as String;
		 	var sender:User= e._user as User;
		 	var senderName:String = sender.getName();
		 	///_shell._messageLabel.appendText(senderName + " sends private message: \n" + msg + "\n");
		 	//tbController.characterSay(_server._sender.getId(), this.box.x, this.box.y - this.box.height, _server._msgText);
		 }
		 /** receives public messages sent by another user and prints them
		 *   as text balloons
		 */
		 public function onReceivedPublicMessage(e:UserEvent):void{
		 	var msg:String = e._msg as String;
		 	var sender:User= e._user as User;
		 	var senderName:String = sender.getName();
		 	///var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentRoomId:int = ModelLocator.getInstance()._currentRoomId;
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(sender.getId().toString()) as CharacterVO;
		 	var screenPoint:Point = IsoUtils.isoToScreen(characterVO._isoContainer.position);
			tbController.characterSay(characterVO._isoContainer, sender.getId(), screenPoint.x, screenPoint.y - characterVO._isoContainer.height, msg);
		 }
		/** this avatar "said" something, either public or private - show text bubble!*/
		public function onSentPublicMessage(e:UserEvent):void{
			var msg:String = e._msg as String;
		 	var sender:User= e._user as User;
		 	var senderName:String = sender.getName();
		 	///var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentRoomId:int = ModelLocator.getInstance()._currentRoomId;
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(sender.getId().toString()) as CharacterVO;
			var screenPoint:Point = IsoUtils.isoToScreen(characterVO._isoContainer.position);
			tbController.characterSay(characterVO._isoContainer, sender.getId(), screenPoint.x, screenPoint.y - characterVO._isoContainer.height, msg);
		}
		/** the system is "saying" something, show text bubble centered on screen*/
		public function onSentSpamMessage(e:UserEvent):void{
			var msg:String = e._msg as String;
			var sender:User= e._user as User;
			var senderName:String = sender.getName();
			///var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentRoomId:int = ModelLocator.getInstance()._currentRoomId;
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(sender.getId().toString()) as CharacterVO;
			var screenPoint:Point = IsoUtils.isoToScreen(characterVO._isoContainer.position);
			//NOTE: 400, 300 should be center of screen
			var initObj:Object = new Object();
			initObj.color = 0x0000cc;
			initObj.selectable = false;
			initObj.autoSize = "center";
			initObj.wordWrap = true;
			initObj.multiline = true;
			
			initObj.textColor = 0x000000;
			initObj.borderColor = 0x00ff00;
			initObj.htmlText1 = "<p align='center'><font face=\"Verdana\" size=\"16\">";
			initObj.htmlText2 = "</font></p>";
			spamTbController.systemSay(characterVO._isoContainer, sender.getId(), 400, 300, msg, initObj);
			///tbController.systemSay(characterVO._isoContainer, sender.getId(), screenPoint.x, screenPoint.y, msg);
		}
		/** the system is "saying" something, show text bubble centered on screen*/
		public function onSentGenericMessage(e:UserEvent):void{
			var msg:String = e._msg as String;
			var sender:User= e._user as User;
			var senderName:String = sender.getName();
			///var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentRoomId:int = ModelLocator.getInstance()._currentRoomId;
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(sender.getId().toString()) as CharacterVO;
			var screenPoint:Point = IsoUtils.isoToScreen(characterVO._isoContainer.position);
			//NOTE: 400, 300 should be center of screen
			var initObj:Object = new Object();
			initObj.color = 0x00ff00;
			initObj.selectable = false;
			initObj.autoSize = "center";
			initObj.wordWrap = true;
			initObj.multiline = true;
			
			///initObj.textColor = 0x00ffff;
			initObj.textColor = 0x000000;
			initObj.htmlText1 = "<p align='center'><font face=\"Verdana\" size=\"14\">";
			initObj.htmlText2 = "</font></p>";
			//tbController.systemSay(characterVO._isoContainer, sender.getId(), 400, 300, msg, initObj);
			///move message to lower left hand of screen
			///tbController.systemSay(characterVO._isoContainer, sender.getId(), 10, 450, msg, initObj);
			genericTbController.systemSay(characterVO._isoContainer, sender.getId(), 10, 450, msg, initObj);
			///tbController.systemSay(characterVO._isoContainer, sender.getId(), screenPoint.x, screenPoint.y, msg);
		}
		/** the system is showing a status message, lower left hand side of screen*/
		public function onSentStatusMessage(e:UserEvent):void{
			var msg:String = e._msg as String;
			var sender:User= e._user as User;
			var senderName:String = sender.getName();
			///var currentRoomId:int = ModelLocator.getInstance()._currentRoom.getId();
			var currentRoomId:int = ModelLocator.getInstance()._currentRoomId;
			var currentUserSettingsMap:Map = ModelLocator.getInstance()._currentRoomUserSettingsMap.getValue(currentRoomId.toString()) as Map;
			var characterVO:CharacterVO = currentUserSettingsMap.getValue(sender.getId().toString()) as CharacterVO;
			var screenPoint:Point = IsoUtils.isoToScreen(characterVO._isoContainer.position);
			//NOTE: 400, 300 should be center of screen
			var initObj:Object = new Object();
			initObj.color = 0x00ff00;
			initObj.selectable = false;
			initObj.autoSize = "center";
			initObj.wordWrap = true;
			initObj.multiline = true;
			
			///initObj.textColor = 0x00ffff;
			initObj.textColor = 0x000000;
			initObj.borderColor = 0xff0000;
			initObj.htmlText1 = "<p align='center'><font face=\"Verdana\" size=\"14\">";
			initObj.htmlText2 = "</font></p>";
			//tbController.systemSay(characterVO._isoContainer, sender.getId(), 400, 300, msg, initObj);
			///move message to lower left hand of screen
			///tbController.systemSay(characterVO._isoContainer, sender.getId(), 10, 450, msg, initObj);
			statusTbController.systemSay(characterVO._isoContainer, sender.getId(), 100, 450, msg, initObj);
			///tbController.systemSay(characterVO._isoContainer, sender.getId(), screenPoint.x, screenPoint.y, msg);
		}
		/** the system is "saying" something, show text bubble centered on screen*/
		public function onSentContentMessage(e:ClickedTileEvent, msg:String):void{
			
			
			var screen3dPoint:Point3D = e.destinationPosition;
			var screenPoint:Point = IsoUtils.isoToScreen(screen3dPoint);
			//NOTE: 400, 300 should be center of screen
			var initObj:Object = new Object();
			initObj.color = 0xff0000;
			initObj.selectable = false;
			initObj.autoSize = "center";
			initObj.wordWrap = true;
			initObj.multiline = true;
			
			initObj.textColor = 0xff0000;
			initObj.borderColor = 0x00cc00;
			initObj.htmlText1 = "<p align='center'><font face=\"Verdana\" size=\"12\">";
			initObj.htmlText2 = "</font></p>";
			tbController.systemSay(null, ModelLocator.getInstance()._mainCharacterId, screenPoint.x+400, screenPoint.y, msg, initObj);
			///tbController.systemSay(characterVO._isoContainer, sender.getId(), screenPoint.x, screenPoint.y, msg);
		}
		
	}
}