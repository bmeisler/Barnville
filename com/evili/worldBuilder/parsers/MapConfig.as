package com.evili.worldBuilder.parsers{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.*;
	import flash.utils.*;
	
	import com.evili.worldBuilder.events.XMLEvent;
	
	public class MapConfig extends EventDispatcher{
		private static var _instance:MapConfig;
		private static const MAP_PARSE_COMPLETE:String = "mapParseComplete";
		
		private var _XML_URL:String;
		
		private var contentXMLURL:URLRequest;
		private var contentXMLLoader:URLLoader;
		
		
		
		public function MapConfig() {
		}
		/* ensures class is a singleton */
		public static function getInstance():MapConfig{
			if(_instance == null){
				_instance = new MapConfig();
			}
			return _instance;
		}
		public function set XML_URL(s:String):void{
			_XML_URL = s;
		}
		public function init():void{
			contentXMLURL = new URLRequest(_XML_URL);
			contentXMLLoader = new URLLoader(contentXMLURL);
			contentXMLLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			contentXMLLoader.load(contentXMLURL);
		}
		private function xmlLoaded(event:Event):void{
			var xml:XML = new XML(event.target.data);
			dispatchEvent(new XMLEvent(XMLEvent.XML_COMPLETE, xml));
				
				
		}
	}
}