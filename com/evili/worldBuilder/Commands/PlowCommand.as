package com.evili.worldBuilder.Commands
{
	import com.evili.worldBuilder.controllers.TileController;
	import com.friendsofed.isometric.IsoObject;

	public class PlowCommand implements ICommand
	{
		private var _tileController:TileController;
		private var _clickedTile:IsoObject;
		public function PlowCommand(tileController:TileController, clickedTile:IsoObject)
		{
			_tileController = tileController;
			_clickedTile = clickedTile;
		}
		
		public function execute():void
		{
			_tileController.doPlow(_clickedTile);
		}
	}
}