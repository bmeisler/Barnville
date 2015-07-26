package com.evili.utils{
 /**
 * <p>
 * Creates a Map with name/value pairs that can be added and removed at will
 * </p>
 *
 * @author <a href="mailto:bernard@meisler.net">Bernard Meisler</a>
 */
	public class Map {
		private var _size:Number = 0;
		private var _key:String;
		private var _value:Object;
		private var ASTERISK:String = "*";
		/**
		     * The minimum number of words needed to reach a leaf node from here.
		     * Defaults to zero.
		     */
		private var _height:Number = 0;
		private var _map:Object;
		public function Map () {
			_map = new Object ();
		}
		public function get key ():String {
			return _key;
		}
		public function get map():Object{
			return _map;
		}
		/**
		     * Puts the given object into the Map, associated with the given key.
		     * 
		     * @param keyToUse the key to use
		     * @param valueToPut the value to put
		     * @return the same object that was put into the Nodemaster
		     */
		public function put (keyToUse:String, valueToPut:Object):Object {
			_key = keyToUse.toUpperCase ();
			_map[_key] = valueToPut;
			_value = valueToPut;
			_size++;
			return _value;
		}
		/**
		     * Removes the given object from the Nodemaster.
		     * 
		     * @param keyToCheck the name of the object to remove
		     */
		//public function remove (valueToRemove:Object):Void {
			
		    public function remove (keyToCheck:String):void {
			//trace("Map:::containsKey: keyToCheck: " + keyToCheck);
				for (var prop:Object in _map) {
					if (prop == keyToCheck.toUpperCase ()) {
						var foundKey:Boolean = true;
						//trace("foundKey: " + foundKey);
						delete _map[prop];
						_size--;
					}
				}
		    }
			//return false;
			
			//trace("Nodemaster:::remove::valueToRemove: "+valueToRemove);
			/*
			if (this.size > 1) {
				// Find the key for this value.
				var keyToRemove:String = null;
				for (var prop in map) {
					var currentValue:Object = map[prop];
					if (valueToRemove == currentValue) {
						keyToRemove = prop;
						break;
					}
				}
				//trace("Nodemaster:::Remove::keyToRemove: "+keyToRemove);
				if (keyToRemove == null) {
					// We didn't find a key.
					trace ("ERROR: Key was not found for value when trying to remove.");
				}
				if (this.size > 2) {
					// Remove the value from the HashMap (ignore the primary
					// value/key pair).
					map[keyToRemove] = null;
					this.size--;
				} else {
					// Remove this item from the HashMap.
					map[keyToRemove] = null;
					// Set the last item in HashMap to be the primary value/key for
					// this Nodemapper.
					//this.key = this.hidden.keySet().iterator().next();
					//this.value = this.hidden.remove(this.key);
					// Remove the empty HashMap to save space.
					//this.hidden = null;
					this.size = 1;
				}
			} else if (this.size == 1) {
				this.value = null;
				this.key = null;
				this.size = 0;
			}
			*/
		
		/**
		     * Gets the object associated with the specified key.
		     * NOTE: traditional language, this function should be called GET
		     * 
		     * @param keyToGet the key to use
		     * @return the object associated with the given key
		     */
		public function getValue (keyToGet:String):Object {
			//trace("Map:::get: keyToGet: " + keyToGet);
			for (var prop:Object in _map) {
				if (prop == keyToGet.toUpperCase ()) {
					var currentValue:Object = _map[prop];
					//trace("currentValue: " + currentValue);
					return currentValue;
				}
			}
			return null;
		}
		public function getKeys():Array{
			var keys:Array = new Array();
			for (var prop:String in _map) {
				keys.push(prop);
			}
			return keys;
		}
		/**
		     * @param keyToCheck the key to check
		     * @return whether or not the Map contains the given key
		     */
		public function containsKey (keyToCheck:String):Boolean {
			//trace("Map:::containsKey: keyToCheck: " + keyToCheck);
			for (var prop:Object in _map) {
				if (prop == keyToCheck.toUpperCase ()) {
					var foundKey:Boolean = true;
					//trace("foundKey: " + foundKey);
					return foundKey;
				}
			}
			return false;
		}
		/**
		     * @return the size (number of entries) of the Map
		     */
		public function get size ():Number {
			return _size;
		}
	}
}
