package com.evili.worldBuilder.modules{
 /**
 *  TextBubbleController class - manages text bubbles
 * 
 * @author		(C) TheoWorlds.com, 2007-2008.
 * @version		1.0
 * @date 			11.17.2008
 *
 */
	import com.evili.worldBuilder.model.ModelLocator;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	/**
	 * 
	 */
	public class TextBubbleController {
		/** in current usage, the box */
		public var targetMC:Sprite;
		/** the world, the big sprite we're sitting in */
		public var _world:Sprite;
		/**borders of map`s mask in coordinates of Stage*/
		private var globalBorders:Rectangle;
		/**
		 * 
		 * the away contains objects {intervalID:Number, textBubble:TextBubble}
		 * intervalID - the time in wich the bubble will disappear
		 * textBubble - the bubble itself
		 */
		private var aTextBubbles:Array;
		/**for names generation*/
		private var textBubbleCounter:Number = 0;
		/** contains the text bubble outline(frame) and the actual text content*/
		private var bContainer:Sprite;
		
		private var maxTextLength:Number = 100;
		private var maxBubbleLifeTime:Number = ModelLocator.getInstance()._maxBubbleLifeTime;
		private var minBubbleLifeTime:Number = ModelLocator.getInstance()._minBubbleLifeTime;
		
		/**
		 * @param target
		 */
		public function TextBubbleController(world:Sprite){
			_world = world
		///	this.targetMC = target;
			this.aTextBubbles = new Array();
		}
	
		/**
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 */
		public function setBorders(x:Number, y:Number, width:Number, height:Number):void{
			
			this.globalBorders = new Rectangle(x, y, width, height);
		}
		
		/**
		 * adds a text bubble or extends the existing one when a character says something 
		 * @param characterID
		 * @param posX
		 * @param posY
		 * @param txt
		 * @param initObj
		 */
		public function characterSay(target:Sprite, characterID: Number, posX: Number, posY: Number, txt:String, initObj:Object = null):void{
			this.targetMC = target;
			if(initObj == null)
				var initObj:Object = {};
				
			initObj.bgColor = ModelLocator.getInstance()._chatBubbleColor;
			
			var topLeftBorder:Point = new Point(globalBorders.topLeft.x, globalBorders.topLeft.y);
			this.targetMC.globalToLocal(topLeftBorder);
			var bottomRightBorder:Point = new Point(globalBorders.bottomRight.x, globalBorders.bottomRight.y);
			this.targetMC.globalToLocal(bottomRightBorder);
			
			var addedText:Boolean = false;
			var b:TextBubble = getTextBubbleByCharacterID(characterID, true);
			if(b){
				if(this.maxTextLength >= (b._text.length + txt.length)){
					txt = b._text+" "+txt;
					addedText = true;
				}				
				b.kill();
			}
			// if the character is on the screen and there is an old bubble - just replace the text
			/* if(	topLeftBorder.x > posX || 
				bottomRightBorder.x<posX ||
				posY < topLeftBorder.y ||
				posY > bottomRightBorder.y){
				return;
			} */
		
			
			var tbID:Number = this.textBubbleCounter++;
			
			var o:Object = new Object();
			
			//var t:MovieClip = this.targetMC.createEmptyMovieClip("b"+tbID, this.targetMC.getNextHighestDepth());
			var t:Sprite = new Sprite();
			targetMC.addChild(t);
			
			if(!addedText)
				//t.visible = false;		 
			 o["textBubble"] = new TextBubble(tbID, characterID, t, posX, posY, txt, initObj);
			///o["intervalID"] = setInterval(Proxy.create(this, clearTextBubble, o.textBubble), this.getBubbleLifeTime(txt.length));		
			var bubbleLifeTime:Number = this.getBubbleLifeTime(txt.length);	
			o["intervalID"] = setInterval(clearTextBubble, bubbleLifeTime, o.textBubble);		
			aTextBubbles.push(o);
			this.updateBubblePosition(characterID, posX, posY);
			
			/* var idVisible:Number = setInterval(
				function( mc:TextBubbleController,_characterID:Number, posX:Number, posY:Number, o:Object):void{
					mc.aTextBubbles.push(o);					
					mc.updateBubblePosition(_characterID, posX, posY);
					o.textBubble.containerMC.visible = true;								
					clearInterval(idVisible);
				},100, this, characterID, posX, posY, o
			);  */
		}
		/**
		 * adds a text bubble or extends the existing one when a character says something 
		 * @param characterID
		 * @param posX
		 * @param posY
		 * @param txt
		 * @param initObj
		 */
		public function systemSay(target:Sprite, characterID: Number, posX: Number, posY: Number, txt:String, initObj:Object = null):void{
		
			///this.targetMC = target;
			if(initObj == null)
				var initObj:Object = {};
			
			initObj.bgColor = ModelLocator.getInstance()._chatBubbleColor;
			
			var topLeftBorder:Point = new Point(globalBorders.topLeft.x, globalBorders.topLeft.y);
			///this.targetMC.globalToLocal(topLeftBorder);
			var bottomRightBorder:Point = new Point(globalBorders.bottomRight.x, globalBorders.bottomRight.y);
			///this.targetMC.globalToLocal(bottomRightBorder);
			
			var addedText:Boolean = false;
			var b:TextBubble = getTextBubbleByCharacterID(characterID, true);
			if(b){
				if(this.maxTextLength >= (b._text.length + txt.length)){
					txt = b._text+" "+txt;
					addedText = true;
				}				
				b.kill();
			}
		
			var tbID:Number = this.textBubbleCounter++;
			
			var o:Object = new Object();
			
			//var t:MovieClip = this.targetMC.createEmptyMovieClip("b"+tbID, this.targetMC.getNextHighestDepth());
			var t:Sprite = new Sprite();
			///targetMC.addChild(t);
			_world.addChild(t);
			t.x = _world.width/2;
			t.y = _world.height/2;
			
			
			
			
			if(!addedText)
				//t.visible = false;		 
				o["textBubble"] = new TextBubble(tbID, characterID, t, posX, posY, txt, initObj);
				var bubbleLifeTime:Number = this.getBubbleLifeTime(txt.length);	
				var currentTextBubble:TextBubble = o["textBubble"];
				//NOTE$$$*** over-riding auto-placement of text bubbles - put them on the screen's edge instead and out of the way
				if (posX == 10 && posY == 450){
					currentTextBubble._containerMC.x = 175;
					currentTextBubble._containerMC.y = 500;
				}else if (posX == 100){
					currentTextBubble._containerMC.x = -175;
					currentTextBubble._containerMC.y = 500;
				}else{
					currentTextBubble._containerMC.x = 0;
					currentTextBubble._containerMC.y = 200;
				}
				o["intervalID"] = setInterval(clearTextBubble, bubbleLifeTime, o.textBubble);		
				aTextBubbles.push(o);
				
		}
		/**
		 * @param strLength
		 * 
		 * @return
		 */
		private function getBubbleLifeTime(strLength:Number):Number{
			if(strLength == 0){
				return this.minBubbleLifeTime;
			}
			
			var result:Number = Math.floor((this.minBubbleLifeTime * strLength) / 20);
			
			if(result < this.minBubbleLifeTime) result = this.minBubbleLifeTime;
			if(result > this.maxBubbleLifeTime) result = this.maxBubbleLifeTime;
			
			return result;
		}
		
		/**
		 * updates the position of the bubble (to match with the character position)
		 * @param characterID
		 * @param posX
		 * @param posY
		 */
		public function updateBubblePosition(characterID:Number, posX:Number, posY:Number):void{
			var textBub:TextBubble = getTextBubbleByCharacterID(characterID);		
			var deltaX:Number;
			
			var topLeftBorder:Point = this.globalBorders.topLeft;
			this.targetMC.globalToLocal(topLeftBorder);
			var bottomRightBorder:Point = this.globalBorders.bottomRight;
			this.targetMC.globalToLocal(bottomRightBorder);
			
			bContainer = textBub._containerMC;	
			
				
			var topLeft:Point = new Point(posX-Math.floor(bContainer.width/2), posY-bContainer.height);
			var bottomRight:Point = new Point(posX+Math.floor(bContainer.width/2), posY);
			
			if(topLeft.y < topLeftBorder.y){
				posY += Math.abs(topLeftBorder.y - topLeft.y);			
			}
			if(topLeft.x < topLeftBorder.x){
				deltaX = Math.abs(topLeftBorder.x - topLeft.x);
				posX += deltaX;
				
				textBub.redraw(-deltaX, 0);
			}
			if(bottomRight.x > bottomRightBorder.x){
				deltaX = Math.abs(bottomRight.x - bottomRightBorder.x); 
				posX -= deltaX;
				
				textBub.redraw(deltaX, 0);
			}
			
			
			if(bottomRight.y > bottomRightBorder.y){
			 	posY = bottomRightBorder.y;
			}
			//bContainer.x = posX;
			//bContainer.y = posY;
			bContainer.x = bContainer.width/2;
			bContainer.y = -30;;
		}
		
		/**
		 * removes a text bubble 
		 * @param textBubble
		 */
		public function clearTextBubble(textBubble:TextBubble):void{
			for (var i:Number=0; i<aTextBubbles.length; i++){			
				if (textBubble == aTextBubbles[i].textBubble){
					clearInterval(aTextBubbles[i].intervalID);
					aTextBubbles.splice(i, 1);
					textBubble.kill();
					///delete textBubble;
					break;
				}
			}
		}
		
		/**
		 * removes all text bubbles
		 */
		public function clearAllTextBubbles():void{
			var length:Number = this.aTextBubbles.length;
			
			var textBubble:TextBubble;
			for(var i:Number=0; i<length; i++) {
				textBubble = this.aTextBubbles[i].textBubble;
				clearInterval(this.aTextBubbles[i].intervalID);
				textBubble.kill();
			}
			
			aTextBubbles = new Array();
		}
		
		/**
		 * clears the assets
		 */
		public function kill():void{		
			this.clearAllTextBubbles();
			this.targetMC = undefined;
			this.globalBorders = undefined;
		}
		
		/**
		 * get a text bubble by its ID 
		 * @param textBubbleID
		 * @param removeFromArray
		 * 
		 * @return ({@link TextBubble})
		 */
		private function getTextBubbleByID(textBubbleID: Number, removeFromArray: Boolean): TextBubble{
			var tb: TextBubble;
			for (var i:Number=0; i<aTextBubbles.length; i++){
				if (textBubbleID==aTextBubbles[i].textBubble.ID){
					if (removeFromArray) {			
						clearInterval(aTextBubbles[i].intervalID);					
						var a:Object = aTextBubbles.splice(i, 1)[0];
						tb = a.textBubble;
					}  else { 
						tb = aTextBubbles[i].textBubble;
					} 				
					break;
				}
			}
			return tb;
		}
		
		/**
		 * find the character's text bubble 
		 * @param characterID
		 * @param removeFromArray
		 * 
		 * @return ({@link TextBubble})
		 */
		private function getTextBubbleByCharacterID(characterID:Number, removeFromArray:Boolean=false):TextBubble{
			var tb:TextBubble;
			for (var i:Number=0; i<aTextBubbles.length; i++){			
				if (characterID==aTextBubbles[i].textBubble._characterID){
					if (removeFromArray) {
						clearInterval(aTextBubbles[i].intervalID);					
						var a:Object = aTextBubbles.splice(i, 1)[0];
						tb = a.textBubble;
					}  else { 
						tb = aTextBubbles[i].textBubble;
					} 				
					return tb;
				}
			}
			return null;
		}
		
		
	}
}