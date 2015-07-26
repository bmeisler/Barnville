package com.evili.worldBuilder.controllers
{
	import com.evili.utils.JSAlert;
	import com.evili.utils.SoundPlayer;
	import com.evili.worldBuilder.Commands.*;
	import com.evili.worldBuilder.controllers.TileController;
	import com.evili.worldBuilder.controllers.TileManager;
	import com.evili.worldBuilder.model.GridVO;
	import com.evili.worldBuilder.model.ItemVO;
	import com.evili.worldBuilder.model.ModelLocator;
	import com.evili.worldBuilder.model.TileVO;
	import com.friendsofed.isometric.*;
	import com.friendsofed.pathfinding.Grid;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	

	public class ActionsController extends EventDispatcher
	{
		
		private var _vehicleBoard:Sprite;
		private var _tilePopupContainer:Sprite;
		private var _grid:Grid;
		private var _gridVO:GridVO;
		private var _isoWorld:IsoWorld;
		private var _clickedTile;
		private var _clickedPosition:Point3D;
		/** what kind of item did we click on to open this popup box? A chicken? A barn? Corn?*/
		private var _clickedItemVO:ItemVO;
		private var popupPosition:Point3D;
		/** the controller that calls this, that we speak back to - should use event handler instead!*/
		private var _tileController:TileController

		//public function ActionsController (gridVO, grid, isoWorld,clickedTile:IsoObject, clickedPosition:Point3D)
		public function ActionsController (gridVO, grid, isoWorld, tileController)
		{
			///_tilePopupContainer = tilePopupContainer;
			_gridVO = gridVO;
			_grid = grid;
			_isoWorld = isoWorld;
			//_clickedTile = clickedTile;
			//_clickedPosition = clickedPosition;
			ModelLocator.getInstance()._isActionsMenuOpen = true;
			_tileController = tileController;
			
		}
		private function createPopupContainer(width:Number):void{
			if (_tilePopupContainer != null){
				kill();
			}
			_tilePopupContainer = new Sprite();
			_tilePopupContainer.graphics.lineStyle(3, 0xeeeeee, 1);
			_tilePopupContainer.graphics.beginFill(0xffffff, 1);
			_tilePopupContainer.graphics.drawRoundRect(0, 0, width, 60, 15, 15);
			_tilePopupContainer.graphics.endFill();
			
			var circle:Sprite = new Sprite();
			circle.graphics.lineStyle(3, 0xeeeeee, 1);
			circle.graphics.beginFill(0x006633, 1);
			circle.graphics.drawCircle(0, 0, 10);
			circle.graphics.endFill();
			_tilePopupContainer.addChild(circle);
			var x:TextField = new TextField();
			x.text = "X";
			var xFormat:TextFormat = new TextFormat("Verdana", 18, 0xff0000, true);
			x.setTextFormat(xFormat);
			circle.addChild(x);
			x.x = -9;
			x.y = -12;
			x.selectable = false;
			circle.addEventListener(MouseEvent.CLICK, ignore);
			
			
			var screenPoint:Point = IsoUtils.isoToScreen(_clickedPosition);
			
			///_tilePopupContainer.x -= ModelLocator.getInstance()._worldContainerWidth/2;
			///_tilePopupContainer.x += _tilePopupContainer.width;
			if (screenPoint.y <= 40){
				_tilePopupContainer.y = screenPoint.y + 10;
			}else{
				_tilePopupContainer.y = screenPoint.y - _tilePopupContainer.height;
			}
			if (screenPoint.x + _tilePopupContainer.width > 380){
				_tilePopupContainer.x = 380-_tilePopupContainer.width;
			}else{
				_tilePopupContainer.x = screenPoint.x;
			}
			trace("_tilePopupContainer.x: " + _tilePopupContainer.x);
			trace("screenPoint.x: " + screenPoint.x);
			trace("_tilePopupContainer.width: " + _tilePopupContainer.width);
			
			_isoWorld.addChild(_tilePopupContainer);
			
			dispatchEvent(new Event("RemovePopup"));
			
		}
		public function addBuildingActionsMenu(clickedItemVO:ItemVO, clickedTile:IsoObject, clickedPosition:Point3D):void{
			_clickedTile = clickedTile;
			_clickedPosition = clickedPosition;
			var itemList:Array = new Array();
			var itemsArray:Array = ModelLocator.getInstance()._itemsArray;
			var vehiclesArray:Array = itemsArray[3];
			var width:Number = 50 * vehiclesArray.length;
			createPopupContainer(width);
			for (var i:uint=0; i<vehiclesArray.length; i++){
				var currentItemVO:ItemVO = new ItemVO(vehiclesArray[i]);
				var currentName:String = currentItemVO._itemName;
				itemList.push(currentName);
				var currentClass:Class = getDefinitionByName(currentName) as Class;
				var icon_mc:MovieClip = new currentClass() as MovieClip;
				_tilePopupContainer.addChild(icon_mc);
				icon_mc.x = 15 + (i *35);
				icon_mc.y = 10;
				icon_mc.addEventListener(MouseEvent.CLICK, handleClick);
			}
		}
		public function addAnimalActionsMenu(clickedItemVO:ItemVO, clickedTile:IsoObject, clickedPosition:Point3D):void{
			_clickedTile = clickedTile;
			_clickedPosition = clickedPosition;
			
			var tileID:int = clickedTile._node._id;
			var floorData:Array = _gridVO._floorData;
			var tileVO:TileVO = floorData[tileID];
			var isGrown:Boolean = tileVO._grown;
			var isLoved:Boolean = tileVO._isLoved;
			
			
			var harvestable:Boolean = clickedItemVO._isHarvestable;
			var itemList:Array = new Array();;
			var itemsArray:Array = ModelLocator.getInstance()._itemsArray;
			var vehiclesArray:Array = itemsArray[4];
			var width:Number = 50 * vehiclesArray.length;
			createPopupContainer(width);
			for (var i:uint=0; i<vehiclesArray.length; i++){
				var currentItemVO:ItemVO = new ItemVO(vehiclesArray[i]);
				var currentName:String = currentItemVO._itemName;
				itemList.push(currentName);
				var currentClass:Class = getDefinitionByName(currentName) as Class;
				var icon_mc:MovieClip = new currentClass() as MovieClip;
				_tilePopupContainer.addChild(icon_mc);
				icon_mc.x = 15 + (i *50);
				icon_mc.y = 15;
				if (currentName == "PickupTruck" && harvestable == false){
					icon_mc.alpha = 0.2;
				}else if (currentName == "PickupTruck" && isGrown == false){
					icon_mc.alpha = 0.2;
				}else if (currentName == "Bulldozer" && clickedItemVO._itemName != "Rattlesnake"){
					icon_mc.alpha = 0.2;
				}else if (currentName == "CashRegister" && isGrown == true){
					icon_mc.alpha = 0.2;
				}else if (currentName == "HandMove" && isGrown == true){
					icon_mc.alpha = 0.2;
				}else if (currentName == "Love" && isLoved == true){
					icon_mc.alpha = 0.2;
				}else if (currentName == "Love" && isGrown == true){
					icon_mc.alpha = 0.2;
				}else{
					icon_mc.addEventListener(MouseEvent.CLICK, handleClick);
				}
			}
		}
		public function addCropsActionsMenu(clickedItemVO:ItemVO, clickedTile:IsoObject, clickedPosition:Point3D):void{
			_clickedTile = clickedTile;
			_clickedPosition = clickedPosition;
			
			var tileID:int = clickedTile._node._id;
			var floorData:Array = _gridVO._floorData;
			var tileVO:TileVO = floorData[tileID];
			
			var harvestable:Boolean = clickedItemVO._isHarvestable;
			var itemList:Array = new Array();;
			var itemsArray:Array = ModelLocator.getInstance()._itemsArray;
			var actionIconsArray:Array = itemsArray[5];
			var width:Number = 70 * actionIconsArray.length;
			createPopupContainer(width);
			for (var i:uint=0; i<actionIconsArray.length; i++){
				var currentItemVO:ItemVO = new ItemVO(actionIconsArray[i]);
				var currentName:String = currentItemVO._itemName;
				itemList.push(currentName);
				var currentClass:Class = getDefinitionByName(currentName) as Class;
				var icon_mc:MovieClip = new currentClass() as MovieClip;
				_tilePopupContainer.addChild(icon_mc);
				icon_mc.x = 15 + (i *50);
				icon_mc.y = 10;
				if (currentName == "PickupTruck" && harvestable == false){
					icon_mc.alpha = 0.2;
				}else if (currentName == "WateringCan" && tileVO._grown == true){
					icon_mc.alpha = 0.2;
				}else if (currentName == "WateringCan" && tileVO._isFed == true){
					icon_mc.alpha = 0.2;
				}else if (currentName == "Manure" && tileVO._isFed == false){
					icon_mc.alpha = 0.2;
				}else if (currentName == "Tractor" && tileVO._grown == true){
					icon_mc.alpha = 0.2;
				}else{
					icon_mc.addEventListener(MouseEvent.CLICK, handleClick);
				}
			}
		}
		private function handleClick(e:Event):void
		{
			//trace(menu.clickedItem);
			var selectedIcon:MovieClip = e.currentTarget as MovieClip;
			e.stopPropagation();
			
			//ModelLocator.getInstance()._selectedItemVO = null;
			//ModelLocator.getInstance()._destroyMode = false;
			
			selectedIcon.removeEventListener(MouseEvent.CLICK, handleClick);
			var className:String = flash.utils.getQualifiedClassName( selectedIcon );
			//JSAlert.showAlert("selected " + className + " icon");
			
			var currentItemVO:ItemVO = TileManager.getCurrentItemVO(className);
			///ModelLocator.getInstance()._selectedItemVO = currentItemVO;
			
			var classRef:Class = getDefinitionByName(className) as Class;
			currentItemVO._itemClass = classRef;
			
			var contextMenuInvoker:ContextMenuInvoker = new ContextMenuInvoker();
			
			
			
			//var tileController:TileController = new TileController(_gridVO, _grid,  _isoWorld);
			///if (className == "Bulldozer" || className == "Tractor" || className == "PickupTruck"){
			///_tileController.destroyTile(_clickedTile, _clickedPosition, className);
			if(className == "Bulldozer"){
				var soundclassRef:Class = getDefinitionByName("Collapse") as Class;
				var snd:Sound = new soundclassRef() as Sound;
				SoundPlayer.instance.startSound(snd, 0.5, 0);
				var bulldozeCommand:BulldozeCommand = new BulldozeCommand(_tileController, _clickedTile);
				contextMenuInvoker.setCommand(bulldozeCommand);
				contextMenuInvoker.issueCommand();
			}
			else if (className == "Tractor"){
				var plowCommand:PlowCommand = new PlowCommand(_tileController, _clickedTile);
				contextMenuInvoker.setCommand(plowCommand);
				contextMenuInvoker.issueCommand();
			}else if (className == "PickupTruck"){
				var harvestCommand:HarvestCommand = new HarvestCommand(_tileController, _clickedTile);
				contextMenuInvoker.setCommand(harvestCommand);
				contextMenuInvoker.issueCommand();	
				
			}else if (className == "WateringCan"){
				///_tileController.startGrowing(_clickedTile, _clickedPosition);
				var soundclassRef:Class = getDefinitionByName("WateringSound") as Class;
				var snd:Sound = new soundclassRef() as Sound;
				SoundPlayer.instance.startSound(snd, 0.5, 0);
				var waterCommand:WaterCommand = new WaterCommand(_tileController, _clickedTile);
				contextMenuInvoker.setCommand(waterCommand);
				contextMenuInvoker.issueCommand();
				
			}else if (className == "Love"){
				trace("petting - animal should make noise");
				_tileController.doTileThing(_clickedTile);
			}else if (className == "HandMove"){
				trace("starting drag and drop");
				_tileController.moveTile(_clickedTile);
			}else if (className == "CashRegister"){
				trace("selling - remove from grid and add Farmbucks - transaction fee");
				_tileController.destroyTile(_clickedTile, _clickedPosition, className);
				var soundclassRef:Class = getDefinitionByName("CashRegisterSound") as Class;
				var snd:Sound = new soundclassRef() as Sound;
				SoundPlayer.instance.startSound(snd, 0.5, 0);
			}else if (className == "Manure"){
				trace("adding Manure - instantly ready for harvest!");
				_tileController.destroyTile(_clickedTile, _clickedPosition, className);
				var soundclassRef:Class = getDefinitionByName("Splat") as Class;
				var snd:Sound = new soundclassRef() as Sound;
				SoundPlayer.instance.startSound(snd, 0.5, 0);
			}
			
			_isoWorld.removeChild(_tilePopupContainer);
			_tilePopupContainer = null;
		}
		
		public function ignore(e:Event=null):void{
			e.stopPropagation();
			e.target.removeEventListener(MouseEvent.CLICK, ignore);
			_isoWorld.removeChild(_tilePopupContainer);
			_tilePopupContainer = null;
		}
		public function kill():void{
			_isoWorld.removeChild(_tilePopupContainer);
			_tilePopupContainer = null;
		}
	}
}