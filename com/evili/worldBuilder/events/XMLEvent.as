package com.evili.worldBuilder.events {
	import flash.events.Event;
	
	/** all-purpose event class for passing data in the form of
	 * a generic object when an event is completed */
	public class XMLEvent extends Event {
		public static const XML_COMPLETE:String = "xmlComplete";
		private var _xml:XML;
		
		public function XMLEvent(type:String, xml:XML)
		{
			super(type, bubbles, cancelable);
			_xml = xml;
		}
		public function get xml():Object{
			return _xml;
		}
	}
}