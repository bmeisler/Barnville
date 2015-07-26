package com.evili.worldBuilder.parsers
{
	//import com.evili.world.Library;
	//import com.evili.world.MapConfig;
	import com.evili.worldBuilder.events.DataEvent;
	import com.evili.worldBuilder.events.XMLEvent;
	import com.evili.worldBuilder.model.GridVO;
	import com.evili.worldBuilder.model.ItemVO;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	public class ItemParser extends EventDispatcher {
		/** list of urls to import, from first parsing
		 * includes library/furniture, library/tiles, etc */
		private var urlArray:Array;
		/** keep track of library items parsed and loaded */
		private var numItems:Number = 0;
		/**
		 * this object is used for loading and parcing the map XML. It's discarded at the end
		 */
		private var mapXML:XML;
		/** should be replaced by modelLocator!!!
		 * NOTE: fix this!!!
		 * */
		//private var library:Library;
		
		public function ItemParser(target:IEventDispatcher=null) {
			super(target);
		}
		
		/** called after we have selected a room and received
		 * confirmation from the socket that it was joined successfully */
		public function loadMapXML(url:String):void{
			trace("ItemParser:::loadMapXML::url: " + url);
			var mapConfig:MapConfig = MapConfig.getInstance();
			mapConfig.XML_URL = url;
			mapConfig.init();
			mapConfig.addEventListener(XMLEvent.XML_COMPLETE, onLoadXMLMap);
		}
		/**
		 * event generated when the map XML is loaded
		 * 
		 * @param 	success ({@code Boolean})
		 */
		private function onLoadXMLMap(xmlEvent:XMLEvent):void{	
			
			mapXML = xmlEvent.xml as XML;
			onParsedMapXMLLibrary();
		}
		public function useLocalXMLData(xml:XML):void{	
			
			mapXML = xml;
			onParsedMapXMLLibrary();
		}
		
		/** called when the map xml file has completed loading
		 *  we will now load the xml files for the floor, furniture, etc
		 *  for the room (eg chat_levee.xml) we are loading
		 * */
		private function onParsedMapXMLLibrary():void{
			var itemVOArray:Array = new Array();
			itemVOArray = this.parseMapXML();
			// parameters for a specific GUI -----------------------------------
			
			
			this.dispatchEvent(new DataEvent(DataEvent.ITEM_DATA_COMPLETE, itemVOArray));
		}
		
		/**
		 * Parses the loaded XML of a map
		 * We now parse the floor, furniture and character nodes of the room (eg chat_levee.xml)
		 * file. This is just basic tile information, eg, row and column number.
		 * We store this information in TileSettings, FloorSettings, etc.
		 * @return returns Object that contains the attributes needed to generate the new World
		 */
		///private function parseMapXML():Object{
		private function parseMapXML():Array{
			var itemVOArray:Array = new Array();
			var animalData:Array = new Array();
			var tileData:Array = new Array();
			var buildingData:Array = new Array();
			var vehicleData:Array = new Array();
			var actionData:Array = new Array();
			var cropActionData:Array = new Array();
			//gather the animal info
			for each (var currentAnimal:XML in mapXML..animal){
				var itemVO:ItemVO = new ItemVO();
				var name:String = currentAnimal.@name;
				var price:int = int(currentAnimal.@price)
				var soundClassName:String = currentAnimal.@sound;
				var numTiles:int = new int(currentAnimal.@numTiles);
				var direction:String = currentAnimal.@direction;
				var layer:String = currentAnimal.@layer;
				var isHarvestable:String = currentAnimal.@harvestable;
				var growTime:int = int(currentAnimal.@growTime);
				var forSale:String = currentAnimal.@forSale;
				var prettyName:String = currentAnimal.@prettyName;
				var overlapArray = new Array();
				for each (var currentOverlap:XML in currentAnimal.overlap){
					var overlap:Number = Number(currentOverlap.@id);
					overlapArray.push(overlap);
				}
				
				itemVO._itemName = name;
				itemVO._price = price;
				itemVO._itemSoundClassName = soundClassName;
				itemVO._direction = direction;
				itemVO._numTiles = numTiles;
				itemVO._layer = layer;
				itemVO._itemType = "animal";
				itemVO._overlapArray = overlapArray;
				itemVO._growTime = growTime;
				itemVO._prettyName = prettyName;
				if (isHarvestable == "true"){
					itemVO._isHarvestable = true;
				}else{
					itemVO._isHarvestable = false;
				}
				if (forSale == "true"){
					itemVO._forSale = true;
				}else{
					itemVO._forSale = false;
				}
				animalData.push(itemVO);
			}
			itemVOArray.push(animalData);
			//parse tiles
			for each (var currentTile:XML in mapXML..tile){
				var itemVO:ItemVO = new ItemVO();
				var name:String = currentTile.@name;
				var price:int = int(currentTile.@price)
				var soundClassName:String = currentTile.@sound;
				var numTiles:int = int(currentTile.@numTiles);
				var direction:String = currentTile.@direction;
				var layer:String = currentTile.@layer;
				var walkable:String = currentTile.@walkable;
				var sellPrice:int = int(currentTile.@sellPrice);
				var growTime:int = int(currentTile.@growTime);
				var forSale:String =currentTile.@forSale;
				var prettyName:String = currentTile.@prettyName;
				
				itemVO._itemType = "tile";
				
				itemVO._itemName = name;
				itemVO._price = price;
				itemVO._sellPrice = sellPrice;
				itemVO._growTime = growTime;
				itemVO._itemSoundClassName = soundClassName;
				itemVO._direction = direction;
				itemVO._numTiles = numTiles;
				itemVO._layer = layer;
				itemVO._prettyName = prettyName;
				if (walkable == "true"){
					itemVO._walkable = true;
				}else{
					itemVO._walkable = false;
				}
				if (forSale == "true"){
					itemVO._forSale = true;
				}else{
					itemVO._forSale = false;
				}
				
				tileData.push(itemVO);
			}
			itemVOArray.push(tileData);
			for each (var currentBuilding:XML in mapXML..building){
				var itemVO:ItemVO = new ItemVO();
				var name:String = currentBuilding.@name;
				var price:int = int(currentBuilding.@price)
				var soundClassName:String = currentBuilding.@sound;
				var numTiles:int = int(currentBuilding.@numTiles);
				var direction:String = currentBuilding.@direction;
				var layer:String = currentBuilding.@layer;
				var prettyName:String = currentBuilding.@prettyName;
				 
				itemVO._itemType = "building";
				
				var overlapArray = new Array();
				for each (var currentOverlap:XML in currentBuilding.overlap){
					var overlap:Number = Number(currentOverlap.@id);
					overlapArray.push(overlap);
				}
				
				itemVO._itemName = name;
				itemVO._price = price;
				itemVO._itemSoundClassName = soundClassName;
				itemVO._direction = direction;
				itemVO._numTiles = numTiles;
				itemVO._layer = layer;
				itemVO._overlapArray = overlapArray;
				itemVO._prettyName = prettyName;
				buildingData.push(itemVO);
			}
			itemVOArray.push(buildingData);
			for each (var currentVehicle:XML in mapXML..vehicle){
				var itemVO:ItemVO = new ItemVO();
				var name:String = currentVehicle.@name;
				var price:int = int(currentVehicle.@price)
				var soundClassName:String = currentVehicle.@sound;
				var numTiles:int = int(currentVehicle.@numTiles);
				var direction:String = currentVehicle.@direction;
				var layer:String = currentVehicle.@layer;
				itemVO._itemType = "vehicle";
				
				itemVO._itemName = name;
				itemVO._price = price;
				itemVO._itemSoundClassName = soundClassName;
				itemVO._direction = direction;
				itemVO._numTiles = numTiles;
				itemVO._layer = layer;
				vehicleData.push(itemVO);
			}
			itemVOArray.push(vehicleData);
			for each (var currentAction:XML in mapXML..action){
				var itemVO:ItemVO = new ItemVO();
				var name:String = currentAction.@name;
				var price:int = int(currentAction.@price)
				var soundClassName:String = currentAction.@sound;
				var numTiles:int = int(currentAction.@numTiles);
				var direction:String = currentAction.@direction;
				var layer:String = currentAction.@layer;
				itemVO._itemType = "action";
				
				itemVO._itemName = name;
				itemVO._price = price;
				itemVO._itemSoundClassName = soundClassName;
				itemVO._direction = direction;
				itemVO._numTiles = numTiles;
				itemVO._layer = layer;
				actionData.push(itemVO);
			}
			itemVOArray.push(actionData);
			for each (var currentAction:XML in mapXML..cropAction){
				var itemVO:ItemVO = new ItemVO();
				var name:String = currentAction.@name;
				var price:int = int(currentAction.@price)
				var soundClassName:String = currentAction.@sound;
				var numTiles:int = int(currentAction.@numTiles);
				var direction:String = currentAction.@direction;
				var layer:String = currentAction.@layer;
				itemVO._itemType = "cropAction";
				
				itemVO._itemName = name;
				itemVO._price = price;
				itemVO._itemSoundClassName = soundClassName;
				itemVO._direction = direction;
				itemVO._numTiles = numTiles;
				itemVO._layer = layer;
				cropActionData.push(itemVO);
			}
			itemVOArray.push(cropActionData);
			return itemVOArray;
		}
	}
}