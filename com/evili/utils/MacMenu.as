package com.evili.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MacMenu extends Sprite
	{
		public static const MENU_CLICK:String = "menu_click";
		
		public var clickedItem:String;
		
		private var template:Object;
		
		private var icon_min:Number;
		private var icon_max:Number;
		private var icon_size:Number;
		private var icon_spacing:Number;
		private var nWidth:Number;
		private var amplitude:Number;
		private var scale:Number;
		private var span:Number;
		private var ratio:Number;
		private var trend:Number;
		private var xmouse:Number;
		private var ymouse:Number;
		private var layout:String;
		private var items:Array;
		private var xhz:Array;
		private var tray:Sprite;		
		
		public function MacMenu(template:Object)
		{
			this.template = template;
			init();
		}
		
		public function redraw(update:Object):void
		{
			this.template = update;
			init();
		}
		
		private function init():void
		{
			setParams();
			setLayout();
			destroyIcons();
			createIcons();
			createTray();
			////this.addEventListener(Event.ENTER_FRAME, monitorMenu);
		}
		
		private function setParams():void
		{
			this.icon_min = template.icon_min;
			this.icon_max = template.icon_max;
			this.icon_size = template.icon_size;
			this.icon_spacing = template.icon_spacing;
			this.amplitude = getAmplitude();//template.amplitude;
			this.span = getSpan();//template.span;
			this.ratio = geRatio();//template.ratio;
			this.trend = template.trend;
			this.layout = template.layout;
			this.items = template.items;
			xhz = new Array(); 
		}
		
		private function getSpan():Number
		{
			return (icon_min - 16) * (240 - 60) / (96 - 16) + 60;
		}
		
		private function getAmplitude():Number
		{
			return 2 * (icon_max - icon_min + icon_spacing);
		}
		
		private function geRatio():Number
		{
			return Math.PI / 2 / span;
		}
		
		private function setLayout():void
		{
			switch(layout)
			{
				case "left":
					this.rotation = 90;
					break;
				
				case "top":
					this.rotation = 180;
					break;
				
				case "right":
					this.rotation = 270;
					break;
				
				default:
					this.rotation = 0;
					break;
			}
		}
		
		public function getLayout():String
		{
			return layout;
		}
		public function removeEventListeners():void{
			this.removeEventListener(Event.ENTER_FRAME, monitorMenu);
		}
		public function destroyIcons():void
		{
			if ( this.numChildren > 0 )
			{
				var l:Number = this.numChildren;				
				this.removeEventListener(Event.ENTER_FRAME, monitorMenu);
				
				for ( var i:Number = l-1; i > 0; i-- )
				{
					removeChild(getChildAt(i));
				}
				removeChild(tray);
			}
		}
		
		private function createIcons():void
		{
			var id:String;
			scale = 0;
			nWidth = (items.length - 1) * icon_spacing + items.length * icon_min;
			var left:Number = (icon_min - nWidth) / 2;

			for ( var i:Number = 1; i < items.length + 1; i++ )
			{
				var container:Sprite = new Sprite();
				container.name = String(i);
				addChildAt(container, i-1);
				var mc:DisplayObject = container.addChild(items[i-1].id);
				mc.name = String(items[i-1].id);
				
				
				var itemLabel:TextField = new TextField();
				var myformat:TextFormat = new TextFormat();
				myformat.size = 12;
				myformat.color = 0xff0000;
				itemLabel.text = items[i-1].label;
				itemLabel.setTextFormat(myformat);
				///container.addChild(itemLabel);
				addChild(itemLabel);
				
				
				
				var cont = getChildByName(String(i));
				cont.getChildByName(items[i-1].id).y = -icon_size / 2;
				cont.getChildByName(items[i-1].id).rotation = -this.rotation;
				cont.x = xhz[i-1] = left + (i-1) * (icon_min + icon_spacing) + icon_spacing / 2;
				cont.y = -icon_spacing;
				cont.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				cont.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				cont.addEventListener(MouseEvent.CLICK, onClick);
				
				///cont.addChild(itemLabel);
				itemLabel.x = xhz[i-1] = left + (i-1) * (icon_min + icon_spacing) + icon_spacing / 2;
				itemLabel.y = -icon_spacing-10;
				
			}
		}
		
		private function onOver(event:MouseEvent):void
		{
			// Handle onOver event if needed.
		}
		
		private function onOut(event:MouseEvent):void
		{
			// Handle onOut event if needed.
		}
		
		private function onClick(event:MouseEvent):void
		{
			var d:DisplayObject = event.target as DisplayObject;
			trace("d: "  + d);

				clickedItem = items[event.target.parent.name - 1].label
				dispatchEvent( new Event(MacMenu.MENU_CLICK) );
			
		}
		
		private function createTray():void
		{
			var height:Number = icon_min + 2 * icon_spacing;
			var width:Number = nWidth + 2 * icon_spacing;
			tray = new Sprite();
			tray.name = "tray";
			tray.graphics.lineStyle(0, 0xcccccc, 0.8);
			tray.graphics.beginFill(0xe8e8e8, 0.5);
			tray.graphics.drawRect(0, 0, width, -height);
			tray.graphics.endFill();
			addChildAt(tray, 0);
		}
		
		private function monitorMenu(event:Event = null):Boolean
		{
			var dx:Number;
			var dim:Number;
			
			// Mouse did not move and Dock is not between states. Skip rest of the block.
			if ( (xmouse == this.mouseX) && (ymouse == this.mouseY) && 
			   ( (scale <= 0.01) || (scale >= 0.99) ) ) 
			{
				//return false; 
			}
			
			// Mouse moved or Dock is between states. Update Dock.
			xmouse = this.mouseX;
			ymouse = this.mouseY;
			
			// Ensure that inflation does not change direction.
			trend = (trend == 0 ) ? (checkBoundary() ? 0.25 : -0.25) : (trend);
			scale += trend;
			if( (scale < 0.02) || (scale > 0.98) ) 
			{ 
				trend = 0; 
			}
			
			// Actual scale is in the range of 0..1
			scale = Math.min( 1, Math.max(0, scale) );
			
			// Hard stuff. Calculating position and scale of individual icons.
			for( var i:Number = 1; i < items.length+1; i++) 
			///for( var i:Number = 1; i < this.numChildren; i++) 
			{
				dx = xhz[i-1] - xmouse;
				dx = Math.min( Math.max(dx, - span), span);
				dim = icon_min + (icon_max - icon_min) * Math.cos(dx * ratio) * (Math.abs(dx) > span ? 0 : 1) * scale;
				getChildAt(i).x = xhz[i-1] + scale * amplitude * Math.sin(dx * ratio);
				getChildAt(i).scaleX = getChildAt(i).scaleY = dim / icon_size;
			}
			updateTray();
			return true;
		}
		
		private function checkBoundary():Boolean
		{
			var buffer:Number = 4 * scale;
			return (ymouse < 0)
			&& (ymouse > -2 * icon_spacing - icon_min + (icon_min - icon_max) * scale)
			&& (xmouse > getChildAt(1).x - getChildAt(1).width / 2 - icon_spacing - buffer)
			&& (xmouse < getChildAt(items.length).x + getChildAt(items.length).width / 2 + icon_spacing + buffer);
		}
		
		private function updateTray():void
		{
			var x:Number;
			var w:Number;
			x = getChildAt(1).x - getChildAt(1).width / 2 - icon_spacing;
			w = getChildAt(items.length).x + getChildAt(items.length).width / 2 + icon_spacing;
			getChildByName("tray").x = x;
			getChildByName("tray").width = w - x;
		}
	}
}