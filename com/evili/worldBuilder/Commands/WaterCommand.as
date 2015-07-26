package com.evili.worldBuilder.Commands
{
	import com.evili.worldBuilder.controllers.TileController;
	import com.friendsofed.isometric.IsoObject;

	public class WaterCommand implements ICommand
	{
		private var _tileController:TileController;
		private var _clickedTile:IsoObject;
		public function WaterCommand(tileController:TileController, clickedTile:IsoObject)
		{
			_tileController = tileController;
			_clickedTile = clickedTile;
		}
		
		public function execute():void
		{
			_tileController.startGrowing(_clickedTile);
		}
	}
}