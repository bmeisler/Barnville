package com.evili.Shell
{
	import com.evili.worldBuilder.model.ModelLocator;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class StoreDemoModule extends MovieClip
	{
		private var _container:ContainerBG;
		public function StoreDemoModule()
		{
			super();
			_container = new ContainerBG();
			_container.draw(0xffffaa, 0, 0, 250, 150);
			addChild(_container);
			makeIcons();
		}
		private function makeIcons():void{
			
			var cat:Cat = new Cat();
			cat.addEventListener(MouseEvent.CLICK, onSelectItem);
			cat.y = 40;
			_container.addChild(cat);
			
			var chicken:Chicken = new Chicken();
			chicken.addEventListener(MouseEvent.CLICK, onSelectItem);
			_container.addChild(chicken);
			chicken.y = 80;
			chicken.x = 0;
			
			var sheep:Sheep = new Sheep();
			sheep.addEventListener(MouseEvent.CLICK, onSelectItem);
			_container.addChild(sheep);
			sheep.y = 120;
			sheep.x = 0;
			//2nd cold
			var cornPatch:CornPatch = new CornPatch();
			cornPatch.addEventListener(MouseEvent.CLICK, onSelectItem);
			cornPatch.y = 40;
			cornPatch.x = 60;
			_container.addChild(cornPatch);

			var wheatPatch:WheatPatch = new WheatPatch();
			wheatPatch.addEventListener(MouseEvent.CLICK, onSelectItem);
			wheatPatch.y = 80;
			wheatPatch.x = 60;
			_container.addChild(wheatPatch);
			
			var grassPatch:GrassPatch = new GrassPatch();
			grassPatch.addEventListener(MouseEvent.CLICK, onSelectItem);
			grassPatch.y = 120;
			grassPatch.x = 60;
			_container.addChild(grassPatch);
			//3rd col
			
			var cow:Cow = new Cow();
			cow.addEventListener(MouseEvent.CLICK, onSelectItem);
			cow.x = 120;
			cow.y = 40;
			_container.addChild(cow);
			
			var goat:Goat = new Goat();
			goat.addEventListener(MouseEvent.CLICK, onSelectItem);
			goat.y = 80;
			goat.x = 120;
			_container.addChild(goat);
			
			var horse:Horse = new Horse();
			horse.addEventListener(MouseEvent.CLICK, onSelectItem);
			horse.y = 120;
			horse.x = 120;
			_container.addChild(horse);
			
			var dog:Dog = new Dog();
			dog.addEventListener(MouseEvent.CLICK, onSelectItem);
			dog.y = 40;
			dog.x = 180;
			_container.addChild(dog);
			
			var horseLeft:HorseLeft = new HorseLeft();
			horseLeft.addEventListener(MouseEvent.CLICK, onSelectItem);
			horseLeft.y = 80;
			horseLeft.x = 180;
			_container.addChild(horseLeft);
			
			var sheepLeft:SheepLeft = new SheepLeft();
			sheepLeft.addEventListener(MouseEvent.CLICK, onSelectItem);
			sheepLeft.y = 120;
			sheepLeft.x = 180;
			_container.addChild(sheepLeft);
		}
		private function onSelectItem(e:MouseEvent):void{
			var selectedItem:MovieClip = e.target as MovieClip;
			ModelLocator.getInstance()._selectedItem = selectedItem;
		}
	}
}