package com.evili.worldBuilder.modules{
 /**
 *  TextBubble class - chat "bubbles" that appear above characters when they "talk"
 * 
 * @author		(C) TheoWorlds.com, 2007-2008.
 * @version		1.0
 * @date 			11.17.2008
 *
 */
 	import flash.display.MovieClip;
 	import flash.display.Sprite;
 	import flash.text.TextField;
 	import flash.text.TextFormat;

;
 	
	public class TextBubble {
		
		private var ID: Number; 
		private var characterID: Number; 
		/**just in case. like for implementing a more complex bubble-positioning algorithm based on character's position*/
		private var containerMC: Sprite;
		private var bubbleFrame: Sprite; 
		private var bubbleText: TextField;
			
		/** space between the text box and the graphics bubbleFrame */
		private var textPadding: Number;
		private var maxTextWidth: Number;
		/**offset of the pointer from the center*/
		private var pointerCenterOffset: Number;
		/**offset of the pointer from the center*/
		private var pointerCenterWidth: Number;
		/**offset of the pointer from the center*/
		private var pointerCenterHeight: Number;
		/**container movie clip. should be empty*/
		private var target: MovieClip;
		
		private var frameWidth:Number;
		private var frameHeight:Number;
		
		private var bgColor:Number = 0x000000;
		
		/**
		 * Constructor 
		 * @param ID
		 * @param characterID
		 * @param target		- the mc in wich it is created
		 * @param posX
		 * @param posY
		 * @param txt
		 * @param initObj
		 * 		  initObj.bgColor
		 */
		public function TextBubble(ID:Number, characterID: Number, target: Sprite, posX: Number, posY: Number, txt: String, initObj:Object){
			
			//validation
			//target should be a sprite added to box's display list
			
			if (target==null){trace("ERROR! TextBubble.init():  - target is missing"); return;}
			//this.target = target;
			
			if (isNaN(characterID)){trace("ERROR! TextBubble.init(): bad p_characterID"); return;}
			if (isNaN(posX) || isNaN(posY)){trace("ERROR! TextBubble.init(): bad posX or posY"); return;}
			
			this.ID = ID;
			this.characterID = characterID;
			///deprecated
			///var zorder:Number = target.getNextHighestDepth();
			
			//settings
			textPadding = 6; 
			maxTextWidth = 140;
			maxTextWidth = 240;
			//pointer
			//NOTE: *** FOR PLAIN BUBBLES (AKA popups) SET THESE TO ZERO
			//the pointer makes it into a word balloon
			///pointerCenterOffset = -12;
			///pointerCenterWidth = 8;
			///pointerCenterHeight = 12;
			pointerCenterOffset = 0;
			pointerCenterWidth = 0;
			pointerCenterHeight = 0;
		
			
			this.containerMC = target;
			//frameMC = containerMC.createEmptyMovieClip("frame", 1);
			bubbleFrame = new Sprite();
			containerMC.addChild(bubbleFrame);
			
			///text = containerMC.createTextField("text", 2, textPadding, textPadding, maxTextWidth, 20);
			bubbleText = new TextField()
			containerMC.addChild(bubbleText);
			if (initObj == null){
				bubbleText.selectable = false;
				bubbleText.autoSize = "center";
				bubbleText.wordWrap = true;
				bubbleText.multiline = true;
				var borderColor:uint = 0x666666;
				///text.html = true;
				///text.htmlText = true;
				
				bubbleText.textColor = 0x00FFFF;
				bubbleText.htmlText = "<p align='center'><font face=\"Verdana\" size=\"11\">" + txt + "</font></p>";
			}else{
				bubbleText.selectable = initObj.selectable;
				bubbleText.autoSize = initObj.autoSize;
				bubbleText.wordWrap = initObj.wordWrap;
				bubbleText.multiline = initObj.multiline;
				bubbleText.textColor = initObj.textColor;
				bubbleText.width = 300;
				bubbleText.htmlText = initObj.htmlText1 + txt + initObj.htmlText2;
				var borderColor:uint = initObj.borderColor;
			}
			
			//text.x = -Math.floor(maxTextWidth/2);
			bubbleText.x = -bubbleText.width/2;


			/*this.frameWidth = bubbleText.textWidth +  textPadding*2;
			this.frameHeight = bubbleText.textHeight +  textPadding*2;	*/
			
			var color:uint = 0x000000;
			var roundness:Number = 6;
			var alpha:Number = 0.8
			var borderThickness:Number = 2;
			///var borderColor:uint = 0x666666;
			
			var borderAlpha:Number = 1.0;
			
			var _msgFormat:TextFormat = new TextFormat();
			var dualityFont:DualityFont = new DualityFont();
			_msgFormat.font = dualityFont.fontName;
			_msgFormat.size = 16;
			bubbleText.setTextFormat(_msgFormat);
			this.frameWidth = bubbleText.textWidth +  textPadding*2;
			this.frameHeight = bubbleText.textHeight +  textPadding*2;	
			
			if(initObj.bgColor != undefined)
				color = initObj.bgColor;	
			draw(bubbleFrame, 0, 0, frameWidth, frameHeight, roundness, color, alpha, 
					undefined, undefined, undefined, 
					borderThickness, borderColor, borderAlpha, 
					pointerCenterWidth, pointerCenterHeight, pointerCenterOffset,
					true);
			bubbleFrame.y -= this.bubbleFrame.height;//frameHeight; //- textPadding;
			bubbleFrame.x -= Math.floor(frameWidth/2);
			
			bubbleText.y = -Math.floor(bubbleText.textHeight) - this.pointerCenterHeight - 2*textPadding;
	
			containerMC.x = posX;
			containerMC.y = posY;// - pointerCenterHeight - 2;
			trace("TextBubble:::containerMC.x: " + containerMC.x);
		}
		
		/**
		 * when a character reaches the end of the screem the text bubble stays entirely within the screen
		 * the bubble pointer keeps pointing at the character
		 * 
		 * @param deltaX - shift by X
		 * @param deltaY - shift by Y
		 */
		public function redraw(deltaX:Number, deltaY:Number):void{
			this.draw(this.bubbleFrame, 0, 0, this.frameWidth, this.frameHeight, 6, 0, .80, undefined, undefined, undefined, 
				2, 0xffffff, 1.0, this.pointerCenterWidth, this.pointerCenterHeight+deltaY, this.pointerCenterOffset+deltaX, true);
		}
		
		
		/**
		 * draws the text bubble
		 * @param target
		 * @param x			x position of  fill
		 * @param y			y position of  fill
		 * @param w			width of  fill
		 * @param h			height of  fill
		 * @param r			corner radius of fill :: number or object {br:#,bl:#,tl:#,tr:#}
		 * @param c			hex color of fill :: number or array [0x######,0x######]
		 * @param alpha 	alpha value of fill :: number or array [0x######,0x######]
		 * @param rot		rotation of fill :: number or matrix object  {matrixType:"box",x:#,y:#,w:#,h:#,r:(#*(Math.PI/180))}
		 * @param gradient	type of gradient "linear" or "radial"
		 * @param ratios	(optional :: default  [0,255]) - specifies the distribution of colors :: array [#,#];
		 * @param borderThickness
		 * @param borderColor
		 * @param borderAlpha
		 * @param pointerWidth
		 * @param pointerHeight
		 * @param centerOffset
		 * @param clearPrevious
		 */
		private function draw(target : Sprite, x : Number, y : Number, w : Number, h : Number,
				r:*, c:uint, alpha:Number, rot:Number, gradient : String, ratios:Array, //bg
				borderThickness : Number, borderColor : Number, borderAlpha : Number, 
				pointerWidth: Number, pointerHeight: Number, centerOffset: Number,
				clearPrevious: Boolean):void{
			
			if (clearPrevious){target.graphics.clear();}
			x = Math.round (x);
			y = Math.round (y);
			w = Math.round (w);		
			if(w < 30)w = 30;		
			h = Math.round (h);
			var rbr:Number;
			if (typeof r == "object")
			{
				rbr = r.br; //bottom right corner
				var rbl:Number = r.bl; //bottom left corner
				var rtl:Number = r.tl; //top left corner
				var rtr:Number = r.tr; //top right corner
				
			} 
			else
			{
				rbr = rbl = rtl = rtr = r;
			}
			// if color is an object then allow for complex fills
			//NOTE: *** fix this to get gradients in bubble
				/* 
			if (typeof c == "object")
			{
				if (typeof alpha != "object")
					var alphas = [alpha, alpha];
				else
					var alphas = alpha;
				if (ratios == undefined)
					var ratios:Array = [0, 0xff ];
					var sh:Number = h *.7;
				if (typeof rot != "object")
				var matrix = {
					//matrixType : "box", x : - sh, y : sh, w : w * 2, h : h * 4, r : rot * 0.0174532925199433
					matrixType : "box", x : x, y :y, w : w, h : h, r : rot * 0.0174532925199433
				};
				else
				var matrix:Number = rot;
				if (gradient == "radial")
					target.beginGradientFill ("radial", c, alphas, ratios, matrix );
				else
					target.beginGradientFill ("linear", c, alphas, ratios, matrix ); 
			} 
			else */if (c != undefined){
				//target.beginFill (c, alpha);
				target.graphics.beginFill (c, 100);
			}
			
			// the standart type of pointer's direction
			var pointerTypeDirection:Number = 0;  
			
			if(centerOffset < 2*pointerWidth - w/2 ){
				centerOffset = 2*pointerWidth - w/2;
				pointerTypeDirection = 1;
			}else if(centerOffset > w/2 - pointerWidth){
				centerOffset = w/2 - pointerWidth;
			}
			
			//bottom right corner
			r = rbr;
			var a:Number;
			var s:Number;
			
			a = r - (r * 0.707106781186547);
			//radius - anchor pt;
			s = r - (r * 0.414213562373095);
			//radius - control pt;
			//set border
			if (borderThickness > 0){
				target.graphics.lineStyle (borderThickness, borderColor, borderAlpha, false, undefined, undefined, "miter");
			} else {
				target.graphics.lineStyle (undefined, borderColor, borderAlpha);
			}
			target.graphics.moveTo (x + w, y + h - r);
			target.graphics.lineTo (x + w, y + h - r );
					
			if (r>0){
				target.graphics.curveTo (x + w, y + h - s, x + w - a, y + h - a);
				target.graphics.curveTo (x + w - s, y + h, x + w - r, y + h);
			}
			//bottom left corner
			r = rbl;
			a = r - (r * 0.707106781186547);
			s = r - (r * 0.414213562373095);
			// centerOffset
			// pointerWidth
			var halfW:Number = Math.floor(w/2);
			if(pointerTypeDirection == 0){
				target.graphics.lineTo (x + halfW + centerOffset, y + h );
				target.graphics.lineTo (x + halfW + centerOffset, y + h + pointerHeight);
				target.graphics.lineTo (x + halfW + centerOffset - pointerWidth, y + h);
			}else{
				target.graphics.lineTo (x + halfW + centerOffset + pointerWidth, y + h );
				target.graphics.lineTo (x + halfW + centerOffset, y + h + pointerHeight);
				target.graphics.lineTo (x + halfW + centerOffset, y + h);
			}
			target.graphics.lineTo (x + r, y + h );
			
			if (r>0){
				target.graphics.curveTo (x + s, y + h, x + a, y + h - a);
				target.graphics.curveTo (x, y + h - s, x, y + h - r);
			}
			//top left corner
			r = rtl;
			a = r - (r * 0.707106781186547);
			s = r - (r * 0.414213562373095);
			target.graphics.lineTo (x, y + r );
			if (r>0){
				target.graphics.curveTo (x, y + s, x + a, y + a);
				target.graphics.curveTo (x + s, y, x + r, y);
			}
			//top right
			r = rtr;
			a = r - (r * 0.707106781186547);
			s = r - (r * 0.414213562373095);
			target.graphics.lineTo (x + w - r, y );
			if (r>0){
				target.graphics.curveTo (x + w - s, y, x + w - a, y + a);
				target.graphics.curveTo (x + w, y + s, x + w, y + r);
			}
	
			if (c != undefined)
			target.graphics.endFill ();

			target.cacheAsBitmap = true;	
		}
		/**
		 * 
		 */
		public function kill():void{
			containerMC.removeChild(bubbleFrame);
			containerMC.removeChild(bubbleText);
		}
		
		//---------------------------getters/setters------------------------------------------
		/**
		 * @return
		 */
		public function get _ID():Number{
			return this.ID;
		}
		/**
		 * @return
		 */
		public function get _characterID():Number{
			return this.characterID;
		}
		/**
		 * @return
		 */
		public function get _containerMC():Sprite{
			return this.containerMC;
		}
		/**
		 * @return
		 */
		public function get _text():String {return this.bubbleText.text;}
	}
}