package com.evili.worldBuilder.model
{
	/** this class stores all the information about a particular item
	 *  it's associated class, name, price, sound, etc*/

	
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.utils.*;
	
	public class ItemVO {
		/** name of the class associated with this item*/
		public var _itemName:String;
		/** the class reference for this item*/
		public var _itemClass:Class;
		/** how many tiles does the object cover?*/
		public var _numTiles:int;
		/** if the object covers two tiles, does it face left or right?*/
		public var _direction:String;
		/**how much does the object cost to buy? That is, what does the user pay to place this on the grid?*/
		public var _price:Number;
		/**sound class name associated with the item*/
		public var _itemSoundClassName:String;
		/** sound class assocaited with this item*/
		public var _itemSoundClass:Class;
		/**messages associated with this item*/
		public var _itemMessages:Array;
		/** what type of item is this? Animal, vehicle, building, tile, etc?*/
		public var _itemType:String;
		/** what layer does it go on (currently just two, could have more*/
		public var _layer:String;
		/** is the tile walkable? (Only types of "tile" should set this - everything on the world level is non-walkable)*/
		public var _walkable:Boolean;
		/** which tiles (based on current ID) does this tile overlap?*/
		public var _overlapArray:Array;
		/** how much can we sell this item for once it has matured? That is, how many points do we get when we remove the mature version from the grid?*/
		public var _sellPrice:int;
		/** how long, in seconds, does it take to mature?*/
		public var _growTime:int;
		/** is this item for sale? If not, don't add to the store dock
		 *  currently, this specifically refers to EarthPatch and GrassPatch
		 *  which need to be set up in the list of ItemVOs, but should NOT show up in the store*/
		public var _forSale:Boolean = true;
		/** is this item harvestable? Eg, chicken with eggs, sheep with wool, as opposed to a dog, cat, etc.
		 *  AND it's also used to differentiate baby corn from grown (ready to harvest) corn*/
		public var _isHarvestable:Boolean = false;
		/** a more user-friendly name - multiple items (eg sheep, sheepLeft, sheepLeftHarvestable, etc) will share the same pretty name*/
		public var _prettyName:String;
		/** did we already add one of these? Show a special message only the first time you add one!*/
		public var _initMessage:Boolean = false;
		
		
		public function ItemVO(itemObject:Object = null) {
			if (itemObject != null){
				_itemName = itemObject._itemName
				_itemClass = itemObject._itemClass as Class;
				_numTiles = itemObject._numTiles;
				_direction = itemObject._direction;
				_price = itemObject._price;
				_itemSoundClassName = itemObject._itemSoundClassName;
				_itemSoundClass = itemObject._itemSoundClass;
				_itemMessages = itemObject._itemMessages;
				_itemType = itemObject._itemType;
				_layer = itemObject._layer;
				_walkable = itemObject._walkable;
				_overlapArray = itemObject._overlapArray;
				_sellPrice = itemObject._sellPrice;
				_growTime = itemObject._growTime;
				_prettyName = itemObject._prettyName;
				_initMessage = false;
			}
		}

	}
}