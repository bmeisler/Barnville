package com.evili.worldBuilder.controllers
{
	/** will manage the walkability etc of tiles adjacent to a multi-tile object
	 *  such as a barn or a horse.
	 *  NOTE: instead of checking for direciton, or if multi-tiles ==4, should have
	 *  an array of tile ids, eg, for a 4 tile object: {-1, 19, 20}
	 *  for a right-facing object: {20}
	 *  for a left-facing object: {1} etc
	 *  then we would just go through the array, without worry about these other types */
	import com.evili.worldBuilder.model.ItemVO;
	import com.evili.worldBuilder.model.TileVO;
	import com.friendsofed.pathfinding.Grid;
	
	import com.evili.worldBuilder.model.ModelLocator;

	public class TileManager
	{
		public function TileManager()
		{
		}
		public static function updateTiles(currentItemVO:ItemVO, tileID:int, floorData:Array, walkable:String, _grid:Grid):void{
			var i2:int;
			var k2:int;
			var tileVO:TileVO;
			var walkableBoolean:Boolean
			if (walkable == "true"){
				walkableBoolean = true;
			}else{
				walkableBoolean = false;
			}
			var overlapArray:Array = currentItemVO._overlapArray
			for (var i:uint = 0; i < overlapArray.length; i++){
				var curID:int = overlapArray[i];
				tileVO = floorData[tileID+curID];
				if (tileVO != null){
					tileVO._furnitureClassName = "";
					tileVO._walkable = walkable;
					if (walkable == "true"){
						tileVO._occupiedBy = "";
						tileVO._occupierID = 0;
					}else{
						tileVO._occupiedBy = currentItemVO._itemName;
						tileVO._occupierID = tileID;
					}
					i2 = tileVO._col;
					k2 = tileVO._row;
					_grid.setWalkable(i2, k2, walkableBoolean);
				}
			}
			
		}
		 /** gets all the item info for the clicked item*/
		public static function getCurrentItemVO(selectedItem:String):ItemVO{
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
		}
	}
}