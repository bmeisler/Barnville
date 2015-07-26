package com.evili.utils
{
	public class ThumbnailScroller
	{
		//--------------holds the thumbnail objects------
		var arrayThumb:Array = new Array();
		//---------the container of the thumbnails--------
		var photoContainer:Sprite =  new Sprite();
		public function ThumbnailScroller()
		{
			addChild(photoContainer);
			//-----------set the thumb_holder as a mask for the photoContainer
			photoContainer.mask=thumb_holder;
			for (var i:int=0; i<xmlList.length(); i++) {
				      thumb = new Thumbnail(xmlList.url);
				        arrayThumb.push(thumb);
				        arrayThumb.y = 67.5;
				28.        arrayThumb.x = i*100+55;
				29.        photoContainer.addChild(thumb);
				30.    }
		}
		
		//-----------set the thumb_holder as a mask for the photoContainer
		photoContainer.mask=thumb_holder;
		19. 
		20./* ----loop through the xml file, populate the arrayThumb, position the thumbnails and add the thumbnails to bigHolder */
		21.function urlLoaded(event:Event):void {
			22.    xml = XML(event.target.data);
			23.    xmlList = xml.children();
			24.    for (var i:int=0; i<xmlList.length(); i++) {
				25.        thumb = new Thumbnail(xmlList.url);
				26.        arrayThumb.push(thumb);
				27.        arrayThumb.y = 67.5;
				28.        arrayThumb.x = i*100+55;
				29.        photoContainer.addChild(thumb);
				30.    }
			31.}
		32. 
		33.var minScroll:Number = 0;
		34.var maxScroll:Number = track.width-handler.width;
		35.var draging:Boolean = false;
		36. 
		37.//--------------set the limits in which the handler can be dragged-----------
		38.var bounds:Rectangle = new Rectangle(handler.x,handler.y,maxScroll,0);
		39. 
		40.//----------shows the hand cursor when mouse is over the handler-----------
		41.handler.buttonMode = true;
		42. 
		43.handler.addEventListener(MouseEvent.MOUSE_DOWN,beginDrag);
		44. 
		45.//---------- handles the MOUSE_DOWN event--------------------
		46.function beginDrag(event:MouseEvent):void {
			47.    handler.startDrag(false,bounds);
			48.    draging = true;
			49.    handler.addEventListener(Event.ENTER_FRAME,checkingProgress);
			50.    stage.addEventListener(MouseEvent.MOUSE_UP,endDrag);
			51.}
		52.//---------handles the MOUSE_UP event------------
		53.function endDrag(event:MouseEvent):void {
			54.    handler.stopDrag();
			55.    draging = false;
			56.}
		57./*---------checking the x position of the handler and update the x position of the photoContainer based on position of the handler---------*/
		58.function checkingProgress(event:Event):void {
			59.    var procent:Number = handler.x/maxScroll;
			60.    if (draging) {
				61.        Tweener.addTween(photoContainer,{x:(-procent*(photoContainer.width-thumb_holder.width)),time:1});
				62.    }
			63.}
	}
}