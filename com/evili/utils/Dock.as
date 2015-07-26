package com.evili.utils
{	
	import com.evili.worldBuilder.model.ModelLocator;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;

	public class Dock extends Sprite
	{
		public static const SELECT_ITEM:String = "selectItem";
		public var _selectedItem:String;
		///private var menu:MacMenu;
		private var menu:PlainMenu;
		private var template:Object;
		private var _container:DisplayObject;
		
		public function Dock(container:DisplayObject, itemList:Array = null)
		{
			init(container, itemList);
		}
		public function killMenu():void{
			menu.destroyIcons();
			///menu.removeEventListener(MacMenu.MENU_CLICK, handleClick);
			menu.removeEventListener(PlainMenu.MENU_CLICK, handleClick);
			menu.removeEventListeners();
			removeChild(menu);
			menu = null;
		}
		private function init(container:DisplayObject, itemList:Array):void
		{
			_container = container;
			//_stage.scaleMode = StageScaleMode.NO_SCALE;
			//_stage.align = StageAlign.TOP_LEFT;
			_container.addEventListener(Event.RESIZE, alignContent);
			
			template = new Object();
			template.icon_min = 48;
			template.icon_max = 96;
			template.icon_size = 72;
			template.icon_spacing = 1;
			template.trend = 0;
			template.layout = "bottom";
			if (itemList == null){
			template.items = [
								{ id: new Horse, label: "Horse"},
								{ id: new Sheep, label: "Sheep"},
								{ id: new Cow, label: "Cow"},
								{ id: new Dog, label: "Dog"},
								{ id: new Goat, label: "Goat"},
								{ id: new Chicken, label: "Chicken"},
								{ id: new Cat, label: "Cat"}
							 ];
			}else{
				template.items = new Array();
				for (var i:int=0; i < itemList.length; i++){
					var classRef:Class = getDefinitionByName(itemList[i].name) as Class;
					var mc:MovieClip = new classRef() as MovieClip;
					var tempObject:Object = {id: mc, name: itemList[i].name, price: itemList[i].price};
					template.items.push(tempObject);
				}
			}
							 
			///menu = new MacMenu(template);
			///menu.addEventListener(MacMenu.MENU_CLICK, handleClick);
			menu = new PlainMenu(template);
			menu.addEventListener(PlainMenu.MENU_CLICK, handleClick);
			this.addChild(menu);
			
			// To change menu params - modify template object,
			// and call redraw method on menu :
			//
			//template.items.pop();
			//menu.redraw(template);
			
			alignContent();
		}
		
		private function handleClick(e:Event):void
		{
			trace(menu.clickedItem);
			_selectedItem = menu.clickedItem;
			dispatchEvent(new Event(Dock.SELECT_ITEM));
			//var selectedItem:MovieClip = e.target as MovieClip;
			//ModelLocator.getInstance()._selectedItem = selectedItem;
		}
		
		private function alignContent(event:Event = null):void
		{
			//var w:Number = _stage.stageWidth;
			//var h:Number = _stage.stageHeight;
			var w:Number = _container.width;
			var h:Number = _container.height;
			
			if ( menu != null )
			{
				switch( template.layout )
				{
					case "bottom":
						menu.x = w / 2;
						menu.y = h;
						break;
					
					case "right":
						menu.x = w;
						menu.y = h / 2;
						break;
					
					case "left":
						menu.x = 0;
						menu.y = h / 2;
						break;
					
					case "top":
						menu.y = 0;
						menu.x = w / 2;
				}
			}
		}
	}
}
