package com.evili.worldBuilder.controllers
{
	import com.evili.utils.DataTimer;
	import com.evili.utils.FilterHelper;
	import com.evili.utils.JSAlert;
	import com.evili.utils.Map;
	import com.evili.utils.SoundPlayer;
	import com.evili.worldBuilder.controllers.CharacterMovementController;
	import com.evili.worldBuilder.controllers.TileController;
	import com.evili.worldBuilder.controllers.TileManager;
	import com.evili.worldBuilder.events.ClickedTileEvent;
	import com.evili.worldBuilder.events.DataEvent;
	import com.evili.worldBuilder.events.DebugEvent;
	import com.evili.worldBuilder.events.UserMovedEvent;
	import com.evili.worldBuilder.model.CharacterVO;
	import com.evili.worldBuilder.model.GridVO;
	import com.evili.worldBuilder.model.ItemVO;
	import com.evili.worldBuilder.model.ModelLocator;
	import com.evili.worldBuilder.model.TileVO;
	import com.friendsofed.isometric.*;
	import com.friendsofed.pathfinding.Grid;
	import com.friendsofed.pathfinding.Node;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class TileController extends EventDispatcher
	{
		
/** use this grid to hold all the tiles created */
		private var _grid:Grid;
		private var _gridVO:GridVO;
		private var _isoWorld:IsoWorld;
		private var _actionsController:ActionsController;
		
		
		public function TileController(gridVO, grid, isoWorld)
		{

			_gridVO = gridVO;
			_grid = grid;
			_isoWorld = isoWorld;
			_actionsController = new ActionsController(_gridVO, _grid,  _isoWorld, this);
			_actionsController.addEventListener("RemovePopup", doRemovePopup);
			
		}
		private function doRemovePopup(e:Event):void{
			trace("remove popup called");
			dispatchEvent(new Event("RemovePopup"));
		}
		///////////////////////////////////////////////////////////////
		/** select an action from the context menu */
		///////////////////////////////////////////////////////////////
		public function destroyTile(clickedTile:IsoObject, clickedPosition:Point3D, actionName:String):void{
			if (clickedTile is GraphicTile){
				var currentTile:GraphicTile = clickedTile as GraphicTile;
				var classRef:Class = currentTile._classRef;
				
				if (classRef != null){
					var mc:MovieClip = new classRef() as MovieClip;
					mc.mouseEnabled = false;
					trace("classRef:" + classRef);
					
					var currentTileName:String = flash.utils.getQualifiedClassName( mc );
					if (currentTileName == "BigBarn"){
						currentTileName = "Barn";
					}
					if (currentTileName == "BigFarmhouse"){
						currentTileName = "Farmhouse";
					}
					var currentItemVO:ItemVO = TileManager.getCurrentItemVO(currentTileName);
					//NOTE: must "MAIN" tile if click on a non-walkable section of a four-tile building, eg
					
					//var selectedItemVO:ItemVO = ModelLocator.getInstance()._selectedItemVO;
					//if (selectedItemVO != null){
						
						///var destroyer:String = selectedItemVO._itemName;
						
						if (actionName == "Bulldozer"){
							///doBulldozer(currentItemVO, clickedTile, clickedPosition);
						}else if (actionName == "Tractor"){
							///doTractor(currentItemVO, clickedTile, clickedPosition);
						}else if (actionName == "PickupTruck"){
							///doPickup(currentItemVO, clickedTile, clickedPosition);
						}else if (actionName == "CashRegister"){
							//doCashRegister(currentItemVO, selectedItemVO, clickedTile, clickedPosition);
							doCashRegister(currentItemVO, clickedTile, clickedPosition);
						}else if (actionName == "Manure"){
							//doCashRegister(currentItemVO, selectedItemVO, clickedTile, clickedPosition);
							doManure(currentItemVO, clickedTile, clickedPosition);
						}
						
					//}
					
					//ModelLocator.getInstance()._selectedItemVO = null;
					updateSharedObject();
				}
			}
		}
		/** gets all the item info for the clicked item*/
		/*private function getCurrentItemVO(selectedItem:String):ItemVO{
			var itemsArray:Array = ModelLocator.getInstance()._itemsArray;
			for (var i:uint=0; i<itemsArray.length; i++){
				var currentArray:Array = itemsArray[i];
				for (var j:uint=0; j<currentArray.length; j++){
					var currentItemVO:ItemVO = currentArray[j];
					var currentName:String = currentItemVO._itemName;
					if (selectedItem == currentName){
						return currentItemVO;
					}
				}
			}
			return null;
		}*/
		/** gets all the item info for the clicked tile*/
		private function getCurrentTileVO(selectedItem:String):TileVO{
			var floorArray:Array = _gridVO._floorData
			for (var i:uint=0; i<floorArray.length; i++){
				var currentTileVO:TileVO = floorArray[i];
				
				if (currentTileVO._furnitureClassName == selectedItem){
					return currentTileVO;
				}
			}
			return null;
		}
		/** update the stored data for the grid, items and farmbucks*/
		private function updateSharedObject():void{
			ModelLocator.getInstance()._gridVO = _gridVO;
			var mySo:SharedObject = ModelLocator.getInstance()._mySO;
			mySo.data.gridVO = ModelLocator.getInstance()._gridVO;
			mySo.data.itemsArray = ModelLocator.getInstance()._itemsArray;
			mySo.data.farmbucks = ModelLocator.getInstance()._farmBucks;
			mySo.flush();
		}
		/** when we either add an item from the store, or remove an item with the bulldozer etc,
		 *  update the walkability of the surrounding tiles */
		private function updateSurroundingTiles(currentItemVO:ItemVO, tileID:int, floorData:Array, walkable:String):void{
			var walkableBoolean:Boolean
			if (walkable == "true"){
				walkableBoolean = true;
			}else{
				walkableBoolean = false;
			}
			//if (currentItemVO._numTiles > 1){
			if (currentItemVO._overlapArray != null){
				if (currentItemVO._overlapArray.length !=0){
					TileManager.updateTiles(currentItemVO, tileID, floorData, walkable, _grid);
				}
			}
			
		}
		/** this updates the _nodes array to reflect the NEW tile we've added
		 *  when we add/subtract tiles, we create a NEW GraphicTile
		 *  we need to preserve the node value of every tile
		 *  was previously creating a NEW node, but this messed up astar
		 * 	AND it preserves the original node, associated with the original tile
		 *  otherwise the astar function breaks as we can never find the original node!*/
		private function updateNodes(tileID:int, floorData:Array, tile:GraphicTile, originalNode:Node):void{
			var _nodes:Array = this._grid._nodes;
			///var i:int = floorData[tileID][0];
			///var k:int = floorData[tileID][1];
			var tileVO:TileVO = floorData[tileID];
			var i:Number = tileVO._col;
			var k:Number = tileVO._row;
			_nodes[i][k] = tile;
			//$$$NOTE: next line breaks astar, as we can never find the destination node of the tile!
			///var node:Node = new Node(i, k, tileID);
			//tile._node = node;
			tile._node = originalNode;
			//now we can update the owner to reflect the new tile
			tile._node._owner = tile;
		}
		
		///////////////////////////////////////////////////////////////
		/* user has selected an item from the "store" - an animal, a tile, a building, etc - now we
		will place it on the world, update the grid info, and make sure that we take care of any
		overlapping tiles if this is a multi-tile object (eg, a large building)*/
		///////////////////////////////////////////////////////////////
		public function clickOnTile(clickedTile:IsoObject, clickedPosition:Point3D):Boolean{
			//var selectedItemVO:ItemVO = ModelLocator.getInstance()._selectedItemVO;
			
			var currentTile:GraphicTile = clickedTile as GraphicTile;
			var classRef:Class = currentTile._classRef;
			var mc:MovieClip = new classRef() as MovieClip;
			trace("classRef:" + classRef);
			var currentTileName:String = flash.utils.getQualifiedClassName( mc );
			if (currentTileName == "BigBarn"){
				currentTileName = "Barn";
			}
			if (currentTileName == "BigFarmhouse"){
				currentTileName = "Farmhouse";
			}
			var currentItemVO:ItemVO = TileManager.getCurrentItemVO(currentTileName);
			
			if (currentItemVO != null){
				var selectedItemName:String = currentItemVO._itemName;
				var layer:String = currentItemVO._layer;
				var tileID:int = clickedTile._node._id;
				var floorData:Array = _gridVO._floorData;
				var tileVO:TileVO = floorData[tileID];
				//NEED TO RETRIEVE THE TILE THAT IS OVERLAPPING THIS AND RECALL THE FUNCTION...
				if (tileVO._occupierID != 0){
					//need to convert occupierID to find the clickedTile and it's position
					var occupyingTileVO:TileVO = floorData[tileVO._occupierID];
					var occupyingTile:IsoObject = _grid._nodes[occupyingTileVO._col][occupyingTileVO._row];
					clickOnTile(occupyingTile, occupyingTile.position);
					return false;
				}
				
				if (layer == "world"){
					showActionMenu(currentItemVO, clickedTile, clickedPosition);
					return false;
				}else if (layer == "floor"){
					if (currentTileName == "EarthPatch"){//PLOW IT (turn it into plowed tile) then walk to it
						///JSAlert.showAlert("Plow it");
						//$$$CHECK FOR OVERLAPPING!!!!
						plantGrass(clickedTile, clickedPosition);
						return true;
					}else if (currentTileName == "TilledEarth"){//Walk to it - no context menu
						return true;
					}else{//SHOW ACTION MENU
						showActionMenu(currentItemVO, clickedTile, clickedPosition);
						return false;
					}
				}
				
			}
			return false;
		}

		private function showActionMenu(currentItemVO:ItemVO, clickedTile:IsoObject, clickedPosition:Point3D){
				//_actionsController = new ActionsController(_gridVO, _grid,  _isoWorld, clickedTile, clickedPosition);
				///_actionsController = new ActionsController(_gridVO, _grid,  _isoWorld);
				
				if (currentItemVO._itemType == "building"){
					_actionsController.addBuildingActionsMenu(currentItemVO, clickedTile, clickedPosition);
				}else if (currentItemVO._itemType == "animal"){
					_actionsController.addAnimalActionsMenu(currentItemVO, clickedTile, clickedPosition);
				}else if (currentItemVO._itemType == "tile"){
					_actionsController.addCropsActionsMenu(currentItemVO, clickedTile, clickedPosition);
				}
			///dispatchEvent(new Event("selectNone"));*/
		}
		
		
		
		
		
		///////////////////////////////////////////////////////////////
		/* user has selected an item from the "store" - an animal, a tile, a building, etc - now we
		will place it on the world, update the grid info, and make sure that we take care of any
		overlapping tiles if this is a multi-tile object (eg, a large building)*/
		///////////////////////////////////////////////////////////////
		public function addStoreItem(clickedTile:IsoObject, clickedPosition:Point3D):Boolean{
			var selectedItemVO:ItemVO = ModelLocator.getInstance()._selectedItemVO;
			
			var currentTile:GraphicTile = clickedTile as GraphicTile;
			var classRef:Class = currentTile._classRef;
			var mc:MovieClip = new classRef() as MovieClip;
			trace("classRef:" + classRef);
			var currentTileName:String = flash.utils.getQualifiedClassName( mc );
			if (currentTileName == "BigBarn"){
				currentTileName = "Barn";
			}
			if (currentTileName == "BigFarmhouse"){
				currentTileName = "Farmhouse";
			}
			var currentItemVO:ItemVO = TileManager.getCurrentItemVO(currentTileName);
			if (currentItemVO != null){
				if (currentItemVO._walkable == false){
					var statusAlert:String = "You can't put a " + selectedItemVO._prettyName + " onto that thang! That don't make no sense!";
					dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
					return false;
				}
			}
			
			if (selectedItemVO != null){
				///var className:String = flash.utils.getQualifiedClassName( selectedItem );
				///var itemReference:Class = getDefinitionByName(className) as Class;
				//first test - no animals on crops or tilled earth!
				if (selectedItemVO._itemType == "animal" && currentItemVO._itemName != "EarthPatch"){
					var statusAlert:String = "You can't put a " + selectedItemVO._prettyName + " onto that thang! That don't make no sense!";
					dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
					return false;
				}
				var selectedItemName:String = selectedItemVO._itemName;
				
				
				if (selectedItemName == "Barn"){
					var bb:BigBarn;
					var itemReference:Class = getDefinitionByName("BigBarn") as Class;
				}else if (selectedItemName == "Farmhouse"){
					var bb:BigBarn;
					var itemReference:Class = getDefinitionByName("BigFarmhouse") as Class;
				}else{
					var itemReference:Class = selectedItemVO._itemClass;
				}
				
				var layer:String = selectedItemVO._layer;
				var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, itemReference, 20, 10, layer);
				
				tile.x = clickedPosition.x;
				tile.y = clickedPosition.y;
				tile.z = clickedPosition.z;
				tile.walkable = selectedItemVO._walkable;
				var tileID:int = clickedTile._node._id;
				
				if (_gridVO != null){
					var floorData:Array = _gridVO._floorData;
					if (layer == "world"){
						var tileVO:TileVO = floorData[tileID];
						//will this tile land on any overlapping tiles?
						var overlap:Boolean = checkOverlap(selectedItemVO, floorData, tileID);
						
						if (overlap == false){
							//FINALLY! CLEAR! go ahead and deduct the cost now
							var price:Number = selectedItemVO._price;
							if (ModelLocator.getInstance()._isMoved == true){
								var movePrice:Number = price * 0.2;//costs 20% of buy price to move an item
								ModelLocator.getInstance()._farmBucks -= movePrice;
								ModelLocator.getInstance()._isMoved = false;
								ModelLocator.getInstance()._cursor_mc.removeEventListener(Event.ENTER_FRAME, followMouse);
								_isoWorld.removeChild(ModelLocator.getInstance()._cursor_mc);
								ModelLocator.getInstance()._cursor_mc = null;
							}else{
								ModelLocator.getInstance()._farmBucks -= price;
							}
							trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
							dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
							if (selectedItemVO._itemType == "animal"){
								if (selectedItemVO._isHarvestable == true && selectedItemVO._initMessage == false){
									var statusAlert:String = "You just bought yerself a " + selectedItemVO._prettyName + " for " + price + " Farmbucks! Wait a spell and you can harvest it!";
									dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
									selectedItemVO._initMessage = true;
								}else if (selectedItemVO._isHarvestable == false && selectedItemVO._initMessage == false){
									var statusAlert:String = "You just bought yerself a " + selectedItemVO._prettyName + " for " + price + " Farmbucks! You can pet him to make money, just like your pappy do!";
									dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
									selectedItemVO._initMessage = true;
								}
							}
							tileVO._furnitureClassName = selectedItemName;
							tileVO._walkable = "false";
							tileVO._tileClass = null;
							tileVO._tileClassName = "";
							//floorData[tileID][5] = className;
							//floorData[tileID][3] = "false";
							_isoWorld.addChildToWorld(tile);
							if (tileVO._tileClassName !=""){
								///if (floorData[tileID][2] !=""){
								
								///var floorTileName:String = floorData[tileID][2];
								var floorTileName:String = tileVO._tileClassName;
								var floorTileClass:Class = getDefinitionByName(floorTileName) as Class;
								var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, floorTileClass, 20, 10, layer);
								_isoWorld.addChildToFloor(tile);
							};
							
							///updateNodes(tileID, floorData, tile);
							updateNodes(tileID, floorData, tile, clickedTile._node);
							updateSurroundingTiles(selectedItemVO, tileID, floorData, "false");
							updateSharedObject();
							dispatchEvent(new Event("selectNone"));
							if (selectedItemVO._isHarvestable == true){
								startHarvesting(clickedTile, clickedPosition);
							}
						}
					}else if (layer == "floor"){
						if (currentTileName == "EarthPatch"){
							///JSAlert.showAlert("Y'all got to plow before you can adds crops here");
							var statusAlert:String = "Y'all got to plow before you can adds crops here";
							dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
							return true;
						}else{
							var tileVO:TileVO = floorData[tileID];
							tileVO._tileClassName = selectedItemName;
							tileVO._walkable = "true";
							var price:Number = selectedItemVO._price;
							ModelLocator.getInstance()._farmBucks -= price;
							trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
							if(selectedItemVO._initMessage == false){
					
								var statusAlert:String = "You just added some " + selectedItemVO._prettyName + "! You'll need to add water to make it grow!";
								dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
								selectedItemVO._initMessage = true;
							}
							
							dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
							_isoWorld.addChildToFloor(tile);
							
							updateNodes(tileID, floorData, tile, clickedTile._node);
							updateSurroundingTiles(selectedItemVO, tileID, floorData, "false");
							updateSharedObject();
							dispatchEvent(new Event("selectNone"));
						}
					}
				}
				return selectedItemVO._walkable;
			}else{
				return false;
			}
		}
		public function checkOverlap(itemVO:ItemVO, floorData:Array, tileID:int):Boolean{
			if (itemVO._overlapArray != null){
				if (itemVO._overlapArray.length !=0){
					for (var i:uint=0; i < itemVO._overlapArray.length; i++){
						var curID:int = itemVO._overlapArray[i];
						var overlapTileVO:TileVO = floorData[tileID+curID];
						//make sure any tiles we will overlap are not either Overlapped themselves, OR main tiles for other "furniture"
						if (overlapTileVO == null){
							var statusAlert:String = "You can't put a " + itemVO._prettyName + " over yonder! Dad blast it!";
							dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
							return true;
						}else if (overlapTileVO._occupierID != 0){
							///JSAlert.showAlert("you can't add the " + itemVO._itemName + " here!");
							var statusAlert:String = "You can't put a " + itemVO._prettyName + " on that thang! Dad gum it!";
							dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
							return true;
						}else if (overlapTileVO._furnitureClassName != ""){
							///JSAlert.showAlert("you can't add the " + itemVO._itemName + " here!");
							var statusAlert:String = "You can't put no " + itemVO._prettyName + " over thar! Doggone it!";
							dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
							return true;
						}
					}
				}
			} return false;
		}
		
		/** called if we select an animal then click the move icon - removes it from original position
		 *  then adds it to the next clicked tile - same as buying, except much cheaper */
		public function moveTile(clickedTile:GraphicTile):void{
			var classRef:Class = clickedTile._classRef;
			var mc:MovieClip = new classRef() as MovieClip;
			trace("classRef:" + classRef);
			var currentTileName:String = flash.utils.getQualifiedClassName( mc );
			var currentItemVO:ItemVO = TileManager.getCurrentItemVO(currentTileName);
			currentItemVO._itemClass = classRef;
			ModelLocator.getInstance()._selectedItemVO = currentItemVO;
			ModelLocator.getInstance()._isMoved = true;
			
			
			ModelLocator.getInstance()._cursor_mc = new classRef() as MovieClip;
			ModelLocator.getInstance()._cursor_mc.scaleX = 0.5;
			ModelLocator.getInstance()._cursor_mc.scaleY = 0.5;
			//NOTE: *** broadcast this event instead of using ModelLocator
			//NOTE: *** make item "click and stick" to the cursor till it's dropped
			
			
			_isoWorld.addChild(ModelLocator.getInstance()._cursor_mc);
			ModelLocator.getInstance()._cursor_mc.addEventListener(Event.ENTER_FRAME, followMouse);
			removeWorldTile(clickedTile, currentItemVO);
		}
		/** remove any tile and replace it with Bare Earth
		 *  this function also checks for affected overlaps and updates adjacent tiles*/
		private function removeWorldTile(clickedTile:GraphicTile, currentItemVO:ItemVO):void{
			_isoWorld.removeChildFromWorld(clickedTile);
			
			var tileID:int = clickedTile._node._id;
			if (_gridVO != null){
				var floorData:Array = _gridVO._floorData;
				var tileVO:TileVO = floorData[tileID];
				tileVO._furnitureClassName = "";
				tileVO._tileClassName = "";
				tileVO._walkable = "true";
				tileVO._grown = false;
				tileVO._isFed = false;
				tileVO._isLoved = false;
				var i:int = tileVO._col;
				var k:int = tileVO._row; 
				
				_grid.setWalkable(i, k, true);
				
				var itemReference:Class = getDefinitionByName("EarthPatch") as Class;
				
				var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, itemReference, 20, 10, "floor");
				_isoWorld.addChildToFloor(tile);
				
				var _cellSize:Number = ModelLocator.getInstance()._cellSize;
				var position:Point3D = new Point3D(i * _cellSize, 0, k * _cellSize);
				
				tile.x = position.x
				tile.y = position.y;
				tile.z = position.z;
				
				tile.walkable = true;
				
				updateNodes(tileID, floorData, tile, clickedTile._node);
				if(currentItemVO._overlapArray != null){
					if (currentItemVO._overlapArray.length !=0){
						TileManager.updateTiles(currentItemVO, tileID, floorData, "true", _grid);
					}
				}
			}
		}
		private function followMouse(e:Event):void{
			var mc:MovieClip = e.target as MovieClip;
			mc.mouseEnabled = false;
			mc.x = _isoWorld.mouseX-10;
			mc.y = _isoWorld.mouseY-5;
		}
		
		/** start growing animals immediately after they land on the grid*/
		public function startHarvesting(clickedTile:IsoObject, clickedPosition:Point3D):void{
			var selectedItemVO:ItemVO = ModelLocator.getInstance()._selectedItemVO;
			
			var harvestableTile:IsoObject = _grid.findTile(clickedPosition);
			
			if (selectedItemVO != null){
				var selectedItemName:String = selectedItemVO._itemName;
				var itemReference:Class = selectedItemVO._itemClass;
				///var level:String;
				
				var layer:String = selectedItemVO._layer;
				//var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, classRef, 20, 10, layer);
				
				var tileID:int = harvestableTile._node._id;
				var floorData:Array = _gridVO._floorData;
				var tileVO:TileVO = floorData[tileID];
				tileVO._isFed = true;
				if (selectedItemVO._growTime != 0){
					var growthObject:Object = new Object();
					growthObject.tile = harvestableTile;
					growthObject.tileVO = tileVO;
					growthObject.clickedPosition = clickedPosition;
					_harvestTimer = new DataTimer(selectedItemVO._growTime * 1000, 1, growthObject);
					_harvestTimer.start(); 
					_harvestTimer.addEventListener(TimerEvent.TIMER, harvestTimerHandler);
					//_harvestTimer.addEventListener(TimerEvent.TIMER_COMPLETE, growTimerCompleteHandler);
					
				}
			}
		}
		private var _harvestTimer:DataTimer;
		private function harvestTimerHandler(e:TimerEvent):void{
			var dataTimer:DataTimer = e.currentTarget as DataTimer;
			var growthObject:Object = dataTimer.data;
			
			/*var filter:BitmapFilter = FilterHelper.getColoredGlowFilter(0x0000cc);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			*/
			var currentTile:GraphicTile = growthObject.tile as GraphicTile;
			
			var currentTileVO:TileVO = growthObject.tileVO as TileVO;
			currentTileVO._grown = true;
			
			///currentTile.filters = myFilters;
			var classRef:Class = currentTile._classRef;
			var mc:MovieClip = new classRef() as MovieClip;
			trace("classRef:" + classRef);
			var currentTileName:String = flash.utils.getQualifiedClassName( mc );
			//$$$HACK - FIX LATER BY ADDING "GROWN VERSION" PROPERTY TO ITEMVO
			/*if (currentTileName == "Sheep" || currentTileName == "SheepLeft"){
				var newTileName:String = "SheepHarvestable";
			}*/
			
			var currentItemVO:ItemVO = TileManager.getCurrentItemVO(currentTileName);
			
			
			
			mature(currentItemVO, currentTile, growthObject.clickedPosition)
			
			
		}
		/** selected when we select the watering icon after clicking on a baby crop */
		public function startGrowing(clickedTile:IsoObject):void{
			var clickedPosition:Point3D = clickedTile.position;
			
			var currentTile:GraphicTile = clickedTile as GraphicTile;
			var classRef:Class = currentTile._classRef;
			var mc:MovieClip = new classRef() as MovieClip;
			trace("classRef:" + classRef);
			var currentTileName:String = flash.utils.getQualifiedClassName( mc );
			var currentItemVO:ItemVO = TileManager.getCurrentItemVO(currentTileName);
			if (currentItemVO != null){
				var price:Number = currentItemVO._price;
				var wateringPrice:Number = Math.floor(price * 0.5);
				
				ModelLocator.getInstance()._farmBucks -= wateringPrice;
				///JSAlert.showAlert("You just sold a " + currentItemVO._itemName + " for " + sellPrice + " Farmbucks!");
				trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
				dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
				var statusAlert:String = "You done watered some " + currentItemVO._prettyName + ", that'll cost ya " + wateringPrice + " Farmbucks! Ayup! You can add some 'o that fine manure to speed up the harvest!";
				dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
				
				var tileID:int = clickedTile._node._id;
				var floorData:Array = _gridVO._floorData;
				var tileVO:TileVO = floorData[tileID];
				tileVO._isFed = true;
				if (currentItemVO._growTime != 0){
					
					updateFloorTile(currentTile);
				}
			}
		}
		/** remove original tile from floor and replace it with the currentTile*/
		private function updateFloorTile(originalTile:GraphicTile):void{
			_isoWorld.removeChildFromFloor(originalTile);
			
			//add watered version to world
			var classRef:Class = originalTile._classRef;
			trace("classRef:" + classRef);
			var mc:MovieClip = new classRef() as MovieClip;
			var currentTileName:String = flash.utils.getQualifiedClassName( mc );
			//$$$HACK - FIX LATER BY ADDING "GROWN VERSION" PROPERTY TO ITEMVO
			if (currentTileName == "BabyCorn"){
				var newTileName:String = "BabyCornWatered";
			}
			//NOTE: NEED GROWNUP CORN - GrownCorn - is actually GrownWheat
			if (currentTileName == "BabyWheat"){
				var newTileName:String = "BabyWheatWatered";
			}
			var newItemVO:ItemVO = TileManager.getCurrentItemVO(newTileName);
			var newClassRef:Class = getDefinitionByName(newTileName) as Class;
			newItemVO._itemClass = newClassRef;
			var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, newClassRef, 20, 10, "floor");
			
			tile.x = originalTile.position.x;
			tile.y = originalTile.position.y;
			tile.z = originalTile.position.z;
			
			var tileID:int = originalTile._node._id;
			tile.walkable = true;
			if (_gridVO != null){
				var floorData:Array = _gridVO._floorData;
				var tileVO:TileVO = floorData[tileID];
				tileVO._tileClassName = newTileName;
				tileVO._walkable = "true";
				tileVO._grown = false;
				tileVO._isFed = true;
				tileVO._isLoved = false;
				_isoWorld.addChildToFloor(tile);
				
				updateNodes(tileID, floorData, tile, originalTile._node);
				updateSharedObject();
				dispatchEvent(new Event("selectNone"));
			}
			var growthObject:Object = new Object();
			growthObject.tile = tile;
			growthObject.tileVO = tileVO;
			growthObject.clickedPosition = tile.position;
			_growTimer = new DataTimer(newItemVO._growTime * 1000, 1, growthObject);
			_growTimer.start(); 
			_growTimer.addEventListener(TimerEvent.TIMER, growTimerHandler);
			_growTimer.addEventListener(TimerEvent.TIMER_COMPLETE, growTimerCompleteHandler);
		}
		private var _growTimer:DataTimer
		private function growTimerHandler(e:TimerEvent):void{
			///JSAlert.showAlert("grown - ready for harvest!");
			
			var dataTimer:DataTimer = e.currentTarget as DataTimer;
			var growthObject:Object = dataTimer.data;
			var currentTile:GraphicTile = growthObject.tile as GraphicTile;
			var currentTileVO:TileVO = growthObject.tileVO as TileVO;
			currentTileVO._grown = true;
			
			
			var classRef:Class = currentTile._classRef;
			var mc:MovieClip = new classRef() as MovieClip;
			trace("classRef:" + classRef);
			var currentTileName:String = flash.utils.getQualifiedClassName( mc );
			//$$$HACK - FIX LATER BY ADDING "GROWN VERSION" PROPERTY TO ITEMVO
			if (currentTileName == "BabyCornWatered"){
				var newTileName:String = "GrownCorn";
			}
			//NOTE: NEED GROWNUP CORN - GrownCorn - is actually GrownWheat
			if (currentTileName == "BabyWheatWatered"){
				var newTileName:String = "GrownWheat";
			}
			var newItemVO:ItemVO = TileManager.getCurrentItemVO(newTileName);
			newItemVO._isHarvestable = true;
			//TRICKY - sometimes we have this value in the ItemVO, othertimes we need to get it from the string
			var newClassRef:Class = getDefinitionByName(newTileName) as Class;
			newItemVO._itemClass = newClassRef;
			var clickedPosition:Point3D = growthObject.clickedPosition;
			
			_isoWorld.removeChildFromFloor(currentTile);
			
			//add harvestable version to world
			
			var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, newClassRef, 20, 10, "floor");
			
			tile.x = clickedPosition.x;
			tile.y = clickedPosition.y;
			tile.z = clickedPosition.z;
	
			var tileID:int = currentTile._node._id;
			tile.walkable = true;
			if (_gridVO != null){
				var floorData:Array = _gridVO._floorData;
				var tileVO:TileVO = floorData[tileID];
				tileVO._tileClassName = newTileName;
				tileVO._walkable = "true";
				tileVO._grown = true;
				tileVO._isFed = false;
				tileVO._isLoved = false;
				_isoWorld.addChildToFloor(tile);
				
				updateNodes(tileID, floorData, tile, currentTile._node);
				updateSharedObject();
				dispatchEvent(new Event("selectNone"));
			}
			
			dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
			var statusAlert:String = "You done got some " + newItemVO._prettyName + " all a-ready to harvest!";
		}
		private function growTimerCompleteHandler(e:TimerEvent):void{
			//remove handler
		}
		private var usedManure:Boolean;
		private function doManure(currentItemVO, clickedTile, clickedPosition):void{
			_growTimer.stop();
			_growTimer.removeEventListener(TimerEvent.TIMER, growTimerHandler);
			_growTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, growTimerCompleteHandler);
			usedManure = true;
			mature(currentItemVO, clickedTile, clickedPosition);
		}
		/** replaces BOTH harvestable crops (eg GrownCorn) AND harvestable animals (eg CowHarvestable)*/
		private function mature(currentItemVO, currentTile, clickedPosition):void{
			var classRef:Class = currentTile._classRef;
			var mc:MovieClip = new classRef() as MovieClip;
			trace("classRef:" + classRef);
			var currentTileName:String = flash.utils.getQualifiedClassName( mc );
			//$$$HACK - FIX LATER BY ADDING "GROWN VERSION" PROPERTY TO ITEMVO
			if (currentTileName == "BabyCornWatered"){
				var newTileName:String = "GrownCorn";
			}else if (currentTileName == "BabyWheatWatered"){
				var newTileName:String = "GrownWheat";
			}else if (currentTileName == "Sheep"){
				var newTileName:String = "SheepHarvestable";
			}else if (currentTileName == "Cow"){
				var newTileName:String = "CowHarvestable";
			}else if (currentTileName == "Goat"){
				var newTileName:String = "GoatHarvestable";
			}else if (currentTileName == "Chicken"){
				var newTileName:String = "ChickenHarvestable";
			}else if (currentTileName == "SheepLeft"){
				var newTileName:String = "SheepLeftHarvestable";
			}else if (currentTileName == "CowLeft"){
				var newTileName:String = "CowLeftHarvestable";
			}else if (currentTileName == "Pig"){
				var newTileName:String = "PigHarvestable";
			}else{
				var newTileName:String = currentTileName;
			}
			
			var newItemVO:ItemVO = TileManager.getCurrentItemVO(newTileName);
			newItemVO._isHarvestable = true;
			//TRICKY - sometimes we have this value in the ItemVO, othertimes we need to get it from the string
			var newClassRef:Class = getDefinitionByName(newTileName) as Class;
			newItemVO._itemClass = newClassRef;
			
			
			var article:String;
			if (currentItemVO._layer == "floor"){
				_isoWorld.removeChildFromFloor(currentTile);
				article = "some";
			}else if (currentItemVO._layer == "world"){
				//NOTE: getting breakage here...
				_isoWorld.removeChildFromWorld(currentTile);
				article = "a";
			}
			
			
			var price:Number = currentItemVO._price;
			var manurePrice:Number = Math.floor(price * 0.5);
			
			ModelLocator.getInstance()._farmBucks -= manurePrice;
			///JSAlert.showAlert("You just sold a " + currentItemVO._itemName + " for " + sellPrice + " Farmbucks!");
			trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
			dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
			

			if (usedManure == true){
				var statusAlert:String = "Whee doggy! Y'all got " + article + " " +  newItemVO._prettyName + " ready for harvest! But you paid " + manurePrice + " Farmbucks for using manure! Plus your hands are stinky!";
				usedManure = false;
			}else{
				var statusAlert:String = "Whee doggy! Y'all got " + article + " " +  newItemVO._prettyName + " ready for harvest!";
			}
			dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
			
			//add harvestable version to world
			
			var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, newClassRef, 20, 10, "floor");
			
			tile.x = clickedPosition.x;
			tile.y = clickedPosition.y;
			tile.z = clickedPosition.z;
			
			var tileID:int = currentTile._node._id;
			tile.walkable = true;
			if (_gridVO != null){
				var floorData:Array = _gridVO._floorData;
				var tileVO:TileVO = floorData[tileID];
				tileVO._tileClassName = "TilledEarth";
				tileVO._walkable = "true";
				tileVO._grown = true;
				tileVO._isFed = false;
				tileVO._isLoved = false;
				if (currentItemVO._layer == "floor"){
					_isoWorld.addChildToFloor(tile);
				}else if (currentItemVO._layer == "world"){
					_isoWorld.addChildToWorld(tile);
				}
				
				updateNodes(tileID, floorData, tile, currentTile._node);
				updateSharedObject();
				dispatchEvent(new Event("selectNone"));
			}
			
		}
		/** clicked on a building tile and selected the bulldozer from the actions menu*/
		//public function doCashRegister(currentItemVO:ItemVO, selectedItemVO:ItemVO, clickedTile:IsoObject, clickedPosition:Point3D):void{
		public function doCashRegister(currentItemVO:ItemVO, clickedTile:IsoObject, clickedPosition:Point3D):void{
			if (currentItemVO._layer == "world"){
				if (currentItemVO._itemType=="animal"){
					_isoWorld.removeChildFromWorld(clickedTile);
					
					var tileID:int = clickedTile._node._id;
					if (_gridVO != null){
						var floorData:Array = _gridVO._floorData;
						var tileVO:TileVO = floorData[tileID];
						tileVO._furnitureClassName = "";
						tileVO._tileClassName = "";
						tileVO._walkable = "true";
						var i2:int = tileVO._col;
						var k2:int = tileVO._row; 
						
						_grid.setWalkable(i2, k2, true);
						
						var itemReference:Class = getDefinitionByName("EarthPatch") as Class;
						//how much does the item we're destroying cost? Should cost half that much to destroy it...
						var price:Number = currentItemVO._price;
						var sellPrice:Number = Math.floor(price * 0.9);
						
						ModelLocator.getInstance()._farmBucks += sellPrice;
						///JSAlert.showAlert("You just sold a " + currentItemVO._itemName + " for " + sellPrice + " Farmbucks!");
						trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
						dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
						var statusAlert:String = "Y'all just done sold a " + currentItemVO._prettyName + " for " + sellPrice + " Farmbucks! Wee doggy!";
						dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
						
						var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, itemReference, 20, 10, "floor");
						_isoWorld.addChildToFloor(tile);
						
						tile.x = clickedPosition.x;
						tile.y = clickedPosition.y;
						tile.z = clickedPosition.z;
						
						tile.walkable = true;
						tileVO._grown = false;
						tileVO._isFed = false;
						tileVO._isLoved = false;
						
						updateNodes(tileID, floorData, tile, clickedTile._node);
						if(currentItemVO._overlapArray != null){
							if (currentItemVO._overlapArray.length !=0){
								///if (currentItemVO._numTiles > 1){
								TileManager.updateTiles(currentItemVO, tileID, floorData, "true", _grid);
							}
						}
					}
				}else{
					//JSAlert.showAlert("You can't use the Cash Register here");
					dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, "You can't use the Cash Register here"));
					return;
				}
				//NOTE: the bulldozer can't destroy any floor tiles BUT it might be clicking
				//on an overlapping building tile...
			}else if(currentItemVO._layer == "floor"){
				var tileID:int = clickedTile._node._id;
				if (_gridVO != null){
					var floorData:Array = _gridVO._floorData;
					var tileVO:TileVO = floorData[tileID];
					
					//NOTE:*** could be trouble, what if ID is actually 0 and not null? Stupid Flash...
					if (tileVO._occupierID != 0){
						//need to convert occupierID to find the clickedTile and it's position
						var occupyingTileVO:TileVO = floorData[tileVO._occupierID];
						var occupyingTile:IsoObject = _grid._nodes[occupyingTileVO._col][occupyingTileVO._row];
						
						destroyTile(occupyingTile, occupyingTile.position, "CashRegister");
					}else{
						///JSAlert.showAlert("you can't use the CashRegister here");
						dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, "Y'all can't use the dang Cash Register here!"));
					}
					
				}
			}
		}
		/** clicked on a building tile and selected the bulldozer from the actions menu*/
		//public function doBulldozer(currentItemVO:ItemVO, selectedItemVO:ItemVO, clickedTile:IsoObject, clickedPosition:Point3D):void{
		///public function doBulldozer(currentItemVO:ItemVO, clickedTile:IsoObject, clickedPosition:Point3D):void{
		public function doBulldozer(clickedTile:IsoObject):void{
			
			
			var clickedPosition:Point3D = clickedTile.position;
			var currentTile:GraphicTile = clickedTile as GraphicTile;
			var classRef:Class = currentTile._classRef;
			
			if (classRef != null){
				var mc:MovieClip = new classRef() as MovieClip;
				mc.mouseEnabled = false;
				trace("classRef:" + classRef);
				
				var currentTileName:String = flash.utils.getQualifiedClassName( mc );
				if (currentTileName == "BigBarn"){
					currentTileName = "Barn";
				}
				if (currentTileName == "BigFarmhouse"){
					currentTileName = "Farmhouse";
				}
				var currentItemVO:ItemVO = TileManager.getCurrentItemVO(currentTileName);
				
				
				
				
				if (currentItemVO._layer == "world"){
					if (currentItemVO._itemType=="building" || currentItemVO._itemName == "Rattlesnake"){
						_isoWorld.removeChildFromWorld(clickedTile);
						
						var tileID:int = clickedTile._node._id;
						if (_gridVO != null){
							var floorData:Array = _gridVO._floorData;
							var tileVO:TileVO = floorData[tileID];
							tileVO._furnitureClassName = "";
							tileVO._tileClassName = "";
							tileVO._walkable = "true";
							var i2:int = tileVO._col;
							var k2:int = tileVO._row; 
							
							_grid.setWalkable(i2, k2, true);
							
							var itemReference:Class = getDefinitionByName("EarthPatch") as Class;
							//how much does the item we're destroying cost? Should cost half that much to destroy it...
							var price:Number = currentItemVO._price;
							var destroyPrice:Number = Math.ceil(price/2);
							
							ModelLocator.getInstance()._farmBucks -= destroyPrice;
							trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
							dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
							var statusAlert:String = "You done knocked down yer " + currentItemVO._itemName + "! That'll tally up to " + destroyPrice + " Farmbucks!";
							dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
							
							var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, itemReference, 20, 10, "floor");
							_isoWorld.addChildToFloor(tile);
							
							tile.x = clickedPosition.x;
							tile.y = clickedPosition.y;
							tile.z = clickedPosition.z;
							
							tile.walkable = true;
							
							updateNodes(tileID, floorData, tile, clickedTile._node);
							if(currentItemVO._overlapArray != null){
								if (currentItemVO._overlapArray.length !=0){
									///if (currentItemVO._numTiles > 1){
									TileManager.updateTiles(currentItemVO, tileID, floorData, "true", _grid);
								}
							}
							if (currentItemVO._itemName == "Rattlesnake"){
								//can now add rattlesnakes again
								ModelLocator.getInstance()._isRattlesnake = false;
							}
						}
					}else{
						///JSAlert.showAlert("You can't use the Bulldozer here");
						dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, "You can't done use the dag-blamed Bulldozer here!"));
						return;
					}
					//NOTE: the bulldozer can't destroy any floor tiles BUT it might be clicking
					//on an overlapping building tile...
				}else if(currentItemVO._layer == "floor"){
					var tileID:int = clickedTile._node._id;
					if (_gridVO != null){
						var floorData:Array = _gridVO._floorData;
						var tileVO:TileVO = floorData[tileID];
						
						//NOTE:*** could be trouble, what if ID is actually 0 and not null? Stupid Flash...
						if (tileVO._occupierID != 0){
							//need to convert occupierID to find the clickedTile and it's position
							var occupyingTileVO:TileVO = floorData[tileVO._occupierID];
							var occupyingTile:IsoObject = _grid._nodes[occupyingTileVO._col][occupyingTileVO._row];
							
							destroyTile(occupyingTile, occupyingTile.position, "Bulldozer");
						}else{
							///JSAlert.showAlert("you can't use the bulldozer here");
							dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, "You can't done use the dag-blamed Bulldozer here!"));
						}
						
					}
				}
			}
		}
		public function plantGrass(clickedTile:IsoObject, clickedPosition:Point3D):void{
			var tileID:int = clickedTile._node._id;
			if (_gridVO != null){
				var floorData:Array = _gridVO._floorData;
				var tileVO:TileVO = floorData[tileID];
				tileVO._grown = false;
				var walkable:String = tileVO._walkable;
			}
			if (walkable != "false"){//ERROR TRAP - CAN'T PLOW TILES AROUND A BUILDING, ETC
				trace("using Tractor on an Earth tile");
				//NOTE: ** for now, the plow puts down grass - may be other kinds later, so I'll call it "plantedItemVO"
				var itemReference:Class = getDefinitionByName("TilledEarth") as Class;
				var plantedItemVO:ItemVO = TileManager.getCurrentItemVO("TilledEarth");
				var price:Number = plantedItemVO._price;
				var destroyPrice:Number = Math.ceil(price/2);
				
				ModelLocator.getInstance()._farmBucks -= destroyPrice;
				trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
				dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
				if (ModelLocator.getInstance()._hasShowedPlowMessage == false){
					dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, "You done gone and plowed! Plantin' season is a ready!"));
					ModelLocator.getInstance()._hasShowedPlowMessage = true;
				}

				
				
				var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, itemReference, 20, 10, "floor");
				_isoWorld.addChildToFloor(tile);
				
				
				tile.x = clickedPosition.x;
				tile.y = clickedPosition.y;
				tile.z = clickedPosition.z;
				
				tile.walkable = true;
				
				var tileID:int = clickedTile._node._id;
				if (_gridVO != null){
					var floorData:Array = _gridVO._floorData;
					///var tileVO:TileVO = floorData[tileID];
					tileVO._tileClassName = "TilledEarth";
					tileVO._walkable = "true";
				}
				_isoWorld.removeChildFromFloor(clickedTile);
				var currentNode:Node = clickedTile._node;
				updateNodes(tileID, floorData, tile, currentNode);
			}
		}
		/** if we click on a tile with the tractor/plow 
		 *  the plow is for tiles only, so it will never work on a world level*/
		//public function doTractor(currentItemVO:ItemVO, selectedItemVO:ItemVO, clickedTile:IsoObject, clickedPosition:Point3D):void{
		public function doPlow(clickedTile:IsoObject):void{
			var clickedPosition:Point3D = clickedTile.position;
			var currentTile:GraphicTile = clickedTile as GraphicTile;
			var classRef:Class = currentTile._classRef;
			
			if (classRef != null){
				var mc:MovieClip = new classRef() as MovieClip;
				mc.mouseEnabled = false;
				trace("classRef:" + classRef);
				
				var currentTileName:String = flash.utils.getQualifiedClassName( mc );
				if (currentTileName == "BigBarn"){
					currentTileName = "Barn";
				}
				if (currentTileName == "BigFarmhouse"){
					currentTileName = "Farmhouse";
				}
				var currentItemVO:ItemVO = TileManager.getCurrentItemVO(currentTileName);
				
				
				
				
				if (currentItemVO._layer == "world"){
					///JSAlert.showAlert("you can't use the plow here");
					dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, "Y'all can't use the dang plow here!"));
					return;
				}else if (currentItemVO._layer == "floor"){
					if (currentItemVO._itemName == "TilledEarth"){
						///JSAlert.showAlert("you've already plowed here");
						dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, "You already done plowed here!"));
						return;
					}
					
					var tileID:int = clickedTile._node._id;
					if (_gridVO != null){
						var floorData:Array = _gridVO._floorData;
						var tileVO:TileVO = floorData[tileID];
						tileVO._grown = false;
						tileVO._isLoved = true;
						var walkable:String = tileVO._walkable;
					}
					if (walkable != "false"){//ERROR TRAP - CAN'T PLOW TILES AROUND A BUILDING, ETC
						trace("using Tractor on an Earth tile");
						//NOTE: ** for now, the plow puts down grass - may be other kinds later, so I'll call it "plantedItemVO"
						var itemReference:Class = getDefinitionByName("TilledEarth") as Class;
						var plantedItemVO:ItemVO = TileManager.getCurrentItemVO("TilledEarth");
						var price:Number = plantedItemVO._price;
						var destroyPrice:Number = Math.ceil(price/2);
						
						ModelLocator.getInstance()._farmBucks -= destroyPrice;
						trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
						var statusAlert:String = "You used the tractor to plow! That costs " + destroyPrice + " Farmbucks!";
						dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
						dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
						
						
						var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, itemReference, 20, 10, "floor");
						_isoWorld.addChildToFloor(tile);
						
						
						tile.x = clickedPosition.x;
						tile.y = clickedPosition.y;
						tile.z = clickedPosition.z;
						
						tile.walkable = true;
						
						var tileID:int = clickedTile._node._id;
						if (_gridVO != null){
							var floorData:Array = _gridVO._floorData;
							///var tileVO:TileVO = floorData[tileID];
							tileVO._tileClassName = "TilledEarth";
							tileVO._walkable = "true";
						}
						_isoWorld.removeChildFromFloor(clickedTile);
						updateNodes(tileID, floorData, tile, clickedTile._node);
					}else{
						///JSAlert.showAlert("you can't use the plow here");
						var statusAlert:String = "You ain't to use the plow here!";
						dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
					}
				}
			}
		}
		///////////////////////////////////////////////////////////////
		/* clicked on a tile, perform an action - play a sound, show a message, etc - based on the tile/furniture type */
		///////////////////////////////////////////////////////////////
		public function doTileThing(clickedTile:IsoObject):void{
			dispatchEvent(new DebugEvent(DebugEvent.DEBUG_MSG, "Sorry, that tile's not walkable!"));
			if (clickedTile is GraphicTile){
				var currentTile:GraphicTile = clickedTile as GraphicTile;
				var classRef:Class = currentTile._classRef;
				
				var tileID:int = clickedTile._node._id;
				
				
				if (classRef != null){
					var mc:MovieClip = new classRef() as MovieClip;
					trace("classRef:" + classRef);
					
					var className:String = flash.utils.getQualifiedClassName( mc );
					
					var currentItemVO:ItemVO = TileManager.getCurrentItemVO(className);
					var tileVO:TileVO = _gridVO._floorData[tileID];
					
					if (tileVO._occupiedBy != ""){
						var occupyingItemVO:ItemVO = TileManager.getCurrentItemVO(tileVO._occupiedBy);
					}
					//NOTE: **** KEY TO THE WHOLE PROBLEM - ARE WE A "REAL" TILE, OR AN OCCUPIED TILE?
					//WHAT KIND OF REAL TILE? WHAT'S OUR ASSOCIATED MESSAGE, OR SOUND?
					if (currentItemVO._itemType == "animal" || occupyingItemVO._itemType == "animal"){
						
						var cs:ChickenSound;
						var cows:CowSound;
						var hs:HorseSound;
						var ds:DogSound;
						var cats:CatSound;
						var gs:GoatSound;
						var ss:SheepSound;
						var pigSound:PigSound;
						var itemSound:String
						var itemName:String;
						var prettyName:String;
						var petPrice:Number;
						if (currentItemVO._itemType == "animal"){
							itemSound = currentItemVO._itemSoundClassName;
							itemName = currentItemVO._itemName;
							petPrice = currentItemVO._price * 0.1;
							prettyName = currentItemVO._prettyName;
						}else if(occupyingItemVO._itemType == "animal"){
							itemSound = occupyingItemVO._itemSoundClassName;
							itemName = occupyingItemVO._itemName;
							petPrice = occupyingItemVO._price * 0.1;
							prettyName = occupyingItemVO._prettyName;
						}
						/*var publicName:String;
						if (itemName == "SheepLeft"){
							publicName = "sheep";
						}else if (itemName == "CowLeft"){
							publicName = "cow";
						}else{
							publicName = itemName;
						}*/
						
						ModelLocator.getInstance()._farmBucks += petPrice;
						dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
						
						var statusAlert:String = "You just done loved up a " + prettyName + "! " + "You earned " + petPrice + " Farmbucks!";
						dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
						//EASTER EGG***
						/*if (itemSound=="CowSound"){
							ModelLocator.getInstance()._farmBucks += 1250;
							trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
							dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
							JSAlert.showAlert("You made the cow moo! Get 1250 points!");
						}*/
						var soundclassRef:Class = getDefinitionByName(itemSound) as Class;
						var snd:Sound = new soundclassRef() as Sound;
						SoundPlayer.instance.startSound(snd, 0.5, 0);
						tileVO._isLoved = true;
					}
				}
			}
		}
		/** if we click on a tile with the pickup Truck 
		 *  it is for gathering "mature" animals only for sale - removes them from the grid*/
		//public function doPickup(currentItemVO:ItemVO, selectedItemVO:ItemVO, clickedTile:IsoObject, clickedPosition:Point3D):void{
		///public function doPickup(currentItemVO:ItemVO, clickedTile:IsoObject, clickedPosition:Point3D):void{
		public function doHarvest(clickedTile:IsoObject):void{
			var clickedPosition:Point3D = clickedTile.position;
			var currentTile:GraphicTile = clickedTile as GraphicTile;
			var classRef:Class = currentTile._classRef;
			
			if (classRef != null){
				var mc:MovieClip = new classRef() as MovieClip;
				mc.mouseEnabled = false;
				trace("classRef:" + classRef);
				
				var currentTileName:String = flash.utils.getQualifiedClassName( mc );
				if (currentTileName == "BigBarn"){
					currentTileName = "Barn";
				}
				if (currentTileName == "BigFarmhouse"){
					currentTileName = "Farmhouse";
				}
				var currentItemVO:ItemVO = TileManager.getCurrentItemVO(currentTileName);
				
				
				
				if (currentItemVO._layer == "world"){
					var tileID:int;
					var floorData:Array;
					var tileVO:TileVO;
					if(currentItemVO._itemType=="animal"){
						_isoWorld.removeChildFromWorld(clickedTile);
						
						tileID = clickedTile._node._id;
						if (_gridVO != null){
							floorData = _gridVO._floorData;
							tileVO = floorData[tileID];
							tileVO._furnitureClassName = "";
							tileVO._tileClassName = "";
							tileVO._walkable = "true";
							tileVO._grown = false;
							tileVO._isFed = false;
							tileVO._isLoved = false;
							
							var i2:int = tileVO._col;
							var k2:int = tileVO._row; 
							
							_grid.setWalkable(i2, k2, true);
							
							var itemReference:Class = getDefinitionByName("EarthPatch") as Class;
							//how much does the item we're destroying cost? Should cost half that much to destroy it...
							var price:Number = currentItemVO._price;
							var harvestPrice:Number = price * 3;
							
							ModelLocator.getInstance()._farmBucks += harvestPrice;
							trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
							//HACK - FIX AT SOME POINT
							//$$$ should be a property of the ItemVO = publicName
							/*var publicName:String;
							if (currentItemVO._itemName == "SheepLeft" || currentItemVO._itemName == "SheepHarvestable" || currentItemVO._itemName == "SheepLeftHarvestable"){
							publicName = "sheep";
							}else if (currentItemVO._itemName == "CowLeft"){
							publicName = "cow";
							}else{
							publicName = currentItemVO._itemName;
							}*/
							//JSAlert.showAlert("You just harvested a " + publicName + " for " + harvestPrice + " Farmbucks!");
							var statusAlert:String = "Y'all just harvested a " + currentItemVO._prettyName + " for " + harvestPrice + " Farmbucks! Yee-ha!";
							dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
							
							dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
							
							var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, itemReference, 20, 10, "floor");
							_isoWorld.addChildToFloor(tile);
							
							
							tile.x = clickedPosition.x;
							tile.y = clickedPosition.y;
							tile.z = clickedPosition.z;
							
							tile.walkable = true;
							
							updateNodes(tileID, floorData, tile, clickedTile._node);
							if (currentItemVO._overlapArray.length !=0){
								///if (currentItemVO._numTiles > 1){
								TileManager.updateTiles(currentItemVO, tileID, floorData, "true", _grid);
							}
						}
					}else{//can only harvest animals at world level
						//clicking on a world object that's NOT an animal
						///JSAlert.showAlert("you can't use the Pickup Truck here");
						dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, "Y'all can't use that dagblamed PickUp Truck here!"));
						return;
					}
				}else if (currentItemVO._layer == "floor"){
					tileID = clickedTile._node._id;
					/*if (_gridVO != null){
					floorData = _gridVO._floorData;
					tileVO = floorData[tileID];
					var walkable:String = tileVO._walkable;
					}*/
					
					
					
					
					if (_gridVO != null){
						floorData = _gridVO._floorData;
						tileVO = floorData[tileID];
						//is this a harvestable tile type?
						if(tileVO._grown==true){
							
							var harvestPrice:Number = currentItemVO._sellPrice;
							ModelLocator.getInstance()._farmBucks += harvestPrice;
							//HACK - FIX AT SOME POINT
							//$$$ should be a property of the ItemVO = publicName
							/*var publicName:String;
							if (currentItemVO._itemName == "GrownWheat"){
							publicName = "some wheat";
							}else if (currentItemVO._itemName == "GrownCorn"){
							publicName = "some corn";
							}*/
							//JSAlert.showAlert("You just harvested a " + publicName + " for " + harvestPrice + " Farmbucks!");
							var statusAlert:String = "You done harvested " + currentItemVO._prettyName + " for " + harvestPrice + " Farmbucks! Yahoo!";
							dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, statusAlert));
							trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
							dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
							_isoWorld.removeChildFromFloor(clickedTile);
							
							tileID = clickedTile._node._id;
							if (_gridVO != null){
								floorData = _gridVO._floorData;
								tileVO = floorData[tileID];
								tileVO._furnitureClassName = "";
								tileVO._tileClassName = "";
								tileVO._walkable = "true";
								tileVO._grown == false;
								tileVO._isLoved = true;
								
								var i2:int = tileVO._col;
								var k2:int = tileVO._row; 
								
								_grid.setWalkable(i2, k2, true);
								
								var itemReference:Class = getDefinitionByName("EarthPatch") as Class;
								//how much does the item we're destroying cost? Should cost half that much to destroy it...
								var price:Number = currentItemVO._price;
								var destroyPrice:Number = Math.ceil(price/2);
								
								ModelLocator.getInstance()._farmBucks -= destroyPrice;
								trace("ModelLocator.getInstance()._farmBucks: " + ModelLocator.getInstance()._farmBucks);
								dispatchEvent(new DataEvent(DataEvent.PURCHASE_ITEM));
								
								var tile:GraphicTile = new GraphicTile(ModelLocator.getInstance()._cellSize, itemReference, 20, 10, "floor");
								_isoWorld.addChildToFloor(tile);
								
								
								tile.x = clickedPosition.x;
								tile.y = clickedPosition.y;
								tile.z = clickedPosition.z;
								
								tile.walkable = true;
								
								updateNodes(tileID, floorData, tile, clickedTile._node);
								if (currentItemVO._overlapArray != null){
									if (currentItemVO._overlapArray.length !=0){
										///if (currentItemVO._numTiles > 1){
										TileManager.updateTiles(currentItemVO, tileID, floorData, "true", _grid);
									}
								}
							}
							
						}else if (tileVO._occupierID != 0){
							//need to convert occupierID to find the clickedTile and it's position
							var occupyingTileVO:TileVO = floorData[tileVO._occupierID];
							var occupyingTile:IsoObject = _grid._nodes[occupyingTileVO._col][occupyingTileVO._row];
							destroyTile(occupyingTile, occupyingTile.position, "PickupTruck");
						}else{
							///JSAlert.showAlert("you can't use the PickUp Truck here");
							dispatchEvent(new DataEvent(DataEvent.STATUS_UPDATE, "Y'all can't use the PickUp Truck here!"));
						}
						
					}
					
				}
			}
		}
	}
}