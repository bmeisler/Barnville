package com.evili.worldBuilder.parsers
{
	//import com.evili.world.Library;
	//import com.evili.world.MapConfig;
	import com.evili.worldBuilder.events.DataEvent;
	import com.evili.worldBuilder.events.XMLEvent;
	import com.evili.worldBuilder.model.GridVO;
	import com.evili.worldBuilder.model.TileVO;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	public class MapParser extends EventDispatcher {
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
	
		public function MapParser(target:IEventDispatcher=null) {
			super(target);
		}
	
		/** called after we have selected a room and received
		 * confirmation from the socket that it was joined successfully */
		public function loadMapXML(url:String):void{
			trace("MapParser:::loadMapXML::url: " + url);
			var mapConfig:MapConfig = MapConfig.getInstance();
			mapConfig.XML_URL = url;
			mapConfig.init();
			//mapConfig.addEventListener(XMLEvent.XML_COMPLETE, onParsedMapXMLLibrary);
			mapConfig.addEventListener(XMLEvent.XML_COMPLETE, onLoadXMLMap);
		}
		/** use this to pass a local, embedded xml object to this parsing
		 *  class, instead of importing an external xml document */
		public function useLocalXMLData(xml:XML):void{	
			
			mapXML = xml;
			onParsedMapXMLLibrary();
		}
		/**
	 * event generated when the map XML is loaded
	 * 
	 * @param 	success ({@code Boolean})
	 */
	//private function onLoadXMLMap(success:Boolean):Void{
	private function onLoadXMLMap(xmlEvent:XMLEvent):void{	

			mapXML = xmlEvent.xml as XML;
		/* if (!success) {
			trace("ERROR: World.loadXMLMap: Unable to load/parse XML.");
		}else{ */
			if (mapXML.status == 0) {
				trace("XML was loaded and parsed successfully");
			} else {
				trace("ERROR: World.loadXMLMap: XML was loaded successfully, but was unable to be parsed.");
			}
				
			var errorMessage:String;
			switch (mapXML.status) {
				case 0 : 	errorMessage = "No error; parse was completed successfully.";	break;
				case -2 :	errorMessage = "A CDATA section was not properly terminated."; break;
				case -3 :	errorMessage = "The XML declaration was not properly terminated.";	break;
				case -4 :	errorMessage = "The DOCTYPE declaration was not properly terminated.";	break;
				case -5 :	errorMessage = "A comment was not properly terminated.";	break;
				case -6 :	errorMessage = "An XML element was malformed.";	break;
				case -7 :	errorMessage = "Out of memory.";	break;
				case -8 :	errorMessage = "An attribute value was not properly terminated."; break;
				case -9 :	errorMessage = "A start-tag was not matched with an end-tag."; break;
				case -10 :	errorMessage = "An end-tag was encountered without a matching	start-tag."; break;
				default :    errorMessage = "An unknown error has occurred.";	break;
			}
			trace("status: "+mapXML.status+" ("+errorMessage+")");
			//if (mapXML.status==0){
				this.parseMapXMLLibrary();
			//}
		}
		/**
		 * this function does:
		 * maps are for the rooms, eg chat_levee.xml
		 * 1 - "finds" the <library> tag in the XML of the map, and parses it
		 * the library tag has an url for each kind of item, floor, furniture, etc
		 * 2 - creates a new object ({@link Library}) - we will create a new array of urls
		 * to retrieve all the items when the time comes
		 * These arrays should actually be stores in the settings Files, eg
		 * TileSettings, FurnitureSettings, etc, instead of being stored in the library and then
		 * retrieved from them based on a libID and symbolID property
		 * 3 - generates an event when the parcing is over - this.onParsedMapXMLLibrary();
		 */
		private function parseMapXMLLibrary():void{
	
			urlArray = new Array();
			
			for each (var l:XML in mapXML..lib){
				var url:String = String(l.@url);
				urlArray.push(url);
			}
		
			var length:Number = urlArray.length;
			onParsedMapXMLLibrary();
			//NOTE: need a service class here to load all these libraries sequentially
			/* var library:Library = Library.getInstance();
			for(var i:Number=0; i<length; i++){
				library.addLibrary(urlArray[i]);
				//library.addEventListener("parseComplete", parseComplete);
				library.addEventListener("charParseComplete", parseComplete);
			} */
			
			//onParsedMapXMLLibrary(mapXML);
		}
		/* private function parseComplete(event:Event):void{
			numItems++;
			if (numItems < urlArray.length){
				//var library:Library = Library.getInstance();
				//library.addLibrary(urlArray[numItems]);
				//library.addEventListener("parseComplete", parseComplete);
				trace("waiting for all library items to complete parsing");
			}else{
				onParsedMapXMLLibrary();
			}
		} */
		
		
		
		
		/** called when the map xml file has completed loading
		 *  we will now load the xml files for the floor, furniture, etc
		 *  for the room (eg chat_levee.xml) we are loading
		 * */
		private function onParsedMapXMLLibrary():void{
			///var mapInfo:Object = this.parseMapXML();
			var gridVO:GridVO = this.parseMapXML();
			// parameters for a specific GUI -----------------------------------
			
			/*
			var dY:Number = 20;
			mapInfo.masking = false;
			mapInfo.maskMinX = 15;
			mapInfo.maskMinY = -mapInfo.wOrigin.y + dY;
			//mapInfo.maskMinX = 0;
			//mapInfo.maskMinY = 0;
			mapInfo.maskMaxX = 765; 
			mapInfo.maskMaxY = 485;
			
			mapInfo.scrollX = 17;
			mapInfo.scrollY = 29;
			// -----------------------------------------------------------------
			
			if(mapInfo.sizeX < mapInfo.scrollX){
				//mapInfo.wOrigin.x = (mapInfo.scrollX - mapInfo.sizeX) *(Constants.TILE_HEIGHT*3)/2;  
				mapInfo.wOrigin.x = 300;
			}
			if(mapInfo.sizeY < mapInfo.scrollY){
				//mapInfo.wOrigin.y = (mapInfo.scrollY - mapInfo.sizeY) *(Constants.TILE_HEIGHT*2.5)/2 + dY;
				mapInfo.wOrigin.y = 300;
			}
			*/
			///this.dispatchEvent(new DataEvent(DataEvent.DATA_COMPLETE, mapInfo));
			this.dispatchEvent(new DataEvent(DataEvent.DATA_COMPLETE, gridVO));
		}
		
		/**
	 * Parses the loaded XML of a map
	 * We now parse the floor, furniture and character nodes of the room (eg chat_levee.xml)
	 * file. This is just basic tile information, eg, row and column number.
	 * We store this information in TileSettings, FloorSettings, etc.
	 * @return returns Object that contains the attributes needed to generate the new World
	 */
		///private function parseMapXML():Object{
		private function parseMapXML():GridVO{
			///var mapInfo: Object = new Object();
			var gridVO:GridVO = new GridVO();
			/*mapInfo.wOrigin = new Point(Number(mapXML..wOrigin.@x), Number(mapXML..wOrigin.@y));
			mapInfo.sizeY = Number(mapXML..info.@rows);
			mapInfo.sizeX = Number(mapXML..info.@cols);
			mapInfo.name = String(mapXML..info.@name);*/
			gridVO._origin = new Point(Number(mapXML..wOrigin.@x), Number(mapXML..wOrigin.@y));
			gridVO._numRows = Number(mapXML..info.@rows);
			gridVO._numCols = Number(mapXML..info.@cols);
			gridVO._roomName = String(mapXML..info.@name);
			//bg
			/*mapInfo.mapBGImage = {};
			mapInfo.mapBGImage.url = String(mapXML..bg.@image);
			mapInfo.mapBGImage._x = Number(mapXML..bg.@_x);
			mapInfo.mapBGImage._y = Number(mapXML..bg.@_y);
			mapInfo.mapBGImage = {};*/
			var mapBGImageObject:Object = {};
			mapBGImageObject.url = String(mapXML..bg.@image);
			mapBGImageObject.x = Number(mapXML..bg.@_x);
			mapBGImageObject.y = Number(mapXML..bg.@_y);
			gridVO._bgImage = mapBGImageObject;
			//fg
			/*mapInfo.mapFGImage = {}; 
			mapInfo.mapFGImage.url = String(mapXML..fg.@image);
			mapInfo.mapFGImage._x = Number(mapXML..fg.@_x);
			mapInfo.mapFGImage._y = Number(mapXML..fg.@_y); */
			var mapFGImage:Object = {}; 
			mapFGImage.url = String(mapXML..fg.@image);
			mapFGImage._x = Number(mapXML..fg.@_x);
			mapFGImage._y = Number(mapXML..fg.@_y);
			gridVO._fgImage = mapFGImage;
			
			/*mapInfo.aFloor = new Array();
			mapInfo.aFurniture = new Array();
			mapInfo.aCharacters = new Array();*/
			var floorData:Array = new Array();
			var furnitureData:Array = new Array();
			var characterData:Array = new Array();
			//gather the floor info
			for each (var ti:XML in mapXML..t){
				var tileVO:TileVO = new TileVO();
				tileVO._col = Number(ti.@col);
				tileVO._row = Number(ti.@row);
				tileVO._elevation = Number(ti.@elevation);
				tileVO._walkable = String(ti.@walkable);
				tileVO._tileClassName = String(ti.@tile);
				tileVO._furnitureClassName = String(ti.@furniture);
				/*var tileSettingsArray:Array = new Array(col, row, tileClass, walkable, elevation, furnitureClass);*/
				floorData.push(tileVO);
				
				/*var col:Number = Number(ti.@col);
				var row:Number = Number(ti.@row);
				var elevation:Number = Number(ti.@elevation);
				var walkable:String = String(ti.@walkable);
				var tileClass:String = String(ti.@tile);
				var furnitureClass:String = String(ti.@furniture);
				var tileSettingsArray:Array = new Array(col, row, tileClass, walkable, elevation, furnitureClass);*/
				///mapInfo.aFloor.push(tileSettingsArray);
				/*floorData.push(tileSettingsArray);
*/			}
			
			
			gridVO._floorData = floorData;
			return gridVO;
		}
	}
}